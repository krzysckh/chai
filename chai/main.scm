(define-library
  (chai main)

  (import
    (owl core)
    (owl list)
    (owl list-extra)
    (owl io)
    (owl regex)
    (owl sys)
    (owl syscall)
    (owl digest)
    (scheme base)
    (scheme cxr)

    (only (owl intern) start-symbol-interner)

    (chai config)
    (chai util)
    (chai defaults)
    (chai html))

  (export
    main)

  (begin
    (define version "none")

    (define image-extensions
      '(png jpg webp gif ppm jfif svg bmp tif tiff))

    (define (get-images d)
      (filter
        (λ (s) (has? image-extensions (string->symbol (file->extension s))))
        (dir->list d)))

    (define (is-chai-directory? d)
      (and
        (has? (dir->list d) "config.scm")))

    (define (gallery-dirs od)
      (define candidates (filter
                           (λ (s) (not (or (string=? s "config.scm")
                                           (string=? s od)
                                           (string=? s "res"))))
                           (dir->list ".")))
      (filter (λ (s) (has? (dir->list s) "index.scm")) candidates))

    (define (create-gallery cfg d)
      (let* ((css (aq 'css cfg))
             (index-template (aq 'index-template cfg))
             (gallery-template (if (eq? (aq 'gallery-template cfg) 'use-default)
                                 default-gallery-template
                                 (aq 'gallery-template cfg)))
             (page-name (aq 'page-name cfg))
             (output-directory (aq 'output-directory cfg))
             (n (sha1 d))
             (dir (string-append output-directory "/" n))
             (_ (create-directory dir))
             (f (open-output-file (string-append dir "/index.html")))
             (gal-cfg (read-config (string-append d "/index.scm")))
             (date (aq 'date gal-cfg))
             (date-str (string-append
                         (->string (car date)) " "
                         (number->month (cadr date)) " "
                         (->string (cddr date)))))

        (when (eq? #t (naq 'privatstarte gal-cfg))
          (print-to
            (open-output-file (string-append dir "/.htaccess"))
            (private-htaccess (aq 'htpasswd gal-cfg))))

        (define site
          (gallery-template
            (list
              'div ; TODO: fix SOMETHING so this isn't needed (or figure it out)
              `(h1 ,(aq 'gallery-name gal-cfg))
              `(p ,(aq 'description gal-cfg))
              `(p ,date-str)
              (append
                '((div (id . "gal-images")))
                (map
                  (λ (x)
                     `((div (class . "gal-image"))
                       ((a (href . ,(string-append "res/" x)))
                        ((img (src . ,(string-append "res/" x "-min.jpg")))))))
                  (get-images d))))))

        (print-to f (html site))

        (create-directory (string-append dir "/res"))
        (for-each
          (λ (s)
             (define S (string-append d "/" s))
             (copy-file S (string-append dir "/res/" s))
             (system-say `("convert" ,S "-quality" "50" "-resize" "300x300"
                           ,(string-append dir "/res/" s "-min.jpg"))))
          (get-images d))))

    (define (create-index cfg)
      (let ((css (aq 'css cfg))
            (index-template (if (eq? (aq 'index-template cfg) 'use-default)
                                default-index-template
                                (aq 'index-template cfg)))
            (output-directory (aq 'output-directory cfg)))

        (define dirs
          (filter
            (λ (s)
              (and
                (directory? s)
                (not (string=? output-directory s))))
            (dir->list ".")))

        (print-to
          (open-output-file (string-append output-directory "/.htaccess"))
          (public-htaccess))

        (print-to
          (open-output-file (string-append output-directory "/index.html"))
          (html
            (index-template
              (append
                '((div  (id . "idx-gal-list")))
                (map
                  (λ (v)
                     (let*
                       ((D (string-append (sha1 v) "/res/"))
                        (cfg (read-config (string-append v "/index.scm"))))
                       `((div (class . "idx-gal"))
                         ,(aq 'gallery-name cfg)
                         ((a (href . ,(sha1 v)))
                          ,(if (aq 'private cfg)
                             '(p "[private]")
                             `((img
                                 (src
                                   . ,(string-append
                                        D (car
                                            (get-images
                                              (string-append output-directory
                                                             "/" D))))))))))))
                  dirs)))))))

    ; https://gitlab.com/owl-lisp/owl/-/issues/39
    ; (define (interned-symbols)
    ;   (let loop ((x (ref (interact 'intern null) 2))
    ;              (found null))
    ;     (if x
    ;       (loop
    ;         (ref x 1)
    ;         (cons (ref x 2)
    ;               (loop (ref x 3) found)))
    ;       found)))
    ; (define symbols (interned-symbols))

    (define (main args)
      (define chai-dir (if (eqv? (cdr args) '()) "." (cadr args)))
      ; (start-symbol-interner symbols)

      (when (not (directory? chai-dir))
        (err "not a directory: " chai-dir))

      (chdir chai-dir)
      (when (not (is-chai-directory? "."))
        (err "directory does not contain config.scm" ""))

      (let* ((cfg (read-config "config.scm"))
             (css (aq 'css cfg))
             (index-template (aq 'index-template cfg))
             (gallery-template (aq 'gallery-template cfg))
             (page-name (aq 'page-name cfg))
             (output-directory (aq 'output-directory cfg)))

        (if (directory? output-directory)
          (rmdir-recursive output-directory))
        (create-directory output-directory)

        (for-each
          (λ (v) (create-gallery cfg v))
          (gallery-dirs output-directory))

        (create-index cfg)
        (create-directory (string-append output-directory "/res"))
        (print-to
          (open-output-file (string-append output-directory "/res/chai.css"))
          chai-css)
        (print "ok")
        0))))
