# Divvy

## Business outcomes to design for

1. Analyze how much time is spent per trip
   - Based on date and time factors such as day of week and time of day
   - Based on which station is the starting and / or ending station
   - Based on age of the rider at time of the ride
   - Based on whether the rider is a member or a casual rider

fact_trip_duration
- PK time_per_ride_key
- dim_date_time
- dim_start_station
- dim_end_station
- time_spent_per_ride

1. Analyze how much money is spent
   - Per month, quarter, year
   - Per member, based on the age of the rider at account start

fact_money_spent

3. EXTRA CREDIT - Analyze how much money is spent per member
   - Based on how many rides the rider averages per month
   - Based on how many minutes the rider spends on a bike per month

fact_money_spent_per_member

## Provide OLTP database

Create postgres database

Download csv-files from [here](https://video.udacity-data.com/topher/2022/March/622a5fc6_azure-data-warehouse-projectdatafiles/azure-data-warehouse-projectdatafiles.zip)

Import the csv-files to postgres

## Extract Stage (Ingest data)

Create linked service for postgres in Synapse

Create a new blob container ```udacity-divvy``` in the existing storage account ```dlsazdelab```.

Ingest data from postgress into the previously created container with a built-in copy task.

## Load Stage (Staging tables)

Create database ```udacity-divvy``` in the serverless SQL pool

Create external tables from the extracted ```csv``` files.


## Tranform Stage (fact/dim-tables)

### Common Dimension Tables

A python-script ```create_date_dim.py``` has been created to provide a very sophisticated dimension table for dates:

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










[Synapse / Data Factory naming conventions](https://erwindekreuk.com/2020/07/azure-data-factory-naming-conventions/#:%7E:text=There%20are%20a%20few%20standard%20naming%20conventions%20that,begin%20with%20a%20letter%2C%20number%20or%20underscore%20%28_%29.)

[MS Database Architecture](https://learn.microsoft.com/en-us/azure/architecture/databases/)


# README Template

Below is a template provided for use when building your README file for students.

# Project Title

Project description goes here.

## Getting Started

Instructions for how to get a copy of the project running on your local machine.

### Dependencies

```
Examples here
```

### Installation

Step by step explanation of how to get a dev environment running.

List out the steps

```
Give an example here
```

## Testing

Explain the steps needed to run any automated tests

### Break Down Tests

Explain what each test does and why

```
Examples here
```

## Project Instructions

This section should contain all the student deliverables for this project.

## Built With

* [Item1](www.item1.com) - Description of item
* [Item2](www.item2.com) - Description of item
* [Item3](www.item3.com) - Description of item

Include all items used to build project.

## License

[License](LICENSE.txt)
