// Supabase Client Configuration
// Reads configuration from config.js which supports environment variables

// Get configuration from global config
const SUPABASE_URL = window.APP_CONFIG.supabase.url;
const SUPABASE_ANON_KEY = window.APP_CONFIG.supabase.anonKey;

// Initialize Supabase client
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Database API wrapper functions
const db = {
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
