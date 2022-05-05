# Analytics Engineer Prompt Style Guide

## Overview
In an effort to streamline development and maintenance of our dbt models, we want to have a standard approach to writing our SQL/dbt code so there is consistency across our models, regardless of who develops them.

## dbt Model structure
Our dbt structure is separated across multiple databases and schemas and transformations are performed in different "layers" to reduce the repetition of logic across multiple models.
* The `prep` database contains all of the early transformations that are not directly accessed by BI Tools or external processes.
    * The `base` schema contains a 1-1 relationship with the source tables and includes the individual table transformations and column aliasing. Every source table should have a corresponding `base` model.
    * The `intermediate` schema contains early combinations of records that are used as stepping stones to produce additional downstream transformations. One example of this could be combining project information from the `projects` model and the `project_history` model into the more comprehensive `full_project_history` model. This sepration will allow for leveraging the same models downstream without repeating the same joins multiple times.
* The `prod` database contains the "final" transformations to produce the models that are accessed directly by BI Tools and external processes.

## Naming Conventions
* Use snake_case for your model, table, column, and CTE names.
* Model names should be more verbose to describe what the model does. Abbreviations should not be used in model names unless the model name is excessively long.
* Dates and timestamps should use the following suffixes:
    * `_at` should be used for `DATETIME` datatypes.
    * `_date` should be used for `DATE` datatypes that have no time component.
    * `_week` should be used for `DATE` datatypes that represent the first day of a week.

## SQL Style

### Formatting
* Keywords should be capitalized, and non-keywords should be lowercase.
* Keywords should be aligned (both left-aligned and right-aligned are acceptable).
    * ```
      SELECT 'Left Alignment'
      FROM   Style
      WHERE  <Condition>
      ```
    * ```
      SELECT 'Right Alignment'
        FROM Style
       WHERE <Condition>
      ```
* A query should have one column per line and the columns should be aligned with each other.
* Use leading commas in your column lists.
* Explicitly list columns in a `SELECT` statement instead of using `SELECT *`.
* Explicitly list columns in a `GROUP BY` clause instead of using the column's numerical position.
    * Example: Use `GROUP BY column_name` instead of `GROUP BY 1`.
* Dates should be in the format of `YYYY-MM-DD`.

### Query Construction
* When joining tables, always follow the ANSI-style join. Never put your join conditions in the `WHERE` clause of a query.
    * The `JOIN` clause should be aligned with the `FROM` on a new line.
    * The `ON` clause should be on the same line as the `JOIN` clause, with any `AND` components aligned with the `ON`.
    * Example: 
    ```
    FROM table_1
    JOIN table_2 ON table_1.column_1 = table_2.column_1
                AND table_1.column_2 = table_2.column_2
    ```
* When joining tables, don't include `INNER` or `OUTER` in the query as they are redundant.
    * `JOIN` by default implies `INNER JOIN`.
    * `LEFT JOIN` and `RIGHT JOIN` by default imply `LEFT OUTER JOIN` and `RIGHT OUTER JOIN`.
* Avoid using `DISTINCT`. If you need to add `DISTINCT` for some reason, include a comment to explain exactly why.
* Avoid using `ORDER BY` outside of window functions where possible. Sorting at the SQL level is very expensive.

### Aliases
* Aliases should not be used if a query contains only a single table.
* Aliases for CTEs, tables, and columns should always be preceeded by `AS`.
* When aliases are used within a query, all columns should be referenced using their respective alias, even if that column only exists in one table within the query.

### Type Conversions and Calculations
* Use `CASE` statements only if there is not a conversion function that can be used instead.
    * Never use nested `CASE` statements.
* `CASE` statements should follow the format of `CASE WHEN <expression>` and not `CASE <column> WHEN <value>`.
* `CASE` statements should always include an `ELSE` block unless a comment is added that explains why the `ELSE` was omitted.
* `CASE` statements should be formatted so have the `CASE` and `END` components aligned, the `WHEN` and `ELSE` components aligned. The `THEN` on the same line as the `WHEN` unless `AND` conditions are necessary. In those cases, it should align with the `WHEN` conditions.
    * Example (no AND conditions):
    ```
    CASE WHEN <condition> THEN <result>
         WHEN <condition> THEN <result>
         ELSE <result>
     END AS column_name
    ```
    * Example (includes AND conditions)
    ```
    CASE WHEN <condition>
          AND <condition>
         THEN <result>
         ELSE <result>
     END AS column_name
     ```

## Model style
As a general note, some of the below principles are going to be a bit subjective and handled on a case-by-case basis.
* Each model should have a specific single purpose.
    * Example: A `base` model would only be concerned about aliasing its columns and adding any table-specific transformations that would be referenced downstream.
* Ref and Source statements should have spaces between the `{{ }}` and the statement.
    * Example: `{{ ref('model') }}` instead of `{{ref('model')}}`.
* Avoid subqueries and CTEs within a single model where possible. In most cases, these can be separated out into earlier models.
* By default, attempt to create model dependencies from `base` to `prod` directly and only introduce new `intermediate` models if the need arises. We don't want to automatically assume an `intermediate` model is needed.

## Comments
* Use comments to explain complicated or confusing SQL or Jinja logic
* Use comments if you are omitting `ELSE` for some reason
* Use comments if you are needing to use `DISTINCT` for some reason