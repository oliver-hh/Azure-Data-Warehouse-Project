-- Overall spent per year, quarter, month
SELECT
    d.year, d.quarter, d.month,
    amount_dollar = SUM(f.amount_dollar)
FROM
    fact_payment f
INNER JOIN
    dim_date_payment d on d.date_key = f.date_key
GROUP BY
    d.year, d.quarter, d.month
ORDER BY
    d.year, d.quarter, d.month;

-- Top riders per month
;WITH RiderAmounts AS (  
    SELECT   
        d.year, d.quarter, d.month, r.rider_key,  
        amount_dollar = sum(f.amount_dollar),  
        ROW_NUMBER() OVER(PARTITION BY d.year, d.quarter, d.month ORDER BY sum(f.amount_dollar) DESC) as rn  
    FROM  
        fact_payment f  
    INNER JOIN  
        dim_date_payment d on d.date_key = f.date_key  
    INNER JOIN  
        dim_rider r on r.rider_key = f.rider_key  
    GROUP BY  
        d.year, d.quarter, d.month, r.rider_key  
)  
SELECT   
    year, quarter, month, rider_key, amount_dollar   
FROM   
    RiderAmounts   
WHERE   
    rn = 1  
ORDER BY  
    year, quarter, month;  

-- Money spent per member based on rides/minutes per month
SELECT TOP 100
    ft.rider_key,
    d.year,
    d.month,
    number_of_rides = COUNT(1),
    total_minutes = SUM(ft.duration_in_minutes),
    money_spent = SUM(fp.amount_dollar)
FROM
    fact_trip ft
INNER JOIN
    fact_payment fp ON fp.rider_key = ft.rider_key AND fp.date_key = DATEADD(MONTH, DATEDIFF(MONTH, 0, ft.date_key), 0)
INNER JOIN
    dim_date_payment d ON d.date_key = fp.date_key
GROUP BY
    ft.rider_key,
    d.year,
    d.month
ORDER BY
    d.year,
    d.month,
    money_spent DESC
