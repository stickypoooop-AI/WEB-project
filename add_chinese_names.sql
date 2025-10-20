-- ============================================================
-- Add Chinese Name Support to Categories and Materials
-- 为分类和材料表添加中文名称支持
-- ============================================================

-- Step 1: Add name_zh column to categories table
ALTER TABLE categories
ADD COLUMN IF NOT EXISTS name_zh TEXT;

-- Step 2: Add name_zh column to materials table
ALTER TABLE materials
ADD COLUMN IF NOT EXISTS name_zh TEXT;

SELECT '✅ Added name_zh columns to categories and materials tables' AS result;

-- ============================================================
-- Step 3: Update categories with Chinese names
-- ============================================================

UPDATE categories SET name_zh = '螺丝' WHERE name = 'screws';
UPDATE categories SET name_zh = '螺栓' WHERE name = 'bolts';
UPDATE categories SET name_zh = '螺母' WHERE name = 'nuts';
UPDATE categories SET name_zh = '垫圈' WHERE name = 'washers';
UPDATE categories SET name_zh = '锚栓' WHERE name = 'anchors';
UPDATE categories SET name_zh = '铆钉' WHERE name = 'rivets';
UPDATE categories SET name_zh = '单向离合器' WHERE name = 'one-way-clutch';
UPDATE categories SET name_zh = '双向离合器' WHERE name = 'two-way-clutch';

SELECT '✅ Updated categories with Chinese names' AS result;

-- ============================================================
-- Step 4: Update materials with Chinese names
-- ============================================================

UPDATE materials SET name_zh = '不锈钢' WHERE name = 'stainless-steel';
UPDATE materials SET name_zh = '碳钢' WHERE name = 'carbon-steel';
UPDATE materials SET name_zh = '黄铜' WHERE name = 'brass';
UPDATE materials SET name_zh = '铝' WHERE name = 'aluminum';
UPDATE materials SET name_zh = '橡胶' WHERE name = 'rubber';
UPDATE materials SET name_zh = '尼龙' WHERE name = 'nylon';
UPDATE materials SET name_zh = 'Te Gcr' WHERE name = 'te-gcr';

SELECT '✅ Updated materials with Chinese names' AS result;

-- ============================================================
-- Step 5: Add description_zh column to products table
-- ============================================================

ALTER TABLE products
ADD COLUMN IF NOT EXISTS description_zh TEXT;

SELECT '✅ Added description_zh column to products table' AS result;

-- ============================================================
-- Verification: Display Results
-- ============================================================

SELECT '========================================' AS separator;
SELECT '=== CATEGORIES WITH CHINESE NAMES ===' AS info;
SELECT '========================================' AS separator;
SELECT name, display_name, name_zh FROM categories ORDER BY name;

SELECT '========================================' AS separator;
SELECT '=== MATERIALS WITH CHINESE NAMES ===' AS info;
SELECT '========================================' AS separator;
SELECT name, display_name, name_zh FROM materials ORDER BY name;

SELECT '========================================' AS separator;
SELECT '✅ Migration completed successfully!' AS result;
SELECT '✅ Chinese name support added!' AS result;
SELECT '✅ Categories and materials now have Chinese translations!' AS result;
SELECT '========================================' AS separator;
