-- Database initialization script
-- This script runs automatically when PostgreSQL container is first created

-- Create extensions if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Note: Tables will be created by SQLAlchemy/Alembic migrations
-- This script can be used for:
-- 1. Creating additional extensions
-- 2. Setting up initial configuration
-- 3. Creating initial data (if needed)

-- Example: Create a function for generating UUIDs (if not using uuid-ossp)
-- This is already provided by uuid-ossp extension

-- Set timezone
SET timezone = 'UTC';

-- Log initialization
DO $$
BEGIN
    RAISE NOTICE 'Database initialized successfully';
END $$;

