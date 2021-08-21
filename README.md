# 0. Install Ubuntu 20.04 as Virtual Machine with GPU on KVM. See the URL below.
https://github.com/developer-onizuka/virtualMachine_withGPU

Note that you don't need install any GPU librarys in Host Machine. Even nvidia-driver in Host Machine. 
You only install nvidia-driver and CUDA only into the Guest Linux Machine on KVM.
```
OptiPlex-5050:~$ dpkg -l |grep -i nvidia
OptiPlex-5050:~$ (no result)
```

# 1. Create directory for docker images on Virtual Machine
```
$ sudo mount -t ext4 -o data=ordered /dev/nvme0n1 /mnt   (This is my case. I use NVMe disk for mounting at /mnt.)
$ cd /mnt
$ mkdir docker
```

# 2. Install Docker on Virtual Machine and changing directory to store images because it is too large.
```
$ sudo apt-get update
$ sudo apt-get install docker.io
$ sudo su
root@ubuntu-k8s:~ # cp /lib/systemd/system/docker.service /etc/systemd/system/
root@ubuntu-k8s:~ # vi /etc/systemd/system/docker.service 

# Edit as like below:
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --data-root /mnt/docker
#ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

root@ubuntu-k8s:~ # systemctl daemon-reload
root@ubuntu-k8s:~ # systemctl restart docker
root@ubuntu-k8s:~ # exit
```

# 3. Pull images for test on Virtual Machine
```
$ sudo docker pull hello-world
$ sudo docker images
$ sudo docker run hello-world:latest
```

# 4. Install nvidia-docker on Virtual Machine
```
$ sudo apt-get update
$ sudo apt-get install -y nvidia-docker2
$ sudo systemctl restart docker
```

# 5. Pull ubuntu:20.04 images from docker hub and run it on Virtual Machine
```
$ sudo docker pull ubuntu:20.04
$ sudo docker volume create work
$ sudo docker inspect work
[
    {
        "CreatedAt": "2021-08-21T15:21:43+09:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/mnt/docker/volumes/work/_data",
        "Name": "work",
        "Options": null,
        "Scope": "local"
    }
]
$ sudo docker run -itd -v work:/mnt --rm --name="ubuntu" ubuntu:20.04
```
!!! Don't use --gpus option in this step. With gpus option, it will be failed!!!


# 6. Log into ubuntu:20.04 images and install driver on Container Machine
You might be asked Kyeboard Layout. My case was 6(Asia) --> 79(Tokyo) --> 55(Japanese) --> 1(Japanese). 

Finally, You will see the Error message like below. This is because container didi not run with the option of "--gpus all".
```
$ sudo docker exec -it ubuntu /bin/bash
-----
root@3baa8af15d57:/# apt-get update
root@3baa8af15d57:/# apt install nvidia-driver-470
root@3baa8af15d57:/# nvidia-smi
Failed to initialize NVML: Unknown Error
```

# 7. Commit image after driver install on Virtual Machine
```
$ sudo docker commit $(sudo docker ps -aq) ubuntu-gpu:20.04
$ sudo docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
ubuntu-gpu   20.04     79ea786a945d   20 seconds ago   1.94GB
ubuntu       20.04     1318b700e415   3 weeks ago      72.8MB
```

# 8. Install CUDA on Container Machine
This time you add the option "--gpus all". This time you can see the result of nvidia-smi as below:
```
$ xhost +
$ sudo docker run -itd -v work:/mnt -v /tmp/.X11-unix:/tmp/.X11-unix --device /dev/video0:/dev/video0:mwr -e DISPLAY=$DISPLAY --gpus all --rm --name="ubuntu" ubuntu:20.04
$ sudo docker exec -it ubuntu /bin/bash
-----
root@3baa8af15d57:/# nvidia-smi
Sat Aug 21 07:55:09 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.57.02    Driver Version: 470.57.02    CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro P1000        Off  | 00000000:06:00.0 Off |                  N/A |
| 34%   41C    P8    N/A /  N/A |     11MiB /  4040MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+

root@3baa8af15d57:/# apt-get update
root@3baa8af15d57:/# apt-get -y install wget
root@3baa8af15d57:/# wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
root@3baa8af15d57:/# mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
root@3baa8af15d57:/# wget https://developer.download.nvidia.com/compute/cuda/11.4.0/local_installers/cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb
root@3baa8af15d57:/# dpkg -i cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb
root@3baa8af15d57:/# apt-key add /var/cuda-repo-ubuntu2004-11-4-local/7fa2af80.pub
root@3baa8af15d57:/# apt-get update
root@3baa8af15d57:/# apt-get -y install cuda
```

# 9. Install cuDNN on Container Machine
Download libcudnn8 and libcudnn8-dev from https://developer.nvidia.com/rdp/cudnn-download before this step and put them in /mnt/docker/volume/work/\_data directory which is already created in #2. So that container of ubuntu can use it thru mountpoint.
```
$ sudo docker exec -it ubuntu /bin/bash
-----
root@3baa8af15d57:/# echo "deb http://dk.archive.ubuntu.com/ubuntu/ bionic main universe" >> /etc/apt/sources.list
root@3baa8af15d57:/# apt-get update
root@3baa8af15d57:/# apt-get -y install gcc-6 g++-6
root@3baa8af15d57:/# dpkg -i /mnt/libcudnn8_8.2.2.26-1+cuda11.4_amd64.deb 
root@3baa8af15d57:/# dpkg -i /mnt/libcudnn8-dev_8.2.2.26-1+cuda11.4_amd64.deb 
```

# 10. Install dlib with CUDA on Container Machine
```
$ sudo docker exec -it ubuntu /bin/bash
-----
root@3baa8af15d57:/# apt-get install -y python3-distutils python3-setuptools python3-pip
root@3baa8af15d57:/# apt-get install -y cmake libopenblas-dev liblapack-dev libjpeg-dev
root@3baa8af15d57:/# apt-get install -y git
root@3baa8af15d57:/# git clone https://github.com/davisking/dlib.git
root@3baa8af15d57:/# cd dlib/
root@3baa8af15d57:/# mkdir build
root@3baa8af15d57:/# cd build
root@3baa8af15d57:/# cmake .. -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1 -DCUDA_HOST_COMPILER=/usr/bin/gcc-6
root@3baa8af15d57:/# cmake --build .
root@3baa8af15d57:/# cd ..
root@3baa8af15d57:/# sudo python3 setup.py install --set DLIB_USE_CUDA=1 --set USE_AVX_INSTRUCTIONS=1 --set CUDA_HOST_COMPILER=/usr/bin/gcc-6
```

# 11. Check if dlib was compiled with CUDA on Container Machine
```
$ sudo docker exec -it ubuntu /bin/bash
-----
root@3baa8af15d57:/# pip3 list |grep dlib
root@3baa8af15d57:/# python3
Python 3.8.10 (default, Jun  2 2021, 10:49:15) 
[GCC 9.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import dlib
>>> dlib.DLIB_USE_CUDA
True
```

# 12. Install OpenCV and face_recognition on Container Machine
```
$ sudo docker exec -it ubuntu /bin/bash
-----
root@3baa8af15d57:/# apt-get install -y python3-opencv
root@3baa8af15d57:/# pip3 install face_recognition
```

# 13. Commit image after installing everything on Virtual Machine
```
$ sudo docker commit $(sudo docker ps -aq) ubuntu-gpu-dlib:20.04
$ sudo docker images
REPOSITORY        TAG       IMAGE ID       CREATED              SIZE
ubuntu-gpu-dlib   20.04     9a815ec87dd8   About a minute ago   14.8GB
ubuntu-gpu        20.04     79ea786a945d   2 hours ago          1.94GB
ubuntu            20.04     1318b700e415   3 weeks ago          72.8MB
```

# 14. Run test script on Virtual Machine
```
$ git clone https://github.com/developer-onizuka/nvidia-docker_VirtualMachine.git
$ cd nvidia-docker_VirtualMachine
$ sudo cp test.py /mnt/docker/volumes/work/_data
$ xhost +
$ sudo docker run -itd --gpus all --name="camera" --rm -v work:/mnt -v /tmp/.X11-unix:/tmp/.X11-unix --device /dev/video0:/dev/video0:mwr -e DISPLAY=$DISPLAY ubuntu-gpu-dlib:20.04 /mnt/test.py
```
