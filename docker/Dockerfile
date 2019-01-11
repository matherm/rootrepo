############################################################################################
#### BUILD-STAGE I: CLONE PRIVATE GIT REPOS INTO INTERMEDIATE REPO FOR SECURITY
############################################################################################
FROM ubuntu:16.04 as intermediate
RUN apt-get update && apt-get install -y git

# We will need a web access token to download some ios private repos
ARG user
ARG password
ARG SSH_PRIVATE_KEY

# Prepare SSH-KEY
RUN mkdir /root/.ssh/ \
    && echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa \
    && chmod 700 /root/.ssh/id_rsa \
    && touch /root/.ssh/known_hosts \
    # Make sure your domain is accepted
    && ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts \
    && ssh-keyscan github.com >> /root/.ssh/known_hosts \
    && ssh-keyscan git.ios.htwg-konstanz.de >> /root/.ssh/known_hosts

# Clone the private repos 
RUN if [ ${#SSH_PRIVATE_KEY} > 0 ] \  
    ;then \
        git clone git@git.ios.htwg-konstanz.de:mof-applications/ummon3.git && \
        git clone git@git.ios.htwg-konstanz.de:mof-applications/ios-datasets.git && \
        git clone git@git.ios.htwg-konstanz.de:gu-libraries/eigency.git \
    ;else \
        git clone https://${user}:${password}@git.ios.htwg-konstanz.de/mof-applications/ummon3.git && \
        git clone https://${user}:${password}@git.ios.htwg-konstanz.de/mof-applications/ios-datasets.git &&\
        git clone https://${user}:${password}@git.ios.htwg-konstanz.de/gu-libraries/eigency.git \
    ;fi



############################################################################################
#### BUILD-STAGE II: BASE IMAGE
############################################################################################
FROM nvidia/cuda:10.0-devel
MAINTAINER Matthias <matthias.hermann@htwg-konstanz.de>
# Lets start with a ubuntu 16.04 with cuda developer libraries

# Useful system packages 
RUN apt-get update && apt-get install -y curl && apt-get install -y bzip2
RUN apt-get install -y libblas-dev liblapack-dev
RUN apt-get install -y libglu1-mesa-dev freeglut3-dev mesa-common-dev
RUN apt-get install -y libmpfr-dev
RUN apt-get install -y git

# GCNN and Libigl dependencies (https://liuzhiguang.wordpress.com/2017/06/01/compiling-libigl-on-ubuntu/)
RUN apt-get install -y gcc-6 g++-6 cmake
RUN apt-get install -y libxrandr-dev
RUN apt-get install -y libxinerama-dev
RUN apt-get install -y libxcursor-dev
RUN apt-get install -y libxi-dev
RUN apt-get install -y libxxf86vm-dev

# Install miniconda to /miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
RUN bash Miniconda-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda

# Create a conda environment py3 with a good subset of packages
RUN conda create -n py3 python=3.7 jupyter ipython ipykernel scipy networkx imageio matplotlib scikit-learn scikit-image cython psutil paramiko
ENV CONDA_DEFAULT_ENV py3
ENV CONDA_PREFIX /miniconda/envs/py3
ENV PATH /miniconda/envs/py3/bin:$PATH

# Install PyTorch for CUDA-10
RUN conda install pytorch cuda100 torchvision -c pytorch
RUN conda install cudatoolkit=9.2 

# EMVIRONMENT
ENV CUDA_HOME /usr/local/cuda
ENV CPATH=${CUDA_HOME}/lib:${CPATH}
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV CC gcc-6
ENV CXX g++-6

# ADDS INFINITE KERNEL SCRIPT
RUN echo 'while true;'                                                            >  /bootstrap.sh \
 && echo 'do'                                                                     >> /bootstrap.sh \
 && echo '    if [ -f /ipython_runs ];'                                           >> /bootstrap.sh \
 && echo '        then'                                                           >> /bootstrap.sh \
 && echo '            rm -f /home/kernel-*.json;'                                 >> /bootstrap.sh \
 && echo '            cp /root/.ipython/profile_default/security/kernel-* /home/;'>> /bootstrap.sh \
 && echo '            cp /root/.local/share/jupyter/runtime/kernel-* /home/;'     >> /bootstrap.sh \
 && echo '            cp /run/user/0/jupyter/kernel-* /home/;'                    >> /bootstrap.sh \
 && echo '        else'                                                           >> /bootstrap.sh \
 && echo '            touch /ipython_runs;'                                       >> /bootstrap.sh \  
 && echo '            ipython kernel --hb=40104 --stdin=40106 --shell=40103 --control=40105 --iopub=40102 --ip=0.0.0.0 --debug && rm /ipython_runs &' >> /bootstrap.sh \
 && echo '    fi;'                                                                >> /bootstrap.sh \
 && echo '    sleep 5;'                                                           >> /bootstrap.sh \
 && echo 'done;'                                                                  >> /bootstrap.sh \
 && chmod +x /bootstrap.sh

############################################################################################
#### BUILD-STAGE III: SPECIFIC IMAGE
############################################################################################
ADD ./installscripts /gcnn/installscripts

# LIBIGL
ADD ./lib/libigl-legacy /gcnn/lib/libigl-legacy
RUN cd /gcnn && python ./installscripts/install-libigl.py install && cd ~

# TORCH-GEOMETRIC
ADD ./lib/pytorch_scatter /gcnn/lib/pytorch_scatter
ADD ./lib/pytorch_sparse /gcnn/lib/pytorch_sparse
ADD ./lib/pytorch_spline_conv /gcnn/lib/pytorch_spline_conv
ADD ./lib/pytorch_cluster /gcnn/lib/pytorch_cluster
ADD ./lib/pytorch_geometric /gcnn/lib/pytorch_geometric
RUN cd /gcnn/lib/pytorch_scatter/ && python setup.py install && cd ~
RUN cd /gcnn/lib/pytorch_sparse/ && python setup.py install && cd ~
RUN cd /gcnn/lib/pytorch_spline_conv/ && python setup.py install && cd ~
RUN cd /gcnn/lib/pytorch_cluster/ && python setup.py install && cd ~
RUN cd /gcnn/lib/pytorch_geometric/ && python setup.py install && cd ~

# IOS REPOS (ummon3, ios-datasets, eigency)
COPY --from=intermediate /ummon3 /ummon3
COPY --from=intermediate /ios-datasets /ios-datasets
COPY --from=intermediate /eigency /eigency
RUN cd /ummon3 && pip install . && cd ~
RUN cd /ios-datasets && pip install . && cd ~
RUN cd /eigency && pip install . && cd ~

# THIS
ADD ./gcnn /gcnn/gcnn
ADD ./setup.py /gcnn/
RUN cd /gcnn && pip install . && cd ~

############################################################################################
#### BUILD-STAGE IV: CMD: INFINIT IPYTHON KERNEL
############################################################################################
CMD /bootstrap.sh
