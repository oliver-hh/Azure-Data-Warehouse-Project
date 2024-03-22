-- Use case: Analyze how much time is spent per ride/trip

SELECT TOP 1000
    d.season, d.day_of_week, d.time_of_day, d.is_weekend_or_holiday,
    r.age,
    r.is_member,
    start_station = ss.name,
    end_station = es.name,
    f.duration_in_minutes
FROM
    fact_trip_duration f
INNER JOIN
    dim_date d on d.date_key = f.date_key
INNER JOIN
    dim_rider r on r.rider_key = f.rider_key
INNER JOIN
    dim_station ss on ss.station_key = f.start_station_key
INNER JOIN
    dim_station es on es.station_key = f.end_station_key

/*
SELECT TOP 10 * FROM dbo.fact_trip_duration;
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
    fact_trip_duration f  
INNER JOIN  
    dim_date d on d.date_key = f.date_key  
GROUP BY  
    d.day_of_week,   
    d.time_of_day
ORDER BY
    d.day_of_week,   
    CASE d.time_of_day WHEN 'Morning' THEN 1 WHEN 'Afternoon' THEN 2 WHEN 'Evening' THEN 3 WHEN 'Night' THEN 4 ELSE 5 END

SELECT
    d.season,
    d.time_of_day,   
    d.is_weekend_or_holiday,   
    avg_duration = AVG(f.duration_in_minutes)
FROM  
    fact_trip_duration f  
INNER JOIN  
    dim_date d on d.date_key = f.date_key  
GROUP BY  
    d.season,
    d.time_of_day,
    d.is_weekend_or_holiday
ORDER BY
    CASE d.season WHEN 'Spring' THEN 1 WHEN 'Summer' THEN 2 WHEN 'Autumn' THEN 3 WHEN 'Winter' THEN 4 ELSE 5 END,
    CASE d.time_of_day WHEN 'Morning' THEN 1 WHEN 'Afternoon' THEN 2 WHEN 'Evening' THEN 3 WHEN 'Night' THEN 4 ELSE 5 END,
    d.is_weekend_or_holiday;
    

-- Which station is the starting and / or ending station?
SELECT   
    start_station = ss.name,   
    end_station = es.name,   
    avg_duration = AVG(f.duration_in_minutes)  
FROM  
    fact_trip_duration f  
INNER JOIN  
    dim_station ss on ss.station_key = f.start_station_key  
INNER JOIN  
    dim_station es on es.station_key = f.end_station_key  
GROUP BY  
    ss.name,   
    es.name
ORDER BY avg_duration DESC;

-- Age of the rider at time of the ride:
SELECT   
    r.age,   
    avg_duration = AVG(f.duration_in_minutes)  
FROM  
    fact_trip_duration f  
INNER JOIN  
    dim_rider r on r.rider_key = f.rider_key  
GROUP BY  
    r.age
ORDER by age

SELECT     
    age_range = CASE    
        WHEN r.age BETWEEN 10 AND 19 THEN '10-19'  
        WHEN r.age BETWEEN 20 AND 29 THEN '20-29'  
        WHEN r.age BETWEEN 30 AND 39 THEN '30-39'  
        WHEN r.age BETWEEN 40 AND 49 THEN '40-49'  
        WHEN r.age BETWEEN 50 AND 59 THEN '50-59'  
        WHEN r.age BETWEEN 60 AND 69 THEN '60-69'  
        WHEN r.age BETWEEN 70 AND 79 THEN '70-79'  
        WHEN r.age BETWEEN 80 AND 89 THEN '80-89'  
        ELSE 'Other'  
    END,  
    avg_duration = AVG(f.duration_in_minutes)    
FROM    
    fact_trip_duration f    
INNER JOIN    
    dim_rider r on r.rider_key = f.rider_key    
GROUP BY    
    CASE    
        WHEN r.age BETWEEN 10 AND 19 THEN '10-19'  
        WHEN r.age BETWEEN 20 AND 29 THEN '20-29'  
        WHEN r.age BETWEEN 30 AND 39 THEN '30-39'  
        WHEN r.age BETWEEN 40 AND 49 THEN '40-49'  
        WHEN r.age BETWEEN 50 AND 59 THEN '50-59'  
        WHEN r.age BETWEEN 60 AND 69 THEN '60-69'  
        WHEN r.age BETWEEN 70 AND 79 THEN '70-79'  
        WHEN r.age BETWEEN 80 AND 89 THEN '80-89'  
        ELSE 'Other'  
    END
ORDER BY  
    age_range;  


-- Rider is a member or a casual rider
SELECT   
    r.is_member,   
    avg_duration = AVG(f.duration_in_minutes)
FROM  
    fact_trip_duration f  
INNER JOIN  
    dim_rider r on r.rider_key = f.rider_key  
GROUP BY  
    r.is_member;  


