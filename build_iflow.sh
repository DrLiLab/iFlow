#!/bin/bash

function RUN()
{
    while [ 0 -eq 0 ]
    do
        $* 
        echo $*
        if [ $? -eq 0 ]; then
            break;
        else
            echo "...............warning , retry in 2 seconds .........."
            sleep 2
        fi
    done
}



# env
IFLOW_ROOT=$(cd "$(dirname "$0")";pwd)

# essential package
RUN sudo apt install build-essential clang libreadline6-dev bison flex libffi-dev cmake libboost-all-dev swig klayout libeigen3-dev -y

exit(0)
# tcl
sudo apt install tcl-dev -y
sudo cp /usr/include/tcl8.6/*.h /usr/include/
sudo ln -s /usr/lib/x86_64-linux-gnu/libtcl8.6.so /usr/lib/x86_64-linux-gnu/libtcl8.5.so

# lemon
while [ 0 -eq 0 ]
do
    wget http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz 
    if [ $? -eq 0 ]; then
        break;
    else
        echo "...............wget lemon error, retry in 2 seconds .........."
        sleep 2
    fi
done
tar zxvf lemon-1.3.1.tar.gz
cd lemon-1.3.1
mkdir build && cd build && cmake .. && make && sudo make install
cd $IFLOW_ROOT
sudo rm -rf lemon-1.3.1 lemon-1.3.1.tar.gz

# yosys
while [ 0 -eq 0 ]
do
    git clone https://github.com/The-OpenROAD-Project/yosys.git tools/yosys4be891e8
    if [ $? -eq 0 ]; then
        break;
    else
        echo "...............clone yosys error , retry in 2 seconds .........."
        sleep 2
    fi
done
cd $IFLOW_ROOT/tools/yosys4be891e8
git checkout 4be891e8
mkdir build && cd build
while [ 0 -eq 0 ]
do
    make -f ../Makefile
    if [ $? -eq 0 ]; then
        break;
    else
        echo "...............make yosys error , retry in 2 seconds .........."
        sleep 2
    fi
done
cd $IFLOW_ROOT

# TritonRoute
while [ 0 -eq 0 ]
do
    git clone https://github.com/The-OpenROAD-Project/TritonRoute.git tools/TritonRoute758cdac
    if [ $? -eq 0 ]; then
        break;
    else
        echo "...............clone TritonRoute error , retry in 2 seconds .........."
        sleep 2
    fi
done
cd $IFLOW_ROOT/tools/TritonRoute758cdac
git checkout 758cdac
mkdir build && cd build 
cmake .. && make
cd $IFLOW_ROOT

# OpenROAD
while [ 0 -eq 0 ]
do
    git clone https://github.com/The-OpenROAD-Project/OpenROAD.git tools/OpenROAD9295a533 
    if [ $? -eq 0 ]; then
        break;
    else
        echo "...............clone OpenROAD error , retry in 2 seconds .........."
        sleep 2
    fi
done
cd $IFLOW_ROOT/tools/OpenROAD9295a533 
git checkout 9295a533 
cd $IFLOW_ROOT/tools/OpenROAD9295a533/src
while [ 0 -eq 0 ]
do
    git submodule update --init --recursive OpenSTA OpenDB flute3 replace ioPlacer FastRoute eigen TritonMacroPlace OpenRCX
    if [ $? -eq 0 ]; then
        break;
    else
        echo "...............OpenROAD submodule update error , retry in 2 seconds .........."
        sleep 2
    fi
done
while [ 0 -eq 0 ]
do
    git clone https://github.com/ZhishengZeng/PDNSim.git PDNSim
    if [ $? -eq 0 ]; then
        break;
    else
        echo "...............PDNSim clone error , retry in 2 seconds .........."
        sleep 2
    fi
done
cd $IFLOW_ROOT/tools/OpenROAD9295a533
mkdir build && cd build 
cmake .. && make
cd $IFLOW_ROOT
