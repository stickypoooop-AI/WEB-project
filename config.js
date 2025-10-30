// Configuration file
// This allows easy switching between different environments

const config = {
    // Supabase Configuration
    // Priority: window.ENV > hardcoded values
    supabase: {
        url: window.ENV?.SUPABASE_URL || 'https://zoxjvuafzkymgxmsluif.supabase.co',
        anonKey: window.ENV?.SUPABASE_ANON_KEY || 'sb_publishable_hhkTjQk3DNoPByMWbUUWvg_u~fACZ7_'
    },

    // Admin Configuration
    admin: {
        key: window.ENV?.ADMIN_KEY || '12345678901234567890123456789012'
    }
};

// Expose config globally for other scripts to use
window.APP_CONFIG = config;
