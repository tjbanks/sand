FROM continuumio/anaconda3:5.0.0

RUN apt-get update && apt-get install -y automake \
                                         libtool \
                                         build-essential \
                                         libncurses5-dev

ENV BUILD_DIR=/home/build
ENV HOME_DIR=/home/shared
ENV WORK_DIR=${HOME_DIR}/workspace

RUN mkdir -p ${BUILD_DIR}
RUN mkdir -p ${HOME_DIR}
RUN mkdir -p ${WORK_DIR}

#RUN conda install -y numpy h5py lxml pandas matplotlib jsonschema scipy

# Install NEURON
RUN conda install -y -c kaeldai neuron

### Install AllenSDK
RUN pip install --no-cache-dir notebook==5.* allensdk


### Install the bmtk
RUN cd ${BUILD_DIR}; \
    git clone https://github.com/AllenInstitute/biophys_optimize.git; \
    cd biophys_optimize; \
    python setup.py install

ENV NB_USER mizzou
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY . ${HOME}
USER root    
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
