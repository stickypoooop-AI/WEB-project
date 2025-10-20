-- ============================================================
-- Complete Migration: Remove Finish Field and Add Categories/Materials Management
-- ============================================================
-- This migration:
-- 1. Cleans up any previous failed migration attempts
-- 2. Removes the finish field from products table
-- 3. Creates categories and materials tables
-- 4. Sets up RLS policies
-- 5. Inserts default data
--
-- Execute this in: Supabase Dashboard → SQL Editor
-- ============================================================

-- ============================================================
-- STEP 0: CLEANUP (Remove any previous failed attempts)
-- ============================================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Anyone can view categories" ON categories;
DROP POLICY IF EXISTS "Anyone can insert categories" ON categories;
DROP POLICY IF EXISTS "Anyone can update categories" ON categories;
DROP POLICY IF EXISTS "Anyone can delete categories" ON categories;

DROP POLICY IF EXISTS "Anyone can view materials" ON materials;
DROP POLICY IF EXISTS "Anyone can insert materials" ON materials;
DROP POLICY IF EXISTS "Anyone can update materials" ON materials;
DROP POLICY IF EXISTS "Anyone can delete materials" ON materials;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS materials CASCADE;

-- Drop old product constraints if they exist
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_category_fkey;
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_material_fkey;
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_finish_check;
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_category_check;
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_material_check;

-- Drop old indexes
DROP INDEX IF EXISTS idx_products_finish;
DROP INDEX IF EXISTS idx_categories_name;
DROP INDEX IF EXISTS idx_materials_name;

SELECT '✅ Cleanup completed!' AS result;

-- ============================================================
-- STEP 1: CREATE NEW TABLES
-- ============================================================

-- Create categories table
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    display_name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Create materials table
CREATE TABLE materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    display_name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

SELECT '✅ Tables created!' AS result;

-- ============================================================
-- STEP 2: ENABLE ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE materials ENABLE ROW LEVEL SECURITY;

SELECT '✅ RLS enabled!' AS result;

-- ============================================================
-- STEP 3: CREATE RLS POLICIES
-- ============================================================

-- Categories policies (public read, anyone can write for admin operations)
CREATE POLICY "Anyone can view categories" ON categories
    FOR SELECT USING (true);

CREATE POLICY "Anyone can insert categories" ON categories
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can update categories" ON categories
    FOR UPDATE USING (true);

CREATE POLICY "Anyone can delete categories" ON categories
    FOR DELETE USING (true);

-- Materials policies (public read, anyone can write for admin operations)
CREATE POLICY "Anyone can view materials" ON materials
    FOR SELECT USING (true);

CREATE POLICY "Anyone can insert materials" ON materials
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can update materials" ON materials
    FOR UPDATE USING (true);

CREATE POLICY "Anyone can delete materials" ON materials
    FOR DELETE USING (true);

SELECT '✅ RLS policies created!' AS result;

-- ============================================================
-- STEP 4: INSERT DEFAULT DATA
-- ============================================================

-- Insert existing categories
INSERT INTO categories (name, display_name) VALUES
    ('screws', 'Screws'),
    ('bolts', 'Bolts'),
    ('nuts', 'Nuts'),
    ('washers', 'Washers'),
    ('anchors', 'Anchors'),
    ('rivets', 'Rivets'),
    ('one-way-clutch', 'One Way Clutch');

-- Insert existing materials
INSERT INTO materials (name, display_name) VALUES
    ('stainless-steel', 'Stainless Steel'),
    ('carbon-steel', 'Carbon Steel'),
    ('brass', 'Brass'),
    ('aluminum', 'Aluminum'),
    ('rubber', 'Rubber'),
    ('nylon', 'Nylon'),
    ('te-gcr', 'Te Gcr');

SELECT '✅ Default data inserted!' AS result;

-- ============================================================
-- STEP 5: VERIFY DATA COMPATIBILITY
-- ============================================================

-- Check if all current categories in products exist in the new table
DO $$
DECLARE
    invalid_categories TEXT[];
BEGIN
    SELECT ARRAY_AGG(DISTINCT category)
    INTO invalid_categories
    FROM products p
    WHERE category IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM categories c WHERE c.name = p.category
    );

    IF invalid_categories IS NOT NULL AND array_length(invalid_categories, 1) > 0 THEN
        RAISE EXCEPTION 'Invalid categories found in products: %. Please add these categories first.', invalid_categories;
    END IF;
END $$;

-- Check if all current materials in products exist in the new table
DO $$
DECLARE
    invalid_materials TEXT[];
BEGIN
    SELECT ARRAY_AGG(DISTINCT material)
    INTO invalid_materials
    FROM products p
    WHERE material IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM materials m WHERE m.name = p.material
    );

    IF invalid_materials IS NOT NULL AND array_length(invalid_materials, 1) > 0 THEN
        RAISE EXCEPTION 'Invalid materials found in products: %. Please add these materials first.', invalid_materials;
    END IF;
END $$;

SELECT '✅ Data compatibility verified!' AS result;

-- ============================================================
-- STEP 6: REMOVE FINISH FIELD FROM PRODUCTS
-- ============================================================

-- Remove finish column if it exists
ALTER TABLE products DROP COLUMN IF EXISTS finish;

SELECT '✅ Finish field removed!' AS result;

-- ============================================================
-- STEP 7: CREATE INDEXES FOR PERFORMANCE
-- ============================================================

CREATE INDEX idx_categories_name ON categories(name);
CREATE INDEX idx_materials_name ON materials(name);

SELECT '✅ Indexes created!' AS result;

-- ============================================================
-- VERIFICATION: DISPLAY RESULTS
-- ============================================================

SELECT '========================================' AS separator;
SELECT '=== CATEGORIES TABLE ===' AS info;
SELECT '========================================' AS separator;
SELECT * FROM categories ORDER BY display_name;

SELECT '========================================' AS separator;
SELECT '=== MATERIALS TABLE ===' AS info;
SELECT '========================================' AS separator;
SELECT * FROM materials ORDER BY display_name;

SELECT '========================================' AS separator;
SELECT '=== PRODUCTS TABLE STRUCTURE ===' AS info;
SELECT '========================================' AS separator;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'products'
ORDER BY ordinal_position;

SELECT '========================================' AS separator;
SELECT '✅ Migration completed successfully!' AS result;
SELECT '✅ Finish field has been removed from products table.' AS result;
SELECT '✅ Categories and materials are now managed dynamically.' AS result;
SELECT '✅ You can now test the application!' AS result;
SELECT '========================================' AS separator;
