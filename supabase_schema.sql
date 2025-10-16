-- NaxiWell Industrial Supabase Database Schema
-- Execute this SQL in Supabase SQL Editor (Dashboard → SQL Editor)

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Products Table
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('screws', 'bolts', 'nuts', 'washers', 'anchors', 'rivets')),
    material TEXT NOT NULL CHECK (material IN ('stainless-steel', 'carbon-steel', 'brass', 'aluminum', 'rubber', 'nylon')),
    finish TEXT NOT NULL CHECK (finish IN ('plain', 'zinc-plated', 'black-oxide', 'galvanized')),
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    size TEXT NOT NULL,
    image TEXT NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Enquiries Table
CREATE TABLE IF NOT EXISTS enquiries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_name TEXT NOT NULL,
    customer_email TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    company_name TEXT,
    customer_address TEXT,
    products JSONB NOT NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Admin Users Table (for future authentication enhancement)
CREATE TABLE IF NOT EXISTS admin_users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    admin_key_hash TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_material ON products(material);
CREATE INDEX IF NOT EXISTS idx_products_finish ON products(finish);
CREATE INDEX IF NOT EXISTS idx_enquiries_created_at ON enquiries(created_at DESC);

-- Enable Row Level Security (RLS)
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE enquiries ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Products (Public read, Admin write)
CREATE POLICY "Anyone can view products" ON products
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can insert products" ON products
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update products" ON products
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can delete products" ON products
    FOR DELETE USING (auth.role() = 'authenticated');

-- RLS Policies for Enquiries (Public insert, Admin read)
CREATE POLICY "Anyone can insert enquiries" ON enquiries
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Authenticated users can view enquiries" ON enquiries
    FOR SELECT USING (auth.role() = 'authenticated');

-- RLS Policies for Admin Users (Admin only)
CREATE POLICY "Only admins can view admin_users" ON admin_users
    FOR SELECT USING (auth.role() = 'authenticated');

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc', NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Insert default products (matching current localStorage data)
INSERT INTO products (name, category, material, finish, price, size, image, description) VALUES
    ('Stainless Steel Phillips Head Screw', 'screws', 'stainless-steel', 'plain', 0.15, 'M6 x 40mm', 'https://images.unsplash.com/photo-1615733487868-c5d05d1c5d39?w=400&h=400&fit=crop', 'High-quality stainless steel Phillips head screws, corrosion-resistant and suitable for both indoor and outdoor applications.'),
    ('Zinc Plated Wood Screw', 'screws', 'carbon-steel', 'zinc-plated', 0.08, '#8 x 1.5"', 'https://images.unsplash.com/photo-1590856029826-c7a73142bbf1?w=400&h=400&fit=crop', 'Durable wood screws with zinc plating for enhanced corrosion resistance. Perfect for carpentry and woodworking projects.'),
    ('Black Oxide Machine Screw', 'screws', 'carbon-steel', 'black-oxide', 0.12, 'M5 x 30mm', 'https://images.unsplash.com/photo-1598659003036-f29a25efb6b5?w=400&h=400&fit=crop', 'Precision machine screws with black oxide finish. Ideal for mechanical assemblies and equipment manufacturing.'),
    ('Brass Flathead Screw', 'screws', 'brass', 'plain', 0.22, 'M4 x 25mm', 'https://images.unsplash.com/photo-1615733487868-c5d05d1c5d39?w=400&h=400&fit=crop&sat=-100', 'Premium brass flathead screws offering excellent conductivity and aesthetic appeal for decorative applications.'),
    ('Hex Head Bolt Grade 8.8', 'bolts', 'carbon-steel', 'zinc-plated', 0.35, 'M10 x 60mm', 'https://images.unsplash.com/photo-1504326046-fa3bcc4c3461?w=400&h=400&fit=crop', 'High-strength hex head bolts rated Grade 8.8. Suitable for structural applications requiring reliable fastening.'),
    ('Stainless Steel Carriage Bolt', 'bolts', 'stainless-steel', 'plain', 0.42, 'M8 x 50mm', 'https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=400&h=400&fit=crop', 'Smooth dome head carriage bolts in stainless steel. Perfect for wood-to-wood or wood-to-metal connections.'),
    ('Galvanized U-Bolt', 'bolts', 'carbon-steel', 'galvanized', 1.25, '1/2" x 4"', 'https://images.unsplash.com/photo-1587653915936-5623ea0b949a?w=400&h=400&fit=crop', 'Heavy-duty U-bolts with galvanized finish. Commonly used for pipe mounting and vehicle suspension systems.'),
    ('Aluminum Eye Bolt', 'bolts', 'aluminum', 'plain', 0.95, 'M12 x 70mm', 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=400&h=400&fit=crop', 'Lightweight aluminum eye bolts for lifting and rigging applications. Corrosion-resistant and durable.'),
    ('Hex Nut Grade A', 'nuts', 'carbon-steel', 'zinc-plated', 0.05, 'M10', 'https://images.unsplash.com/photo-1599932193825-8c13cc8e5b3b?w=400&h=400&fit=crop', 'Standard hex nuts with zinc plating. Compatible with metric bolts for general fastening applications.'),
    ('Stainless Steel Lock Nut', 'nuts', 'stainless-steel', 'plain', 0.18, 'M8', 'https://images.unsplash.com/photo-1593115057582-0bc2316d050e?w=400&h=400&fit=crop', 'Self-locking nuts with nylon insert to prevent loosening from vibration. Marine-grade stainless steel.'),
    ('Wing Nut Brass', 'nuts', 'brass', 'plain', 0.28, 'M6', 'https://images.unsplash.com/photo-1599932193825-8c13cc8e5b3b?w=400&h=400&fit=crop&hue=30', 'Hand-tightenable wing nuts in brass. Ideal for applications requiring frequent assembly and disassembly.'),
    ('Square Nut Heavy Duty', 'nuts', 'carbon-steel', 'black-oxide', 0.15, 'M12', 'https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=400&h=400&fit=crop&sat=-50', 'Square nuts designed to resist rotation. Excellent for wood applications and rough construction.'),
    ('Flat Washer Stainless', 'washers', 'stainless-steel', 'plain', 0.03, 'M10', 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=400&h=400&fit=crop&contrast=20', 'Standard flat washers to distribute load and protect surfaces. Corrosion-resistant stainless steel.'),
    ('Spring Lock Washer', 'washers', 'carbon-steel', 'zinc-plated', 0.04, 'M8', 'https://images.unsplash.com/photo-1587653915936-5623ea0b949a?w=400&h=400&fit=crop&contrast=30', 'Split ring spring washers to prevent loosening under vibration. Zinc-plated for corrosion resistance.'),
    ('Fender Washer Large', 'washers', 'carbon-steel', 'galvanized', 0.08, '1/4" x 1.5"', 'https://images.unsplash.com/photo-1504326046-fa3bcc4c3461?w=400&h=400&fit=crop&contrast=40', 'Extra-large diameter washers for distributing load over soft materials. Galvanized for outdoor use.'),
    ('Rubber Washer Seal', 'washers', 'rubber', 'plain', 0.06, 'M10', 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=400&h=400&fit=crop&sat=-80', 'EPDM rubber washers for sealing applications. Weather-resistant and suitable for plumbing installations.'),
    ('Concrete Wedge Anchor', 'anchors', 'carbon-steel', 'zinc-plated', 0.65, 'M12 x 100mm', 'https://images.unsplash.com/photo-1504326046-fa3bcc4c3461?w=400&h=400&fit=crop&brightness=-10', 'Heavy-duty wedge anchors for concrete and masonry. Provides high pull-out and shear strength.'),
    ('Plastic Wall Anchor', 'anchors', 'nylon', 'plain', 0.08, '#10 x 1"', 'https://images.unsplash.com/photo-1615733487868-c5d05d1c5d39?w=400&h=400&fit=crop&hue=210', 'Ribbed plastic anchors for drywall and hollow walls. Easy installation for light to medium loads.'),
    ('Toggle Bolt Heavy Duty', 'anchors', 'carbon-steel', 'zinc-plated', 0.45, '1/4" x 3"', 'https://images.unsplash.com/photo-1590856029826-c7a73142bbf1?w=400&h=400&fit=crop&brightness=-5', 'Spring-loaded toggle bolts for hollow walls. Excellent holding power for heavy fixtures and shelves.'),
    ('Sleeve Anchor Stainless', 'anchors', 'stainless-steel', 'plain', 0.85, 'M10 x 75mm', 'https://images.unsplash.com/photo-1598659003036-f29a25efb6b5?w=400&h=400&fit=crop&brightness=5', 'Versatile sleeve anchors for concrete, brick, and block. Stainless steel for marine and coastal applications.'),
    ('Aluminum Pop Rivet', 'rivets', 'aluminum', 'plain', 0.12, '1/8" x 1/4"', 'https://images.unsplash.com/photo-1599932193825-8c13cc8e5b3b?w=400&h=400&fit=crop&brightness=10', 'Standard blind rivets in aluminum. Quick installation for joining thin sheet materials.'),
    ('Stainless Steel Rivet', 'rivets', 'stainless-steel', 'plain', 0.18, '3/16" x 1/2"', 'https://images.unsplash.com/photo-1593115057582-0bc2316d050e?w=400&h=400&fit=crop&brightness=-5', 'Corrosion-resistant stainless steel rivets. Perfect for marine, food service, and outdoor applications.'),
    ('Brass Solid Rivet', 'rivets', 'brass', 'plain', 0.25, '#10 x 3/8"', 'https://images.unsplash.com/photo-1599932193825-8c13cc8e5b3b?w=400&h=400&fit=crop&hue=40', 'Traditional solid brass rivets for decorative and electrical applications. Requires rivet setting tools.'),
    ('Multi-Grip Rivet Steel', 'rivets', 'carbon-steel', 'zinc-plated', 0.15, '1/8" x 3/8"', 'https://images.unsplash.com/photo-1587653915936-5623ea0b949a?w=400&h=400&fit=crop&brightness=-10', 'Versatile multi-grip rivets for varying material thickness. Zinc-plated steel with aluminum mandrel.');

-- Success message
SELECT 'Database schema created successfully!' AS message;
