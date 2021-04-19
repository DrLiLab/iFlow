#!/bin/bash

# essential package
sudo apt install build-essential clang libreadline6-dev bison flex libffi-dev cmake libboost-all-dev swig klayout libeigen3-dev -y

# tcl
sudo apt install tcl-dev -y
sudo cp /usr/include/tcl8.6/*.h /usr/include/
sudo ln -s /usr/lib/x86_64-linux-gnu/libtcl8.6.so /usr/lib/x86_64-linux-gnu/libtcl8.5.so

# lemon
wget http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz
tar zxvf lemon-1.3.1.tar.gz
cd lemon-1.3.1
mkdir build && cd build && cmake .. && make && sudo make install
cd ../../
sudo rm -rf lemon-1.3.1 lemon-1.3.1.tar.gz

# yosys
git clone https://github.com/The-OpenROAD-Project/yosys.git tools/yosys4be891e8
cd tools/yosys4be891e8
git checkout 4be891e8
mkdir build && cd build
make -f ../Makefile
cd ../../

# TritonRoute
git clone https://github.com/The-OpenROAD-Project/TritonRoute.git tools/TritonRoute758cdac
cd tools/TritonRoute758cdac
git checkout 758cdac
mkdir build && cd build 
cmake .. && make
cd ../../../../

# OpenROAD
git clone https://github.com/The-OpenROAD-Project/OpenROAD.git tools/OpenROAD9295a533 
cd tools/OpenROAD9295a533 
git checkout 9295a533 
git submodule update --init --recursive OpenSTA OpenDB flute3 replace ioPlacer FastRoute eigen TritonMacroPlace OpenRCX
git clone https://github.com/ZhishengZeng/PDNSim.git src/PDNSim
mkdir build && cd build 
cmake .. && make
cd ../../../
