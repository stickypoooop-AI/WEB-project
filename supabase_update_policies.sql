-- Update RLS Policies for Admin Operations
-- Run this SQL in Supabase SQL Editor if you've already created the tables

-- Drop existing policies
DROP POLICY IF EXISTS "Authenticated users can insert products" ON products;
DROP POLICY IF EXISTS "Authenticated users can update products" ON products;
DROP POLICY IF EXISTS "Authenticated users can delete products" ON products;

-- Create new policies allowing public access (admin verification is in frontend)
CREATE POLICY "Anyone can insert products" ON products
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can update products" ON products
    FOR UPDATE USING (true);

CREATE POLICY "Anyone can delete products" ON products
    FOR DELETE USING (true);

-- Create Storage Bucket Policies (if product-images bucket exists)
-- These will be created automatically when you create the bucket
-- But here's the SQL for reference:

-- INSERT INTO storage.buckets (id, name, public)
-- VALUES ('product-images', 'product-images', true)
-- ON CONFLICT (id) DO NOTHING;

-- Storage policies for product-images bucket
-- Allow public read access
-- INSERT INTO storage.policies (name, bucket_id, definition)
-- VALUES (
--     'Public Read Access',
--     'product-images',
--     'bucket_id = ''product-images'''
-- );

-- Allow public upload (admin verification in frontend)
-- INSERT INTO storage.policies (name, bucket_id, definition, operation)
-- VALUES (
--     'Public Upload Access',
--     'product-images',
--     'bucket_id = ''product-images''',
--     'INSERT'
-- );

SELECT 'RLS Policies updated successfully!' AS message;
