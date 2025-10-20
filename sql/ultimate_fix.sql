-- ============================================================
-- ULTIMATE FIX - Complete RLS and Permissions Reset
-- ============================================================
-- This script will completely reset all permissions and policies
-- Run this in your Supabase SQL Editor
-- ============================================================

-- ============================================================
-- PART 1: DIAGNOSTIC - Check Current State
-- ============================================================

-- Check 1: Table exists and RLS status
SELECT
    '=== TABLE STATUS ===' AS section,
    schemaname,
    tablename,
    rowsecurity AS rls_enabled,
    tableowner
FROM pg_tables
WHERE tablename = 'enquiries';

-- Check 2: All existing policies
SELECT
    '=== CURRENT POLICIES ===' AS section,
    policyname,
    roles::text,
    cmd
FROM pg_policies
WHERE tablename = 'enquiries';

-- Check 3: Table-level permissions
SELECT
    '=== TABLE PERMISSIONS ===' AS section,
    grantee,
    privilege_type
FROM information_schema.table_privileges
WHERE table_name = 'enquiries'
ORDER BY grantee, privilege_type;

-- ============================================================
-- PART 2: COMPLETE RESET
-- ============================================================

-- Step 1: Temporarily disable RLS
ALTER TABLE public.enquiries DISABLE ROW LEVEL SECURITY;

-- Step 2: Revoke ALL permissions from everyone
REVOKE ALL ON TABLE public.enquiries FROM PUBLIC;
REVOKE ALL ON TABLE public.enquiries FROM anon;
REVOKE ALL ON TABLE public.enquiries FROM authenticated;
REVOKE ALL ON TABLE public.enquiries FROM service_role;

-- Step 3: Drop ALL existing policies
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT policyname
        FROM pg_policies
        WHERE schemaname = 'public' AND tablename = 'enquiries'
    ) LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.enquiries', r.policyname);
        RAISE NOTICE 'Dropped policy: %', r.policyname;
    END LOOP;
END $$;

-- Step 4: Grant schema usage
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;

-- Step 5: Grant table-level permissions
GRANT INSERT ON TABLE public.enquiries TO anon;
GRANT INSERT ON TABLE public.enquiries TO authenticated;
GRANT SELECT ON TABLE public.enquiries TO authenticated;
GRANT SELECT ON TABLE public.enquiries TO service_role;
GRANT ALL ON TABLE public.enquiries TO service_role;

-- Step 6: Re-enable RLS
ALTER TABLE public.enquiries ENABLE ROW LEVEL SECURITY;

-- Step 7: Create simple INSERT policy for anon
CREATE POLICY "enable_insert_for_anon"
ON public.enquiries
FOR INSERT
TO anon
WITH CHECK (true);

-- Step 8: Create INSERT policy for authenticated
CREATE POLICY "enable_insert_for_authenticated"
ON public.enquiries
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Step 9: Create SELECT policy for authenticated
CREATE POLICY "enable_select_for_authenticated"
ON public.enquiries
FOR SELECT
TO authenticated
USING (true);

-- ============================================================
-- PART 3: VERIFICATION
-- ============================================================

-- Verify 1: Check policies
SELECT
    '=== NEW POLICIES ===' AS section,
    policyname,
    roles::text,
    cmd,
    with_check::text
FROM pg_policies
WHERE tablename = 'enquiries'
ORDER BY policyname;

-- Verify 2: Check permissions
SELECT
    '=== VERIFIED PERMISSIONS ===' AS section,
    'anon' as role_name,
    has_table_privilege('anon', 'public.enquiries', 'INSERT') as can_insert,
    has_table_privilege('anon', 'public.enquiries', 'SELECT') as can_select
UNION ALL
SELECT
    '===',
    'authenticated',
    has_table_privilege('authenticated', 'public.enquiries', 'INSERT'),
    has_table_privilege('authenticated', 'public.enquiries', 'SELECT');

-- ============================================================
-- PART 4: TEST INSERT AS ANON USER
-- ============================================================

-- This will test if anon can actually insert
-- Set role to anon temporarily
SET ROLE anon;

-- Try to insert
INSERT INTO public.enquiries (
    customer_name,
    customer_email,
    customer_phone,
    products,
    notes
) VALUES (
    'SQL Test User',
    'sqltest@example.com',
    '0400000000',
    '[{"id": 999, "name": "SQL Test Product", "quantity": 1}]'::jsonb,
    'Test insert from SQL as anon role'
) RETURNING id, customer_name, created_at;

-- Reset role
RESET ROLE;

-- Final success message
SELECT '✅ ULTIMATE FIX COMPLETE! If you see a record inserted above, RLS is working!' AS status;
