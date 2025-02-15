FROM rocker/r2u:noble AS base

RUN apt-get update && \
    apt-get install r-cran-devtools r-cran-shiny -y

ENV SHINY_PORT=6542

WORKDIR /app

FROM base AS test

# FIXME Find someone more trustworthy to get chromium from.
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:xtradeb/apps -y
RUN apt-get update
RUN apt-get install ungoogled-chromium -y

ENV CHROMOTE_CHROME=ungoogled-chromium

COPY . ./

RUN Rscript -e "devtools::install(dependencies = 'soft')"

ENTRYPOINT ["R", "--vanilla", "-q", "-e", "devtools::check()"]

FROM base AS prod

COPY . ./

RUN Rscript -e "devtools::install()"

EXPOSE ${SHINY_PORT}

ENTRYPOINT ["dev/run_app.sh"]
