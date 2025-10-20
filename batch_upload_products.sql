-- ============================================================
-- Batch Upload: One Way Clutch Products (13 items)
-- ============================================================
-- Execute this in: Supabase Dashboard → SQL Editor
-- ============================================================

INSERT INTO products (name, category, material, price, size, description, image) VALUES
-- DC Series Products
('DC5476A', 'one-way-clutch', 'te-gcr', 24, '54.765*71.425*16', 'High-precision one-way clutch bearing with Te & Gcr material construction. Ideal for applications requiring controlled directional rotation.', 'https://via.placeholder.com/400x400.png?text=DC5476A'),

('DC4445A', 'one-way-clutch', 'te-gcr', 23, '44.450*61.110*16', 'Compact one-way clutch bearing featuring Te & Gcr material for reliable performance in limited space applications.', 'https://via.placeholder.com/400x400.png?text=DC4445A'),

('DC3804C', 'one-way-clutch', 'te-gcr', 22, '38.092*54.752*16', 'Precision-engineered one-way clutch with Te & Gcr construction, suitable for light to medium-duty applications.', 'https://via.placeholder.com/400x400.png?text=DC3804C'),

('DC7221B', 'one-way-clutch', 'te-gcr', 35, '72.217*88.877*21', 'Heavy-duty one-way clutch bearing with increased thickness for enhanced load capacity and durability.', 'https://via.placeholder.com/400x400.png?text=DC7221B'),

('DC8334C', 'one-way-clutch', 'te-gcr', 60, '83.340*100.000*25.4', 'Large-diameter one-way clutch designed for industrial applications requiring high torque transmission.', 'https://via.placeholder.com/400x400.png?text=DC8334C'),

('DC5776A', 'one-way-clutch', 'te-gcr', 29, '57.760*74.420*16', 'Standard one-way clutch bearing with Te & Gcr material, offering excellent reliability for general applications.', 'https://via.placeholder.com/400x400.png?text=DC5776A'),

('DC5776B', 'one-way-clutch', 'te-gcr', 36, '57.760*74.420*21', 'Enhanced version of DC5776A with increased thickness for greater load-bearing capacity.', 'https://via.placeholder.com/400x400.png?text=DC5776B'),

('DC1234C', 'one-way-clutch', 'te-gcr', 180, '123.340*140.000*25.4', 'Premium large-scale one-way clutch for heavy industrial machinery and high-torque applications.', 'https://via.placeholder.com/400x400.png?text=DC1234C'),

('DC2776C', 'one-way-clutch', 'te-gcr', 30, '27.762*44.422*25.4', 'Small-diameter one-way clutch with robust construction, perfect for compact machinery and equipment.', 'https://via.placeholder.com/400x400.png?text=DC2776C'),

-- FE Series Products
('FE423Z', 'one-way-clutch', 'te-gcr', 12, 'd16*D23*12', 'Economical FE-series one-way clutch bearing suitable for cost-effective solutions in light-duty applications.', 'https://via.placeholder.com/400x400.png?text=FE423Z'),

('FE443Z', 'one-way-clutch', 'te-gcr', 30, 'd35*D43*12', 'Mid-range FE-series one-way clutch offering balanced performance and value for general industrial use.', 'https://via.placeholder.com/400x400.png?text=FE443Z'),

('FE448Z', 'one-way-clutch', 'te-gcr', 35, 'd40*D48*12', 'High-performance FE-series one-way clutch with larger diameter for increased torque handling capability.', 'https://via.placeholder.com/400x400.png?text=FE448Z'),

('FE435Z', 'one-way-clutch', 'te-gcr', 28, 'd27*D35*12', 'Versatile FE-series one-way clutch bearing designed for medium-duty applications with space constraints.', 'https://via.placeholder.com/400x400.png?text=FE435Z');

-- Verification Query
SELECT '✅ Successfully inserted 13 One Way Clutch products!' AS result;
SELECT COUNT(*) as total_one_way_clutch_products FROM products WHERE category = 'one-way-clutch';
SELECT * FROM products WHERE category = 'one-way-clutch' ORDER BY name;
