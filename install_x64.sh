#!/bin/bash
#
# Brandon Gant
# Created: 2021-03-27
# Updated: 2021-04-11
#
# Ubuntu Server 20.04 on Intel 64-bit computer
#   git clone https://github.com/bgant/backyard_birdbot
#   cd backyard_birdbot
#   bash install_x64.sh
#
# It is safe to run install_x64.sh script multiple times.
#
# Remove all pip packages and start over:
#   rm -r birdbot-env 
#   bash install_x64.sh
#
# If you need an older version of Python:
#   sudo add-apt-repository ppa:deadsnakes/ppa
#   sudo apt-get update
#   sudo apt-get install python3.7 python3.7-venv
#
# Change Log:
#   - tensorflow 2.4.0 requires numpy 1.19.x
#       - matplotlib 3.3.x uses numpy 1.19.x (3.4.x uses 1.20.x)
#       - tensorflow 2.4.0 breaks with pandas 1.2.x (works with pandas 1.1.x)
#

# Tensorflow 2.x requires a CPU with Advanced Vector Extensions (AVX)
if [ `grep -c avx /proc/cpuinfo` == 0 ]
then
    echo "CPU does not support Advanced Vector Extensions (AVX)"
    exit 0
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
python3 -m pip install tensorflow 
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

