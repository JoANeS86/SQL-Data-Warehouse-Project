### <ins>Measures</ins>

    For just counting unique values, prefer DISTINCTCOUNT().
    COUNTROWS(DISTINCT()) becomes useful when you want to operate on the distinct table before counting it.
    
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

    Customer Rank Ratio = 
    DIVIDE(
        [Customer Rank],
        COUNTROWS(ALLSELECTED('Gold dim_customers'))
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

    Customer Retention Analysis (Virtual Tables):

    New Customers

    New Customers =
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
        COUNTROWS(NewCustomerSet)

    Retained Customers
    
    Retained Customers =
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
        COUNTROWS(RetainedCustomerSet)
        
    Lost Customers
    
    Lost Customers =
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
        COUNTROWS(LostCustomerSet)
