#!/bin/bash

# Review https://github.com/lhelontra/tensorflow-on-arm/releases and Download appropriate release

if [ ! -f tensorflow-2.4.0-cp37-none-linux_armv7l.whl ]
then
    wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v2.4.0/tensorflow-2.4.0-cp37-none-linux_armv7l.whl
fi

sudo apt update
sudo apt -y upgrade

sudo apt install -y apt-file
sudo apt-file update
# When a python import has a missing file,
# use apt-file to find which package to install
#    apt-file file <missing file>
#    apt-cache search <missing package>
#    apt install <missing package>

# Setup Python Package Environment
sudo apt install -y python3-venv
python3 -m venv birdbot-env
source birdbot-env/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade setuptools

# Tensorflow Installation
# Source: https://raspberrypi.stackexchange.com/questions/107483/error-installing-tensorflow-cannot-find-libhdfs-so
sudo apt-get install -y libhdf5-dev libc-ares-dev libeigen3-dev openmpi-bin libopenmpi-dev libatlas-base-dev
python3 -m pip install tensorflow-2.4.0-cp37-none-linux_armv7l.whl  # Requires numpy 1.19.x
python3 -c "import tensorflow; print('import tensorflow WORKS"

python3 -m pip install pandas~=1.1.5    # version 1.2.3 breaks Tensorflow 2.4.0
python3 -c "import tensorflow; print('import tensorflow STILL WORKS"

# OpenCV Installation
python3 -m pip install opencv-python-headless
sudo apt install -y libwebp6 libtiff5 libopenjp2-7 libilmbase23 libopenexr23 libavcodec58 libavformat58 libswscale5 liblapack3 libatlas3-base

# Other packages needed by Birdbot
python3 -m pip install matplotlib~=3.3.4    # Version 3.3.x required if using numpy 1.19.x
python3 -m pip install tensorflow_hub
python3 -m pip install tweepy
python3 -m pip install wikipedia
python3 -m pip install config

# Python import tests
python3 -c "import cv2; print('opencv version', cv2.__version__)"
python3 -c "import matplotlib; print('matplotlib version', matplotlib.__version__)"
python3 -c "import tensorflow; print('tensorflow version', tensorflow.__version__)"
python3 -c "import numpy; print('numpy version', numpy.__version__)"
python3 -c "import pandas; print('pandas version', pandas.__version__)"

# To upgrade all venv packages (probably a bad idea unless testing):
#python3 -m pip list | egrep -v "Package|----" | awk '{print $1}' | xargs -I {} python3 -m pip install --upgrade {}

