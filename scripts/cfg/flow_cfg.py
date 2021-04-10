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

coosa           = Flow('soc_asic_top','smic110','HD','MAX')
design_b_top    = Flow('DESIGN_B_TOP','smic55','HD','MAX')
design_b_crg    = Flow('design_b_crg','smic55','HD','MAX')
coyote_tc       = Flow('coyote_tc','sky130','HS','TYP')

