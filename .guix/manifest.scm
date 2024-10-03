(define %packages (map specification->package
                       (list "r-shiny")))

(define %dev-packages (map specification->package
                           (list "r"
                                 "r-devtools"
                                 "r-usethis")))

(packages->manifest (append %dev-packages %packages))
