### <ins>Measures</ins>

    Total Products = DISTINCTCOUNT('Gold dim_products'[product_id])
    
    Top Product Revenue = 
    MAXX(
        VALUES('Gold dim_products'[product_name]),
        [Total Revenue]
    )
    
    Top Category Revenue = 
    MAXX(
        VALUES('Gold dim_products'[category]),
        [Total Revenue]
    )
    
    Product Revenue % = 
    DIVIDE(
        [Total Revenue],
        CALCULATE(
            [Total Revenue],
            ALL('Gold dim_products')
        )
    )
    
    Product Rank = 
    RANKX(
        ALLSELECTED('Gold dim_products'),
        [Total Revenue],
        ,
        DESC
    )
