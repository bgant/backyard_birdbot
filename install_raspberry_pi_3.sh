#!/bin/bash
#
# Brandon Gant
# Created: 2021-03-27
# Updated:
#
# Raspian OS Lite on Raspberry Pi 3
#   apt install git
#   git clone https://github.com/bgant/backyard_birdbot
#   cd backyard_birdbot
#   bash install_raspberry_pi_3.sh
#
# Change Log:
#   - tensorflow 2.4.0 requires numpy 1.19.x
#       - matplotlib 3.3.x uses numpy 1.19.x (3.4.x uses 1.20.x)
#       - tensorflow 2.4.0 breaks with pandas 1.2.x (works with pandas 1.1.x)
#

# Review https://github.com/lhelontra/tensorflow-on-arm/releases and Download appropriate tensorflow release
VERSION="2.4.0" 
if [ ! -f tensorflow-${VERSION}-cp37-none-linux_armv7l.whl ]
then
    wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v${VERSION}/tensorflow-${VERSION}-cp37-none-linux_armv7l.whl
fi

sudo apt update && apt -y upgrade

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
python3 -m pip install --upgrade pip setuptools

# Tensorflow Installation
# Source: https://raspberrypi.stackexchange.com/questions/107483/error-installing-tensorflow-cannot-find-libhdfs-so
sudo apt-get install -y libhdf5-dev libc-ares-dev libeigen3-dev openmpi-bin libopenmpi-dev libatlas-base-dev
python3 -m pip install tensorflow-${VERSION}-cp37-none-linux_armv7l.whl 
python3 -c "import tensorflow; print('import tensorflow WORKS')"

python3 -m pip install pandas~=1.1.5 
python3 -c "import tensorflow; print('import tensorflow STILL WORKS')"

# OpenCV Installation
python3 -m pip install opencv-python-headless
sudo apt install -y libwebp6 libtiff5 libopenjp2-7 libilmbase23 libopenexr23 libavcodec58 libavformat58 libswscale5 liblapack3 libatlas3-base

# Other packages needed by Birdbot
python3 -m pip install matplotlib~=3.3.4 
python3 -m pip install tensorflow_hub tweepy wikipedia config

# Python import checks
echo
echo "########################"
echo "# Python Import Checks #"
echo "########################"
python3 -c "import cv2; print('opencv version', cv2.__version__)"
python3 -c "import matplotlib; print('matplotlib version', matplotlib.__version__)"
python3 -c "import tensorflow; print('tensorflow version', tensorflow.__version__)"
python3 -c "import numpy; print('numpy version', numpy.__version__)"
python3 -c "import pandas; print('pandas version', pandas.__version__)"


# To upgrade all venv packages (probably a bad idea unless testing):
#python3 -m pip list | egrep -v "Package|----" | awk '{print $1}' | xargs -I {} python3 -m pip install --upgrade {}

