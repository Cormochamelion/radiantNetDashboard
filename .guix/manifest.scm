(define %packages (map specification->package
                       (list "r-data-table"
                             "r-dt"
                             "r-dbi"
                             "r-dbplyr"
                             "r-dplyr"
                             "r-import"
                             "r-lubridate"
                             "r-magrittr"
                             "r-shiny"
                             "r-rsqlite"
                             "r-withr")))

(define %dev-packages (map specification->package
                           (list "r"
                                 "r-devtools"
                                 "r-usethis")))

(packages->manifest (append %dev-packages %packages))
