-- ============================================================
-- ABSOLUTE FIX for Enquiries RLS - Complete Reset
-- ============================================================
-- This script completely resets all RLS policies for enquiries table
-- and creates simple, working policies for anonymous INSERT
-- ============================================================

-- Step 1: Temporarily disable RLS
ALTER TABLE enquiries DISABLE ROW LEVEL SECURITY;

-- Step 2: Drop ALL existing policies (using dynamic SQL to be thorough)
DO $$
DECLARE
    policy_record RECORD;
BEGIN
    FOR policy_record IN
        SELECT policyname
        FROM pg_policies
        WHERE schemaname = 'public' AND tablename = 'enquiries'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON enquiries', policy_record.policyname);
    END LOOP;
END $$;

-- Step 3: Verify all policies are dropped
-- This should return 0 rows
SELECT policyname FROM pg_policies WHERE tablename = 'enquiries';

-- Step 4: Re-enable RLS
ALTER TABLE enquiries ENABLE ROW LEVEL SECURITY;

-- Step 5: Create simple INSERT policy for everyone (public)
CREATE POLICY "Allow all inserts"
ON enquiries
FOR INSERT
TO public
WITH CHECK (true);

-- Step 6: Create SELECT policy for authenticated users (for admin)
CREATE POLICY "Allow authenticated selects"
ON enquiries
FOR SELECT
TO authenticated
USING (true);

-- ============================================================
-- VERIFICATION QUERIES
-- ============================================================

-- Show RLS status
SELECT
    schemaname,
    tablename,
    rowsecurity AS rls_enabled
FROM pg_tables
WHERE tablename = 'enquiries';

-- Show all policies with details
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'enquiries'
ORDER BY policyname;

-- Check role permissions
SELECT
    'anon' as role_name,
    has_table_privilege('anon', 'enquiries', 'INSERT') as can_insert,
    has_table_privilege('anon', 'enquiries', 'SELECT') as can_select
UNION ALL
SELECT
    'authenticated' as role_name,
    has_table_privilege('authenticated', 'enquiries', 'INSERT') as can_insert,
    has_table_privilege('authenticated', 'enquiries', 'SELECT') as can_select
UNION ALL
SELECT
    'public' as role_name,
    has_table_privilege('public', 'enquiries', 'INSERT') as can_insert,
    has_table_privilege('public', 'enquiries', 'SELECT') as can_select;

-- Success message
SELECT '✅ RLS ABSOLUTE FIX COMPLETE! All policies reset and reconfigured.' AS status;
