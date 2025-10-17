-- ============================================================
-- Simple Permission Check for Enquiries Table
-- ============================================================
-- This single query checks if anon role can insert into enquiries
-- ============================================================

-- Check permissions for anon and authenticated roles
SELECT
    'anon' as role_name,
    has_table_privilege('anon', 'enquiries', 'INSERT') as can_insert,
    has_table_privilege('anon', 'enquiries', 'SELECT') as can_select
UNION ALL
SELECT
    'authenticated' as role_name,
    has_table_privilege('authenticated', 'enquiries', 'INSERT') as can_insert,
    has_table_privilege('authenticated', 'enquiries', 'SELECT') as can_select;
