// Admin Key (reads from config.js which supports environment variables)
const ADMIN_KEY = window.APP_CONFIG.admin.key;

// Session Management
const ADMIN_SESSION_KEY = 'admin_authenticated';

// Products will be loaded from Supabase
let productsData = null;

// Default Product Database
const defaultProducts = [
    // Screws
    {
        id: 1,
        name: 'Stainless Steel Phillips Head Screw',
        category: 'screws',
        material: 'stainless-steel',
        finish: 'plain',
        price: 0.15,
        size: 'M6 x 40mm',
        description: 'High-quality stainless steel Phillips head screws, corrosion-resistant and suitable for both indoor and outdoor applications.',
        image: 'https://images.unsplash.com/photo-1615733487868-c5d05d1c5d39?w=400&h=400&fit=crop'
    },
    {
        id: 2,
        name: 'Zinc Plated Wood Screw',
        category: 'screws',
        material: 'carbon-steel',
        finish: 'zinc-plated',
        price: 0.08,
        size: '#8 x 1.5"',
        description: 'Durable wood screws with zinc plating for enhanced corrosion resistance. Perfect for carpentry and woodworking projects.',
        image: 'https://images.unsplash.com/photo-1590856029826-c7a73142bbf1?w=400&h=400&fit=crop'
    },
    {
        id: 3,
        name: 'Black Oxide Machine Screw',
        category: 'screws',
        material: 'carbon-steel',
        finish: 'black-oxide',
        price: 0.12,
        size: 'M5 x 30mm',
        description: 'Precision machine screws with black oxide finish. Ideal for mechanical assemblies and equipment manufacturing.',
        image: 'https://images.unsplash.com/photo-1598659003036-f29a25efb6b5?w=400&h=400&fit=crop'
    },
    {
        id: 4,
        name: 'Brass Flathead Screw',
        category: 'screws',
        material: 'brass',
        finish: 'plain',
        price: 0.22,
        size: 'M4 x 25mm',
        description: 'Premium brass flathead screws offering excellent conductivity and aesthetic appeal for decorative applications.',
        image: 'https://images.unsplash.com/photo-1615733487868-c5d05d1c5d39?w=400&h=400&fit=crop&sat=-100'
    },

    // Bolts
    {
        id: 5,
        name: 'Hex Head Bolt Grade 8.8',
        category: 'bolts',
        material: 'carbon-steel',
        finish: 'zinc-plated',
        price: 0.35,
        size: 'M10 x 60mm',
        description: 'High-strength hex head bolts rated Grade 8.8. Suitable for structural applications requiring reliable fastening.',
        image: 'https://images.unsplash.com/photo-1504326046-fa3bcc4c3461?w=400&h=400&fit=crop'
    },
    {
        id: 6,
        name: 'Stainless Steel Carriage Bolt',
        category: 'bolts',
        material: 'stainless-steel',
        finish: 'plain',
        price: 0.42,
        size: 'M8 x 50mm',
        description: 'Smooth dome head carriage bolts in stainless steel. Perfect for wood-to-wood or wood-to-metal connections.',
        image: 'https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=400&h=400&fit=crop'
    },
    {
        id: 7,
        name: 'Galvanized U-Bolt',
        category: 'bolts',
        material: 'carbon-steel',
        finish: 'galvanized',
        price: 1.25,
        size: '1/2" x 4"',
        description: 'Heavy-duty U-bolts with galvanized finish. Commonly used for pipe mounting and vehicle suspension systems.',
        image: 'https://images.unsplash.com/photo-1587653915936-5623ea0b949a?w=400&h=400&fit=crop'
    },
    {
        id: 8,
        name: 'Aluminum Eye Bolt',
        category: 'bolts',
        material: 'aluminum',
        finish: 'plain',
        price: 0.95,
        size: 'M12 x 70mm',
        description: 'Lightweight aluminum eye bolts for lifting and rigging applications. Corrosion-resistant and durable.',
        image: 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=400&h=400&fit=crop'
    },

    // Nuts
    {
        id: 9,
        name: 'Hex Nut Grade A',
        category: 'nuts',
        material: 'carbon-steel',
        finish: 'zinc-plated',
        price: 0.05,
        size: 'M10',
        description: 'Standard hex nuts with zinc plating. Compatible with metric bolts for general fastening applications.',
        image: 'https://images.unsplash.com/photo-1599932193825-8c13cc8e5b3b?w=400&h=400&fit=crop'
    },
    {
        id: 10,
        name: 'Stainless Steel Lock Nut',
        category: 'nuts',
        material: 'stainless-steel',
        finish: 'plain',
        price: 0.18,
        size: 'M8',
        description: 'Self-locking nuts with nylon insert to prevent loosening from vibration. Marine-grade stainless steel.',
        image: 'https://images.unsplash.com/photo-1593115057582-0bc2316d050e?w=400&h=400&fit=crop'
    },
    {
        id: 11,
        name: 'Wing Nut Brass',
        category: 'nuts',
        material: 'brass',
        finish: 'plain',
        price: 0.28,
        size: 'M6',
        description: 'Hand-tightenable wing nuts in brass. Ideal for applications requiring frequent assembly and disassembly.',
        image: 'https://images.unsplash.com/photo-1599932193825-8c13cc8e5b3b?w=400&h=400&fit=crop&hue=30'
    },
    {
        id: 12,
        name: 'Square Nut Heavy Duty',
        category: 'nuts',
        material: 'carbon-steel',
        finish: 'black-oxide',
        price: 0.15,
        size: 'M12',
        description: 'Square nuts designed to resist rotation. Excellent for wood applications and rough construction.',
        image: 'https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=400&h=400&fit=crop&sat=-50'
    },

    // Washers
    {
        id: 13,
        name: 'Flat Washer Stainless',
        category: 'washers',
        material: 'stainless-steel',
        finish: 'plain',
        price: 0.03,
        size: 'M10',
        description: 'Standard flat washers to distribute load and protect surfaces. Corrosion-resistant stainless steel.',
        image: 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=400&h=400&fit=crop&contrast=20'
    },
    {
        id: 14,
        name: 'Spring Lock Washer',
        category: 'washers',
        material: 'carbon-steel',
        finish: 'zinc-plated',
        price: 0.04,
        size: 'M8',
        description: 'Split ring spring washers to prevent loosening under vibration. Zinc-plated for corrosion resistance.',
        image: 'https://images.unsplash.com/photo-1587653915936-5623ea0b949a?w=400&h=400&fit=crop&contrast=30'
    },
    {
        id: 15,
        name: 'Fender Washer Large',
        category: 'washers',
        material: 'carbon-steel',
        finish: 'galvanized',
        price: 0.08,
        size: '1/4" x 1.5"',
        description: 'Extra-large diameter washers for distributing load over soft materials. Galvanized for outdoor use.',
        image: 'https://images.unsplash.com/photo-1504326046-fa3bcc4c3461?w=400&h=400&fit=crop&contrast=40'
    },
    {
        id: 16,
        name: 'Rubber Washer Seal',
        category: 'washers',
        material: 'rubber',
        finish: 'plain',
        price: 0.06,
        size: 'M10',
        description: 'EPDM rubber washers for sealing applications. Weather-resistant and suitable for plumbing installations.',
        image: 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=400&h=400&fit=crop&sat=-80'
    },

    // Anchors
    {
        id: 17,
        name: 'Concrete Wedge Anchor',
        category: 'anchors',
        material: 'carbon-steel',
        finish: 'zinc-plated',
        price: 0.65,
        size: 'M12 x 100mm',
        description: 'Heavy-duty wedge anchors for concrete and masonry. Provides high pull-out and shear strength.',
        image: 'https://images.unsplash.com/photo-1504326046-fa3bcc4c3461?w=400&h=400&fit=crop&brightness=-10'
    },
    {
        id: 18,
        name: 'Plastic Wall Anchor',
        category: 'anchors',
        material: 'nylon',
        finish: 'plain',
        price: 0.08,
        size: '#10 x 1"',
        description: 'Ribbed plastic anchors for drywall and hollow walls. Easy installation for light to medium loads.',
        image: 'https://images.unsplash.com/photo-1615733487868-c5d05d1c5d39?w=400&h=400&fit=crop&hue=210'
    },
    {
        id: 19,
        name: 'Toggle Bolt Heavy Duty',
        category: 'anchors',
        material: 'carbon-steel',
        finish: 'zinc-plated',
        price: 0.45,
        size: '1/4" x 3"',
        description: 'Spring-loaded toggle bolts for hollow walls. Excellent holding power for heavy fixtures and shelves.',
        image: 'https://images.unsplash.com/photo-1590856029826-c7a73142bbf1?w=400&h=400&fit=crop&brightness=-5'
    },
    {
        id: 20,
        name: 'Sleeve Anchor Stainless',
        category: 'anchors',
        material: 'stainless-steel',
        finish: 'plain',
        price: 0.85,
        size: 'M10 x 75mm',
        description: 'Versatile sleeve anchors for concrete, brick, and block. Stainless steel for marine and coastal applications.',
        image: 'https://images.unsplash.com/photo-1598659003036-f29a25efb6b5?w=400&h=400&fit=crop&brightness=5'
    },

    // Rivets
    {
        id: 21,
        name: 'Aluminum Pop Rivet',
        category: 'rivets',
        material: 'aluminum',
        finish: 'plain',
        price: 0.12,
        size: '1/8" x 1/4"',
        description: 'Standard blind rivets in aluminum. Quick installation for joining thin sheet materials.',
        image: 'https://images.unsplash.com/photo-1599932193825-8c13cc8e5b3b?w=400&h=400&fit=crop&brightness=10'
    },
    {
        id: 22,
        name: 'Stainless Steel Rivet',
        category: 'rivets',
        material: 'stainless-steel',
        finish: 'plain',
        price: 0.18,
        size: '3/16" x 1/2"',
        description: 'Corrosion-resistant stainless steel rivets. Perfect for marine, food service, and outdoor applications.',
        image: 'https://images.unsplash.com/photo-1593115057582-0bc2316d050e?w=400&h=400&fit=crop&brightness=-5'
    },
    {
        id: 23,
        name: 'Brass Solid Rivet',
        category: 'rivets',
        material: 'brass',
        finish: 'plain',
        price: 0.25,
        size: '#10 x 3/8"',
        description: 'Traditional solid brass rivets for decorative and electrical applications. Requires rivet setting tools.',
        image: 'https://images.unsplash.com/photo-1599932193825-8c13cc8e5b3b?w=400&h=400&fit=crop&hue=40'
    },
    {
        id: 24,
        name: 'Multi-Grip Rivet Steel',
        category: 'rivets',
        material: 'carbon-steel',
        finish: 'zinc-plated',
        price: 0.15,
        size: '1/8" x 3/8"',
        description: 'Versatile multi-grip rivets for varying material thickness. Zinc-plated steel with aluminum mandrel.',
        image: 'https://images.unsplash.com/photo-1587653915936-5623ea0b949a?w=400&h=400&fit=crop&brightness=-10'
    }
];

// Products array - will be loaded from Supabase
let products = [];

// Flag to track if initial data load is complete
let isDataLoaded = false;

// Function to load products from Supabase
async function loadProductsFromDB() {
    try {
        const data = await db.products.getAll();
        products = data.map(p => ({
            id: p.id,
            name: p.name,
            category: p.category,
            material: p.material,
            finish: p.finish,
            price: parseFloat(p.price),
            size: p.size,
            description: p.description,
            image: p.image
        }));
        isDataLoaded = true;
        renderProducts();
    } catch (error) {
        console.error('Error loading products:', error);
        alert('Failed to load products. Please refresh the page.');
    }
}

// State Management
let cart = [];
let currentCategory = 'all';
let currentFilters = { material: '', finish: '' };
let currentSort = 'name';
let searchQuery = '';
let selectedProduct = null;

// Initialize App
document.addEventListener('DOMContentLoaded', async () => {
    initializeEventListeners();
    initializeAdminListeners();
    updateCartCount();
    checkAdminSession();

    // Load products from Supabase
    await loadProductsFromDB();
});

// Event Listeners
function initializeEventListeners() {
    // Navigation
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
            link.classList.add('active');
            const target = link.getAttribute('href');
            document.querySelector(target).scrollIntoView({ behavior: 'smooth' });
        });
    });

    // Category Buttons
    document.querySelectorAll('.category-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentCategory = btn.dataset.category;
            renderProducts();
        });
    });

    // Filters
    document.getElementById('materialFilter').addEventListener('change', (e) => {
        currentFilters.material = e.target.value;
        renderProducts();
    });

    document.getElementById('finishFilter').addEventListener('change', (e) => {
        currentFilters.finish = e.target.value;
        renderProducts();
    });

    document.getElementById('clearFilters').addEventListener('click', () => {
        currentFilters = { material: '', finish: '' };
        document.getElementById('materialFilter').value = '';
        document.getElementById('finishFilter').value = '';
        renderProducts();
    });

    // Search
    document.getElementById('searchInput').addEventListener('input', (e) => {
        searchQuery = e.target.value.toLowerCase();
        renderProducts();
    });

    // Sort
    document.getElementById('sortSelect').addEventListener('change', (e) => {
        currentSort = e.target.value;
        renderProducts();
    });

    // Cart Modal
    document.getElementById('cartBtn').addEventListener('click', openCartModal);
    document.getElementById('closeCart').addEventListener('click', closeCartModal);
    document.getElementById('closeCart2').addEventListener('click', closeCartModal);

    // Enquiry Modal
    document.getElementById('proceedEnquiry').addEventListener('click', openEnquiryModal);
    document.getElementById('closeEnquiry').addEventListener('click', closeEnquiryModal);
    document.getElementById('closeEnquiry2').addEventListener('click', closeEnquiryModal);
    document.getElementById('submitEnquiry').addEventListener('click', submitEnquiry);

    // Product Detail Modal
    document.getElementById('closeProduct').addEventListener('click', closeProductModal);

    // Quantity Controls
    document.getElementById('decreaseQty').addEventListener('click', () => {
        const input = document.getElementById('quantityInput');
        if (input.value > 1) input.value = parseInt(input.value) - 1;
    });

    document.getElementById('increaseQty').addEventListener('click', () => {
        const input = document.getElementById('quantityInput');
        input.value = parseInt(input.value) + 1;
    });

    document.getElementById('addToCartBtn').addEventListener('click', addToCart);

    // Close modals on outside click
    window.addEventListener('click', (e) => {
        if (e.target.classList.contains('modal')) {
            e.target.classList.remove('active');
        }
    });
}

// Render Products
function renderProducts() {
    let filteredProducts = products.filter(product => {
        // Category filter
        if (currentCategory !== 'all' && product.category !== currentCategory) return false;

        // Material filter
        if (currentFilters.material && product.material !== currentFilters.material) return false;

        // Finish filter
        if (currentFilters.finish && product.finish !== currentFilters.finish) return false;

        // Smart search filter - search all fields with normalization
        if (searchQuery) {
            const normalizedQuery = normalizeText(searchQuery);

            // All searchable fields including ID, name, size, category, material, finish, description, price
            const searchableFields = [
                product.id.toString(),
                product.name,
                product.size,
                product.category,
                product.material,
                product.finish,
                product.description,
                product.price.toString()
            ];

            // Check if any field matches the normalized query
            const hasMatch = searchableFields.some(field =>
                normalizeText(field).includes(normalizedQuery)
            );

            if (!hasMatch) return false;
        }

        return true;
    });

    // Sort products
    filteredProducts.sort((a, b) => {
        switch (currentSort) {
            case 'name':
                return a.name.localeCompare(b.name);
            case 'price-low':
                return a.price - b.price;
            case 'price-high':
                return b.price - a.price;
            default:
                return 0;
        }
    });

    const grid = document.getElementById('productsGrid');

    if (filteredProducts.length === 0) {
        grid.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 3rem; color: var(--text-gray);">No products found matching your criteria.</div>';
        return;
    }

    grid.innerHTML = filteredProducts.map(product => `
        <div class="product-card" onclick="openProductModal(${product.id})">
            <img src="${product.image}" alt="${product.name}" class="product-image">
            <span class="product-category">${product.category}</span>
            <h3 class="product-name">${product.name}</h3>
            <div class="product-specs">
                ${product.size} | ${formatMaterial(product.material)} | ${formatFinish(product.finish)}
            </div>
            <div class="product-price">$${product.price.toFixed(2)}</div>
        </div>
    `).join('');
}

// Format helper functions
function formatMaterial(material) {
    return material.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
}

function formatFinish(finish) {
    return finish.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
}

// Smart search normalization function
function normalizeText(text) {
    if (text === null || text === undefined) return '';
    return text.toString()
        .toLowerCase()
        .replace(/[-\s*x×]/g, '')  // Remove hyphens, spaces, *, x, ×
        .replace(/[$,]/g, '')      // Remove $, commas
        .trim();
}

// Product Modal
function openProductModal(productId) {
    selectedProduct = products.find(p => p.id === productId);
    if (!selectedProduct) return;

    document.getElementById('modalProductName').textContent = selectedProduct.name;
    document.getElementById('modalProductImage').src = selectedProduct.image;
    document.getElementById('modalProductPrice').textContent = `$${selectedProduct.price.toFixed(2)} per unit`;
    document.getElementById('modalProductDescription').textContent = selectedProduct.description;

    const specsHtml = `
        <div class="spec-item">
            <span class="spec-label">Category:</span>
            <span class="spec-value">${formatMaterial(selectedProduct.category)}</span>
        </div>
        <div class="spec-item">
            <span class="spec-label">Size:</span>
            <span class="spec-value">${selectedProduct.size}</span>
        </div>
        <div class="spec-item">
            <span class="spec-label">Material:</span>
            <span class="spec-value">${formatMaterial(selectedProduct.material)}</span>
        </div>
        <div class="spec-item">
            <span class="spec-label">Finish:</span>
            <span class="spec-value">${formatFinish(selectedProduct.finish)}</span>
        </div>
    `;

    document.getElementById('modalProductSpecs').innerHTML = specsHtml;
    document.getElementById('quantityInput').value = 1;
    document.getElementById('productModal').classList.add('active');
}

function closeProductModal() {
    document.getElementById('productModal').classList.remove('active');
    selectedProduct = null;
}

// Cart Functions
function addToCart() {
    if (!selectedProduct) return;

    const quantity = parseInt(document.getElementById('quantityInput').value);
    const existingItem = cart.find(item => item.id === selectedProduct.id);

    if (existingItem) {
        existingItem.quantity += quantity;
    } else {
        cart.push({
            ...selectedProduct,
            quantity: quantity
        });
    }

    updateCartCount();
    closeProductModal();

    // Show brief notification
    alert(`Added ${quantity} x ${selectedProduct.name} to enquiry cart`);
}

function removeFromCart(productId) {
    cart = cart.filter(item => item.id !== productId);
    updateCartCount();
    renderCartItems();
}

function updateCartCount() {
    const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
    document.querySelector('.cart-count').textContent = totalItems;
}

function openCartModal() {
    renderCartItems();
    document.getElementById('cartModal').classList.add('active');
}

function closeCartModal() {
    document.getElementById('cartModal').classList.remove('active');
}

function renderCartItems() {
    const cartItemsContainer = document.getElementById('cartItems');
    const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);

    document.getElementById('totalItems').textContent = totalItems;

    if (cart.length === 0) {
        cartItemsContainer.innerHTML = '';
        return;
    }

    cartItemsContainer.innerHTML = cart.map(item => `
        <div class="cart-item">
            <img src="${item.image}" alt="${item.name}" class="cart-item-image">
            <div class="cart-item-info">
                <div class="cart-item-name">${item.name}</div>
                <div class="cart-item-details">
                    Quantity: ${item.quantity} | $${(item.price * item.quantity).toFixed(2)}
                </div>
            </div>
            <button class="cart-item-remove" onclick="removeFromCart(${item.id})">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `).join('');
}

// Enquiry Functions
function openEnquiryModal() {
    if (cart.length === 0) {
        alert('Your enquiry cart is empty. Please add products first.');
        return;
    }

    closeCartModal();
    renderEnquirySummary();
    document.getElementById('enquiryModal').classList.add('active');
}

function closeEnquiryModal() {
    document.getElementById('enquiryModal').classList.remove('active');
}

function renderEnquirySummary() {
    const summary = cart.map(item => `
        <div class="enquiry-item">
            <strong>${item.name}</strong><br>
            Quantity: ${item.quantity} | Unit Price: $${item.price.toFixed(2)} | Total: $${(item.price * item.quantity).toFixed(2)}<br>
            Specs: ${item.size} | ${formatMaterial(item.material)} | ${formatFinish(item.finish)}
        </div>
    `).join('');

    document.getElementById('enquirySummary').innerHTML = summary;
}

async function submitEnquiry() {
    const form = document.getElementById('enquiryForm');

    // Validate required fields
    const name = document.getElementById('customerName').value.trim();
    const email = document.getElementById('customerEmail').value.trim();
    const phone = document.getElementById('customerPhone').value.trim();

    if (!name || !email || !phone) {
        alert('Please fill in all required fields (Name, Email, Phone)');
        return;
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        alert('Please enter a valid email address');
        return;
    }

    // Prepare enquiry data for Supabase
    const enquiryData = {
        customer_name: name,
        customer_email: email,
        customer_phone: phone,
        company_name: document.getElementById('companyName').value || null,
        customer_address: document.getElementById('customerAddress').value || null,
        products: cart.map(item => ({
            id: item.id,
            name: item.name,
            quantity: item.quantity,
            price: item.price,
            specs: `${item.size} | ${item.material} | ${item.finish}`
        })),
        notes: document.getElementById('additionalNotes').value || null
    };

    try {
        // Save enquiry to Supabase
        await db.enquiries.create(enquiryData);

        // Show success message
        alert(`Thank you for your enquiry, ${name}!\n\nWe have received your request for ${cart.length} product(s). Our team will contact you shortly at ${email}.\n\nEnquiry Details:\n${cart.map(item => `- ${item.name} (Qty: ${item.quantity})`).join('\n')}`);

        // Clear cart and close modals
        cart = [];
        updateCartCount();
        closeEnquiryModal();
        form.reset();
    } catch (error) {
        console.error('Error submitting enquiry:', error);
        alert('Failed to submit enquiry. Please try again or contact us directly.');
    }
}

// Admin Functions
function checkAdminSession() {
    const isAuthenticated = sessionStorage.getItem(ADMIN_SESSION_KEY);
    if (isAuthenticated === 'true') {
        showAdminDashboard();
    }
}

function openAdminLogin() {
    document.getElementById('adminLoginModal').classList.add('active');
    document.getElementById('adminKeyInput').value = '';
    document.getElementById('adminLoginError').classList.remove('show');
}

function closeAdminLogin() {
    document.getElementById('adminLoginModal').classList.remove('active');
}

function submitAdminLogin() {
    const keyInput = document.getElementById('adminKeyInput').value;
    const errorMsg = document.getElementById('adminLoginError');

    if (keyInput.length !== 32) {
        errorMsg.textContent = 'Admin key must be exactly 32 characters';
        errorMsg.classList.add('show');
        return;
    }

    if (keyInput === ADMIN_KEY) {
        sessionStorage.setItem(ADMIN_SESSION_KEY, 'true');
        closeAdminLogin();
        showAdminDashboard();
    } else {
        errorMsg.textContent = 'Invalid admin key. Access denied.';
        errorMsg.classList.add('show');
    }
}

function showAdminDashboard() {
    document.getElementById('adminDashboard').classList.add('active');
    renderAdminProducts();
}

function hideAdminDashboard() {
    document.getElementById('adminDashboard').classList.remove('active');
}

function logoutAdmin() {
    sessionStorage.removeItem(ADMIN_SESSION_KEY);
    hideAdminDashboard();
}

function renderAdminProducts() {
    const tableContainer = document.getElementById('adminProductsTable');

    if (products.length === 0) {
        tableContainer.innerHTML = '<p style="text-align: center; color: var(--text-gray); padding: 2rem;">No products available. Click "Add New Product" to get started.</p>';
        return;
    }

    const tableHTML = `
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Material</th>
                    <th>Size</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                ${products.map(product => `
                    <tr>
                        <td><img src="${product.image}" class="product-img-small" alt="${product.name}"></td>
                        <td>${product.name}</td>
                        <td>${formatMaterial(product.category)}</td>
                        <td>$${product.price.toFixed(2)}</td>
                        <td>${formatMaterial(product.material)}</td>
                        <td>${product.size}</td>
                        <td>
                            <div class="admin-actions">
                                <button class="btn btn-edit btn-icon btn-small" onclick="editProduct(${product.id})">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <button class="btn btn-danger btn-icon btn-small" onclick="deleteProduct(${product.id})">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </div>
                        </td>
                    </tr>
                `).join('')}
            </tbody>
        </table>
    `;

    tableContainer.innerHTML = tableHTML;
}

function openProductForm(productId = null) {
    const modal = document.getElementById('productFormModal');
    const form = document.getElementById('productForm');
    const title = document.getElementById('productFormTitle');

    form.reset();

    if (productId) {
        const product = products.find(p => p.id === productId);
        if (product) {
            title.textContent = 'Edit Product';
            document.getElementById('productId').value = product.id;
            document.getElementById('productName').value = product.name;
            document.getElementById('productCategory').value = product.category;
            document.getElementById('productMaterial').value = product.material;
            document.getElementById('productFinish').value = product.finish;
            document.getElementById('productPrice').value = product.price;
            document.getElementById('productSize').value = product.size;
            document.getElementById('productImage').value = product.image;
            document.getElementById('productDescription').value = product.description;
        }
    } else {
        title.textContent = 'Add New Product';
        document.getElementById('productId').value = '';
    }

    modal.classList.add('active');
}

function closeProductForm() {
    document.getElementById('productFormModal').classList.remove('active');
}

async function saveProduct() {
    const form = document.getElementById('productForm');

    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    const productId = document.getElementById('productId').value;
    const productData = {
        name: document.getElementById('productName').value,
        category: document.getElementById('productCategory').value,
        material: document.getElementById('productMaterial').value,
        finish: document.getElementById('productFinish').value,
        price: parseFloat(document.getElementById('productPrice').value),
        size: document.getElementById('productSize').value,
        image: document.getElementById('productImage').value,
        description: document.getElementById('productDescription').value
    };

    try {
        if (productId) {
            // Edit existing product in Supabase
            await db.products.update(productId, productData);
        } else {
            // Add new product to Supabase
            await db.products.create(productData);
        }

        // Reload products from database
        await loadProductsFromDB();
        renderAdminProducts();
        closeProductForm();
    } catch (error) {
        console.error('Error saving product:', error);
        alert('Failed to save product. Please try again.');
    }
}

function editProduct(productId) {
    openProductForm(productId);
}

async function deleteProduct(productId) {
    if (confirm('Are you sure you want to delete this product? This action cannot be undone.')) {
        try {
            await db.products.delete(productId);
            // Reload products from database
            await loadProductsFromDB();
            renderAdminProducts();
        } catch (error) {
            console.error('Error deleting product:', error);
            alert('Failed to delete product. Please try again.');
        }
    }
}

// Initialize Admin Event Listeners
function initializeAdminListeners() {
    // Admin button
    document.getElementById('adminBtn').addEventListener('click', () => {
        const isAuthenticated = sessionStorage.getItem(ADMIN_SESSION_KEY);
        if (isAuthenticated === 'true') {
            showAdminDashboard();
        } else {
            openAdminLogin();
        }
    });

    // Admin login modal
    document.getElementById('closeAdminLogin').addEventListener('click', closeAdminLogin);
    document.getElementById('cancelAdminLogin').addEventListener('click', closeAdminLogin);
    document.getElementById('submitAdminLogin').addEventListener('click', submitAdminLogin);

    // Enter key for admin login
    document.getElementById('adminKeyInput').addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            submitAdminLogin();
        }
    });

    // Logout button
    document.getElementById('logoutBtn').addEventListener('click', logoutAdmin);

    // Add product button
    document.getElementById('addProductBtn').addEventListener('click', () => openProductForm());

    // Product form modal
    document.getElementById('closeProductForm').addEventListener('click', closeProductForm);
    document.getElementById('cancelProductForm').addEventListener('click', closeProductForm);
    document.getElementById('saveProduct').addEventListener('click', saveProduct);
}

// Expose functions to global scope for onclick handlers
window.openProductModal = openProductModal;
window.removeFromCart = removeFromCart;
window.editProduct = editProduct;
window.deleteProduct = deleteProduct;