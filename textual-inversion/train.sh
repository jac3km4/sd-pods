#!/bin/bash

args=()

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -i|--input_dir) input_dir="$2"; shift ;;
        -o|--output_dir) output_dir="$2"; shift ;;
        -m|--model) model="$2"; shift ;;
        -lp|--learnable_property) args+=("--learnable_property=$2"); shift ;;
        -pt|--placeholder_token) args+=("--placeholder_token=$2"); shift ;;
        -it|--initializer_token) args+=("--initializer_token=$2"); shift ;;
        -r|--resolution) args+=("--resolution=$2"); shift ;;
        -bs|--train_batch_size) args+=("--train_batch_size=$2"); shift ;;
        -ms|--max_train_steps) args+=("--max_train_steps=$2"); shift ;;
        -s|--lr_scheduler) args+=("--lr_scheduler=$2"); shift ;;
        -ws|--lr_warmup_steps) args+=("--lr_warmup_steps=$2"); shift ;;
        -nc|--lr_num_cycles) args+=("--lr_num_cycles=$2"); shift ;;
        -lr|--learning_rate) args+=("--learning_rate=$2"); shift ;;
        -mc|--mixed_precision) args+=("--mixed_precision=$2"); shift ;;
        -sl|--scale_lr) args+=("--scale_lr") ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "${input_dir}" ]; then
    echo "--input-dir parameter is required"
    exit 1
fi

if [ ! -d "${output_dir:=./output}" ]; then
  echo "creating output directory ${output_dir}"
  mkdir -p $output_dir
fi

COMMAND=$(hash podman 2>/dev/null && echo "podman" || echo "docker")

$COMMAND run -it \
  --mount type=bind,src=${input_dir},dst=/data/input,readonly \
  --mount type=bind,src=${output_dir:-./output},dst=/data/output \
  --mount type=volume,src=hf-cache,dst="/data/cache" \
  ghcr.io/jac3km4/sd-pods:ti-0.1.0 \
  --train_data_dir=/data/input \
  --output_dir=/data/output \
  --pretrained_model_name_or_path=${model:-runwayml/stable-diffusion-v1-5} \
  ${args[@]}
