# This Dockerfile essentially implements the instructions at
# https://github.com/ethz-asl/kalibr/wiki/installation, with slight changes for
# Ros melodic.

FROM ros:melodic

# Install deps
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
python-setuptools \
python-rosinstall \
ipython \
libeigen3-dev \
libboost-all-dev \
doxygen \
libopencv-dev \
ros-melodic-vision-opencv \
ros-melodic-image-transport-plugins \
ros-melodic-cmake-modules \
software-properties-common \
libpoco-dev \
python-matplotlib \
python-scipy \
python-git \
python-pip \
libtbb-dev \
libblas-dev \
liblapack-dev \
python-catkin-tools \
python-igraph \
libv4l-dev \
wget \
&& rm -rf /var/lib/apt/lists/*

# Build Kalibr
WORKDIR /opt/kalibr_workspace
COPY ./ src/kalibr
RUN . /opt/ros/melodic/setup.sh && \
catkin init && \
catkin config --extend /opt/ros/melodic && \
catkin config --merge-devel && \
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release && \
catkin build -DCMAKE_BUILD_TYPE=Release

# Login as non-root user (uid & gid are 1000)
RUN useradd -m user
WORKDIR /home/user
USER user

# Source environemnt setup scripts at login
RUN echo '. /opt/ros/melodic/setup.sh\n. /opt/kalibr_workspace/devel/setup.sh' >>  ~/.bashrc



