# Installation

This beta version of `project` can be installed by running the Stata command:

```
net install project, from(https://github.com/michaelstepner/project_stata/raw/main)
```

# Description

This repository is a fork of Robert Picard's Stata program [project](https://ideas.repec.org/c/boc/bocode/s457685.html), containing various adaptations that Michael Stepner found useful. A description of the changes is posted below.

This is beta software and a work-in-progress.

# Changelog

- You no longer need to use `preserve` after `project, original/uses/creates/relies_on()` It will no longer clear your dataset, ever. Instead it uses Stata 16's new frames feature to efficiently update its database.
- It stores the database of projects in your Stata PERSONAL folder, not next to `project.ado`. That means you might need to run `project, setup` again even if you have already configured a previous version of `project` installed from the SSC.
- It standardizes the timestamp in dta files that you save and link using `project, creates()`. This means that if you overwrite a dataset with an identical dataset (ie nothing changed), it’s more likely that project recognizes the dataset is unchanged. It’s not perfect, for complex reasons relating to stochastic "junk" data added in various dta fields, not just the timestamp.
- It only works in Stata 16. [Because it uses frames and python]
