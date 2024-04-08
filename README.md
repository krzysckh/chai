chai
----

a static html gallery generator written in
[owl lisp](https://haltp.org/posts/owl.html)

*work in progress, i may or may not introduce breaking changes*

why
---

as a fast alternative to my cringe perl cgi script that used to power my
website.

dependencies
------------

  - [owl lisp](https://haltp.org/posts/owl.html)
  - [robusta](https://github.com/krzysckh/robusta) (will clone as submodule)
  - [ImageMagick](https://imagemagick.org/)

how
---

```sh
$ git clone --recursive https://github.com/krzysckh/chai
$ cd chai
$ make
# make install
```

then, create your galleries like this:

```
- my-gallery/
  - config.scm
  - photos-from-somewhere/
    - index.scm
    - ....jpg
    - ....png
    - ...
  - photos-from-somewhere-else/
    - index.scm
    - ...
```

config.scm, and every index.scm will be `(eval)`'d at runtime, and they must
return these association lists:

```scheme
; config.scm:
'((css . use-default)                 ; this setting is not implemented yet
  (gallery-template . use-default)    ; explained below
  (index-template . use-default)      ; explained below
  (page-name . "example gallery")     ; the <title> and the <h1> title
  (output-directory . "public_html")) ; output directory under my-gallery
```

```scheme
; index.scm
'((gallery-name . "gallery name here")      ; name of the gallery (the title)
  (date . (07 9 2023))                      ; day month year
  (description . "description")             ; self-explanatory
  (private . #t)                            ; if #t, add .htpasswd to dir.
  (htpasswd . "/etc/httpd/conf/.htpasswd")) ; this can be skipped when
                                            ; private = #f
```

`'use-default` can be used if you don't want to write your own
`{gallery,index}-template`. Though if you want to, a template is a function
that takes the body of a given page, so for example, an `index-template` could
be implemented like this:

```scheme
; config.scm
`((css . use-default)
  (gallery-template . use-default)
  (page-name . "example gallery")
  (output-directory . "public_html")
  (index-template . ,(lambda (idx)
                       `(html
                          (body
                            (p "this will be an index to the gallery")
                            ,idx
                            ((a (href . "https://example.com"))
                             "a link to example.com"))))))
```

Note that index-template is not just plain html, it's html written in
s-expressions *(cool!!)*. This is what `(robusta encoding html)` does.
To get to know more, look at `chai/defaults.scm`, which defines default pages
as `(robusta encoding html)` expressions.

caveats
-------

- chai doesn't try to sort the galleries in the index by date. sorry (for now),
- user-defined css doesn't work yet,
- the man page sucks

------
```
krzysckh 2023, 2024
krzysckh.org
```
