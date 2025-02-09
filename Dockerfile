FROM rocker/r2u AS base

RUN apt-get update && \
    apt-get install r-cran-devtools r-cran-shiny -y

ENV SHINY_PORT=6542

WORKDIR /app

COPY . ./

FROM base AS test

RUN Rscript -e "devtools::install(dependencies = 'soft')"

ENTRYPOINT ["R", "--vanilla", "-q", "-e", "devtools::test()"]

FROM base AS prod

RUN Rscript -e "devtools::install()"

EXPOSE ${SHINY_PORT}

ENTRYPOINT ["dev/run_app.sh"]
