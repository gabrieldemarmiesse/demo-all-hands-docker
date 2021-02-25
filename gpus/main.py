from python_on_whales import docker

print(docker.run("nvidia/cuda:11.0-base", ["nvidia-smi"], gpus="all"))

print(docker.run("oguzpastirmaci/gpu-burn:latest", ["5"], gpus="devices=0"))
