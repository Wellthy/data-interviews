# Analytics Engineer Prompt

## Preparing for your Technical Interview
Prior to your technical interview, please review the files in the `base`, `intermediate`, and `prod` subdirectories, as well as the [Analytics Engineer Prompt Style Guide](Style_Guide.md). Make note of any questions you might have about the sample data model - you will have an opportunity to ask them during the interview.

## The Technical Interview
During your technical interview, you will be presented with a pull request to review via a screen sharing session. We want this to be a collaborative session where we will talk through your review of the PR based on your understanding of the data model and style guide. You will be able to refer to any files within the model at any point for reference, and you will not be asked to do any coding yourself, however we might ask you some general questions about how you would approach correcting any logic or style issues you see.

## Assumptions
Since this is an incomplete dbt project, you are unable to run the models yourself to verify their accuracy. As such, please assume the following:
* `dbt run` results in a successful build of all models.
* `dbt test` results in a successful test of all models.
* The PR you review will not necessarily be limited to just these models. It may contain new models that currently don't exist here.
* The PR you review will not contain any complex logic just for the sake of being complex. Anything you encounter will be based on reasonable business scenarios that you might encounter.