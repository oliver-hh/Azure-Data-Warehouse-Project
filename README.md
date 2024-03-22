# Divvy

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

Create external tables from the 



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
