-- ============================================================
-- Add New Category and Material to Products Table
-- ============================================================
-- This migration adds "one-way-clutch" category and "te-gcr" material
-- to the existing products table constraints
--
-- Execute this in: Supabase Dashboard → SQL Editor
-- ============================================================

-- Step 1: Drop existing category constraint
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_category_check;

-- Step 2: Add updated category constraint with new value
ALTER TABLE products ADD CONSTRAINT products_category_check
    CHECK (category IN (
        'screws',
        'bolts',
        'nuts',
        'washers',
        'anchors',
        'rivets',
        'one-way-clutch'
    ));

-- Step 3: Drop existing material constraint
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_material_check;

-- Step 4: Add updated material constraint with new value
ALTER TABLE products ADD CONSTRAINT products_material_check
    CHECK (material IN (
        'stainless-steel',
        'carbon-steel',
        'brass',
        'aluminum',
        'rubber',
        'nylon',
        'te-gcr'
    ));

-- Verification queries
SELECT '=== Category Constraint Updated ===' AS status;
SELECT conname, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conname = 'products_category_check';

SELECT '=== Material Constraint Updated ===' AS status;
SELECT conname, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conname = 'products_material_check';

SELECT '✅ Migration completed successfully! You can now use "one-way-clutch" category and "te-gcr" material.' AS result;
