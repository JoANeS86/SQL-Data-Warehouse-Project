### <ins>Measures</ins>

    Total Quantity = SUM('Gold fact_sales'[quantity])
    
    Avg Price = AVERAGE('Gold fact_sales'[price])
    
    Total Cost = SUMX('Gold fact_sales', 'Gold fact_sales'[quantity] * RELATED('Gold dim_products'[cost]))
    
    Margin = [Total Revenue] - [Total Cost]
