/*

===================================================================
DDL Script: Create Bronze Tables
===================================================================
Script Purpose:
  This script creates tables in the 'Bronze' schema, dropping existing tables if they already exist.
  Run this script to re-defined the DDL structure of 'Bronze' tables.
===================================================================

*** Analyze and understand Source Systems: Set up a meeting with the Source Systems experts in order to interview them, to ask them
a lot of stuff about the source (check ''Most common questions before connecting sources to DB'' snapshot).

*** Create DDL for tables: You can ask the technical experts of the source systems or directly check the sources to try to define
the structure of your tables and the data types.

*/

-- CREATE TABLE statements for the crm and erp sources:

CREATE TABLE Bronze.crm_cust_info (
	cst_id				INT,
	cst_key				NVARCHAR(50),
	cst_firstname		NVARCHAR(50),
	cst_lastname		NVARCHAR(50),
	cst_marital_status	NVARCHAR(50),
	cst_gndr			NVARCHAR(50),
	cst_create_date		DATETIME
)

CREATE TABLE Bronze.crm_prd_info (
	prd_id			INT,
	prd_key			NVARCHAR(50),
	prd_nm			NVARCHAR(50),
	prd_cost		INT,
	prd_line		NVARCHAR(50),
	prd_start_dt	DATETIME,
	prd_end_dt		DATETIME
)

CREATE TABLE Bronze.crm_sales_details (
	sls_ord_num		NVARCHAR(50),
	sls_prd_key		NVARCHAR(50),
	sls_cust_id		INT,
	sls_order_dt	INT,
	sls_ship_dt		INT,
	sls_due_dt		INT,
	sls_sales		INT,
	sls_quantity	INT,
	sls_price		INT
)

CREATE TABLE Bronze.erp_cust_az12 (
	cid		NVARCHAR(50),
	bdate	DATE,
	gen		NVARCHAR(50)
)

CREATE TABLE Bronze.erp_loc_a101 (
	cid		NVARCHAR(50),
	cntry	NVARCHAR(50)
)

CREATE TABLE Bronze.erp_px_cat_g1v2 (
	id				NVARCHAR(50),
	cat				NVARCHAR(50),
	subcat			NVARCHAR(50),
	maintenance		NVARCHAR(50)
)

/*

T-SQL could be used before the CREATE TABLE statements in case we need to redo the table.

IF OBJECT_ID ('tablename', 'U') IS NOT NULL
	DROP TABLE tablename;

*/
