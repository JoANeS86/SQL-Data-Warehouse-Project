### <ins>Measures</ins>

      Total Revenue = SUM('Gold fact_sales'[sales_amount])
      
      Revenue LY = 
      CALCULATE(
          [Total Revenue],
          SAMEPERIODLASTYEAR(DimDate[Date])
      )
      
      Revenue YoY % = 
      DIVIDE(
          [Total Revenue] - [Revenue LY],
          [Revenue LY]
      )
      
      Revenue MTD = 
      TOTALMTD([Total Revenue], DimDate[Date])
      
      Revenue YTD = 
      TOTALYTD(
          [Total Revenue],
          DimDate[Date]
      )
      
      Rolling 3M Avg Revenue = 
      CALCULATE(
          AVERAGEX(
              VALUES(DimDate[YearMonth]),
              [Total Revenue]
          ),
          DATESINPERIOD(
              DimDate[Date],
              MAX(DimDate[Date]),
              -3,
              MONTH
          )
      )
      
      Revenue per Customer = DIVIDE([Total Revenue], [Total Customers])
      
      Revenue per Product = DIVIDE([Total Revenue], [Total Products])
      
      Cumulative Revenue (Time) = 
      CALCULATE(
          [Total Revenue],
          FILTER(
              ALLSELECTED(DimDate[Date]),
              DimDate[Date] <= MAX(DimDate[Date])
          )
      )
      
      Revenue by Percentile Band = 
      VAR BandStart = SELECTEDVALUE('Percentile Bands'[Value])
      VAR BandEnd = BandStart + 0.01
      RETURN
      CALCULATE(
          [Total Revenue],
          FILTER(
              ALL('Gold dim_customers'),
              [Customer Percentile] > BandStart &&
              [Customer Percentile] <= BandEnd
          )
      )

      
      
      Revenue by Shipping Date = 
      CALCULATE(
          [Total Revenue],
          USERELATIONSHIP('Gold fact_sales'[shipping_date], DimDate[Date])
      )

      New Customer Revenue

      New Customer Revenue =
      VAR CurrentCustomers =
          CALCULATETABLE(
              VALUES('Gold fact_sales'[customer_key])
          )
      
      VAR PreviousCustomers =
          CALCULATETABLE(
              VALUES('Gold fact_sales'[customer_key]),
              SAMEPERIODLASTYEAR(DimDate[Date])
          )
      
      VAR NewCustomerSet =
          EXCEPT(
              CurrentCustomers,
              PreviousCustomers
          )
      
      RETURN
          CALCULATE(
              [Total Revenue],
              TREATAS(
                  NewCustomerSet,
                  'Gold fact_sales'[customer_key]
              )
          )


#### <ins>Customer Retention Analysis (Virtual Tables):</ins>

      
      Retained Customer Revenue
      
      Retained Customer Revenue =
      VAR CurrentCustomers =
          CALCULATETABLE(
              VALUES('Gold fact_sales'[customer_key])
          )
      
      VAR PreviousCustomers =
          CALCULATETABLE(
              VALUES('Gold fact_sales'[customer_key]),
              SAMEPERIODLASTYEAR(DimDate[Date])
          )
      
      VAR RetainedCustomerSet =
          INTERSECT(
              CurrentCustomers,
              PreviousCustomers
          )
      
      RETURN
          CALCULATE(
              [Total Revenue],
              TREATAS(
                  RetainedCustomerSet,
                  'Gold fact_sales'[customer_key]
              )
          )
      
      Lost Customer Revenue
      
      Lost Customer Revenue =
      VAR CurrentCustomers =
          CALCULATETABLE(
              VALUES('Gold fact_sales'[customer_key])
          )
      
      VAR PreviousCustomers =
          CALCULATETABLE(
              VALUES('Gold fact_sales'[customer_key]),
              SAMEPERIODLASTYEAR(DimDate[Date])
          )
      
      VAR LostCustomerSet =
          EXCEPT(
              PreviousCustomers,
              CurrentCustomers
          )
      
      RETURN
          CALCULATE(
              [Revenue LY],
              TREATAS(
                  LostCustomerSet,
                  'Gold fact_sales'[customer_key]
              )
          )

#### <ins>Top N Revenue</ins>

**[Selected Top N] is a measure saved in the "Selections" subfolder.*

            Top N Revenue =
            VAR N = [Selected Top N]
            
            VAR CustomerRevenue =
                ADDCOLUMNS(
                    ALLSELECTED('Gold dim_customers'[customer_key]),
                    "@Revenue", [Total Revenue]
                )
            
            VAR TopCustomers =
                TOPN(
                    N,
                    CustomerRevenue,
                    [@Revenue],
                    DESC
                )
            
            RETURN
                SUMX(
                    TopCustomers,
                    [@Revenue]
                )

#### <ins>Top N Revenue %</ins>

            Top N Revenue % =
            DIVIDE(
                [Top N Revenue],
                CALCULATE(
                    [Total Revenue],
                    ALLSELECTED('Gold dim_customers')
                )
            )
