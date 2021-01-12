#FROM ubuntu:16.04
#
#RUN apt-get update && apt-get install -y --allow-downgrades --no-install-recommends \
#         build-essential \
#         cmake \
#         git \
#         curl \
#         vim \
#         ca-certificates \
#         python-qt4 \
#         libjpeg-dev \
#	       zip \
#	       unzip \
#         nginx \
#         libpng-dev &&\
#     rm -rf /var/lib/apt/lists/*
#
#ENV PYTHON_VERSION=3.6
#RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
#     chmod +x ~/miniconda.sh && \
#     ~/miniconda.sh -b -p /opt/conda && \
#     rm ~/miniconda.sh && \
#    /opt/conda/bin/conda install conda-build
#
#RUN git clone https://github.com/mattmcclean/fastai.git
#RUN cd fastai/ && ls && /opt/conda/bin/conda env create -f environment-cpu.yml
#RUN /opt/conda/bin/conda clean -ya
#
#ENV PATH /opt/conda/envs/fastai-cpu/bin:$PATH
#ENV USER fastai
#
#WORKDIR /fastai
#
#CMD source activate fastai-cpu
#CMD source ~/.bashrc
#
## Here we install the extra python packages to run the inference code
#RUN pip install flask gevent gunicorn && \
#        rm -rf /root/.cache
#
#ENV PYTHONUNBUFFERED=TRUE
#ENV PYTHONDONTWRITEBYTECODE=TRUE
#ENV PATH="/opt/program:${PATH}"
#
## Set up the program in the image
#COPY conv_net /opt/program
#WORKDIR /opt/program
#RUN chmod 755 serve
#
#RUN ln -s /fastai/fastai fastai

#FROM ubuntu:16.04
#
#RUN apt-get update && apt-get install -y --allow-downgrades --no-install-recommends \
#         build-essential \
#         cmake \
#         git \
#         curl \
#         vim \
#         ca-certificates \
#         python-qt4 \
#         libjpeg-dev \
#	       zip \
#	       unzip \
#         nginx \
#         libpng-dev &&\
#     rm -rf /var/lib/apt/lists/*
#
#ENV PYTHON_VERSION=3.6
#RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
#     chmod +x ~/miniconda.sh && \
#     ~/miniconda.sh -b -p /opt/conda && \
#     rm ~/miniconda.sh && \
#    /opt/conda/bin/conda install conda-build
#
#RUN git clone https://github.com/mattmcclean/fastai.git
#RUN cd fastai/ && ls && /opt/conda/bin/conda env create -f environment-cpu.yml
#RUN /opt/conda/bin/conda clean -ya
#
#ENV PATH /opt/conda/envs/fastai-cpu/bin:$PATH
#ENV USER fastai
#
#WORKDIR /fastai
#
#CMD source activate fastai-cpu
#CMD source ~/.bashrc
#
## Here we install the extra python packages to run the inference code
#RUN pip install flask gevent gunicorn && \
#        rm -rf /root/.cache
#
#ENV PYTHONUNBUFFERED=TRUE
#ENV PYTHONDONTWRITEBYTECODE=TRUE
#ENV PATH="/opt/program:${PATH}"
#
## Set up the program in the image
#COPY conv_net /opt/program
#WORKDIR /opt/program
#RUN chmod 755 serve
#
#RUN ln -s /fastai/fastai fastai

FROM ubuntu:18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"
LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true
LABEL com.amazonaws.sagemaker.capabilities.multi-models=true

ARG PYTHON_VERSION=3.6
ARG OPEN_MPI_VERSION=4.0.1
ARG TS_VERSION="0.2.1=py36_0"
ARG PT_INFERENCE_URL=https://aws-pytorch-binaries.s3-us-west-2.amazonaws.com/r1.6.0_inference/20200727-223446/b0251e7e070e57f34ee08ac59ab4710081b41918/cpu/torch-1.6.0-cp36-cp36m-manylinux1_x86_64.whl
ARG PT_VISION_URL=https://torchvision-build.s3.amazonaws.com/1.6.0/cpu/torchvision-0.7.0-cp36-cp36m-linux_x86_64.whl

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH /opt/conda/lib/:$LD_LIBRARY_PATH
ENV PATH /opt/conda/bin:$PATH
ENV SAGEMAKER_SERVING_MODULE sagemaker_pytorch_serving_container.serving:main
ENV TEMP=/home/model-server/tmp

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    emacs \
    git \
    jq \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    openjdk-11-jdk \
    vim \
    wget \
    zlib1g-dev

# https://github.com/docker-library/openjdk/issues/261 https://github.com/docker-library/openjdk/pull/263/files
RUN keytool -importkeystore -srckeystore /etc/ssl/certs/java/cacerts -destkeystore /etc/ssl/certs/java/cacerts.jks -deststoretype JKS -srcstorepass changeit -deststorepass changeit -noprompt; \
    mv /etc/ssl/certs/java/cacerts.jks /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure;


RUN curl -L -o ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p /opt/conda \
 && rm ~/miniconda.sh \
 && /opt/conda/bin/conda update conda \
 && /opt/conda/bin/conda install -y \
    python=$PYTHON_VERSION \
 && /opt/conda/bin/conda clean -ya \
 && rm -rf /var/lib/apt/lists/*



RUN wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-$OPEN_MPI_VERSION.tar.gz \
 && gunzip -c openmpi-$OPEN_MPI_VERSION.tar.gz | tar xf - \
 && cd openmpi-$OPEN_MPI_VERSION \
 && ./configure --prefix=/home/.openmpi \
 && make all install \
 && cd .. \
 && rm openmpi-$OPEN_MPI_VERSION.tar.gz \
 && rm -rf openmpi-$OPEN_MPI_VERSION

# The ENV variables declared below are changed in the previous section
# Grouping these ENV variables in the first section causes
# ompi_info to fail. This is only observed in CPU containers
ENV PATH="$PATH:/home/.openmpi/bin"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/.openmpi/lib/"
RUN ompi_info --parsable --all | grep mpi_built_with_cuda_support:value


RUN pip install --upgrade pip --trusted-host pypi.org --trusted-host files.pythonhosted.org \
 && ln -s /opt/conda/bin/pip /usr/local/bin/pip3 \
 && pip install cython==0.29.15 \
    ipython==7.12.0 \
    # mkl==2020.0 \
    numpy==1.19.4 \
    scipy==1.4.1 \
    typing==3.7.4.3 \
    opencv-python==4.2.0.32 \
    scikit-learn==0.21.3 \
    pandas==0.24.2 \
    h5py==2.10.0 \
    requests==2.25.0 \
    packaging==20.7 \
    enum-compat==0.0.3 \
    cryptography==2.8 \
    Pillow==6.2.2 \
    nginx==0.0.1 \
 && conda install -y -c pytorch torchserve=$TS_VERSION \
 && conda install -y -c pytorch torch-model-archiver=$TS_VERSION \
 && rm -rf /root/.cache \
 && rm -rf /var/lib/apt/lists/*

# Uninstall and re-install torch and torchvision from the PyTorch website
RUN pip install --no-cache-dir torch==1.7.1 \
 && pip install --no-deps --no-cache-dir torchvision==0.8.2 \
 && pip install --no-cache-dir "sagemaker-pytorch-inference>=2" \
 && rm -rf /root/.cache \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m model-server \
 && mkdir -p /home/model-server/tmp /opt/ml/model \
 && chown -R model-server /home/model-server /opt/ml/model

COPY torchserve-entrypoint.py /usr/local/bin/dockerd-entrypoint.py
COPY config.properties /home/model-server

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

ADD https://raw.githubusercontent.com/aws/deep-learning-containers/master/src/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN curl https://aws-dlc-licenses.s3.amazonaws.com/pytorch-1.6.0/license.txt -o /license.txt

RUN conda install -y -c conda-forge pyyaml==5.3.1

EXPOSE 8080 8081
ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["torchserve", "--start", "--ts-config", "/home/model-server/config.properties", "--model-store", "/home/model-server/"]



# # AssertionError: NVidia Apex package must be installed. See https://github.com/NVIDIA/apex.
# RUN pip install --quiet -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" git+https://github.com/NVIDIA/apex
# RUN pip install git+https://github.com/mapillary/inplace_abn.git@v1.0.3

# Here we install the extra python packages to run the inference code
RUN pip install flask==1.1.1 \
        gevent==1.4.0 \
        gunicorn \
        && rm -rf /root/.cache \
        && rm -rf /var/lib/apt/lists/*


ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"

# Set up the program in the image
RUN git clone https://github.com/Ramstein/Retinopathy2DockerDeployment.git
RUN cd Retinopathy2DockerDeployment/ && cp -a . /opt/program

WORKDIR /opt/program
RUN git clone https://github.com/Ramstein/Retinopathy2.git

RUN cd Retinopathy2/ && ls && pip install -r requirements.txt \
    && rm -rf /root/.cache \
    && rm -rf /var/lib/apt/lists/*

RUN cd ../
RUN chmod 755 serve