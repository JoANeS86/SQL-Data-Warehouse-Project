/*

===================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===================================================================
Script Purpose:
    This stored procedure loads data into the 'Bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the Bronze tables before loading data.
    - Uses the 'BULK INSERT' command to load data from csv files to Bronze tables.

Parameters:
    None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
  EXEC Bronze.load_bronze;
===================================================================

Once I've run the BULK statement, I'm going to:
	
	- Check the data that has been loaded.
	- Use the COUNT function to compare the number of rows loaded VS number of rows in the source.
	- I could use the TRUNCATE statement before the BULK INSERT for those cases when I need to delete all the data within the table
	before inserting new data: TRUNCATE quickly delete all rows from a table, resetting it to an empty state.

*/

CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '==================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '==================================================';

		PRINT '--------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_cust_info'
		TRUNCATE TABLE Bronze.crm_cust_info;

		PRINT '>> Inserting Data Into: Bronze.crm_cust_info'
		BULK INSERT Bronze.crm_cust_info
		FROM 'D:\Data Analytics\SQL\SQL Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,				-- Used to identify first row including actual data (meaning, row 1 contains the header).
			FIELDTERMINATOR = ',',		-- Used to identify the separator.
			TABLOCK						-- It locks the table as it's being updated.
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_prd_info'
		TRUNCATE TABLE Bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: Bronze.crm_prd_info'
		BULK INSERT Bronze.crm_prd_info
		FROM 'D:\Data Analytics\SQL\SQL Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_sales_details'
		TRUNCATE TABLE Bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: Bronze.crm_sales_details'
		BULK INSERT Bronze.crm_sales_details
		FROM 'D:\Data Analytics\SQL\SQL Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		PRINT '--------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '--------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_cust_az12'
		TRUNCATE TABLE Bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: Bronze.erp_cust_az12'
		BULK INSERT Bronze.erp_cust_az12
		FROM 'D:\Data Analytics\SQL\SQL Project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_loc_a101'
		TRUNCATE TABLE Bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into: Bronze.erp_loc_a101'
		BULK INSERT Bronze.erp_loc_a101
		FROM 'D:\Data Analytics\SQL\SQL Project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Data Into: Bronze.erp_px_cat_g1v2'
		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'D:\Data Analytics\SQL\SQL Project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '==================================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '		- Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '==================================================';
	END TRY
	BEGIN CATCH
		PRINT '=================================================='
		PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=================================================='
	END CATCH
END

/*

During this Stored Procedure I've:

	- Added PRINTS: To track execution, debug issues, and understand its flow.
	- Added TRY...CATCH: To ensure error handling, data integrity, and issue logging for easier debugging.
						 SQL runs the TRY block, and if it fails, it runs the CATCH block to handle the error.
	- Tracked the ETL duration: Helps to identify bottlenecks, optimize performance, monitor trends, detect issues.

*/
