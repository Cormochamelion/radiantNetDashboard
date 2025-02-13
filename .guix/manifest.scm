(use-modules (guix profiles))

(define %packages (map specification->package
                       (list "r-config"
                             "r-dbplyr"
                             "r-dplyr"
                             "r-dt"
                             "r-ggplot2"
                             "r-lubridate"
                             "r-magrittr"
                             "r-pool"
                             "r-purrr"
                             "r-rappdirs"
                             "r-rlang"
                             "r-rsqlite"
                             "r-tidyr"
                             "r-shiny")))

(define %dev-packages (map specification->package
                           (list "r"
                                 "r-dbi"
                                 "r-devtools"
                                 "r-import"
                                 "r-httpgd"
                                 "r-languageserver"
                                 "r-testthat"
                                 "r-styler"
                                 "r-usethis")))

(packages->manifest (append %dev-packages %packages))
