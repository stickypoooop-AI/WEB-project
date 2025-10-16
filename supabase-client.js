// Supabase Client Configuration
// Reads configuration from config.js which supports environment variables

// Get configuration from global config
const SUPABASE_URL = window.APP_CONFIG.supabase.url;
const SUPABASE_ANON_KEY = window.APP_CONFIG.supabase.anonKey;

// Initialize Supabase client
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Storage configuration
const STORAGE_BUCKET = 'product-images';

// Database API wrapper functions
const db = {
    // Storage operations
    storage: {
        async uploadImage(file) {
            // Generate unique filename
            const fileExt = file.name.split('.').pop();
            const fileName = `${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`;
            const filePath = `products/${fileName}`;

            // Upload file to Supabase Storage
            const { data, error } = await supabaseClient.storage
                .from(STORAGE_BUCKET)
                .upload(filePath, file, {
                    cacheControl: '3600',
                    upsert: false
                });

            if (error) throw error;

            // Get public URL
            const { data: urlData } = supabaseClient.storage
                .from(STORAGE_BUCKET)
                .getPublicUrl(filePath);

            return urlData.publicUrl;
        },

        async deleteImage(imageUrl) {
            // Extract file path from URL
            const url = new URL(imageUrl);
            const pathParts = url.pathname.split('/');
            const bucketIndex = pathParts.indexOf(STORAGE_BUCKET);
            if (bucketIndex === -1) return false;

            const filePath = pathParts.slice(bucketIndex + 1).join('/');

            // Delete file from storage
            const { error } = await supabaseClient.storage
                .from(STORAGE_BUCKET)
                .remove([filePath]);

            if (error) throw error;
            return true;
        }
    },

    // Products operations
    products: {
        async getAll() {
            const { data, error } = await supabaseClient
                .from('products')
                .select('*')
                .order('created_at', { ascending: false });

            if (error) throw error;
            return data;
        },

        async getById(id) {
            const { data, error } = await supabaseClient
                .from('products')
                .select('*')
                .eq('id', id)
                .single();

            if (error) throw error;
            return data;
        },

        async create(productData) {
            const { data, error } = await supabaseClient
                .from('products')
                .insert([productData])
                .select()
                .single();

            if (error) throw error;
            return data;
        },

        async update(id, productData) {
            const { data, error } = await supabaseClient
                .from('products')
                .update(productData)
                .eq('id', id)
                .select()
                .single();

            if (error) throw error;
            return data;
        },

        async delete(id) {
            const { error } = await supabaseClient
                .from('products')
                .delete()
                .eq('id', id);

            if (error) throw error;
            return true;
        }
    },

    // Enquiries operations
    enquiries: {
        async create(enquiryData) {
            const { data, error } = await supabaseClient
                .from('enquiries')
                .insert([enquiryData])
                .select()
                .single();

            if (error) throw error;
            return data;
        },

        async getAll() {
            const { data, error } = await supabaseClient
                .from('enquiries')
                .select('*')
                .order('created_at', { ascending: false });

            if (error) throw error;
            return data;
        }
    }
};
