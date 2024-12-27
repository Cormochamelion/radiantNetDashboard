FROM rocker/r2u

RUN apt-get update && \
    apt-get install r-cran-devtools r-cran-shiny -y

ENV SHINY_PORT=6542

WORKDIR /app

COPY . ./

RUN Rscript -e "devtools::install()"

EXPOSE ${SHINY_PORT}

ENTRYPOINT dev/run_app.sh
