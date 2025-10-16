// Supabase Client Configuration
// NOTE: In production, these values should come from environment variables
// For now, they are hardcoded for Vercel deployment (will be replaced by env vars)

const SUPABASE_URL = 'https://zoxjvuafzkymgxmsluif.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpveGp2dWFmemt5bWd4bXNsdWlmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5NzY5NDMsImV4cCI6MjA3NTU1Mjk0M30.csyxXbV6IxuP8v4I-zi7TeTw1qTI2HDJU52U84K7Tas';

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
