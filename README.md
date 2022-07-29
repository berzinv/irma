# Irma

## Intro

Irma is a tool to predict values in time series based on a linear regression algorithm.

## Usage

```
commands:
  help    : displays this message
  init    : initialize a database
  add     : adds data. Example: add mybatch 1659011843 17
  delete  : deletes all data related to a label. Example: delete mybatch
  predict : predicts x with y. Example: predict 1659011843
  alerts  : displays problematic labels depending on what has been configured.
```

Full example:

```
$ irma init
$ irma add mybatch 1659011843 17
$ irma add mybatch 1659020843 25
$ irma predict mybatch 1659055555
$ irma delete mybatch
$ irma alerts
```

## Configuration

Configuration is in config.rkt and has currently two parameters:

- db : the filename of the database
- evolution: the evolution's percentage for a label


