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

class Foundry(object):
    all_object = ()
    def __init__(self,name,lib={},lef={},gds={}):
        self.name   = name
        self.lib    = lib
        self.lef    = lef
        self.gds    = gds
        Foundry.all_object += (self,)

    def get_libs(name):
        for obj in Foundry.all_object :
            if name == obj.name :
                return obj.lib

    def get_lefs(name):
        for obj in Foundry.all_object :
            if name == obj.name :
                return obj.lef

    def get_gds(name):
        for obj in Foundry.all_object :
            if name == obj.name :
                return obj.gds

    def get_track(name):
        for obj in Foundry.all_object :
            if name == obj.name :
                return list(dict.fromkeys([re.search(r'std,(\w+),\w+', key).group(1) for key in obj.lib if re.search(r'std,(\w+),\w+', key)]))
                    
    def get_corner(name):
        for obj in Foundry.all_object :
            if name == obj.name :
                return list(dict.fromkeys([re.search(r'std,\w+,(\w+)$', key).group(1) for key in obj.lib if re.search(r'std,\w+,(\w+)$', key)]))
        
class Tools(object):
    all_object = ()
    def __init__(self,step,tool_name,path):
        self.step       = step
        self.tool_name  = tool_name
        self.path       = path
        Tools.all_object += (self,)

    def get_path(tool_name):
        for obj in Tools.all_object :
            if tool_name == obj.tool_name:
                return obj.path

    def get_step(tool_name):
        for obj in Tools.all_object :
            if tool_name == obj.tool_name:
                return obj.step

    def get_tools_for_step(step_name):
        tools_found = ()
        for obj in Tools.all_object :
            for astep in obj.step :
                if step_name == astep : 
                    tools_found += (obj.tool_name,)
        return tools_found

    def tool_step_info(tool_name,step_name):
        tool_include_step_flag = 0
        for obj in Tools.all_object :
            if tool_name == obj.tool_name:
                for astep in obj.step :
                    if step_name == astep :
                        tool_include_step_flag = 1
        return tool_include_step_flag

    def get_cmd_format(tool_name):
        for obj in Tools.all_object :
            if tool_name == obj.tool_name:
                return obj.cmd_format

    def list_tools():
        for obj in Tools.all_object :
            print(obj.tool_name, obj.path)

    def get_obj(tool_name):
        for obj in Tools.all_object :
            if tool_name == obj.tool_name :
                return obj

class Flow(object):
    all_object = ()

    def __init__(self,design,default_foundry,default_track,default_corner):
        self.design             = design
        self.default_foundry    = default_foundry
        self.default_track      = default_track
        self.default_corner     = default_corner
        self.step           = ('synth','floorplan','tapcell','pdn','gplace','resize','dplace','cts','filler','groute','droute','layout')
        self.tool           = {
            'synth'     :   'yosys_0.9'         ,
            'floorplan' :   'openroad_1.1.0'    ,
            'tapcell'   :   'openroad_1.1.0'    ,
            'pdn'       :   'openroad_1.1.0'    ,
            'gplace'    :   'openroad_1.1.0'    ,
            'resize'    :   'openroad_1.1.0'    ,
            'dplace'    :   'openroad_1.1.0'    ,
            'cts'       :   'openroad_0.9.0'    ,
            'filler'    :   'openroad_1.1.0'    ,
            'groute'    :   'openroad_1.1.0'    ,
            'droute'    :   'TritonRoute_1.0'   ,
            'layout'    :   'klayout_0.26.2'   
        }
        Flow.all_object    += (self,)

    def get_step(design):
        for obj in Flow.all_object :
            if design == obj.design :
                return obj.step

    def get_tool(design):
        for obj in Flow.all_object :
            if design == obj.design :
                return obj.tool

    def get_obj(design):
        for obj in Flow.all_object :
            if design == obj.design :
                return obj

