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
