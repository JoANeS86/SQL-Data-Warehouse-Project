### <ins>Measures</ins>

      Customer Rank = 
      RANKX(
          ALL('Gold dim_customers'),
          [Total Revenue],
          ,
          DESC
      )
      
      
      Customer Percentile = 
      DIVIDE(
          [Customer Rank],
          COUNTROWS(ALL('Gold dim_customers'))
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


      Cumulative Revenue % by Band = 
      VAR CurrentBand = SELECTEDVALUE('Percentile Bands'[Value])
      RETURN
      DIVIDE(
          CALCULATE(
              [Total Revenue],
              FILTER(
                  ALL('Gold dim_customers'),
                  [Customer Percentile] <= CurrentBand
              )
          ),
          CALCULATE([Total Revenue], ALL('Gold dim_customers'))
      )


### <ins>Columns</ins>

Gold.dim_customer:

      Customer Segment = 
      SWITCH(
          TRUE(),
          [Customer Percentile] <= 0.1, "Top 10%",
          [Customer Percentile] <= 0.3, "10–30%",
          "Others"
      )
