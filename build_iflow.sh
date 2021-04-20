#!/bin/bash

function RUN()
{
    while [ 0 -eq 0 ]
    do
        $* 
        if [ $? -eq 0 ]; then
            break;
        else
            echo "EXEC COMMAND FAILED: '"$*"' retry..."
            sleep 1
        fi
    done
}

# env
IFLOW_ROOT=$(cd "$(dirname "$0")";pwd)

# essential package
RUN sudo apt install build-essential clang libreadline6-dev bison flex libffi-dev cmake libboost-all-dev swig klayout libeigen3-dev -y

exit(0)
# tcl
RUN sudo apt install tcl-dev -y
RUN sudo cp /usr/include/tcl8.6/*.h /usr/include/
RUN sudo ln -s /usr/lib/x86_64-linux-gnu/libtcl8.6.so /usr/lib/x86_64-linux-gnu/libtcl8.5.so

# lemon
RUN wget http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz 
RUN tar zxvf lemon-1.3.1.tar.gz
RUN cd lemon-1.3.1
RUN mkdir build && cd build && cmake .. && make && sudo make install
RUN cd $IFLOW_ROOT
RUN sudo rm -rf lemon-1.3.1 lemon-1.3.1.tar.gz

# yosys
RUN git clone https://github.com/The-OpenROAD-Project/yosys.git tools/yosys4be891e8
RUN cd $IFLOW_ROOT/tools/yosys4be891e8
RUN git checkout 4be891e8
RUN mkdir build && cd build
RUN make -f ../Makefile
RUN cd $IFLOW_ROOT

# TritonRoute
RUN git clone https://github.com/The-OpenROAD-Project/TritonRoute.git tools/TritonRoute758cdac
RUN cd $IFLOW_ROOT/tools/TritonRoute758cdac
RUN git checkout 758cdac
RUN mkdir build && cd build 
RUN cmake .. && make
RUN cd $IFLOW_ROOT

# OpenROAD
RUN git clone https://github.com/The-OpenROAD-Project/OpenROAD.git tools/OpenROAD9295a533 
RUN cd $IFLOW_ROOT/tools/OpenROAD9295a533 
RUN git checkout 9295a533 
RUN cd $IFLOW_ROOT/tools/OpenROAD9295a533/src
RUN git submodule update --init --recursive OpenSTA OpenDB flute3 replace ioPlacer FastRoute eigen TritonMacroPlace OpenRCX
RUN git clone https://github.com/ZhishengZeng/PDNSim.git PDNSim
RUN cd $IFLOW_ROOT/tools/OpenROAD9295a533
RUN mkdir build && cd build 
RUN cmake .. && make
RUN cd $IFLOW_ROOT
