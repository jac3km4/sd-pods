ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=11.8.0
FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
ARG PEFT_VERSION=0.2.0

RUN apt-get update && apt-get -y install git python3 python3-pip

RUN \
  git clone https://github.com/huggingface/peft --branch "v${PEFT_VERSION}" && \
  cd peft/examples/lora_dreambooth && \
  pip install -r requirements.txt && \
  pip install "peft==${PEFT_VERSION}" bitsandbytes

WORKDIR /peft/examples/lora_dreambooth
COPY accelerate.yaml .

ENV HF_HOME "/data/cache"

ENTRYPOINT ["accelerate", "launch", "--config_file", "accelerate.yaml", "train_dreambooth.py"]
