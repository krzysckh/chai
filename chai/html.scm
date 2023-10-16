; it writes ugly, but maybe even sometimes semantic html

(define-library
  (chai html)

  (import
    (owl core)
    (owl syscall)
    (owl list)
    (owl list-extra)
    (owl io)
    (owl string)
    (scheme base)

    (chai util))

  (export
    html)

  (begin
    (define version "none")

    ; https://github.com/jquery/jquery-migrate/issues/444
    (define self-closing-tags
      '(area base br col embed hr img input link meta param source track wbr))

    (define (string->safe-html-string s)
      s) ; TODO: implement this

    (define (string->quote-quotes-string s)
      (str-replace s "\"" "\\\""))

    (define (print-opts l)
      (->string
        (map (λ (x) (string-append
                       (->string (car x))
                       "=\""
                       (string->quote-quotes-string (cdr x))
                       "\"")) l)))

    (define (print-tag T v)
      (if (and (list? v) (eq? 'start T))
        (string-append
          (if (eq? 'end T) "</" "<")
          (->string (car v))
          " "
          (print-opts (cdr v))
          ">\n")
        (string-append
          (if (eq? 'end T) "</" "<")
          (->string (car* v))
          ">\n")))

    (define (html l)
      (->string
        (list
          (print-tag 'start (car l))

          (if (cdr l)
            (map
              (λ (x)
                (cond
                  ((string? x) (string->safe-html-string x))
                  ((list? x) (html x))
                  (else
                    (error "fatal while parsing: unknown data type"))))
              (cdr l))
            "")

          (if (not (has? self-closing-tags (car* (car l))))
            (print-tag 'end (car l))
            "")
          )))))

