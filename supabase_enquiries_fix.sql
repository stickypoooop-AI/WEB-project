-- ============================================================
-- Enquiries Table RLS Policy Complete Fix
-- ============================================================
-- This script completely resets and reconfigures RLS policies
-- for the enquiries table to allow public enquiry submissions.
--
-- Run this in: Supabase Dashboard → SQL Editor
-- ============================================================

-- Step 1: Disable RLS temporarily
ALTER TABLE enquiries DISABLE ROW LEVEL SECURITY;

-- Step 2: Drop ALL existing policies (clean slate)
DROP POLICY IF EXISTS "Anyone can insert enquiries" ON enquiries;
DROP POLICY IF EXISTS "Authenticated users can view enquiries" ON enquiries;
DROP POLICY IF EXISTS "Public can submit enquiries" ON enquiries;
DROP POLICY IF EXISTS "Enable insert for all users" ON enquiries;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON enquiries;

-- Step 3: Re-enable RLS
ALTER TABLE enquiries ENABLE ROW LEVEL SECURITY;

-- Step 4: Create NEW policies with explicit permissions

-- Policy 1: Allow anyone to INSERT enquiries (public access)
CREATE POLICY "Enable insert for all users" ON enquiries
    FOR INSERT
    WITH CHECK (true);

-- Policy 2: Allow authenticated users to SELECT enquiries (admin access)
CREATE POLICY "Enable read access for authenticated users" ON enquiries
    FOR SELECT
    USING (auth.role() = 'authenticated');

-- ============================================================
-- Verification Queries
-- ============================================================

-- Show all policies for enquiries table
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
WHERE tablename = 'enquiries';

-- Show RLS status for enquiries table
SELECT
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables
WHERE tablename = 'enquiries';

-- Success message
SELECT '✅ Enquiries RLS Policies have been completely reset and reconfigured!' AS status;
SELECT '📋 Please check the query results above to verify policies are active.' AS next_step;
