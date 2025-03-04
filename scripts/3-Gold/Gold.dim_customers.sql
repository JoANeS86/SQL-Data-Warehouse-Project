/*

===================================================================
DDL Script: Create Gold Views
===================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema)

	Each view performs transformations and combines data from the Silver layer
	to produce a clean, enriched, and business-ready dataset.

Usage:
	- These views can be queried directly for analytics and reporting.
===================================================================

*/

CREATE VIEW Gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
		 ELSE COALESCE(ca.gen, 'N/A')
	END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_loc_a101 la
ON ci.cst_key = la.cid

-- After joining table, check if any duplicates were introduced by the join logic (use the COUNT(*), grouping by cst_id).

/* Now, if I check the results from the query above, I see an integration issue: There are two sources for the gender.
   I have to do Data Integration.
   
   After running the query below, I see different scenarios.
   For those cases where I have different values coming from each source (Female VS Male or Male vs Female), I have to ask to
   the experts about it: Whi source is the master for this values? 
   
   Let's say that in this case the answer is that the Master Source of Customer Data is CRM (meaning the CRM information is
   more accurate than the ERP information). */

SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	CASE WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
		 ELSE COALESCE(ca.gen, 'N/A')
	END AS new_gen
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_loc_a101 la
ON ci.cst_key = la.cid
ORDER BY 1,2

-- So in this query above I have integrated two data sources in one.

/* Now I'm gonna give friendly names to the fields by following the General Principles that I defined at the beginning of the
   project (use snake_case, with lowercase letters and underscores (_) to separate words).
   
   Also, I'm gonna sort the columns into logical groups to improve readability (E.g., country is an important field, so
   I'm moving it after the last name). */

/* Is this a Dimension or a Fact table?
   Dimension holds descriptive information about an object, and in this table I can see fields like First Name, Last Name,
   Country... That are descriptions about the customers, and also I don't have transactions, events, measures and so on,
   so this is clearly a Dimension.
   
   So, I'm going to call this object the Dimension Customer.
   Then, when you create a Dimension, you need always a Primary Key for the Dimension.
   
   In some cases you can use the PK coming from the sources, but sometimes you won't be able to count on that, so a new PK
   will need to be generated in the DWH: Those PKs are called Surrogate Keys. 
   
   I'm creating that key through the ROW_NUMBER function in the main query above.
   
   Once I have created the View (the Dimension), I can apply some quality checks (E.g., looking for duplicates,
   or select the DISTINCT values of the gender to confirm everything is ok. */

SELECT * FROM Gold.dim_customers
   
SELECT DISTINCT gender FROM Gold.dim_customers
