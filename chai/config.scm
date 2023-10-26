(define-library
  (chai config)

  (import
    (scheme base)
    (owl io)
    (owl eval)
    (owl sexp)

    (chai util))

  (export
    read-config)

  (begin
    (define version "none")

    (define (define-config S) S)

    (define (read-config filename)
      (exported-eval (read (open-input-file filename)) *toplevel*))))
