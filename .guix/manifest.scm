(use-modules (guix profiles))

(define %packages (map specification->package
                       (list "r-bslib"
                             "r-config"
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
                                 "r-lintr"
                                 "r-testthat"
                                 "r-shinytest2"
                                 "r-styler"
                                 "r-usethis"
                                 "ungoogled-chromium")))

;; For interactive development with VSCode.
(define %vscode-packages (map specification->package
                              (list "python-radian"
                                    "r-httpgd"
                                    "r-languageserver")))

(packages->manifest (append %vscode-packages %dev-packages %packages))
