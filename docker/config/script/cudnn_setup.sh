#! /usr/bin/env bash

################################# FUNCTIONS #################################
################################
# Setup ROS master and slave addresses
# Arguments:
# - $1 (String) - Shell Type
# - $2 (String) - This PC is the master or slave
# - $3 (IP) - This IP is the master's IP address
# - $4 (IP) - This IP is the slave's IP address
################################
# sudo cp -i ${HOME}/work/cuda/include/* /usr/local/cuda/include/
# sudo cp -i ${HOME}/cuda/lib64/* /usr/local/cuda/lib64/
# sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*



function cudnn_fn() {
    SHELL=$(echo ${1} | tr [A-Z] [a-z])
    echo "export PATH=\$PATH:/usr/local/cuda/bin">>/home/$USER/.${SHELL}rc
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/cuda/lib64">>/home/$USER/.${SHELL}rc
}

#################################### MAIN ####################################
cudnn_fn "bash" ${ROS_TYPE} ${ROS_MASTER_IP} ${ROS_SLAVE_IP}
cudnn_fn "zsh" ${ROS_TYPE} ${ROS_MASTER_IP} ${ROS_SLAVE_IP}