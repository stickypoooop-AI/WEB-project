-- Update RLS Policies for Enquiries Table
-- Run this SQL in Supabase SQL Editor if enquiry submission is failing

-- Drop existing policies for enquiries (if any)
DROP POLICY IF EXISTS "Anyone can insert enquiries" ON enquiries;
DROP POLICY IF EXISTS "Authenticated users can view enquiries" ON enquiries;
DROP POLICY IF EXISTS "Public can submit enquiries" ON enquiries;

-- Create new policy allowing public enquiry submission
CREATE POLICY "Anyone can insert enquiries" ON enquiries
    FOR INSERT WITH CHECK (true);

-- Policy for viewing enquiries (admin only - requires authentication)
CREATE POLICY "Authenticated users can view enquiries" ON enquiries
    FOR SELECT USING (auth.role() = 'authenticated');

SELECT 'Enquiries RLS Policies updated successfully!' AS message;
