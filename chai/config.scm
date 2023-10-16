(define-library
  (chai config)

  (import
    (scheme base)
    (owl core)
    (owl lazy)
    (owl io)
    (owl sexp)
    (owl eval)

    (chai util))

  (export
    read-config)

  (begin
    (define version "none")

    (define (define-config S) S)

    ; holy hell that took a long time to figure out
    (define (read-config filename)
      (define str (->string (force-ll (lines (open-input-file filename)))))
      (define sexp (string->sexp (substring str 0 (- (string-length str) 1)) #f))

      (exported-eval sexp *toplevel*))))
