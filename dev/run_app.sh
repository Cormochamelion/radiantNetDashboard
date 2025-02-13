#!/usr/bin/env bash

PORT="${SHINY_PORT:-6542}"
APP_COMMAND="shiny::runApp(radiantNetDashboard::radiant_net_dashboard(), port = $PORT)"
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
            