#lang scribble/manual
@require[@for-label[irma
                    racket/base]]

@title{Irma}
@author{Vincent BERZIN}

@defmodule[irma]

Package Description Here


@section{Intro}

Irma is a tool to predict values in time series based on a linear regression algorithm.

@section{Usage}

@verbatim{
commands:
  help    : displays this message
  init    : initialize a database
  add     : adds data. Example: add mybatch 1659011843 17
  delete  : deletes all data related to a label. Example: delete mybatch
  predict : predicts x with y. Example: predict 1659011843
  alerts  : displays problematic labels depending on what has been configured.
}

Full example:

@verbatim{
$ irma init
$ irma add mybatch 1659011843 17
$ irma add mybatch 1659020843 25
$ irma predict mybatch 1659055555
$ irma delete mybatch
$ irma alerts
}

@section{Configuration}

Configuration is in config.rkt and has currently three parameters:

@verbatim{
('db . "./tspredict.db") ; the filename of the database
('evolution . 100) ; the evolution's percentage for a label
('timeframe . 86400) ; the timeframe in seconds to compare the evolution
}

