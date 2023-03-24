# sd-pods
Simple and easy-to-use docker images for training stable diffusion models with CUDA. This repo also contains convenience script wrappers that set up mount points and run the containers.

## setup
You will need the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#setting-up-nvidia-container-toolkit) for GPU acceleration.

## lora
```bash
# runs LORA training with NAI as the base checkpoint (optimal for anime models)
# on images in /home/me/doggo_pics
./lora/train.sh \
  -m hiyorichan/nai_diffuser_full \
  -i /home/me/doggo_pics \
  -o ./doggo_lora \
  --instance_prompt "doggo" \
  --resolution 640 \
  --train_batch_size 1 \
  --num_train_epochs 8 \
  --net_dim 8 \
  --alpha 1 \
  --lr_scheduler cosine_with_restarts \
  --lr_num_cycles 4 \
  --learning_rate 1e-4 \
  --mixed_precision bf16 \
  --gradient_checkpointing \
  --use_8bit_adam
```

## textual inversion
```bash
# runs TI training with SDv1.5 as the base checkpoint (optimal for realistic models)
# on images in /home/me/doggo_pics
./textual-inversion/train.sh \
  -m runwayml/stable-diffusion-v1-5 \
  -i /home/me/doggo_pics \
  -o ./doggo_embedding \
  --learnable_property "object" \
  --placeholder_token "<doggo>" \
  --initializer_token "dog" \
  --resolution 640 \
  --train_batch_size 1 \
  --max_train_steps 3000 \
  --lr_scheduler constant \
  --learning_rate 5e-4 \
  --mixed_precision bf16
```
