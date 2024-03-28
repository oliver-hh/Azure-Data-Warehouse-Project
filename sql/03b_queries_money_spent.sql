-- Overall spent per year, quarter, month
SELECT
    d.year, d.quarter, d.month,
    amount_dollar = SUM(f.amount_dollar)
FROM
    fact_money_spent f
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
        fact_money_spent f  
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
    date_month = DATEADD(MONTH, DATEDIFF(MONTH, 0, ft.date_key), 0),
    number_of_rides = COUNT(1),
    total_minutes = SUM(ft.duration_in_minutes),
    money_spent = SUM(fm.amount_dollar)
FROM
    fact_trip ft
INNER JOIN
    fact_money_spent fm ON fm.rider_key = ft.rider_key AND fm.date_key = DATEADD(MONTH, DATEDIFF(MONTH, 0, ft.date_key), 0)
GROUP BY
    ft.rider_key,
    DATEADD(MONTH, DATEDIFF(MONTH, 0, ft.date_key), 0)
