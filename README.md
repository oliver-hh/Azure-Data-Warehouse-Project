# Divvy
Divvy is a bike sharing program in Chicago, Illinois USA that allows riders to purchase a pass at a kiosk or use a mobile application to unlock a bike at stations around the city and use the bike for a specified amount of time. The bikes can be returned to the same station or to another station. The City of Chicago makes the anonymized bike trip data publicly available for projects like this where we can analyze the data.

Text taken from [Udacity Project Description](https://learn.udacity.com/nanodegrees/nd0277/parts/cd11530/lessons/015dff86-2a7f-4a70-a35b-a8026e662389/concepts/48cb5238-ea63-4256-83bb-ab3d79d69b48)  

## Getting started
The folder structure of the project contain the following folder and files I chanchged/created
- ```README.md```: This file with the documentation
- Folders relevant to project rubric
  - ```01_star_schema```: PDF file with the star schemas used in the project
  - ```02_extract_step```: Screenshot of the files extracted from the PostgrSQL database
  - ```03_load_step```: SQL-scripts that create the staging tables
  - ```04_transform_step```: SQL-scripts that create the dimension and fact tables
- ```images```: Several screenshots that document steps executed in Azure Synapse
  - Extract
  - Load
  - Linked Services
  - Star schema
- ```work_files```: This is/was my place for the working mode and left room for experimantation.
  - ```data```/```python```: This was just an experiment to create a Python version of an date dimension table.
  - ```sql```: Working folder for PostgrSQL data analysis, load/transform and queries I created to validate the dimension and fact tables against the expected business outcomes. 

## Business outcomes to design for

1. Analyze how much time is spent per trip
   - Based on date and time factors such as day of week and time of day
   - Based on which station is the starting and / or ending station
   - Based on age of the rider at time of the ride
   - Based on whether the rider is a member or a casual rider

2. Analyze how much money is spent
   - Per month, quarter, year
   - Per member, based on the age of the rider at account start

3. EXTRA CREDIT - Analyze how much money is spent per member
   - Based on how many rides the rider averages per month
   - Based on how many minutes the rider spends on a bike per month

It has not been specified in the project rubric but I defined some queries to analyze the date regarding the before mentioned business outcomes in folder ```./work_files/sql```
- ```03a_queries_trip.sql```
- ```03b_queries_payment.sql```

When it came to the extra credit I didn't create more dimension and fact tables because I was able to fulfil the requirement with the already existing tables (see last query in ```03b_queries_payment.sql```)

## Other Notes / Instructions

### Provide OLTP database

Create postgres database

Download csv-files from [here](https://video.udacity-data.com/topher/2022/March/622a5fc6_azure-data-warehouse-projectdatafiles/azure-data-warehouse-projectdatafiles.zip)

Import the csv-files to postgres

### Extract Stage (Ingest data)

Create linked service for postgres in Synapse

Create a new blob container ```udacity-divvy``` in the existing storage account ```dlsazdelab```.

Ingest data from postgress into the previously created container with a built-in copy task.

### Load Stage (Staging tables)

Create database ```udacity-divvy``` in the serverless SQL pool

Create external tables from the extracted ```csv``` files.

### Tranform Stage (fact/dim-tables)

This is just a note to document the effort I made when creating the date dimension-table for the trips. 

| Column                | Type   | Values                                  |
| --------------------- | ------ | --------------------------------------- |
| date_key              | date   | 2021-01-01 00:00:00-2022-12-31 23:00:00 |
| year                  | int    | 2021-022                                |
| month                 | int    | 01-12                                   |
| day                   | int    | 01-31                                   |
| hour                  | int    | 00-23                                   |
| time_of_day           | string | Morning, Afternoon, Evening, Night      |
| quarter               | int    | 1-4                                     |
| week                  | int    | 1-53                                    |
| day_of_week           | int    | 0-6                                     |
| season                | string | Sprint, Sumer, Autumn, Winter           |
| is_weekend_or_holiday | bool   | True, False                             |

### Useful Links

[Synapse / Data Factory naming conventions](https://erwindekreuk.com/2020/07/azure-data-factory-naming-conventions/#:%7E:text=There%20are%20a%20few%20standard%20naming%20conventions%20that,begin%20with%20a%20letter%2C%20number%20or%20underscore%20%28_%29.)

[MS Database Architecture](https://learn.microsoft.com/en-us/azure/architecture/databases/)
