-- ============================================================
-- Remove Finish Field and Add Categories/Materials Management
-- ============================================================
-- This migration:
-- 1. Removes the finish field from products table
-- 2. Creates categories and materials tables
-- 3. Updates products table to reference these new tables
--
-- Execute this in: Supabase Dashboard → SQL Editor
-- ============================================================

-- Step 1: Create categories table
CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    display_name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Step 2: Create materials table
CREATE TABLE IF NOT EXISTS materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    display_name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Step 3: Enable RLS for new tables
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE materials ENABLE ROW LEVEL SECURITY;

-- Step 4: Create RLS policies (public read, anyone can write for admin operations)
CREATE POLICY "Anyone can view categories" ON categories
    FOR SELECT USING (true);

CREATE POLICY "Anyone can insert categories" ON categories
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can update categories" ON categories
    FOR UPDATE USING (true);

CREATE POLICY "Anyone can delete categories" ON categories
    FOR DELETE USING (true);

CREATE POLICY "Anyone can view materials" ON materials
    FOR SELECT USING (true);

CREATE POLICY "Anyone can insert materials" ON materials
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can update materials" ON materials
    FOR UPDATE USING (true);

CREATE POLICY "Anyone can delete materials" ON materials
    FOR DELETE USING (true);

-- Step 5: Insert existing categories
INSERT INTO categories (name, display_name) VALUES
    ('screws', 'Screws'),
    ('bolts', 'Bolts'),
    ('nuts', 'Nuts'),
    ('washers', 'Washers'),
    ('anchors', 'Anchors'),
    ('rivets', 'Rivets'),
    ('one-way-clutch', 'One Way Clutch')
ON CONFLICT (name) DO NOTHING;

-- Step 6: Insert existing materials
INSERT INTO materials (name, display_name) VALUES
    ('stainless-steel', 'Stainless Steel'),
    ('carbon-steel', 'Carbon Steel'),
    ('brass', 'Brass'),
    ('aluminum', 'Aluminum'),
    ('rubber', 'Rubber'),
    ('nylon', 'Nylon'),
    ('te-gcr', 'Te Gcr')
ON CONFLICT (name) DO NOTHING;

-- Step 7: Drop finish constraint and index
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_finish_check;
DROP INDEX IF EXISTS idx_products_finish;

-- Step 8: Remove finish column
ALTER TABLE products DROP COLUMN IF EXISTS finish;

-- Step 9: Drop old category and material constraints
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_category_check;
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_material_check;

-- Step 10: Verify existing data compatibility
-- Check if all current categories exist in the new table
DO $$
DECLARE
    invalid_categories TEXT[];
BEGIN
    SELECT ARRAY_AGG(DISTINCT category)
    INTO invalid_categories
    FROM products p
    WHERE NOT EXISTS (
        SELECT 1 FROM categories c WHERE c.name = p.category
    );

    IF invalid_categories IS NOT NULL AND array_length(invalid_categories, 1) > 0 THEN
        RAISE EXCEPTION 'Invalid categories found in products: %. Please add these categories first.', invalid_categories;
    END IF;
END $$;

-- Step 11: Verify materials compatibility
DO $$
DECLARE
    invalid_materials TEXT[];
BEGIN
    SELECT ARRAY_AGG(DISTINCT material)
    INTO invalid_materials
    FROM products p
    WHERE NOT EXISTS (
        SELECT 1 FROM materials m WHERE m.name = p.material
    );

    IF invalid_materials IS NOT NULL AND array_length(invalid_materials, 1) > 0 THEN
        RAISE EXCEPTION 'Invalid materials found in products: %. Please add these materials first.', invalid_materials;
    END IF;
END $$;

-- Step 12: Add foreign key constraints
-- Note: We keep category and material as TEXT for flexibility
-- but add check constraints to ensure they reference valid options
ALTER TABLE products ADD CONSTRAINT products_category_fkey
    CHECK (EXISTS (SELECT 1 FROM categories WHERE name = category));

ALTER TABLE products ADD CONSTRAINT products_material_fkey
    CHECK (EXISTS (SELECT 1 FROM materials WHERE name = material));

-- Step 13: Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_categories_name ON categories(name);
CREATE INDEX IF NOT EXISTS idx_materials_name ON materials(name);

-- Verification queries
SELECT '=== Categories Table ===' AS status;
SELECT * FROM categories ORDER BY display_name;

SELECT '=== Materials Table ===' AS status;
SELECT * FROM materials ORDER BY display_name;

SELECT '=== Products Table Structure ===' AS status;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'products'
ORDER BY ordinal_position;

SELECT '✅ Migration completed successfully!' AS result;
SELECT '✅ Finish field has been removed from products table.' AS result;
SELECT '✅ Categories and materials are now managed dynamically.' AS result;
