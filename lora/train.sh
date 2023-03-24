#!/bin/bash

args=()

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -i|--input_dir) input_dir="$2"; shift ;;
        -o|--output_dir) output_dir="$2"; shift ;;
        -m|--model) model="$2"; shift ;;
        -p|--instance_prompt) args+=("--instance_prompt=$2"); shift ;;
        -r|--resolution) args+=("--resolution=$2"); shift ;;
        -bs|--train_batch_size) args+=("--train_batch_size=$2"); shift ;;
        -e|--num_train_epochs) args+=("--num_train_epochs=$2"); shift ;;
        -ms|--max_train_steps) args+=("--max_train_steps=$2"); shift ;;
        -nd|--net_dim) args+=("--lora_r=$2" "--lora_text_encoder_r=$2"); shift ;;
        -a|--alpha) args+=("--lora_alpha=$2" "--lora_text_encoder_alpha=$2"); shift ;;
        -s|--lr_scheduler) args+=("--lr_scheduler=$2"); shift ;;
        -ws|--lr_warmup_steps) args+=("--lr_warmup_steps=$2"); shift ;;
        -nc|--lr_num_cycles) args+=("--lr_num_cycles=$2"); shift ;;
        -lr|--learning_rate) args+=("--learning_rate=$2"); shift ;;
        -mp|--mixed_precision) args+=("--mixed_precision=$2"); shift ;;
        -gc|--gradient_checkpointing) args+=("--gradient_checkpointing") ;;
        -u8|--use_8bit_adam) args+=("--use_8bit_adam") ;;
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
  ghcr.io/jac3km4/sd-pods:lora-0.1.0 \
  --instance_data_dir=/data/input \
  --output_dir=/data/output \
  --pretrained_model_name_or_path=${model:-runwayml/stable-diffusion-v1-5} \
  --use_lora \
  --train_text_encoder \
  ${args[@]}
