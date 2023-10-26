(define-library
  (chai util)

  (import
    (owl core)
    (owl list)
    (owl string)
    (owl regex)
    (owl port)
    (owl sys)
    (owl io)
    (scheme write)
    (scheme base))

  (export
    aq
    naq
    err
    bool->string
    create-directory
    file->extension
    number->month
    rmdir-recursive
    ->string
    system-say
    tolower)

  (begin
    (define version "none")

    (define month-names
      '(jan feb mar apr may june july aug sept oct nov dec))

    (define (tolower s)
      (list->string (map (λ (x) (if (< x 97) (+ x 32) x)) (string->list s))))

    (define (naq v l)
      (if (pair? (assq v l))
        (cdr (assq v l))
        #f))

    (define (file->extension s)
      (tolower (last ((string->regex "c/\\./") s) #f)))

    (define (rmdir-recursive p)
      (for-each
        (λ (x)
          (cond
            ((and (directory? x)
                  (eq? (length (dir->list x)) 0))
             (rmdir x))
            ((directory? x) (rmdir-recursive x))
            (else
              (unlink x))))
        (map (λ (s) (string-append p "/" s)) (dir->list p)))
      (rmdir p))

    (define (create-directory p)
      (mkdir p 511)) ; 0o777 = 511

    (define (bool->string v)
      (if v "#t" "#f"))

    (define (->string x)
      (cond
        ((list? x) (foldl
                     string-append
                     ""
                     (map (λ (x) (string-append (->string x) " ")) x)))
        ((number? x) (number->string x))
        ((symbol? x) (symbol->string x))
        ((boolean? x) (bool->string x))
        ((char? x) (string x))
        ((string? x) x)
        (else
	  "")))

    ; (err) doesn't work when compiled
    (define (err s . x)
      (print-to stderr (string-append "error: " s " " (->string x))))

    ; this is mainly for debugging purposes, that's why (->string l) -> "."
    (define (system-say l)
      ;(print (->string l))
      (display ".")
      (system l))

    (define (aq v l)
      (if (pair? (assq v l))
        (cdr (assq v l))
        (err "undefined in config: " v)))

    (define (number->month d)
      (->string (list-ref month-names (- d 1))))))

