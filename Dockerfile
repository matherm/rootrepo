############################################################################################
#### BUILD-STAGE: INTERMEDIATE IMAGE FOR SSH-KEY SECURITY
############################################################################################
# FROM ubuntu:16.04 as intermediate
# RUN apt-get update && apt-get install -y git

# # We will need a web access token to download some ios private repos
# ARG USER
# ARG PASSWORD
# ARG SSH_PRIVATE_KEY

# # Prepare SSH-KEY
# RUN if [ ${#SSH_PRIVATE_KEY} -gt 0 ] \
#     ;then \
#         mkdir /root/.ssh/ \
#         && echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa \
#         && chmod 700 /root/.ssh/id_rsa \
#         && touch /root/.ssh/known_hosts \
#         # Make sure your domain is accepted
#         && ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts \
#         && ssh-keyscan github.com >> /root/.ssh/known_hosts \
#         && ssh-keyscan git.ios.htwg-konstanz.de >> /root/.ssh/known_hosts \
#     ;fi

# # Clone the private repos 
# RUN if [ ${#SSH_PRIVATE_KEY} -gt 0 ] \  
#     ;then \
#         git clone git@git.ios.htwg-konstanz.de:mof-applications/ummon3.git && \
#         git clone git@git.ios.htwg-konstanz.de:mof-applications/ios-datasets.git && \
#         git clone git@git.ios.htwg-konstanz.de:gu-libraries/eigency.git \
#     ;else \
#         git clone https://${USER}:${PASSWORD}@git.ios.htwg-konstanz.de/mof-applications/ummon3.git && \
#         git clone https://${USER}:${PASSWORD}@git.ios.htwg-konstanz.de/mof-applications/ios-datasets.git &&\
#         git clone https://${USER}:${PASSWORD}@git.ios.htwg-konstanz.de/gu-libraries/eigency.git \
#     ;fi
# # Later in main image
#COPY --from=intermediate /ummon3 /installdir/lib/ummon3
#COPY --from=intermediate /ios-datasets /installdir/lib/ios-datasets
#COPY --from=intermediate /eigency /installdir/lib/eigency


############################################################################################
#### BUILD-STAGE: BASE IMAGE
############################################################################################
FROM nvidia/cuda:10.0-devel
MAINTAINER Matthias <matthias.hermann@htwg-konstanz.de>
# Lets start with a ubuntu 16.04 with cuda developer libraries

# Useful system packages 
RUN apt-get update && apt-get install -y curl bzip2 git vim
RUN apt-get install -y libblas-dev liblapack-dev libmpfr-dev
RUN apt-get install -y libglu1-mesa-dev freeglut3-dev mesa-common-dev

# Dev and Libigl dependencies (https://liuzhiguang.wordpress.com/2017/06/01/compiling-libigl-on-ubuntu/)
RUN apt-get install -y gcc-5 g++-5 gcc-6 g++-6 gcc-7 g++-7 cmake
RUN apt-get install -y libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev libxxf86vm-dev

# Install miniconda to /miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
RUN bash Miniconda-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda

# Create a conda environment py3 with a good subset of packages
RUN conda create -n py3 python=3.7 jupyter ipython ipykernel scipy networkx imageio matplotlib scikit-learn scikit-image cython psutil paramiko  pytest pytest-runner pytest-cov
ENV CONDA_DEFAULT_ENV py3
ENV CONDA_PREFIX /miniconda/envs/py3
ENV PATH /miniconda/envs/py3/bin:$PATH

# Install PyTorch for CUDA-10
RUN conda install pytorch cuda100 torchvision -c pytorch
RUN conda install cudatoolkit=9.2 

# Pip installs
RUN pip install ptvsd openmesh

# EMVIRONMENT
ENV CUDA_HOME /usr/local/cuda
ENV CPATH=${CUDA_HOME}/lib:${CPATH}
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV CC gcc-6
ENV CXX g++-6


############################################################################################
#### BUILD-STAGE: SPECIFIC IMAGE
############################################################################################

ENV CC gcc-6
ENV CXX g++-6
# TORCH-GEOMETRIC
ADD ./lib/pytorch_scatter /installdir/lib/pytorch_scatter
RUN (cd /installdir/lib/pytorch_scatter/ && python setup.py install)

ADD ./lib/pytorch_sparse /installdir/lib/pytorch_sparse
RUN (cd /installdir/lib/pytorch_sparse/ && python setup.py install)

ADD ./lib/pytorch_spline_conv /installdir/lib/pytorch_spline_conv
RUN (cd /installdir/lib/pytorch_spline_conv/ && python setup.py install)

ADD ./lib/pytorch_cluster /installdir/lib/pytorch_cluster
RUN (cd /installdir/lib/pytorch_cluster/ && python setup.py install)

ADD ./lib/pytorch_geometric /installdir/lib/pytorch_geometric
RUN (cd /installdir/lib/pytorch_geometric/ && python setup.py install)

RUN rm -rf /installdir/lib/pytorch_scatter/python/build \
    && rm -rf /installdir/lib/pytorch_sparse/python/build \
    && rm -rf /installdir/lib/pytorch_spline_conv/python/build \
    && rm -rf /installdir/lib/pytorch_cluster/python/build \
    && rm -rf /installdir/lib/pytorch_geometric/python/build

# LIBIGL (https://github.com/panchagil/docker-pyigl/blob/master/Dockerfile)
#RUN cd /installdir/lib/libigl-legacy  \
#    && mkdir -p external/nanogui/ext/glfw/include/GL \
#    && (cd external/nanogui/ext/glfw/include/GL && curl -O https://www.khronos.org/registry/OpenGL/api/GL/glcorearb.h) \   
#    && mkdir -p python/build \
#    && cd python/build \
#    && cmake -DLIBIGL_WITH_NANOGUI=ON -DLIBIGL_USE_STATIC_LIBRARY=ON  -DCMAKE_CXX_COMPILER=g++-7 -DCMAKE_C_COMPILER=gcc-7 -DLIBIGL_WITH_EMBREE=OFF .. \
#    && make -j 2 
ADD ./lib/libigl-legacy /installdir/lib/libigl-legacy
RUN (cd /installdir/lib/libigl-legacy/python \
    && python setup.py install)
RUN (cd /installdir/lib/libigl-legacy/python/ \
    && cp iglhelpers.py *.so /miniconda/envs/py3/lib/python3.7/site-packages/)
RUN rm -rf /installdir/lib/libigl-legacy/python/build

# IOS REPOS (ummon3, ios-datasets, eigency)
ADD ./lib/ummon3 /installdir/lib/ummon3
RUN (cd /installdir/lib/ummon3/ && pip install .)

ADD ./lib/ummon3 /installdir/lib/eigency
RUN (cd /installdir/lib/eigency/ && pip install .)

ADD ./lib/ummon3 /installdir/lib/ios-datasets
RUN (cd /installdir/lib/ios-datasets/ && pip install .)
 
# THIS
ADD ./setup.py /installdir/
ADD ./opt /installdir/opt
ADD ./gcnn /installdir/gcnn
RUN (cd /installdir && pip install .)


############################################################################################
#### BUILD-STAGE: CLEAN UP 
############################################################################################
# ~ 3 GB
RUN rm -rf /installdir          
RUN conda clean -a -y -q
RUN rm -rf /root/.cache/pip
RUN apt-get clean

############################################################################################
#### BUILD-STAGE: CMD: INFINIT IPYTHON KERNEL
############################################################################################
RUN echo 'while true;'                                                            >  /bootstrap.sh \
 && echo 'do'                                                                     >> /bootstrap.sh \
 && echo '    if [ -f /ipython_runs ];'                                           >> /bootstrap.sh \
 && echo '        then'                                                           >> /bootstrap.sh \
 && echo '            mv /root/.ipython/profile_default/security/kernel-* /home/;'>> /bootstrap.sh \
 && echo '            mv /root/.local/share/jupyter/runtime/kernel-* /home/;'     >> /bootstrap.sh \
 && echo '            mv /run/user/0/jupyter/kernel-* /home/;'                    >> /bootstrap.sh \
 && echo '            mv /home/kernel-* /home/kernel-1.json;'                     >> /bootstrap.sh \
 && echo '        else'                                                           >> /bootstrap.sh \
 && echo '            rm -f /home/kernel-*.json;'                                 >> /bootstrap.sh \
 && echo '            touch /ipython_runs;'                                       >> /bootstrap.sh \  
 && echo '            ipython kernel --hb=40104 --stdin=40106 --shell=40103 --control=40105 --iopub=40102 --ip=0.0.0.0 --debug && rm /ipython_runs &'  >> /bootstrap.sh \
 && echo '    fi;'                                                                >> /bootstrap.sh \
 && echo '    sleep 5;'                                                           >> /bootstrap.sh \
 && echo 'done;'                                                                  >> /bootstrap.sh \
 && chmod +x /bootstrap.sh
CMD /bootstrap.sh