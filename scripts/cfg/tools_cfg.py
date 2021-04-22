#!/usr/bin/python3
#--------------------------------------------------------------------------- 
#             Copyright 2021 PENG CHENG LABORATORY
#--------------------------------------------------------------------------- 
# Author      : liubojun
# Email       : liubj@pcl.ac.cn
# Date        : 2021-04-06
# Project     : 
# Language    : Python
# Description : 
#--------------------------------------------------------------------------- 
import sys
import os
import subprocess
import re
from   data_def import *

tool1  = Tools(
        ('synth',),
        'yosys_0.9',
        '../../../iFlow/tools/yosys4be891e8/build/yosys')
tool2  = Tools(
        ('floorplan','tapcell','pdn','gplace','resize','dplace','cts','filler','groute'),   
        'openroad_1.1.0',
        '../../../iFlow/tools/OpenROAD9295a533/build/src/openroad')
tool3  = Tools(
        ('floorplan','tapcell','pdn','gplace','resize','dplace','cts','filler','groute'),   
        'openroad_1.2.0',
        '../../../iFlow/tools/OpenROADae191807/build/src/openroad')
tool4  = Tools(
        ('droute',),   
        'TritonRoute_1.0',
        '../../../iFlow/tools/TritonRoute758cdac/build/TritonRoute')
tool5  = Tools(
        ('droute',),   
        'TritonRoute_1.1',
        '../../../iFlow/TritonRoute')
tool6  = Tools(
        ('layout',),   
        'klayout_0.26.2',
        '/usr/bin/klayout')

