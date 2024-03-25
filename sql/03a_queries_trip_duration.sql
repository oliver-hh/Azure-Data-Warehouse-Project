-- Use case: Analyze how much time is spent per ride/trip

SELECT TOP 1000
    d.season, d.day_of_week, d.time_of_day, d.is_weekend,
    f.age_trip,
    r.is_member,
    start_station = ss.name,
    end_station = es.name,
    f.duration_in_minutes
FROM
    fact_trip f
INNER JOIN
    dim_date_trip d on d.date_key = f.date_key
INNER JOIN
    dim_rider r on r.rider_key = f.rider_key
INNER JOIN
    dim_station ss on ss.station_key = f.start_station_key
INNER JOIN
    dim_station es on es.station_key = f.end_station_key

/*
SELECT TOP 10 * FROM dbo.fact_trip;
SELECT TOP 10 * FROM dim_date;
SELECT TOP 10 * FROM dim_station;
SELECT TOP 10 * FROM dim_rider;
*/


-- Date and time factors such as day of week and time of day
SELECT
    d.day_of_week,   
    d.time_of_day,   
    avg_duration = AVG(f.duration_in_minutes)
FROM  
    fact_trip f  
INNER JOIN  
    dim_date_trip d on d.date_key = f.date_key  
GROUP BY  
    d.day_of_week,   
    d.time_of_day
ORDER BY
    d.day_of_week,   
    CASE d.time_of_day WHEN 'Morning' THEN 1 WHEN 'Afternoon' THEN 2 WHEN 'Evening' THEN 3 WHEN 'Night' THEN 4 ELSE 5 END

SELECT
    d.season,
    d.time_of_day,   
    d.is_weekend,   
    avg_duration = AVG(f.duration_in_minutes)
FROM  
    fact_trip f  
INNER JOIN  
    dim_date_trip d on d.date_key = f.date_key  
GROUP BY  
    d.season,
    d.time_of_day,
    d.is_weekend
ORDER BY
    CASE d.season WHEN 'Spring' THEN 1 WHEN 'Summer' THEN 2 WHEN 'Autumn' THEN 3 WHEN 'Winter' THEN 4 ELSE 5 END,
    CASE d.time_of_day WHEN 'Morning' THEN 1 WHEN 'Afternoon' THEN 2 WHEN 'Evening' THEN 3 WHEN 'Night' THEN 4 ELSE 5 END,
    d.is_weekend;
    

-- Which station is the starting and / or ending station?
SELECT   
    start_station = ss.name,   
    end_station = es.name,   
    avg_duration = AVG(f.duration_in_minutes)  
FROM  
    fact_trip f  
INNER JOIN  
    dim_station ss on ss.station_key = f.start_station_key  
INNER JOIN  
    dim_station es on es.station_key = f.end_station_key  
GROUP BY  
    ss.name,   
    es.name

-- Age of the rider at time of the ride
SELECT   
    f.age_trip,   
    avg_duration = AVG(f.duration_in_minutes)  
FROM  
    fact_trip f  
GROUP BY  
    f.age_trip
ORDER by f.age_trip

-- Age of the rider at time of the ride in ranges
SELECT
    age_range = CASE    
        WHEN f.age_trip BETWEEN 10 AND 19 THEN '10-19'  
        WHEN f.age_trip BETWEEN 20 AND 29 THEN '20-29'  
        WHEN f.age_trip BETWEEN 30 AND 39 THEN '30-39'  
        WHEN f.age_trip BETWEEN 40 AND 49 THEN '40-49'  
        WHEN f.age_trip BETWEEN 50 AND 59 THEN '50-59'  
        WHEN f.age_trip BETWEEN 60 AND 69 THEN '60-69'  
        WHEN f.age_trip BETWEEN 70 AND 79 THEN '70-79'  
        WHEN f.age_trip BETWEEN 80 AND 89 THEN '80-89'  
        ELSE 'Other'  
    END,  
    avg_duration = AVG(f.duration_in_minutes)    
FROM    
    fact_trip f    
INNER JOIN    
    dim_rider r on r.rider_key = f.rider_key
GROUP BY    
    CASE    
        WHEN f.age_trip BETWEEN 10 AND 19 THEN '10-19'  
        WHEN f.age_trip BETWEEN 20 AND 29 THEN '20-29'  
        WHEN f.age_trip BETWEEN 30 AND 39 THEN '30-39'  
        WHEN f.age_trip BETWEEN 40 AND 49 THEN '40-49'  
        WHEN f.age_trip BETWEEN 50 AND 59 THEN '50-59'  
        WHEN f.age_trip BETWEEN 60 AND 69 THEN '60-69'  
        WHEN f.age_trip BETWEEN 70 AND 79 THEN '70-79'  
        WHEN f.age_trip BETWEEN 80 AND 89 THEN '80-89'  
        ELSE 'Other'  
    END
ORDER BY  
    age_range;  

-- Rider is a member or a casual rider
SELECT   
    r.is_member,   
    avg_duration = AVG(f.duration_in_minutes)
FROM  
    fact_trip f  
INNER JOIN  
    dim_rider r on r.rider_key = f.rider_key  
GROUP BY  
    r.is_member;  


