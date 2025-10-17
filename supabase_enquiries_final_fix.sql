-- ============================================================
-- Enquiries Table FINAL FIX - Explicit ANON Role
-- ============================================================
-- This script explicitly grants INSERT permission to the ANON role
-- which is used by unauthenticated Supabase clients
-- ============================================================

-- Step 1: Disable RLS temporarily
ALTER TABLE enquiries DISABLE ROW LEVEL SECURITY;

-- Step 2: Drop ALL existing policies
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'enquiries') LOOP
        EXECUTE 'DROP POLICY IF EXISTS "' || r.policyname || '" ON enquiries';
    END LOOP;
END $$;

-- Step 3: Re-enable RLS
ALTER TABLE enquiries ENABLE ROW LEVEL SECURITY;

-- Step 4: Create policy explicitly for ANON role (unauthenticated users)
CREATE POLICY "anon_insert_enquiries" ON enquiries
    FOR INSERT
    TO anon
    WITH CHECK (true);

-- Step 5: Create policy for AUTHENTICATED role (admin view)
CREATE POLICY "authenticated_select_enquiries" ON enquiries
    FOR SELECT
    TO authenticated
    USING (true);

-- Step 6: Also create policy for AUTHENTICATED to insert (backup)
CREATE POLICY "authenticated_insert_enquiries" ON enquiries
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- ============================================================
-- Verification
-- ============================================================

-- Show all policies
SELECT
    policyname,
    cmd,
    roles::text,
    with_check::text
FROM pg_policies
WHERE tablename = 'enquiries'
ORDER BY policyname;

-- Test permissions
SELECT
    'anon' as role_name,
    has_table_privilege('anon', 'enquiries', 'INSERT') as can_insert,
    has_table_privilege('anon', 'enquiries', 'SELECT') as can_select
UNION ALL
SELECT
    'authenticated' as role_name,
    has_table_privilege('authenticated', 'enquiries', 'INSERT') as can_insert,
    has_table_privilege('authenticated', 'enquiries', 'SELECT') as can_select;

SELECT '✅ FINAL FIX: Policies now explicitly target ANON role!' AS status;
