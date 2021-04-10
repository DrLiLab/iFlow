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
        '/Project/liubojun/iFlow/tools/yosys/bin/yosys')
tool2  = Tools(
        ('floorplan','tapcell','pdn','gplace','resize','dplace','cts','filler','groute'),   
        'openroad_1.1.0',
        '/Project/liubojun/iFlow/tools/OpenROAD/src/openroad')
tool3  = Tools(
        ('floorplan','tapcell','pdn','gplace','resize','dplace','cts','filler','groute'),   
        'openroad_0.9.0',
        '/Project/liubojun/iFlow/tools/OpenROAD_fixcts/src/openroad')
tool4  = Tools(
        ('droute'),   
        'TritonRoute_1.0',
        '/Project/liubojun/iFlow/tools/TritonRoute/TritonRoute')
tool4  = Tools(
        ('layout'),   
        'klayout_0.26.2',
        '/usr/bin/klayout')

