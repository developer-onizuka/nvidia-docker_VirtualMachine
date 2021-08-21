# nvidia-docker_VirtualMachine

```
$ sudo apt-get update
$ sudo apt-get install docker.io

$ sudo docker pull hello-world
$ sudo docker images
$ sudo docker run hello-world:latest

$ sudo apt-get update
$ sudo apt-get install -y nvidia-docker2
$ sudo systemctl restart docker

$ sudo docker pull ubuntu:20.04
$ sudo docker run -itd --gpu all --name="ubuntu" --rm ubuntu:20.04
$ sudo docker exec -it ubuntu /bin/bash
-----
root@3baa8af15d57:/# apt-get update
root@3baa8af15d57:/# apt install nvidia-driver-470
-----
$ sudo docker ps
$ sudo docker commit <container-id> ubuntu-gpu

$ sudo docker volume create work
$ xhost +
$ sudo docker run -itd -v work:/mnt -v /tmp/.X11-unix:/tmp/.X11-unix --device /dev/video0:/dev/video0:mwr -e DISPLAY=$DISPLAY --gpus all --rm --name="ubuntu" ubuntu-gpu:latest
8fe2ce33725ab21e364aae4905355e3436016e5db4d58468d187bd308e4f5ad8

$ sudo docker exec -it ubuntu /bin/bash
-----
root@8fe2ce33725a:/# nvidia-smi
Sat Aug 21 09:45:19 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.57.02    Driver Version: 470.57.02    CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro P1000        Off  | 00000000:06:00.0 Off |                  N/A |
| 34%   40C    P8    N/A /  N/A |     11MiB /  4040MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+

root@8fe2ce33725a:/# apt-get install python3-opencv

```


```
    1  pwd
    2  hostname
    3  exit
    4  ls /dev/
    5  apt-get install python3-opencv
    6  cd /mnt
    7  python3 openCV1.py 
    8  cd
    9  echo "deb http://dk.archive.ubuntu.com/ubuntu/ bionic main universe" >> /etc/apt/sources.list
   10  apt-get update
   11  apt-get install gcc-6 g++-6
   12  dpkg -i /mnt/libcudnn8_8.2.2.26-1+cuda11.4_amd64.deb 
   13  dpkg -i /mnt/libcudnn8-dev_8.2.2.26-1+cuda11.4_amd64.deb 
   14  cd /mnt
   15  ls
   16  git clone https://github.com/davisking/dlib.git
   17  apt-get install git
   18  git clone https://github.com/davisking/dlib.git
   19  cd dlib/
   20  mkdir build
   21  cmake .. -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1 -DCUDA_HOST_COMPILER=/usr/bin/gcc-6
   22  apt-get install cmake libopenblas-dev liblapack-dev libjpeg-dev
   23  apt-get install python3-pip
   24  cmake .. -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1 -DCUDA_HOST_COMPILER=/usr/bin/gcc-6
   25  cd build/
   26  cmake .. -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1 -DCUDA_HOST_COMPILER=/usr/bin/gcc-6
   27  apt-get install libx11-dev
   28  cmake .. -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1 -DCUDA_HOST_COMPILER=/usr/bin/gcc-6
   29  history

```
