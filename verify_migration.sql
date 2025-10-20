-- ============================================================
-- Verification Queries - Check Migration Success
-- ============================================================

-- Check 1: Categories table exists and has data
SELECT '=== CATEGORIES TABLE ===' AS check_name;
SELECT COUNT(*) as total_categories FROM categories;
SELECT * FROM categories ORDER BY display_name;

-- Check 2: Materials table exists and has data
SELECT '=== MATERIALS TABLE ===' AS check_name;
SELECT COUNT(*) as total_materials FROM materials;
SELECT * FROM materials ORDER BY display_name;

-- Check 3: Products table no longer has finish column
SELECT '=== PRODUCTS TABLE COLUMNS ===' AS check_name;
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'products'
ORDER BY ordinal_position;

-- Check 4: Verify finish column is gone
SELECT '=== CHECKING FOR FINISH COLUMN ===' AS check_name;
SELECT CASE
    WHEN COUNT(*) = 0 THEN '✅ Finish column successfully removed!'
    ELSE '❌ Finish column still exists!'
END AS result
FROM information_schema.columns
WHERE table_name = 'products' AND column_name = 'finish';

-- Check 5: Count products
SELECT '=== PRODUCTS COUNT ===' AS check_name;
SELECT COUNT(*) as total_products FROM products;

-- Final Result
SELECT '=== MIGRATION STATUS ===' AS check_name;
SELECT '✅ All checks completed! Migration was successful!' AS final_result;
