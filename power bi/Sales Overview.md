### <ins>Tables</ins>

I've loaded the following tables to Power BI:

  - Gold.fact_sales
  - Gold.dim_customers
  - Gold.dim_products

Then I've created a **DimDate** table and related it to one active relationship (order_date) and added inactive relationships (shipping_date and due_date).

**I've marked the DimDate as the Date Table:** Marking the DimDate table as the Date Table in Power BI is important because it enables time-intelligence functions (like YTD, MoM, and rolling calculations) to work correctly by explicitly defining a continuous, unique date column.

     DimDate = 
     ADDCOLUMNS(
         CALENDAR(DATE(2000,1,1), DATE(2029,12,31)),
         "Year", YEAR([Date]),
         "Month", FORMAT([Date], "MMM"),
         "MonthNumber", MONTH([Date]),
         "YearMonth", FORMAT([Date], "YYYY-MM")
     )

### <ins>Columns</ins>

Gold.dim_customer:

     Full Name = 'Gold dim_customers'[first_name] & " " & 'Gold dim_customers'[last_name]

     Age = DATEDIFF('Gold dim_customers'[birthdate], TODAY(), YEAR)




     
