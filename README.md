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


$ sudo docker run -itd --gpus all --rm --name="ubuntu" ubuntu-gpu:latest
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

```
