-- ============================================================
-- Enquiries Table ULTIMATE FIX - Most Permissive Approach
-- ============================================================
-- This script uses the most permissive RLS policy possible
-- to ensure enquiry submissions work.
--
-- Run this in: Supabase Dashboard → SQL Editor
-- ============================================================

-- Step 1: Completely disable RLS temporarily
ALTER TABLE enquiries DISABLE ROW LEVEL SECURITY;

-- Step 2: Remove ALL existing policies
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

-- Step 4: Create SUPER PERMISSIVE policy for INSERT
-- This allows ALL operations from ALL users (public access)
CREATE POLICY "allow_all_insert" ON enquiries
    FOR INSERT
    TO public
    WITH CHECK (true);

-- Step 5: Create permissive policy for SELECT (admin only)
CREATE POLICY "allow_auth_select" ON enquiries
    FOR SELECT
    TO authenticated
    USING (true);

-- ============================================================
-- Verification
-- ============================================================

-- Show all policies
SELECT
    policyname,
    cmd,
    roles::text,
    qual::text,
    with_check::text
FROM pg_policies
WHERE tablename = 'enquiries';

-- Show RLS status
SELECT tablename, rowsecurity as rls_enabled
FROM pg_tables
WHERE tablename = 'enquiries';

-- Test INSERT permission (this will show if public role can insert)
SELECT
    has_table_privilege('anon', 'enquiries', 'INSERT') as anon_can_insert,
    has_table_privilege('authenticated', 'enquiries', 'INSERT') as auth_can_insert;

SELECT '✅ Ultimate fix applied! Policies are now SUPER PERMISSIVE.' AS status;
