--------------------------------------------------
-- Analyze data from relational DB with the aim to
-- optimize data types of staging-table columns
--------------------------------------------------

-- station
SELECT MAX(LENGTH(station_id)) FROM public.station;  
SELECT MAX(LENGTH(name)) FROM public.station;  
SELECT MIN(latitude), MAX(latitude) FROM public.station;  
SELECT MIN(longitude), MAX(longitude) FROM public.station;  
SELECT * FROM public.station LIMIT 10

-- rider
SELECT * FROM public.rider LIMIT 10;
SELECT MAX(rider.rider_id), MAX(LENGTH(first)), max(LENGTH(last)), max(LENGTH(address)) FROM public.rider;

-- paymet
SELECT * FROM public.payment LIMIT 10;
SELECT max(amount) FROM public.payment;

-- trip
SELECT * FROM public.trip LIMIT 10;
SELECT MAX(LENGTH(trip_id)), MAX(LENGTH(rideable_type)), MAX(LENGTH(start_station_id)), MAX(LENGTH(end_station_id))  from public.trip
SELECT MIN(start_at), max(start_at) from public.trip;
SELECT MIN(ended_at), max(ended_at) from public.trip;
