### <ins>Columns</ins>

Gold.dim_customer:

      Customer Segment = 
      SWITCH(
          TRUE(),
          [Customer Percentile] <= 0.1, "Top 10%",
          [Customer Percentile] <= 0.3, "10–30%",
          "Others"
      )
