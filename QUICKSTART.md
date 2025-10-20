# 🚀 Quick Start Guide - Enquiries RLS Fix

**Problem**: `Error: new row violates row-level security policy for table "enquiries"`

**Solution**: Execute SQL script to enable anonymous enquiry submissions

**Time Required**: 5 minutes

---

## ⚡ 3-Step Deployment

### Step 1: Execute SQL Script (2 minutes)

1. Open Supabase Dashboard:
   - URL: https://supabase.com/dashboard/project/zoxiyuaf2kymgxmsluifsql
   - Click **SQL Editor** in left menu
   - Click **New query**

2. Copy and paste **entire contents** of `sql/enquiries_policies.sql`

3. Click **Run** button (or press `Ctrl+Enter` / `Cmd+Enter`)

4. ✅ **Success**: You should see "✅ Enquiries RLS policies configured successfully!"

---

### Step 2: Deploy Frontend Changes (1 minute)

**If using Git + Vercel**:
```bash
git add script.js
git commit -m "feat: Add rate limiting and error handling"
git push
```
Vercel will auto-deploy in ~2 minutes.

**If updating manually**:
- Replace `script.js` on your server with the updated version
- Clear CDN cache if using Cloudflare/Vercel

---

### Step 3: Test (2 minutes)

1. Open website: https://web-project-naxiwell.vercel.app

2. Open browser console (`F12`)

3. Run this test:
```javascript
(async () => {
  const { createClient } = window.supabase;
  const client = createClient(
    window.APP_CONFIG.supabase.url,
    window.APP_CONFIG.supabase.anonKey
  );

  const { data, error } = await client
    .from('enquiries')
    .insert([{
      customer_name: 'Test User',
      customer_email: 'test@example.com',
      customer_phone: '0412345678',
      products: [{ id: 1, name: 'Test', quantity: 1 }]
    }])
    .select();

  if (error) {
    console.error('❌ FAILED:', error.code, error.message);
  } else {
    console.log('✅ SUCCESS:', data);
  }
})();
```

4. ✅ **Expected**: `✅ SUCCESS: [{ id: ..., customer_name: 'Test User', ... }]`

---

## ✅ Success Criteria

All of these should be true:

- [x] SQL script executed without errors
- [x] Verification queries show 2 policies
- [x] Browser console test shows `✅ SUCCESS`
- [x] Website form submission works
- [x] Second immediate submission shows "Please wait XX seconds"

---

## ❌ Troubleshooting

### SQL Execution Failed

**Error**: "permission denied" or "relation does not exist"

**Solution**:
- Ensure you're logged in as project owner
- Check table exists: `SELECT * FROM public.enquiries LIMIT 1;`

### Browser Test Shows `❌ FAILED`

**Check error code**:

| Error Code | Cause | Solution |
|------------|-------|----------|
| `42501` | RLS policy violation | Re-run SQL script |
| `PGRST116` | Policy not found | Re-run SQL script |
| `23505` | Duplicate data | Change test email |

### Frontend Still Shows Error

**Steps**:
1. Hard refresh browser: `Ctrl+Shift+R` (Windows) or `Cmd+Shift+R` (Mac)
2. Clear site data: DevTools → Application → Clear storage
3. Test in incognito/private window
4. Check if `script.js` changes deployed: View page source and search for `ENQUIRY_COOLDOWN_MS`

---

## 📚 Full Documentation

For detailed information, see:

- **SQL Script**: `sql/enquiries_policies.sql`
- **Policy Documentation**: `docs/enquiries-rls-readme.md`
- **Testing Guide**: `docs/verification-guide.md`
- **Deployment Summary**: `docs/deployment-summary.md`

---

## 🆘 Still Having Issues?

1. **Check Supabase Logs**:
   - Dashboard → Logs → Database
   - Look for `42501` errors

2. **Verify Policies**:
   ```sql
   SELECT policyname, roles::text, cmd
   FROM pg_policies
   WHERE tablename = 'enquiries';
   ```
   Should show:
   - `Public can insert enquiries` for `{anon,authenticated}` INSERT
   - `Authenticated users can select enquiries` for `{authenticated}` SELECT

3. **Contact Support**:
   - Email: stickypoooop@gmail.com
   - Include: SQL verification output + browser console errors

---

## 🎯 What Changed?

### Database
- ✅ Enabled RLS on `enquiries` table
- ✅ Created INSERT policy for anonymous users
- ✅ Created SELECT policy for authenticated users only

### Frontend (`script.js`)
- ✅ Added 30-second rate limiting
- ✅ Improved error messages (bilingual)
- ✅ Button disable during submission
- ✅ Enhanced validation
- ✅ Detailed error logging

### Security
- ✅ Anonymous users can **INSERT only**
- ✅ Anonymous users **cannot SELECT/UPDATE/DELETE**
- ✅ Admin users can **SELECT** all enquiries
- ✅ Rate limiting prevents spam

---

**Ready to deploy? Start with Step 1! 🚀**
