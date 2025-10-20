-- ============================================================
-- Migration: Add Chinese Language Fields
-- ============================================================
-- Execute this in: Supabase Dashboard → SQL Editor
-- ============================================================

-- Add Chinese name field to categories table
ALTER TABLE categories ADD COLUMN IF NOT EXISTS name_zh TEXT;

-- Add Chinese name field to materials table
ALTER TABLE materials ADD COLUMN IF NOT EXISTS name_zh TEXT;

-- Add Chinese description field to products table
ALTER TABLE products ADD COLUMN IF NOT EXISTS description_zh TEXT;

-- Verification Query
SELECT '✅ Successfully added Chinese language fields!' AS result;

-- Verify categories table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'categories' AND column_name IN ('name', 'name_zh')
ORDER BY ordinal_position;

-- Verify materials table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'materials' AND column_name IN ('name', 'name_zh')
ORDER BY ordinal_position;

-- Verify products table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'products' AND column_name IN ('description', 'description_zh')
ORDER BY ordinal_position;
