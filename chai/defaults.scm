(define-library
  (chai defaults)

  (import
    (scheme base)
    (owl core)
    (owl lazy)
    (owl sys)
    (owl io)

    (chai util)
    (chai config))

  (export
    chai-css
    private-htaccess
    public-htaccess
    default-gallery-template
    default-index-template)

  (begin
    (define version "none")

    (define (default-index-template index) ; TODO: config title etc.
      `(html
         (head
           ((link (rel . "stylesheet") (href . "/res/chai.css")))
           ((meta (charset . "utf-8")))
           ((meta (name . "viewport")
                  (content . "width=device-width, initial-scale=1.0")))
           (title ,(aq 'page-name (read-config "config.scm"))))
         (body
           ((div (id . "main"))
             ,index
             (footer
               "powered by" ((a (href . "https://github.com/krzysckh/chai"))
                             "chai"))))))

    (define (default-gallery-template gallery)
      `(html
         (head
           ((link (rel . "stylesheet") (href . "/res/chai.css")))
           ((meta (charset . "utf-8")))
           (title "halo"))
         (body
           ((div (id . "main"))
             ,gallery ; yeah good luck with that
             (footer
               "powered by" ((a (href . "https://github.com/krzysckh/chai"))
                             "chai"))))))

    (define (private-htaccess htaccess)
      (string-append "
AuthType Basic
AuthName \"Restricted Access\"
AuthUserFile " htaccess "
Require valid-user"))

    (define (public-htaccess) ; htaccess for public stuff
      "
Options All -Indexes
Require all granted
")

    ; TODO: accept user-defined css
    (define chai-css
      "
@font-face {
  font-family: 'Luculent';
  src: url('https://pub.krzysckh.org/_fonts/luculent/luculentb.ttf') format('truetype');
  font-weight: bold;
  font-style: normal;
}

@font-face {
  font-family: 'Luculent';
  src: url('https://pub.krzysckh.org/_fonts/luculent/luculentbi.ttf') format('truetype');
  font-weight: bold;
  font-style: italic;
}

@font-face {
  font-family: 'Luculent';
  src: url('https://pub.krzysckh.org/_fonts/luculent/luculenti.ttf') format('truetype');
  font-weight: normal;
  font-style: italic;
}

@font-face {
  font-family: 'Luculent';
  src: url('https://pub.krzysckh.org/_fonts/luculent/luculent.ttf') format('truetype');
  font-weight: normal;
  font-style: normal;
}

* {
  font-family: Luculent, monospace;
  background-color: #dedede;
  color: #222222;
}

a {
  color: #229977;
}

html, body {
  width: 100%;
  height: 100%;
  padding: 0;
  margin: 0;
}

#main {
  margin-left: 15%;
  margin-right: 15%;
  padding-top: 5%;
}

@media only screen and (max-device-width: 768px) {
  #main {
    margin-left: 2%;
    margin-right: 2%;
    padding-top: 10px;
  }
}

p {
  display: block;
}

img {
  width: 100%;
  display: block;
  margin: auto;
}

#idx-gal-list, #gal-images {
  width: 100%;

  display: grid;
  grid-auto-flow: row dense;
  grid-auto-columns: 1fr;
  gap: 0px 0px;
  justify-content: start;
  justify-items: stretch;
  align-items: start;
}

#idx-gal-list {
  grid-template-columns: 1fr 1fr 1fr 1fr;
}

#gal-images {
  grid-template-columns: 1fr 1fr 1fr 1fr 1fr 1fr;
}

.idx-gal, .gal-image {
  padding-right: 10px;
  padding-bottom: 10px;
}
      ")))

