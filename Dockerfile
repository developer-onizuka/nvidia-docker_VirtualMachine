FROM ubuntu:20.04
RUN apt-get update && DEBIAN_FRONTEND='noninteractive' apt-get install -y nvidia-driver-470 && apt-get -y install wget
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
COPY cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb /tmp
#RUN wget https://developer.download.nvidia.com/compute/cuda/11.4.0/local_installers/cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb
RUN dpkg -i /tmp/cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb
RUN apt-key add /var/cuda-repo-ubuntu2004-11-4-local/7fa2af80.pub && apt-get update && apt-get -y install cuda
RUN echo "deb http://dk.archive.ubuntu.com/ubuntu/ bionic main universe" >> /etc/apt/sources.list && apt-get update && apt-get -y install gcc-6 g++-6 && apt-get -y install libx11-dev
COPY libcudnn8_8.2.2.26-1+cuda11.4_amd64.deb /tmp
COPY libcudnn8-dev_8.2.2.26-1+cuda11.4_amd64.deb /tmp
RUN dpkg -i /tmp/libcudnn8_8.2.2.26-1+cuda11.4_amd64.deb && dpkg -i /tmp/libcudnn8-dev_8.2.2.26-1+cuda11.4_amd64.deb
RUN rm -f /tmp/cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb /tmp/libcudnn8_8.2.2.26-1+cuda11.4_amd64.deb /tmp/libcudnn8-dev_8.2.2.26-1+cuda11.4_amd64.deb
RUN apt-get update && apt-get install -y python3-distutils python3-setuptools python3-pip python3-opencv git && DEBIAN_FRONTEND='noninteractive' apt-get install -y cmake libopenblas-dev liblapack-dev libjpeg-dev
RUN git clone https://github.com/davisking/dlib.git && cd dlib/; \
    mkdir build; \
    cd build; \
    cmake .. -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1 -DCUDA_HOST_COMPILER=/usr/bin/gcc-6; \
    cmake --build .; \
    cd .. ; \
    python3 setup.py install --set DLIB_USE_CUDA=1 --set USE_AVX_INSTRUCTIONS=1 --set CUDA_HOST_COMPILER=/usr/bin/gcc-6
RUN rm -rf /dlib && pip3 install face_recognition
COPY train.pkl /tmp
COPY test.py /tmp
ENTRYPOINT /tmp/test.py
