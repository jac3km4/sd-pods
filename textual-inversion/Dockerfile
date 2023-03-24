ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=11.8.0
FROM nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_VERSION}

RUN apt-get update && apt-get -y install git python3 python3-pip

RUN \
  git clone https://github.com/huggingface/diffusers && \
  cd diffusers && \
  pip install . && \
  cd ./examples/textual_inversion && \
  pip install -r requirements.txt

WORKDIR /diffusers/examples/textual_inversion
COPY accelerate.yaml .

ENV HF_HOME "/data/cache"

ENTRYPOINT ["accelerate", "launch", "--config_file", "accelerate.yaml", "textual_inversion.py"]
