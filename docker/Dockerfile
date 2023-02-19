# syntax = docker/dockerfile:experimental
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu18.04



############################## SYSTEM PARAMETERS ##############################
## Base arguments
ARG USER=root
ARG GROUP=initial
ARG UID=1000
ARG GID=${UID}
ARG SHELL=/bin/bash
ARG TZ="Asia/Taipei"

## NVIDIA GraphicsCard parameter
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
# ENV NVIDIA_DRIVER_CAPABILITIES graphics, utility, compute

# environment
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive



## Setup users and groups
RUN groupadd --gid ${GID} ${GROUP} \
  && useradd --gid ${GID} --uid ${UID} -ms ${SHELL} ${USER} \
  && mkdir -p /etc/sudoers.d \
  && echo "${USER}:x:${UID}:${UID}:${USER},,,:$HOME:${shell}" >> /etc/passwd \
  && echo "${USER}:x:${UID}:" >> /etc/group \
  && echo "${USER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${USER}" \
  && chmod 0440 "/etc/sudoers.d/${USER}"

## Replace apt urls
# Taiwan
RUN sed -i 's@archive.ubuntu.com@tw.archive.ubuntu.com@g' /etc/apt/sources.list
# TKU
# RUN sed -i 's@archive.ubuntu.com@ftp.tku.edu.tw/@g' /etc/apt/sources.list


############################### Timezone ###############################
ENV TIME_ZONE=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime \
  && echo $TIME_ZONE > /etc/timezone

############################### INSTALL & SETUP ###############################
RUN apt-key adv --fetch-keys
RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo htop git wget curl \
  # Shell
  byobu zsh \
  terminator \
  dbus-x11 libglvnd0 libgl1 libglx0 libegl1 libxext6 libx11-6 libxtst6 libinih-dev\
  # Editing tools
  nano vim \
  gnome-terminal libcanberra-gtk-module libcanberra-gtk3-module \
  software-properties-common \
  # python
  python3-pip python3-dev python3-setuptools && \
  apt install -y libopencv-dev
  



############################### INSTALL ROS ###############################
#setting system clock
RUN apt-get update && \
  sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
  apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
  apt update && \
  apt install -y ros-melodic-desktop-full && \
  echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc && \
  /bin/bash -c "source /root/.bashrc" && \
  apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && \
  rosdep init && \
  sudo rosdep update





WORKDIR /home/${USER}/.tmp

## setup custom configuration
COPY config .

## ROS Arguments
# Is the computer master or slave in ROS
ARG ROS_TYPE=MASTER
ARG ROS_MASTER_IP=localhost
ARG ROS_SLAVE_IP=localhost

## Favorite shell when using byobu
ARG BYOBU_SHELL=zsh

## Set User configuration
RUN bash ./script/shell_setup.sh \
  && bash ./script/editor_setup.sh \
  # Dependent
  && bash ./script/pip_setup.sh \
  && bash ./script/ros_setup.sh \
  && bash ./script/cudnn_setup.sh \
  && bash ./script/opencv_setup.sh \
  && rm -rf /home/${USER}/.tmp

## Copy entrypoint
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh


WORKDIR /home/${USER}

## Switch user to ${USER}
USER ${USER}

RUN sudo mkdir work

## Make SSH available
EXPOSE 22

## Switch to user's HOME folder
WORKDIR /home/${USER}/work

# ENTRYPOINT ["byobu"]
# ENTRYPOINT ["/entrypoint.sh", "byobu"]
# ENTRYPOINT ["/entrypoint.sh", "bash"]
ENTRYPOINT ["/entrypoint.sh", "terminator"]
# ENTRYPOINT ["/entrypoint.sh", "zsh"]
