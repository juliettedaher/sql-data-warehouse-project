-- ==========================================
-- WARNING: This will DROP the database if it exists!
-- The project 'datawarehouse' will be deleted and recreated.
-- ==========================================

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'datawarehouse')
BEGIN
    PRINT '⚠️ WARNING: Dropping existing database [datawarehouse]...';
    DROP DATABASE datawarehouse;
END
GO

-- Create a fresh database
CREATE DATABASE datawarehouse;
GO

USE datawarehouse;
GO

-- Create schemas
CREATE SCHEMA gold;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA bronze;
GO
