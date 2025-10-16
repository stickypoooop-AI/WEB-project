# 🔧 Setup Instructions - IMPORTANT

## ⚠️ Required Manual Steps

You **MUST** complete these steps in your Supabase Dashboard for the website to work properly:

---

## Step 1: Update RLS Policies (CRITICAL)

### Option A: If you haven't run the SQL schema yet

1. Go to Supabase Dashboard → SQL Editor
2. Copy the entire contents of `supabase_schema.sql`
3. Paste and Run

### Option B: If you already created the tables

1. Go to Supabase Dashboard → SQL Editor
2. Copy the entire contents of `supabase_update_policies.sql`
3. Paste and Run

This will fix the permission issues that prevented products from being added.

---

## Step 2: Create Storage Bucket (REQUIRED)

### Create the bucket:

1. Go to **Supabase Dashboard** → **Storage** (left sidebar)
2. Click **"New bucket"**
3. Fill in the form:
   - **Name**: `product-images` (exact name, no spaces)
   - **Public bucket**: ✅ **CHECK THIS BOX** (very important!)
   - **File size limit**: 20 MB
   - **Allowed MIME types**: Leave empty (allows all)
4. Click **"Create bucket"**

### Configure bucket policies:

1. Click on the `product-images` bucket
2. Go to **"Policies"** tab
3. Click **"New Policy"**

**Policy 1: Public Read Access**
- Policy name: `Public Read Access`
- Target: `SELECT`
- Definition: `true`
- Click **"Create policy"**

**Policy 2: Public Upload Access**
- Policy name: `Public Upload Access`
- Target: `INSERT`
- Definition: `true`
- Click **"Create policy"**

**Policy 3: Public Delete Access** (for admins)
- Policy name: `Public Delete Access`
- Target: `DELETE`
- Definition: `true`
- Click **"Create policy"**

---

## Step 3: Verify Setup

### Test in Supabase Dashboard:

1. **Check Tables**:
   - Go to **Table Editor** → **products**
   - Should see 24 products (if you ran the schema with sample data)

2. **Check Storage**:
   - Go to **Storage** → **product-images**
   - Should see the bucket listed
   - Should show as **Public**

3. **Check Policies**:
   - Go to **Table Editor** → **products** → **RLS Policies**
   - Should see policies allowing public access

---

## Step 4: Deploy to Vercel

Once Supabase is set up, your changes will auto-deploy to Vercel (if connected to GitHub).

If not auto-deploying:
1. Go to Vercel Dashboard
2. Select your project
3. Click **"Redeploy"**

---

## Testing Checklist

After completing the setup, test these features:

### Frontend (Public):
- [ ] Products load on homepage
- [ ] Can view product details
- [ ] Can add products to enquiry cart
- [ ] Can submit enquiry form

### Admin (Backend):
- [ ] Can login to admin dashboard (key: `12345678901234567890123456789012`)
- [ ] Can see all products in admin table
- [ ] **Can add new product with image upload** ✨
- [ ] Image upload shows preview
- [ ] Can edit existing product
- [ ] Can delete product

---

## 🎉 New Features

### Image Upload System:
- ✅ **Drag & Drop**: Select images from your computer
- ✅ **Format Support**: PNG, JPG, JPEG, WebP
- ✅ **Size Limit**: Maximum 20MB per image
- ✅ **Live Preview**: See image before uploading
- ✅ **Validation**: Automatic file type and size checking
- ✅ **Cloud Storage**: Images stored in Supabase Storage
- ✅ **Public Access**: Images immediately available on frontend

---

## Troubleshooting

### Problem: "Failed to save product"

**Solutions**:
1. Verify RLS policies are updated (Step 1)
2. Check browser console for errors
3. Ensure `product-images` bucket exists (Step 2)

### Problem: "Storage API error"

**Solutions**:
1. Verify bucket is set to **Public**
2. Check bucket policies are configured (Step 2)
3. Verify bucket name is exactly `product-images`

### Problem: Images not displaying

**Solutions**:
1. Check image URL in database (should start with your Supabase URL)
2. Verify bucket policies allow public read access
3. Check browser console for CORS errors

### Problem: Can't upload images

**Solutions**:
1. Check file is under 20MB
2. Check file format (PNG, JPG, JPEG, WebP only)
3. Verify upload policies exist on bucket

---

## 🔒 Security Notes

### Current Setup:
- **RLS Policies**: Allow public access (admin verification in frontend)
- **Storage**: Public bucket (required for images to display)

### Production Recommendations:
1. Implement proper Supabase Auth for admin users
2. Use Supabase Auth JWT tokens for RLS policies
3. Add rate limiting for uploads
4. Consider using signed URLs for images

---

## 📞 Need Help?

If you encounter issues:

1. Check Supabase logs: **Dashboard** → **Logs**
2. Check browser console for errors (F12)
3. Verify all setup steps completed
4. Check that Vercel deployment succeeded

---

## 🎯 Summary

**What You Did**:
- ✅ Fixed RLS policies for database operations
- ✅ Added image upload functionality
- ✅ Created Supabase Storage integration
- ✅ Replaced URL input with file upload

**What You Need to Do**:
- ⚠️ Run SQL update script in Supabase
- ⚠️ Create `product-images` storage bucket
- ⚠️ Configure bucket policies
- ✅ Test the functionality

---

Good luck! 🚀
