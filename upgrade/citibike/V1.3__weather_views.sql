USE SCHEMA demo;

-- Load the trips data
CREATE OR REPLACE VIEW trip_analytics AS
    SELECT
         DATE_TRUNC('hour', starttime) AS "date"
        ,COUNT(*) AS "num trips"
        ,AVG(tripduration)/60 AS "avg duration (mins)"
        ,AVG(HAVERSINE(start_station_latitude, start_station_longitude, end_station_latitude, end_station_longitude)) AS "avg distance (km)"
    FROM trips
    GROUP BY 1
    ORDER BY 1
;
