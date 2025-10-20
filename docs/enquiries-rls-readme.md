# Enquiries RLS Policy Documentation

## 📋 Overview

This document describes the Row Level Security (RLS) policies implemented for the `enquiries` table to enable anonymous enquiry submissions while maintaining data security.

---

## 🎯 Policy Summary

| Role | INSERT | SELECT | UPDATE | DELETE |
|------|--------|--------|--------|--------|
| `anon` (anonymous users) | ✅ Yes | ❌ No | ❌ No | ❌ No |
| `authenticated` (logged-in admin) | ✅ Yes | ✅ Yes | ❌ No | ❌ No |

### What This Means:
- **Anonymous visitors** can submit enquiries through the website form
- **Only authenticated admin users** can view enquiry records
- **No one** can update or delete enquiries through the frontend (admin must use Supabase Dashboard)

---

## 🔒 Security Boundaries

### ✅ What's Protected:
1. **Data Privacy**: Anonymous users cannot see other users' enquiries
2. **Data Integrity**: No UPDATE/DELETE access prevents tampering
3. **Audit Trail**: All submissions are timestamped and immutable
4. **Admin Access**: Only authenticated users can view submission history

### ⚠️ Potential Risks:

#### Risk 1: Spam Submissions
- **Mitigation**: Frontend rate limiting (30s cooldown)
- **Future Enhancement**: Integrate Cloudflare Turnstile or reCAPTCHA

#### Risk 2: Data Flooding
- **Mitigation**: Database-level rate limits via Supabase quotas
- **Monitoring**: Set up alerts for unusual submission volumes

#### Risk 3: Malicious Data Injection
- **Mitigation**: Frontend validation + Supabase input sanitization
- **Best Practice**: Never render raw user input without escaping

---

## 🚀 Deployment Instructions

### 1. Execute SQL Script

Open Supabase Dashboard → SQL Editor:

```bash
# Navigate to project
https://supabase.com/dashboard/project/zoxiyuaf2kymgxmsluifsql

# Copy and paste contents of sql/enquiries_policies.sql
# Click "Run" or press Ctrl/Cmd + Enter
```

### 2. Verify Policies

After execution, you should see:

**Query 1: Policies List**
```
policyname                             | roles                    | cmd
---------------------------------------|--------------------------|--------
Public can insert enquiries            | {anon,authenticated}     | INSERT
Authenticated users can select enquiries | {authenticated}        | SELECT
```

**Query 2: RLS Status**
```
tablename  | rls_enabled
-----------|------------
enquiries  | true
```

**Query 3: Permission Check**
```
role_name      | can_insert | can_select | can_update | can_delete
---------------|------------|------------|------------|------------
anon           | true       | false      | false      | false
authenticated  | true       | true       | false      | false
```

### 3. Frontend Verification

Open browser console on your website and run:

```javascript
(async () => {
  const { createClient } = window.supabase;
  const supabase = createClient(
    window.APP_CONFIG.supabase.url,
    window.APP_CONFIG.supabase.anonKey
  );

  const { data, error } = await supabase
    .from('enquiries')
    .insert([{
      customer_name: 'Test User',
      customer_email: 'test@example.com',
      customer_phone: '0412345678',
      products: [{ id: 1, name: 'Test Product', quantity: 1 }],
      notes: 'Test submission from console'
    }])
    .select();

  if (error) {
    console.error('❌ Insert failed:', error.code, error.message);
  } else {
    console.log('✅ Insert successful:', data);
  }
})();
```

**Expected Output**: `✅ Insert successful: [{ id: ..., customer_name: 'Test User', ... }]`

---

## 🔧 Rollback Procedures

### Option 1: Disable Anonymous Inserts (Recommended)

```sql
-- Remove INSERT policy for anonymous users
DROP POLICY IF EXISTS "Public can insert enquiries" ON public.enquiries;

-- Recreate for authenticated only
CREATE POLICY "Authenticated users can insert enquiries"
ON public.enquiries
FOR INSERT
TO authenticated
WITH CHECK (true);
```

**Effect**: Only logged-in admin can create enquiries

### Option 2: Temporarily Disable All RLS (NOT RECOMMENDED for Production)

```sql
-- WARNING: This exposes all data!
ALTER TABLE public.enquiries DISABLE ROW LEVEL SECURITY;
```

**Effect**: All users can read/write/delete all enquiries (⚠️ **DANGEROUS**)

### Option 3: Restore to Default (Lock Down Everything)

```sql
-- Drop all policies
DROP POLICY IF EXISTS "Public can insert enquiries" ON public.enquiries;
DROP POLICY IF EXISTS "Authenticated users can select enquiries" ON public.enquiries;

-- Re-enable RLS (no policies = no access)
ALTER TABLE public.enquiries ENABLE ROW LEVEL SECURITY;
```

**Effect**: No one can access enquiries (including admin)

---

## 🛡️ Rate Limiting Implementation

Frontend rate limiting is implemented in `script.js`:

```javascript
// Session-based throttle: 30 seconds cooldown
const ENQUIRY_COOLDOWN_MS = 30000;
let lastEnquiryTime = 0;

async function submitEnquiry() {
  const now = Date.now();
  if (now - lastEnquiryTime < ENQUIRY_COOLDOWN_MS) {
    const remainingSeconds = Math.ceil((ENQUIRY_COOLDOWN_MS - (now - lastEnquiryTime)) / 1000);
    alert(`Please wait ${remainingSeconds} seconds before submitting another enquiry.`);
    return;
  }

  // ... rest of submission logic
  lastEnquiryTime = now;
}
```

---

## 📊 Monitoring and Alerts

### Recommended Supabase Monitoring:

1. **Database Usage**
   - Monitor `enquiries` table row count
   - Set alert for >1000 rows/day (adjust based on traffic)

2. **API Usage**
   - Track INSERT operations on `enquiries` table
   - Alert on >100 inserts/hour (potential spam)

3. **Error Rates**
   - Monitor RLS policy violations
   - Alert on repeated 403/42501 errors

### Query to Check Recent Submissions:

```sql
-- Last 24 hours submission count
SELECT COUNT(*) AS submissions_today
FROM public.enquiries
WHERE created_at >= NOW() - INTERVAL '24 hours';

-- Hourly submission rate (last 24h)
SELECT
  DATE_TRUNC('hour', created_at) AS hour,
  COUNT(*) AS submissions
FROM public.enquiries
WHERE created_at >= NOW() - INTERVAL '24 hours'
GROUP BY hour
ORDER BY hour DESC;
```

---

## 🔍 Troubleshooting

### Error: "new row violates row-level security policy"

**Causes**:
1. Policy not created or incorrectly configured
2. Using wrong Supabase key (service_role instead of anon key)
3. RLS enabled but no INSERT policy exists

**Solutions**:
1. Re-run `sql/enquiries_policies.sql`
2. Verify frontend uses `window.APP_CONFIG.supabase.anonKey`
3. Check policy exists: `SELECT * FROM pg_policies WHERE tablename='enquiries'`

### Error: "permission denied for table enquiries"

**Causes**:
1. Missing GRANT permissions for anon/authenticated roles
2. RLS disabled but no table-level permissions

**Solutions**:
```sql
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT INSERT ON TABLE public.enquiries TO anon, authenticated;
```

### Frontend: Enquiry submission succeeds but data not visible

**Expected Behavior**: This is correct! Anonymous users cannot SELECT enquiries.

**To View Data**: Log in as admin and check Supabase Dashboard → Table Editor → enquiries

---

## 📝 Change Log

| Date | Change | Author |
|------|--------|--------|
| 2025-10-17 | Initial RLS policy implementation | Claude Code |
| 2025-10-17 | Added rate limiting and error handling | Claude Code |

---

## 📞 Support

If policies fail to apply or submissions still fail:

1. Check Supabase logs: Dashboard → Logs → Database
2. Verify policies: Run verification queries in `sql/enquiries_policies.sql`
3. Test with browser console: Use verification script above
4. Contact support with error code and message

---

## 🔗 Related Documentation

- [Supabase RLS Documentation](https://supabase.com/docs/guides/auth/row-level-security)
- [PostgreSQL Policies](https://www.postgresql.org/docs/current/sql-createpolicy.html)
- Project Setup: `SETUP_INSTRUCTIONS.md`
- Environment Config: `config.js`
