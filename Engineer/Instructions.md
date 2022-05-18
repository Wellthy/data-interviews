# Analytics Engineer Prompt

## Background
At Wellthy, we use dbt to build and maintain our data transformations. dbt is a open source, command line tool that lets data teams quickly and collaboratively deploy analytics code following software engineering best practices using SQL. For more information about dbt you can reference the documentation [here](https://docs.getdbt.com/docs/introduction) or feel free to test it out by following their [online tutorial](https://courses.getdbt.com/collections), but please note this is not required for this interview. 

For the purpose of this challenge, think of dbt as a tool that enables you to build and test tables (data models) using `SELECT` statements. Each data model that is created in a dbt project is stored in a .sql file. Since data models are often dependent on each other, dbt creates a directed acyclic graph (DAG) that allows you to see these dependencies. This is done by using jinja like so `{{ ref('some_model_name') }}` to reference tables in the `FROM` statement.

Data models can be configured and data tests and documentation can be added using YAML files. Click [here](https://docs.getdbt.com/docs/building-a-dbt-project/tests) for more information about dbt tests or [here](https://docs.getdbt.com/docs/building-a-dbt-project/documentation) for more information about documentation.

## Scenario:
A data analyst comes to the analytics engineers and says that the Care Team is struggling to meet capacity. One manager hypothesizes that this is due to an increase in the number of care projects and they need to hire more people. However, another manager thinks that there is an efficiency problem and certain tasks or projects are causing bottlenecks in the process. The data analyst needs to be able to analyze the data and deliver insights to the Care Team so they can make a decision on how to handle the capacity problem. 

## Here are some of the business questions that analyst would like to be able to answer:
How many projects are starting each week?
How many `in progress` tasks are in each project?
How long is it taking to complete tasks and projects?
Is there a particular phase of a task that takes longer than others?
Is there a particular project type or task type that takes longer than others?

## Challenge
An analytics engineer on the team has started modeling out this data to allow the analyst to answer these questions more easily. The analytics engineer has submitted a pull request (PR) for you to review. 

Prior to your technical interview, please review the files in the `base`, `intermediate`, and `prod` subdirectories as well as the open Pull Request. Make note of any questions you might have about the sample data model - you will have an opportunity to ask them during the interview.

## The Technical Interview
During your technical interview, we will discuss your review of the Pull Request in a collaborative session. You will not be asked to do any coding yourself, but please be prepared to share your screen and discuss what changes, suggestions, or questions you would include in your Pull Request review. Please note: You do not need to submit anything ahead of the interview or prepare a presentation of any kind.

## dbt Model structure
Our dbt structure is separated across multiple databases and schemas and transformations are performed in different "layers" to reduce the repetition of logic across multiple models.
* The `prep` database contains all of the early transformations that are not directly accessed by BI Tools or external processes.
    * The `base` schema contains a 1-1 relationship with the source tables and includes the individual table transformations and column aliasing. Every source table should have a corresponding `base` model.
    * The `intermediate` schema contains early combinations of records that are used as stepping stones to produce additional downstream transformations. One example of this could be combining project information from the `projects` model and the `project_history` model into the more comprehensive `full_project_history` model. This sepration will allow for leveraging the same models downstream without repeating the same joins multiple times.
* The `prod` database contains the "final" transformations to produce the models that are accessed directly by BI Tools and external processes.

## Lineage Graph
![DAG](DAG.png)

## Assumptions
Since this is an incomplete dbt project, you are unable to run the models yourself to verify their accuracy. As such, please assume the following:
* `dbt run` results in a successful build of all models.
* `dbt test` results in a successful test of all models.