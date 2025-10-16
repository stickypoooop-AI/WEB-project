// Configuration file
// This allows easy switching between different environments

const config = {
    // Supabase Configuration
    // Priority: window.ENV > hardcoded values
    supabase: {
        url: window.ENV?.SUPABASE_URL || 'https://zoxjvuafzkymgxmsluif.supabase.co',
        anonKey: window.ENV?.SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpveGp2dWFmemt5bWd4bXNsdWlmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5NzY5NDMsImV4cCI6MjA3NTU1Mjk0M30.csyxXbV6IxuP8v4I-zi7TeTw1qTI2HDJU52U84K7Tas'
    },

    // Admin Configuration
    admin: {
        key: window.ENV?.ADMIN_KEY || '12345678901234567890123456789012'
    }
};

// Expose config globally for other scripts to use
window.APP_CONFIG = config;
