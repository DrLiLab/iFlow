#!/bin/bash
#--------------------------------------------------------------------------- 
#             Copyright 2021 PENG CHENG LABORATORY
#--------------------------------------------------------------------------- 
# Author      : ZhishengZeng
# Date        : 2021-04-21
# Project     : iFlow 
#--------------------------------------------------------------------------- 

echo "  _ _____ _               "
echo " (_)  ___| | _____      __"
echo " | | |_  | |/ _ \ \ /\ / /"
echo " | |  _| | | (_) \ V  V / "
echo " |_|_|   |_|\___/ \_/\_/  "
sleep 1

# env
THREAD_NUM=$(cat /proc/cpuinfo| grep "processor"| wc -l)
IFLOW_ROOT=$(cd "$(dirname "$0")";pwd)
IFLOW_TOOLS=$(cd "$(dirname "$0")";pwd)/tools

######################################
function CHECK_EXIST()
{
    if [ -d $* ]; then
        # exist
        echo "[iFlow Info] dir exist: '$*' skiping..."
        return 0
    else
        return 1
    fi
}

function RUN()
{
    echo "[iFlow Info] exec command: '$*'"
    while [ 0 -eq 0 ]
    do
        $* 
        if [ $? -eq 0 ]; then
            break;
        else
            echo "[iFlow Warning] exec command failed: '$*' retry..."
            sleep 1
        fi
    done
}
######################################

# essential package
RUN sudo apt install build-essential clang libreadline6-dev bison flex libffi-dev cmake libboost-all-dev swig klayout libeigen3-dev libspdlog-dev -y

# tcl
RUN sudo apt install tcl-dev -y
RUN sudo cp -f /usr/include/tcl8.6/*.h /usr/include/
RUN sudo ln -s -f /usr/lib/x86_64-linux-gnu/libtcl8.6.so /usr/lib/x86_64-linux-gnu/libtcl8.5.so

# lemon
CHECK_EXIST /usr/local/include/lemon ||\
{
    RUN wget http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz
    RUN tar zxvf lemon-1.3.1.tar.gz
    RUN cd lemon-1.3.1
    RUN mkdir build && cd build && cmake .. && make -j$THREAD_NUM && sudo make install
    RUN cd $IFLOW_ROOT && rm -rf lemon-1.3.1 lemon-1.3.1.tar.gz
}

# update iFlow
RUN cd $IFLOW_ROOT
RUN git pull origin master

# yosys4be891e8
CHECK_EXIST $IFLOW_TOOLS/yosys4be891e8 || RUN git clone https://github.com/The-OpenROAD-Project/yosys.git tools/yosys4be891e8
RUN cd $IFLOW_TOOLS/yosys4be891e8
RUN git checkout 4be891e8
CHECK_EXIST $IFLOW_TOOLS/yosys4be891e8/build || RUN mkdir build
RUN cd build && make -f ../Makefile -j$THREAD_NUM
RUN cd $IFLOW_ROOT

# TritonRoute758cdac
CHECK_EXIST $IFLOW_TOOLS/TritonRoute758cdac || RUN git clone https://github.com/The-OpenROAD-Project/TritonRoute.git tools/TritonRoute758cdac
RUN cd $IFLOW_TOOLS/TritonRoute758cdac
RUN git checkout 758cdac
CHECK_EXIST $IFLOW_TOOLS/TritonRoute758cdac/build || RUN mkdir build
RUN cd build 
RUN cmake .. && make -j$THREAD_NUM
RUN cd $IFLOW_ROOT
    
# OpenROAD9295a533
CHECK_EXIST $IFLOW_TOOLS/OpenROAD9295a533 || RUN git clone https://github.com/The-OpenROAD-Project/OpenROAD.git tools/OpenROAD9295a533
RUN cd $IFLOW_TOOLS/OpenROAD9295a533 
RUN git checkout 9295a533 
RUN cd $IFLOW_TOOLS/OpenROAD9295a533/src
RUN git submodule update --init --recursive OpenSTA OpenDB flute3 replace ioPlacer FastRoute eigen TritonMacroPlace OpenRCX
CHECK_EXIST $IFLOW_TOOLS/OpenROAD9295a533/src/PDNSim || RUN git clone https://github.com/ZhishengZeng/PDNSim.git PDNSim
RUN cd $IFLOW_TOOLS/OpenROAD9295a533
CHECK_EXIST $IFLOW_TOOLS/OpenROAD9295a533/build || RUN mkdir build
RUN cd build && cmake .. && make -j$THREAD_NUM
RUN cd $IFLOW_ROOT

# OpenROADae191807
CHECK_EXIST $IFLOW_TOOLS/OpenROADae191807 || RUN git clone https://github.com/The-OpenROAD-Project/OpenROAD.git tools/OpenROADae191807
RUN cd $IFLOW_TOOLS/OpenROADae191807 
RUN git checkout ae191807  
RUN git submodule update --init --recursive
CHECK_EXIST $IFLOW_TOOLS/OpenROADae191807/build || RUN mkdir build
RUN cd build && cmake .. && make -j$THREAD_NUM
RUN cd $IFLOW_ROOT

echo ""
echo "************************************"
echo "[iFlow Info] build checking... "
if (CHECK_EXIST /usr/local/include/lemon) && (CHECK_EXIST $IFLOW_ROOT/tools/yosys4be891e8) && (CHECK_EXIST $IFLOW_ROOT/tools/TritonRoute758cdac) && (CHECK_EXIST $IFLOW_ROOT/tools/OpenROAD9295a533) && (CHECK_EXIST $IFLOW_ROOT/tools/OpenROADae191807); then
    echo "[iFlow Info] build successful! "
else
    echo "[iFlow Info] build failed! "
fi
echo "************************************"
