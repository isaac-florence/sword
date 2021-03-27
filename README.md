
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sword

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/sword)](https://CRAN.R-project.org/package=sword)
<!-- badges: end -->

Inspired by Apache Airflow and prompted by Eli Lily’s {targets},
**sword** is a flexible package which interprets special,
{roxygen2}-style comments to create interactive DAGs of pipelines or
processes in R.

Designed to provide a non-disruptive, drop-in DAG building capacity that
is simplistic and easy to implement. You can also use drop-in functions
to monitor pipeline progression in an external, auxiliary dataset for
real-time monitoring.

The reason for **sword**’s conception was to provide real-time
logging and monitoring of frequently run pipelines or processes which
use similar but new/updated data or contexts, attempting to emulate the
UI used in Apache Airflow. Naturally **sword** does not have the same
functionality for pipeline/process execution, it is purely for
visualisation and monitoring/logging.

What about {targets}? {targets} is a very clever package which at the
outset may appear similar to sword but in reality the two are
dissimilar in functionality and purpose. **sword** is much more
simplistic and doesn’t attempt to be as clever as {targets}, but in
return shouldn’t require any changes to code or style, and isn’t as
restrictive. I recommend having a look at {targets} to see if its more
extensive and structured functionality is a better fit for your project.

## Installation

**sword** is not yet on CRAN. You can install the development version
using {remotes}

``` r
remotes::install_git("isaac-florence/sword")
```

## Development

**sword** is in its primordial phase of development and does not have
the full suite of intended first release functionality. Please check
back for announcements on the state of monitoring/logging capabilities
as these develop.

| Planned first release functionality                | Status          |
|----------------------------------------------------|-----------------|
| Create DAGs using roxygen2-style script comments   | in testing      |
| Drop-in functions for logging pipeline progression | to be developed |
| Visualise pipeline progression logs in shiny app   | to be developed |
