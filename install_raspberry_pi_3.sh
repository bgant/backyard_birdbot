#!/bin/bash

# Review https://github.com/lhelontra/tensorflow-on-arm/releases and Download appropriate release
wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v2.4.0/tensorflow-2.4.0-cp37-none-linux_armv7l.whl

apt update
apt -y upgrade

apt install -y apt-file
apt-file update
# When a python import has a missing file,
# use apt-file to find which package to install
#    apt-file file <missing file>
#    apt-cache search <missing package>
#    apt install <missing package>

# Setup Python Package Environment
apt install -y python3-venv
python3 -m venv birdbot-env
source birdbot/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade setuptools


python3 -m pip install numpy=1.19.2        # Required by Tensorflow 2.4.0
python3 -m pip install multiplotlib=3.3.4  # Version 3.3.x required if using numpy 1.19.2

# OpenCV Installation
python3 -m pip install opencv-python-headless
sudo apt install -y libwebp6 libtiff5 libopenjp2-7 libilmbase23 libopenexr23 libavcodec58 libavformat58 libswscale5 liblapack3 libatlas3-base

# Tensorflow Installation
# Source: https://raspberrypi.stackexchange.com/questions/107483/error-installing-tensorflow-cannot-find-libhdfs-so
apt-get install -y libhdf5-dev libc-ares-dev libeigen3-dev
python3 -m pip install keras_applications --no-deps
python3 -m pip install keras_preprocessing --no-deps
python3 -m pip install h5py
apt-get install -y openmpi-bin libopenmpi-dev libatlas-base-dev
python3 -m pip install six
python3 -m pip install wheel
python3 -m pip install mock
python3 -m pip install tensorflow-2.4.0-cp37-none-linux_armv7l.whl

# Other packages needed by Birdbot
python3 -m pip install tensorflow_hub
python3 -m pip install pandas
python3 -m pip install tweepy
python3 -m pip install wikipedia
python3 -m pip install config

# Test packages work
python3 -c "import cv2; print(cv2.version)"
python3 -c "import tensorflow; tensorflow.__version__"

# To upgrade all venv packages (probably a bad idea unless testing):
#python3 -m pip list | egrep -v "Package|----" | awk '{print $1}' | xargs -I {} python3 -m pip install --upgrade {}

