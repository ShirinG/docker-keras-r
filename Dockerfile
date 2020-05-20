## Keras for R with RStudio
## Automatic build from
## https://github.com/ShirinG/docker-keras-r
## to
## https://hub.docker.com/repository/docker/shiringlander/docker-keras-r

#FROM shiringlander/docker-rstudio
FROM rocker/tidyverse:latest

RUN apt-get update && apt-get install -y curl

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv
    
# Some TF tools expect a "python" binary
RUN ln -s $(which python3) /usr/local/bin/python

RUN python -m pip --no-cache-dir install --upgrade \
    pip \
    setuptools \
    virtualenv

RUN R -e "install.packages('reticulate')"
RUN R -e "reticulate::install_miniconda(path = '/home/rstudio/.local/share/r-miniconda', update = TRUE, force = FALSE)"

RUN R -e "devtools::install_github('rstudio/keras')"
RUN R -e "keras::install_keras(method = 'virtualenv', version = '2.3.1', tensorflow = '2.2.0', extra_packages = c('tensorflow-hub'))"

EXPOSE 8787

CMD ["/init"]