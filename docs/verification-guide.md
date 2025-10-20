# Enquiries RLS Verification & Testing Guide

This guide provides step-by-step verification procedures to ensure the RLS policies are correctly configured and the enquiry submission system is working as expected.

---

## 📋 Pre-Flight Checklist

Before testing, ensure:

- [ ] SQL script executed: `sql/enquiries_policies.sql`
- [ ] No errors in SQL execution
- [ ] All verification queries returned expected results
- [ ] Frontend code deployed with rate limiting

---

## 🔍 Verification Step 1: SQL Policy Verification

### Open Supabase SQL Editor

1. Navigate to: https://supabase.com/dashboard/project/zoxiyuaf2kymgxmsluifsql
2. Click **SQL Editor** in left menu
3. Click **New query**

### Run Verification Query

Copy and paste the following query:

```sql
-- Verification Query: Show all RLS policies on enquiries table
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
```

### Expected Output

You should see exactly **2 policies**:

| policyname | permissive | roles | cmd | using_expression | with_check_expression |
|------------|------------|-------|-----|------------------|------------------------|
| Authenticated users can select enquiries | PERMISSIVE | {authenticated} | SELECT | true | - |
| Public can insert enquiries | PERMISSIVE | {anon,authenticated} | INSERT | - | true |

### ✅ Pass Criteria:
- Both policies exist
- `Public can insert enquiries` targets `{anon,authenticated}` for `INSERT`
- `Authenticated users can select enquiries` targets `{authenticated}` for `SELECT`

### ❌ If Policies Missing:
Re-run `sql/enquiries_policies.sql` completely

---

## 🔍 Verification Step 2: Permission Check

### Run Permission Query

```sql
-- Check role permissions
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
```

### Expected Output

| role_name | can_insert | can_select | can_update | can_delete |
|-----------|------------|------------|------------|------------|
| anon | **true** | false | false | false |
| authenticated | **true** | **true** | false | false |

### ✅ Pass Criteria:
- `anon` can only INSERT
- `authenticated` can INSERT and SELECT
- Both roles cannot UPDATE or DELETE

### ❌ If Permissions Wrong:
Run GRANT statements from `sql/enquiries_policies.sql`

---

## 🔍 Verification Step 3: RLS Status Check

### Run RLS Status Query

```sql
-- Verify RLS is enabled
SELECT
    schemaname,
    tablename,
    rowsecurity AS rls_enabled
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'enquiries';
```

### Expected Output

| schemaname | tablename | rls_enabled |
|------------|-----------|-------------|
| public | enquiries | **true** |

### ✅ Pass Criteria:
- `rls_enabled` = **true**

### ❌ If RLS Disabled:
```sql
ALTER TABLE public.enquiries ENABLE ROW LEVEL SECURITY;
```

---

## 🧪 Testing Step 1: Browser Console Test (Anonymous Insert)

### 1. Open Your Website

Navigate to: https://web-project-naxiwell.vercel.app

### 2. Open Browser Developer Tools

- **Chrome/Edge**: Press `F12` or `Ctrl+Shift+I` (Windows) / `Cmd+Option+I` (Mac)
- **Firefox**: Press `F12` or `Ctrl+Shift+K`
- **Safari**: `Cmd+Option+C`

### 3. Switch to Console Tab

### 4. Run Test Script

Copy and paste the following code into the console:

```javascript
// Anonymous Insert Test
(async () => {
  console.log('🧪 Starting anonymous insert test...');

  try {
    // Get Supabase client from global scope
    const { createClient } = window.supabase || supabase;
    const testClient = createClient(
      window.APP_CONFIG.supabase.url,
      window.APP_CONFIG.supabase.anonKey
    );

    console.log('📡 Supabase client initialized');
    console.log('URL:', window.APP_CONFIG.supabase.url);
    console.log('Using anon key:', window.APP_CONFIG.supabase.anonKey.substring(0, 20) + '...');

    // Test data
    const testData = {
      customer_name: 'Test User - Console',
      customer_email: 'test@example.com',
      customer_phone: '0412345678',
      company_name: 'Test Company',
      customer_address: '123 Test Street',
      products: [
        {
          id: 1,
          name: 'Test Product',
          quantity: 5,
          price: 1.99,
          specs: 'M6*40mm | Stainless Steel | Zinc Plated'
        }
      ],
      notes: 'This is a test submission from browser console'
    };

    console.log('📝 Test data prepared:', testData);

    // Attempt insert
    console.log('🚀 Attempting INSERT...');
    const { data, error } = await testClient
      .from('enquiries')
      .insert([testData])
      .select();

    if (error) {
      console.error('❌ INSERT FAILED');
      console.error('Error code:', error.code);
      console.error('Error message:', error.message);
      console.error('Error details:', error.details);
      console.error('Error hint:', error.hint);
      console.error('Full error object:', error);

      // Check if it's RLS error
      if (error.code === '42501') {
        console.error('🔒 RLS POLICY VIOLATION - Policies not configured correctly!');
      } else if (error.code === 'PGRST116') {
        console.error('🔒 RLS POLICY NOT FOUND - No policies exist for this operation!');
      }

      return;
    }

    console.log('✅ INSERT SUCCESSFUL');
    console.log('Inserted data:', data);
    console.log('Record ID:', data[0]?.id);
    console.log('Customer name:', data[0]?.customer_name);

    // Test SELECT (should fail for anon)
    console.log('\n🧪 Testing SELECT (should fail for anon)...');
    const { data: selectData, error: selectError } = await testClient
      .from('enquiries')
      .select('*')
      .limit(1);

    if (selectError) {
      console.log('✅ SELECT CORRECTLY DENIED for anon role');
      console.log('Error code:', selectError.code);
    } else {
      console.warn('⚠️ WARNING: SELECT should be denied for anon, but succeeded!');
      console.warn('This indicates a security issue - anon can read data!');
    }

    console.log('\n✅ All tests completed successfully!');

  } catch (error) {
    console.error('❌ Test failed with exception:', error);
  }
})();
```

### Expected Console Output

```
🧪 Starting anonymous insert test...
📡 Supabase client initialized
URL: https://zoxiyuaf2kymgxmsluifsql.supabase.co
Using anon key: eyJhbGciOiJIUzI1NiIs...
📝 Test data prepared: {...}
🚀 Attempting INSERT...
✅ INSERT SUCCESSFUL
Inserted data: [{...}]
Record ID: 123
Customer name: Test User - Console

🧪 Testing SELECT (should fail for anon)...
✅ SELECT CORRECTLY DENIED for anon role
Error code: 42501

✅ All tests completed successfully!
```

### ✅ Pass Criteria:
- ✅ INSERT succeeds without errors
- ✅ Returns inserted data with ID
- ✅ SELECT fails with error code `42501`

### ❌ Failure Scenarios:

#### Scenario A: INSERT fails with error `42501`
```
❌ INSERT FAILED
Error code: 42501
🔒 RLS POLICY VIOLATION - Policies not configured correctly!
```
**Solution**: Re-run `sql/enquiries_policies.sql`

#### Scenario B: INSERT fails with error `PGRST116`
```
❌ INSERT FAILED
Error code: PGRST116
🔒 RLS POLICY NOT FOUND - No policies exist for this operation!
```
**Solution**: Policies missing entirely, re-run SQL script

#### Scenario C: SELECT succeeds (Security Issue!)
```
⚠️ WARNING: SELECT should be denied for anon, but succeeded!
This indicates a security issue - anon can read data!
```
**Solution**: Drop incorrect SELECT policies:
```sql
DROP POLICY IF EXISTS "Enable read access for all users" ON public.enquiries;
```

---

## 🧪 Testing Step 2: Full Frontend Flow Test

### 1. Open Website in Incognito/Private Window

This ensures no cached authentication

### 2. Add Products to Cart

1. Click on any product card
2. Click "Add to Cart"
3. Repeat for 2-3 products

### 3. Submit Enquiry

1. Click cart icon (top right)
2. Click "Proceed to Enquiry"
3. Fill in form:
   - **Name**: Your Name
   - **Email**: your.email@example.com
   - **Phone**: 0412345678
   - **Company** (optional): Test Company
   - **Address** (optional): 123 Test St
   - **Notes** (optional): Test enquiry
4. Click "Submit Enquiry"

### Expected Behavior

#### First Submission:
- ✅ Button shows "Submitting..." briefly
- ✅ Success alert appears: "✅ Thank you for your enquiry..."
- ✅ Cart clears
- ✅ Modal closes
- ✅ Form resets

#### Second Immediate Submission:
- ⏳ Alert shows: "Please wait XX seconds before submitting another enquiry"
- ✅ Submission blocked (rate limiting working)

#### After 30 Seconds:
- ✅ Can submit again successfully

### Check Browser Console

Should see:
```
✅ Insert successful: {...}
✅ Email sent successfully
```

Should NOT see:
```
❌ Error submitting enquiry: ...
Error code: 42501
```

---

## 🧪 Testing Step 3: Verify Data in Supabase

### 1. Open Supabase Dashboard

Navigate to: https://supabase.com/dashboard/project/zoxiyuaf2kymgxmsluifsql

### 2. Go to Table Editor

Click **Table Editor** → **enquiries**

### 3. Check Recent Records

You should see:
- Recent test submissions
- All required fields populated
- `created_at` timestamps

### 4. Verify Data Integrity

Check that:
- `customer_name`, `customer_email`, `customer_phone` match your input
- `products` JSONB contains correct product array
- `notes` contains your message

---

## 🔍 Troubleshooting Common Issues

### Issue 1: "new row violates row-level security policy"

**Diagnosis**:
```sql
-- Check if policies exist
SELECT * FROM pg_policies WHERE tablename='enquiries';
```

**If returns 0 rows**: Policies not created
**Solution**: Re-run `sql/enquiries_policies.sql`

**If returns rows but still fails**: Policy syntax error
**Solution**:
```sql
-- Drop all and recreate
DROP POLICY IF EXISTS "Public can insert enquiries" ON public.enquiries;
DROP POLICY IF EXISTS "Authenticated users can select enquiries" ON public.enquiries;

-- Then re-run sql/enquiries_policies.sql
```

### Issue 2: Frontend shows "Database permission issue"

**Cause**: RLS policy violation (code 42501)

**Check**:
1. Verify policies exist (see Verification Step 1)
2. Verify permissions (see Verification Step 2)
3. Ensure frontend uses `anonKey` not `serviceRoleKey`

**Verify frontend config**:
```javascript
// In browser console
console.log('Supabase URL:', window.APP_CONFIG.supabase.url);
console.log('Anon Key:', window.APP_CONFIG.supabase.anonKey.substring(0, 20) + '...');
// Should NOT show service_role key!
```

### Issue 3: Rate limiting not working

**Check**:
```javascript
// In browser console
console.log('ENQUIRY_COOLDOWN_MS:', ENQUIRY_COOLDOWN_MS);
console.log('lastEnquiryTime:', lastEnquiryTime);
```

Should show:
```
ENQUIRY_COOLDOWN_MS: 30000
lastEnquiryTime: 1729xxxxx (timestamp after first submission)
```

**If undefined**: Script not loaded, hard refresh (`Ctrl+Shift+R`)

### Issue 4: EmailJS not sending emails

**This is separate from RLS** - even if email fails, database INSERT should succeed

**Check**:
```javascript
// In browser console after submission
// Look for:
✅ Insert successful: {...}
❌ Email failed: {...}  // Email error is separate
```

**Database insert success** = RLS working correctly
**Email failure** = EmailJS configuration issue (check EmailJS dashboard)

---

## 📊 Success Metrics

All checks should pass:

- [x] SQL Verification: 2 policies visible
- [x] Permission Check: anon can INSERT, cannot SELECT
- [x] RLS Status: Enabled on enquiries table
- [x] Browser Console Test: INSERT succeeds, SELECT fails
- [x] Frontend Test: Submission succeeds with success message
- [x] Rate Limiting: Second submission blocked for 30s
- [x] Data in Supabase: Records appear in table editor

---

## 🎯 Final Validation Checklist

Run this final check after all tests:

```sql
-- Final comprehensive validation
SELECT
  'RLS Enabled' AS check_item,
  CASE WHEN rowsecurity THEN '✅ PASS' ELSE '❌ FAIL' END AS status
FROM pg_tables
WHERE schemaname='public' AND tablename='enquiries'

UNION ALL

SELECT
  'Insert Policy Exists',
  CASE WHEN COUNT(*) > 0 THEN '✅ PASS' ELSE '❌ FAIL' END
FROM pg_policies
WHERE tablename='enquiries' AND cmd='INSERT' AND 'anon' = ANY(roles::text[])

UNION ALL

SELECT
  'Select Policy Exists',
  CASE WHEN COUNT(*) > 0 THEN '✅ PASS' ELSE '❌ FAIL' END
FROM pg_policies
WHERE tablename='enquiries' AND cmd='SELECT' AND 'authenticated' = ANY(roles::text[])

UNION ALL

SELECT
  'Anon Can Insert',
  CASE WHEN has_table_privilege('anon', 'public.enquiries', 'INSERT')
       THEN '✅ PASS' ELSE '❌ FAIL' END

UNION ALL

SELECT
  'Anon Cannot Select',
  CASE WHEN NOT has_table_privilege('anon', 'public.enquiries', 'SELECT')
       THEN '✅ PASS' ELSE '❌ FAIL' END;
```

### Expected Output

| check_item | status |
|------------|--------|
| RLS Enabled | ✅ PASS |
| Insert Policy Exists | ✅ PASS |
| Select Policy Exists | ✅ PASS |
| Anon Can Insert | ✅ PASS |
| Anon Cannot Select | ✅ PASS |

All rows should show `✅ PASS` - if any show `❌ FAIL`, revisit corresponding verification step.

---

## 📞 Support

If all verification steps pass but issues persist:

1. Clear browser cache completely
2. Test in incognito/private window
3. Check Supabase Dashboard → Logs for detailed errors
4. Review browser console for network errors
5. Contact support with:
   - Screenshot of SQL verification results
   - Browser console error output
   - Supabase logs from time of error
