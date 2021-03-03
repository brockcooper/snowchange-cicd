## Steps:

1. Run Reset Citibike in Snowflake
2. Run the following in Snowflake:
```
USE ROLE dba_citibike;
CREATE WAREHOUSE IF NOT EXISTS load_wh
    INITIALLY_SUSPENDED = true
    AUTO_SUSPEND = 120
    WAREHOUSE_SIZE = Small
;

-- represents dev db maintained by data team
CREATE OR REPLACE DATABASE citibike_dev CLONE citibike;

-- represents personal dev db
CREATE OR REPLACE DATABASE citibike_john CLONE citibike;
```
3. Run this in your terminal to get up to 1.2:
```
python snowchange/cli.py -a SNOWFLAKE_ACCOUNT -u john -r dba_citibike -w load_wh -d citibike_john -c citibike_john.metadata.change_history --create-change-history-table
```
4. Now, you want to make your own change. Add the file `V1.3__weather_views.sql` with this inside:
```
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
```
5. Push those changes to Github and make a Pull Request to Dev, watch those changes be made to `citibike_dev`
6. Make another PR to main and watch those changes be made to GitHub
7. Always undo the commits made to the main and dev branches by just deleting the `V1.3__weather_views.sql` files from the branches
