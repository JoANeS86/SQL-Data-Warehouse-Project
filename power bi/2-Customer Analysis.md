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

### <ins>Columns</ins>

Gold.dim_customer:

      Customer Segment = 
      SWITCH(
          TRUE(),
          [Customer Percentile] <= 0.1, "Top 10%",
          [Customer Percentile] <= 0.3, "10–30%",
          "Others"
      )
