#!/usr/bin/env bash

APP_COMMAND="shiny::runApp(radiantNetDashboard::radiantNetDashboard())"
R_COMMAND="Rscript --vanilla -e"

if command -v guix &> /dev/null
then
    channel_path=".guix/channels.scm"
    package_path=".guix/guix.scm"
    guix time-machine -C $channel_path -- \
        shell -f $package_path r r-shiny -- $R_COMMAND "$APP_COMMAND"
else
    $R_COMMAND "$APP_COMMAND"
fi
            