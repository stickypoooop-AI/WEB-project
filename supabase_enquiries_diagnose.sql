-- ============================================================
-- Enquiries Table Diagnostic Script
-- ============================================================
-- This script checks all possible issues with the enquiries table
-- Run this to understand why INSERT is failing
-- ============================================================

-- 1. Check table exists and structure
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'enquiries'
ORDER BY ordinal_position;

-- 2. Check RLS is enabled
SELECT
    tablename,
    rowsecurity as rls_enabled,
    tableowner
FROM pg_tables
WHERE tablename = 'enquiries';

-- 3. Check ALL policies on enquiries table
SELECT
    schemaname,
    policyname,
    permissive,
    roles::text,
    cmd,
    qual::text as using_expression,
    with_check::text as with_check_expression
FROM pg_policies
WHERE tablename = 'enquiries';

-- 4. Check table permissions for different roles
SELECT
    'anon' as role_name,
    has_table_privilege('anon', 'enquiries', 'SELECT') as can_select,
    has_table_privilege('anon', 'enquiries', 'INSERT') as can_insert,
    has_table_privilege('anon', 'enquiries', 'UPDATE') as can_update,
    has_table_privilege('anon', 'enquiries', 'DELETE') as can_delete
UNION ALL
SELECT
    'authenticated' as role_name,
    has_table_privilege('authenticated', 'enquiries', 'SELECT') as can_select,
    has_table_privilege('authenticated', 'enquiries', 'INSERT') as can_insert,
    has_table_privilege('authenticated', 'enquiries', 'UPDATE') as can_update,
    has_table_privilege('authenticated', 'enquiries', 'DELETE') as can_delete;

-- 5. Check if there are any constraints
SELECT
    conname as constraint_name,
    contype as constraint_type,
    pg_get_constraintdef(c.oid) as constraint_definition
FROM pg_constraint c
JOIN pg_namespace n ON n.oid = c.connamespace
JOIN pg_class cl ON cl.oid = c.conrelid
WHERE cl.relname = 'enquiries'
AND n.nspname = 'public';

-- 6. Try a test insert as anon user (will show exact error if it fails)
-- Commented out to avoid actual insert during diagnostic
-- SET ROLE anon;
-- INSERT INTO enquiries (customer_name, customer_email, customer_phone, products, notes)
-- VALUES ('Test', 'test@test.com', '123456', '[]'::jsonb, 'test');
-- RESET ROLE;

SELECT '📋 Diagnostic complete! Review the results above.' AS status;
