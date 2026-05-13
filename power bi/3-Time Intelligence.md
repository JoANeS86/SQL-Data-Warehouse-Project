### <ins>Measures</ins>

     Revenue YoY % = 
     DIVIDE(
         [Total Revenue] - [Revenue LY],
         [Revenue LY]
     )


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
