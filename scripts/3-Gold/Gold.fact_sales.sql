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

CREATE VIEW Gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM Silver.crm_sales_details sd
LEFT JOIN Gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN Gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id

/* Is this table a Dimension or a Fact?
   There are several keys to connect multiple Dimensions, there are dates and there are measures, so I can say this is a Fact.
   
   Now, I have to use the dimension's surrogate keys instead of IDs coming from the source to easily connect facts  with dimensions.
   
   Now, I'll be joining the Fact table above to the Gold layer, since there is where tables have surrogate keys.
   
   I'll take the product_key coming from the Gold.dim_products table, and then I'll remove the sls_prd_key from the results,
   and with that I'll have the two keys from the Dimensions within the Fact table.
   
   Next step is to give friendly names to the fields and sort the columns into logical groups to improve readability. */

SELECT * FROM Gold.fact_sales

-- Check if all dimension tables can succesfully join to the fact table.

SELECT *
FROM Gold.fact_sales f
LEFT JOIN Gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN Gold.dim_products p
ON p.product_key = f.product_key
-- WHERE c.customer_key IS NULL
WHERE p.product_key IS NULL

-- I'm not getting anything, which means that everything is matching perfectly.
