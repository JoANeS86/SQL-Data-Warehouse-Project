### <ins>Tables</ins>

I've loaded the following tables to Power BI:

  - Gold.fact_sales
  - Gold.dim_customers
  - Gold.dim_products

Then I've created a **DimDate** table and related it to one active relationship
(order_date) and added inactive relationships (shipping_date and due_date).

     DimDate = 
     ADDCOLUMNS(
         CALENDAR(DATE(2000,1,1), DATE(2029,12,31)),
         "Year", YEAR([Date]),
         "Month", FORMAT([Date], "MMM"),
         "MonthNumber", MONTH([Date]),
         "YearMonth", FORMAT([Date], "YYYY-MM")
     )

### <ins>Measures</ins>

     Total Revenue = SUM('Gold fact_sales'[sales_amount])
     
     Total Quantity = SUM('Gold fact_sales'[quantity])
     
     Avg Price = AVERAGE('Gold fact_sales'[price])


     Revenue YoY = 
     CALCULATE(
         [Total Revenue],
         SAMEPERIODLASTYEAR(DimDate[Date])
     )


     Revenue MTD = 
     TOTALMTD([Total Revenue], DimDate[Date])

The following measure temporarily activates the relationship using shipping_date
instead of the default (order_date), so the revenue is calculated based on shipping date.
     
     Revenue by Shipping Date = 
     CALCULATE(
         [Total Revenue],
         USERELATIONSHIP('Gold fact_sales'[shipping_date], DimDate[Date])
     )

Also consider:

     Total Cost = SUMX(fact_sales, fact_sales[quantity] * RELATED(dim_products[cost]))

     Margin = [Total Sales] - [Total Cost]

### <ins>Columns</ins>

Gold.dim_customer:

     Full Name = dim_customers[first_name] & " " & dim_customers[last_name]

     Age = DATEDIFF(dim_customers[birthdate], TODAY(), YEAR)




     
