(use-modules (gnu packages)
             (guix gexp)
             (guix build-system r)
             (guix git)
             (guix packages)
             (guix licenses))

(include "manifest.scm")

(package
  (name "r-radiantnetdashboard")
  (version "0.0.0")
  (source (local-file
          (dirname (dirname (current-filename)))
          #:recursive? #t
          #:select? (lambda
                      (file stat)
                      ; Exclude hidden dirs & files.
                      (not (string=?
                            (string-copy (basename file) 0 1)
                            ".")))))
  (properties `((upstream-name . "radiantNetDashboard")))
  (build-system r-build-system)
  (native-inputs %dev-packages)
  (propagated-inputs %packages)
  (home-page "https://github.com/Cormochamelion/radiantNetDashboard.git")
  (synopsis "RadiantNet Dashboard")
  (description "Shiny dashboard for displaying @code{RadiantNet} data.")
  (license expat))
