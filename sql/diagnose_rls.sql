-- ============================================================
-- RLS Diagnostic Script
-- ============================================================
-- Run this to check current RLS status and identify issues
-- ============================================================

-- 1. Check if enquiries table exists
SELECT
    '1. Table Exists' AS check_item,
    CASE
        WHEN EXISTS (
            SELECT 1 FROM information_schema.tables
            WHERE table_schema = 'public' AND table_name = 'enquiries'
        ) THEN '✅ YES'
        ELSE '❌ NO - Table does not exist!'
    END AS status;

-- 2. Check if RLS is enabled
SELECT
    '2. RLS Enabled' AS check_item,
    CASE
        WHEN rowsecurity THEN '✅ YES'
        ELSE '❌ NO - RLS is disabled!'
    END AS status
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'enquiries';

-- 3. Count existing policies
SELECT
    '3. Policy Count' AS check_item,
    CONCAT(COUNT(*), ' policies found') AS status
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'enquiries';

-- 4. List all policies
SELECT
    '4. POLICY DETAILS:' AS section,
    '' AS policyname,
    '' AS roles,
    '' AS cmd;

SELECT
    '' AS section,
    policyname,
    roles::text,
    cmd
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'enquiries'
ORDER BY policyname;

-- 5. Check INSERT policy for anon role
SELECT
    '5. Anon INSERT Policy' AS check_item,
    CASE
        WHEN EXISTS (
            SELECT 1 FROM pg_policies
            WHERE schemaname = 'public'
                AND tablename = 'enquiries'
                AND cmd = 'INSERT'
                AND ('anon' = ANY(roles::text[]) OR 'public' = ANY(roles::text[]))
        ) THEN '✅ EXISTS'
        ELSE '❌ MISSING - This is the problem!'
    END AS status;

-- 6. Check table permissions
SELECT
    '6. Anon INSERT Permission' AS check_item,
    CASE
        WHEN has_table_privilege('anon', 'public.enquiries', 'INSERT')
        THEN '✅ GRANTED'
        ELSE '❌ DENIED - Need to grant INSERT permission!'
    END AS status;

-- 7. Check for conflicting policies
SELECT
    '7. Conflicting Policies' AS check_item,
    CASE
        WHEN COUNT(*) > 2
        THEN CONCAT('⚠️ WARNING - ', COUNT(*), ' policies (expected 2)')
        ELSE CONCAT('✅ OK - ', COUNT(*), ' policies')
    END AS status
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'enquiries';

-- ============================================================
-- FINAL DIAGNOSIS
-- ============================================================

SELECT '===================' AS divider;
SELECT 'DIAGNOSIS SUMMARY' AS section;
SELECT '===================' AS divider;

-- Overall diagnosis
SELECT
    CASE
        WHEN NOT EXISTS (
            SELECT 1 FROM information_schema.tables
            WHERE table_schema = 'public' AND table_name = 'enquiries'
        ) THEN '❌ CRITICAL: enquiries table does not exist!'

        WHEN NOT EXISTS (
            SELECT 1 FROM pg_tables
            WHERE schemaname = 'public' AND tablename = 'enquiries' AND rowsecurity = true
        ) THEN '❌ CRITICAL: RLS is not enabled on enquiries table!'

        WHEN NOT EXISTS (
            SELECT 1 FROM pg_policies
            WHERE schemaname = 'public'
                AND tablename = 'enquiries'
                AND cmd = 'INSERT'
                AND ('anon' = ANY(roles::text[]) OR 'public' = ANY(roles::text[]))
        ) THEN '❌ CRITICAL: No INSERT policy for anonymous users!'

        WHEN NOT has_table_privilege('anon', 'public.enquiries', 'INSERT')
        THEN '❌ CRITICAL: anon role lacks INSERT permission!'

        ELSE '✅ ALL CHECKS PASSED - RLS configured correctly'
    END AS diagnosis;

-- ============================================================
-- RECOMMENDED ACTION
-- ============================================================

SELECT
    CASE
        WHEN NOT EXISTS (
            SELECT 1 FROM pg_policies
            WHERE schemaname = 'public'
                AND tablename = 'enquiries'
                AND cmd = 'INSERT'
                AND ('anon' = ANY(roles::text[]) OR 'public' = ANY(roles::text[]))
        ) THEN '🔧 ACTION: Execute sql/enquiries_policies.sql to create missing policies'

        WHEN NOT has_table_privilege('anon', 'public.enquiries', 'INSERT')
        THEN '🔧 ACTION: Grant INSERT permission by running sql/enquiries_policies.sql'

        ELSE '🎉 NO ACTION NEEDED: Configuration is correct'
    END AS recommended_action;
