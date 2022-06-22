FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

# Setup Environment Variables
ENV DEBIAN_FRONTEND="noninteractive" \
    TZ="Asia/Vietnam"

ENV ANNOTATION_DATA_DIR="/acmmmcheapfakes/" \
    IMAGE_DATA_DIR="/acmmmcheapfakes/images/" \
#     COSMOS_IOU="0.25" \
#     COSMOS_RECT_OPTIM="1"

WORKDIR acmmmcheapfakes/

# Copy Dependencies
COPY . ./

# Install Python
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3.7 python3-dev python3-pip python3-opencv \
    build-essential git && \
    rm -rf /var/lib/apt/lists/*

# Prepare Python Dependencies
RUN python3 -m pip install --upgrade pip && \
    pip3 install cython numpy setuptools


# COSMOS
RUN pip3 install -r COSMOS/requirements.txt

# Download spaCy
RUN python3 -m spacy download en && \
    python3 -m spacy download en_core_web_sm

# install Pytorch with CUDA
RUN pip3 install --no-cache-dir torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchtext==0.4.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN python3 -m pip install -e detectron2
RUN pip3 install numpy --upgrade

# OFA
# RUN cd OFA && pip3 install -r requirements.txt

# Start the code
ENTRYPOINT []
CMD [ "python3", "test.py" ]