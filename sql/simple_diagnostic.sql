-- ============================================================
-- SIMPLE DIAGNOSTIC - Run each query separately
-- ============================================================

-- QUERY 1: Check if policies exist
-- Copy and run this first
SELECT
    policyname,
    roles::text AS for_roles,
    cmd AS command
FROM pg_policies
WHERE tablename = 'enquiries';

-- Expected: Should see 2 policies
-- 1. "Public can insert enquiries" for {anon,authenticated} INSERT
-- 2. "Authenticated users can select enquiries" for {authenticated} SELECT
