(use-modules (guix profiles))

(define %packages (map specification->package
                       (list "r-config"
                             "r-data-table"
                             "r-dt"
                             "r-dbi"
                             "r-dbplyr"
                             "r-dplyr"
                             "r-ggplot2"
                             "r-import"
                             "r-lubridate"
                             "r-magrittr"
                             "r-pool"
                             "r-purrr"
                             "r-rappdirs"
                             "r-rlang"
                             "r-tidyr"
                             "r-shiny"
                             "r-rsqlite")))

(define %dev-packages (map specification->package
                           (list "r"
                                 "r-devtools"
                                 "r-styler"
                                 "r-usethis")))

(packages->manifest (append %dev-packages %packages))
