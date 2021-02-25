# from ubuntu18 minimal
# no need to reboot the server at any point.

set -e -x

apt-get update
apt-get install -y build-essential

# we have T4s in ec2
wget https://us.download.nvidia.com/tesla/450.80.02/NVIDIA-Linux-x86_64-450.80.02.run
# you might get gcc version mismatch, it's ok.
bash ./NVIDIA-Linux-x86_64-*.run --silent
nvidia-smi

apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
docker run hello-world

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get update && sudo apt-get install -y nvidia-container-toolkit
systemctl restart docker
sleep 5
docker run --gpus all nvidia/cuda:10.0-base nvidia-smi

usermod -aG docker ubuntu
service docker restart
sleep 5
nvidia-smi -pm ENABLED
docker run --gpus all nvidia/cuda:10.0-base nvidia-smi
mkdir /home/ubuntu/.docker

curl -L https://raw.githubusercontent.com/docker/compose-cli/main/scripts/install/install_linux.sh | sh

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda

source /root/miniconda/bin/activate
docker pull oguzpastirmaci/gpu-burn:latest
docker pull nvidia/cuda:11.0-base
docker pull redis:5.0-alpine3.10
docker pull postgres:9.4
