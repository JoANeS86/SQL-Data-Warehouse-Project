### <ins>Measures</ins>

    Total Customers = DISTINCTCOUNT('Gold dim_customers'[customer_key])
    
    Top Customer Revenue = 
    MAXX(
        VALUES('Gold dim_customers'[Full Name]),
        [Total Revenue]
    )
    
    Customer Rank = 
    RANKX(
        ALLSELECTED('Gold dim_customers'),
        [Total Revenue],
        ,
        DESC
    )
    
    Customer Percentile = 
    DIVIDE(
        [Customer Rank],
        COUNTROWS(ALL('Gold dim_customers'))
    )
    
    Cumulative Revenue (Customer Rank) = 
    VAR CurrentRank = [Customer Rank]
    RETURN
    CALCULATE(
        [Total Revenue],
        FILTER(
            ALLSELECTED('Gold dim_customers'),
            [Customer Rank] <= CurrentRank
        )
    )
    
    Cumulative Revenue % (Customer Rank) = 
    DIVIDE(
        [Cumulative Revenue (Customer Rank)],
        CALCULATE([Total Revenue], ALLSELECTED('Gold dim_customers'))
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
