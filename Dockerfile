ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG SLICERSALT_DIRECTORY=/usr/src/slicersalt
ARG SLICERSALT_MODULE_VERSION=5.3
ARG SLICERSALT_DOWNLOAD_URL=https://data.kitware.com/api/v1/item/67003a15fb903c47575a911b/download

RUN apt update && apt install --no-install-recommends -y software-properties-common 
RUN apt install --no-install-recommends -y wget libgl1-mesa-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir -p ${SLICERSALT_DIRECTORY} \
    && wget -O ${SLICERSALT_DIRECTORY}.tar.gz ${SLICERSALT_DOWNLOAD_URL}  \
    && tar -zxvf ${SLICERSALT_DIRECTORY}.tar.gz -C ${SLICERSALT_DIRECTORY} --strip-components 1 \
    && rm -rf ${SLICERSALT_DIRECTORY}.tar.gz

ENV LD_LIBRARY_PATH=${SLICERSALT_DIRECTORY}/lib:${SLICERSALT_DIRECTORY}/lib/SlicerSALT-${SLICERSALT_MODULE_VERSION}:${SLICERSALT_DIRECTORY}/lib/Python/lib
ENV PATH=$PATH:${SLICERSALT_DIRECTORY}/lib/SlicerSALT-${SLICERSALT_MODULE_VERSION}/cli-modules
