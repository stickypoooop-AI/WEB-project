-- ============================================================
-- Enquiries RLS Policies - Production Ready
-- ============================================================
-- Purpose: Enable anonymous enquiry submissions while maintaining security
-- Allows: anon/authenticated users can INSERT only
-- Denies: anon users cannot SELECT/UPDATE/DELETE
-- ============================================================

-- Step 1: Enable RLS on enquiries table (idempotent)
ALTER TABLE public.enquiries ENABLE ROW LEVEL SECURITY;

-- Step 2: Drop existing conflicting policies (防重)
DROP POLICY IF EXISTS "Public can insert enquiries" ON public.enquiries;
DROP POLICY IF EXISTS "Allow all inserts" ON public.enquiries;
DROP POLICY IF EXISTS "Allow authenticated selects" ON public.enquiries;
DROP POLICY IF EXISTS "anon_insert_enquiries" ON public.enquiries;
DROP POLICY IF EXISTS "authenticated_select_enquiries" ON public.enquiries;
DROP POLICY IF EXISTS "authenticated_insert_enquiries" ON public.enquiries;
DROP POLICY IF EXISTS "Enable insert for all users" ON public.enquiries;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON public.enquiries;

-- Step 3: Create INSERT policy for anonymous and authenticated users
-- This allows anyone to submit enquiries via the website
CREATE POLICY "Public can insert enquiries"
ON public.enquiries
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- Step 4: Create SELECT policy for authenticated users only
-- This allows admin users to view all enquiries
CREATE POLICY "Authenticated users can select enquiries"
ON public.enquiries
FOR SELECT
TO authenticated
USING (true);

-- Step 5: Ensure created_at has default value (optional but recommended)
-- This prevents insert failures if created_at is not provided
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'enquiries'
      AND column_name = 'created_at'
  ) THEN
    EXECUTE 'ALTER TABLE public.enquiries ALTER COLUMN created_at SET DEFAULT now()';
  END IF;
END $$;

-- Step 6: Ensure updated_at has default value (if exists)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'enquiries'
      AND column_name = 'updated_at'
  ) THEN
    EXECUTE 'ALTER TABLE public.enquiries ALTER COLUMN updated_at SET DEFAULT now()';
  END IF;
END $$;

-- Step 7: Grant minimum required permissions (通常 Supabase 已具备，但显式确认)
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT INSERT ON TABLE public.enquiries TO anon, authenticated;
GRANT SELECT ON TABLE public.enquiries TO authenticated;

-- ============================================================
-- Verification Queries
-- ============================================================

-- Query 1: Show all policies on enquiries table
SELECT
    policyname,
    permissive,
    roles::text,
    cmd,
    qual::text AS using_expression,
    with_check::text AS with_check_expression
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'enquiries'
ORDER BY policyname;

-- Query 2: Verify RLS is enabled
SELECT
    schemaname,
    tablename,
    rowsecurity AS rls_enabled
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'enquiries';

-- Query 3: Check role permissions
SELECT
    'anon' AS role_name,
    has_table_privilege('anon', 'public.enquiries', 'INSERT') AS can_insert,
    has_table_privilege('anon', 'public.enquiries', 'SELECT') AS can_select,
    has_table_privilege('anon', 'public.enquiries', 'UPDATE') AS can_update,
    has_table_privilege('anon', 'public.enquiries', 'DELETE') AS can_delete
UNION ALL
SELECT
    'authenticated' AS role_name,
    has_table_privilege('authenticated', 'public.enquiries', 'INSERT') AS can_insert,
    has_table_privilege('authenticated', 'public.enquiries', 'SELECT') AS can_select,
    has_table_privilege('authenticated', 'public.enquiries', 'UPDATE') AS can_update,
    has_table_privilege('authenticated', 'public.enquiries', 'DELETE') AS can_delete;

-- Success message
SELECT '✅ Enquiries RLS policies configured successfully!' AS status;
SELECT '📝 Summary: anon/authenticated can INSERT, only authenticated can SELECT' AS summary;
