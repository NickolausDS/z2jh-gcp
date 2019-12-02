FROM jupyter/base-notebook:814ef10d64fb
# Built from... https://hub.docker.com/r/jupyter/base-notebook/
#               https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile
# Built from... Ubuntu 18.04

# The jupyter/docker-stacks images contains jupyterhub, jupyterlab and the
# jupyterlab-hub extension already.

# Example install of git and nbgitpuller.
# NOTE: git is already available in the jupyter/minimal-notebook image.
USER root
RUN apt-get update && apt-get install --yes --no-install-recommends \
    git \
    vim \
    build-essential \
    wget \
    gfortran \
    bison \
    libibverbs-dev \
    libibmad-dev \
    libibumad-dev \
    librdmacm-dev \
    graphviz \
    gcc \
    make
RUN rm -rf /var/lib/apt/lists/*

ADD requirements.txt /tmp/requirements.txt
ADD tutorial_files.py /srv/tutorial_files.py
ADD gcp_config_additions.py /srv/gcp_config_additions.py
ADD setup-gcp.py /srv/setup-gcp.py
ADD start-gcp.sh /srv/start-gcp.sh
RUN chmod +x /srv/start-gcp.sh

# Run these as user
USER $NB_USER

# Install python packages
RUN pip install nbgitpuller && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix
RUN pip install -r /tmp/requirements.txt

# Install GCP
RUN wget https://downloads.globus.org/globus-connect-personal/linux/stable/globusconnectpersonal-latest.tgz -O /tmp/globusconnectpersonal-latest.tgz
RUN tar -xzvf /tmp/globusconnectpersonal-latest.tgz -C /opt
RUN mv $(find /opt -type 'd' -name 'globus*' -maxdepth 1) /opt/gcp
RUN cat /srv/gcp_config_additions.py >> /etc/jupyter/jupyter_notebook_config.py

# Uncomment the line below to make nbgitpuller default to start up in JupyterLab
#ENV NBGITPULLER_APP=lab
