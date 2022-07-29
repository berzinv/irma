#lang racket

(require db
         srfi/48
         "linear-regression.rkt")

(define args (current-command-line-arguments))
(define db-filename "")
(define evolution-percentage 0)
(define timeframe 0)

(define (load-config filename)
  (define config (file->list filename))
  (for ((conf config))
    (case (car conf)
      (('db) (set! db-filename (cdr conf)))
      (('evolution) (set! evolution-percentage (cdr conf)))
      (('timeframe) (set! timeframe (cdr conf))))))

(define (init)
  (delete-file db-filename)
  (define c (sqlite3-connect #:database db-filename #:mode 'create))
  (query-exec c "create table datasets (label text, x real, y real);")
  (disconnect c))

(define (evolution x1 x2)
  (* 100 (/ (- x2 x1) x1)))

(define (alerts)
  (define c (sqlite3-connect #:database db-filename #:mode 'create))
  (define labels (query-list c "select distinct label from datasets"))
  (disconnect c)
  (define results (map (lambda (label)
                         (define now (current-seconds))
                         (define now+24h (+ now timeframe))
                         (define y1 (predict-data label now))
                         (define y2 (predict-data label now+24h))
                         (cons label (evolution y1 y2)))
                       labels))
  (filter (lambda (item)
            (>= (cdr item) evolution-percentage))
       results))


(define (display-alerts als)
  (for ((alert als))
    (displayln (format "~a ~0,2F" (car alert) (cdr alert)))))

(define (add-data label x y)
  (define c (sqlite3-connect #:database db-filename #:mode 'read/write))
  (query-exec c
              "insert into datasets (label, x, y) values ($1, $2, $3)"
              label
              x
              y)
  (disconnect c))

(define (predict-data label x)
  (define c (sqlite3-connect #:database db-filename #:mode 'read-only))
  (define data (map (lambda (item)
                    (cons (vector-ref item 1) (vector-ref item 2))) (query-rows c "select * from datasets where label=$1" label)))
  (disconnect c)
  (define lr (linear-regression data))
  (lr x))

(define (delete-data label)
  (define c (sqlite3-connect #:database db-filename #:mode 'create))
  (query-exec c "delete from datasets where label = $1" label)
  (disconnect c))
  

;; program begins here
(load-config "irma.conf")

;; parse command line arguments
(cond
  ((= 1 (vector-length args))
   (case (vector-ref args 0)
     (("init") (init))
     (("alerts") (display-alerts (alerts)))
     (("help") (displayln #<<help-delimiter
commands:
  help    : displays this message
  init    : initialize a database
  add     : adds data. Example: add mybatch 1659011843 17
  delete  : deletes all data related to a label. Example: delete mybatch
  predict : predicts x with y. Example: predict 1659011843
  alerts  : displays problematic labels depending on what has been configured.
help-delimiter
                          ))
     (else
      (error "Wrong parameters"))))
  ((= 2 (vector-length args))
   (case (vector-ref args 0)
     (("delete") (delete-data (vector-ref args 1)))
     (else
      (error "Wrong parameters"))))
  ((= 3 (vector-length args))
   (case (vector-ref args 0)
     (("predict") (begin
                    (display "Predicton: ")
                    (displayln (predict-data (vector-ref args 1) (string->number (vector-ref args 2))))))
     (else
      (error "Wrong parameters"))))
  ((= 4 (vector-length args))
   (case (vector-ref args 0)
     (("add") (add-data (vector-ref args 1)
                        (string->number (vector-ref args 2))
                        (string->number (vector-ref args 3))))
     (else
      (error "Wrong parameters")))))
