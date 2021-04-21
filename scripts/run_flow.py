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
import argparse
sys.path.insert(0,os.path.abspath('.')+'/cfg')
from flow_cfg     import *
from tools_cfg    import *
from foundry_cfg  import *

# Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='For Iflow running')
parser.add_argument('--design',  '-d', required=True,
        help='Design name')
parser.add_argument('--step',  '-s', required=True,
        help='Flow step, such as '+' '.join(Flow.all_object[0].step))
parser.add_argument('--prestep',  '-p', default='',
        help='Previous step ')
parser.add_argument('--foundry', '-f', default='',
        help='Foundry selection, such as '+' '.join([obj.name for obj in Foundry.all_object]))
parser.add_argument('--track', '-t', default='',
        help='Standard cell track selection, '+'; '.join([obj.name+' ['+' '.join(Foundry.get_track(obj.name))+']' for obj in Foundry.all_object]))
parser.add_argument('--corner', '-c', default='',
        help='Corner selection, '+'; '.join([obj.name+' ['+' '.join(Foundry.get_corner(obj.name))+']' for obj in Foundry.all_object]))
parser.add_argument('--version', '-v', default='default',
        help='Append version name to the end of log/result/rpt')
parser.add_argument('--preversion', '-l', default='default',
        help='Version of prestep')
args = parser.parse_args()


if args.foundry == '' :
    foundry_sel = Flow.get_obj(args.design).default_foundry
else : 
    foundry_sel = args.foundry

if args.track == '' :
    track_sel = Flow.get_obj(args.design).default_track
else : 
    track_sel = args.track

if args.corner == '' :
    corner_sel = Flow.get_obj(args.design).default_corner
else : 
    corner_sel = args.corner

prestep_sel     = ''
pre_tool_name   = ''

proj_path = os.path.abspath('..')
for astep in args.step.split(',') :
    match_obj = re.search(r'(\w+)=([\w.]+)',astep)
    if match_obj :
        astep         = match_obj.group(1)
        cur_tool_name = match_obj.group(2)
        if Tools.tool_step_info(cur_tool_name,astep) :
            pass
        else :
            print('Error: '+astep+' cannot use '+cur_tool_name)
            print('The available tool for '+astep+' is '+','.join(Tools.get_tools_for_step(astep)))
            exit()
    else :
        cur_tool_name = Flow.get_tool(args.design)[astep]
        
    if  prestep_sel == '' :
        if args.prestep == '' :
            step_index = Flow.get_obj(args.design).step.index(astep)
            if step_index >= 1 :
                prestep_sel = Flow.get_obj(args.design).step[step_index-1]
                pre_tool_name = Flow.get_tool(args.design)[prestep_sel]
        else :
            match_obj = re.search(r'(\w+)=([\w.]+)',args.prestep)
            if match_obj : 
                prestep_sel      = match_obj.group(1)
                pre_tool_name    = match_obj.group(2)
            else :
                prestep_sel      = args.prestep
                pre_tool_name    = Flow.get_tool(args.design)[prestep_sel]

    expaned_name        = '.'.join((args.design,astep,cur_tool_name,track_sel,corner_sel,args.version))
    pre_expaned_name    = '.'.join((args.design,prestep_sel,pre_tool_name,track_sel,corner_sel,args.preversion))
    print('Current  full name : '+expaned_name)
    print('Previous full name : '+pre_expaned_name+'\n')
    
    #===========================================================
    #   set environment variable and create paths
    #===========================================================
    os.environ['IFLOW_PROJ_PATH']       = proj_path      
    os.environ['IFLOW_DESIGN']          = args.design      
    os.environ['IFLOW_STEP']            = astep            
    os.environ['IFLOW_PRESTEP']         = prestep_sel      
    os.environ['IFLOW_FOUNDRY']         = foundry_sel      
    os.environ['IFLOW_TRACK']           = track_sel        
    os.environ['IFLOW_CORNER']          = corner_sel       
    os.environ['IFLOW_VERSION']         = args.version     
    os.environ['IFLOW_PRESTEPVERSION']  = args.preversion 
    os.environ['IFLOW_WORK_PATH']       = proj_path+'/work/'+expaned_name
    os.environ['IFLOW_RPT_PATH']        = proj_path+'/report/'+expaned_name
    os.environ['IFLOW_RESULT_PATH']     = proj_path+'/result/'+expaned_name
    os.environ['IFLOW_PRE_RESULT_PATH'] = proj_path+'/result/'+pre_expaned_name
    os.environ['IFLOW_RTL_PATH']        = proj_path+'/rtl/'+args.design
    os.environ['IFLOW_SDC_FILE']        = proj_path+'/rtl/'+args.design+'/'+args.design+'.sdc'
    os.environ['IFLOW_LIB_FILES']       = ' '.join(Foundry.get_libs(foundry_sel)['std,'+track_sel+','+corner_sel]+
                                                   Foundry.get_libs(foundry_sel)['macro,'+corner_sel])
    os.environ['IFLOW_LEF_FILES']       = ' '.join(Foundry.get_lefs(foundry_sel)['tech']+
                                                   Foundry.get_lefs(foundry_sel)['std,'+track_sel]+
                                                   Foundry.get_lefs(foundry_sel)['macro'])
    os.environ['IFLOW_GDS_FILES']       = ' '.join(Foundry.get_gds(foundry_sel)['std,'+track_sel]+
                                                   Foundry.get_gds(foundry_sel)['macro'])

    os.system('mkdir -p '+os.environ['IFLOW_WORK_PATH'])
    os.system('mkdir -p '+os.environ['IFLOW_RPT_PATH'])
    os.system('mkdir -p '+os.environ['IFLOW_RESULT_PATH'])

    log_file = proj_path+'/log/'+expaned_name+'.log'
    os.system('echo '+' '.join(sys.argv)+' > '+log_file)
    for key in os.environ :
        if re.match('IFLOW',key) :
            os.system('echo '+key+' : '+os.environ[key]+' >> '+log_file)
    
    #===========================================================
    #   step pre-processing; step run; step post-processing
    #===========================================================
    os.chdir(os.environ['IFLOW_WORK_PATH'])

    # pre-processing
    if re.search('yosys',Flow.get_tool(args.design)[astep]) :
        os.system(proj_path+'/scripts/common/mergeLib.pl '+foundry_sel+'_merged '+
            os.environ['IFLOW_LIB_FILES']+
            ' > '+proj_path+'/foundry/'+foundry_sel+'/lib/merged.lib.tmp')
        os.system(proj_path+'/scripts/common/removeDontUse.pl '+
            proj_path+'/foundry/'+foundry_sel+'/lib/merged.lib.tmp "'+
            Foundry.get_libs(foundry_sel)['dontuse']+'"'+
            ' > '+proj_path+'/foundry/'+foundry_sel+'/lib/merged.lib')
        pass
    elif re.search('TritonRoute',Flow.get_tool(args.design)[astep]) :
        os.system(proj_path+'/scripts/common/mergeLef.py '+
            ' --inputLef '+os.environ['IFLOW_LEF_FILES']+
            ' --outputLef '+proj_path+'/foundry/'+foundry_sel+'/lef/merged_spacing.lef')
        os.system(proj_path+'/scripts/common/modifyLefSpacing.py '+
            ' -i '+proj_path+'/foundry/'+foundry_sel+'/lef/merged_spacing.lef'+
            ' -o '+proj_path+'/foundry/'+foundry_sel+'/lef/merged_spacing.lef')

    # step run
    if re.search('TritonRoute',Flow.get_tool(args.design)[astep]) :
        os.system(Tools.get_path(cur_tool_name)+
            ' -lef '+proj_path+'/foundry/'+foundry_sel+'/lef/merged_spacing.lef'+
            ' -def '+os.environ['IFLOW_PRE_RESULT_PATH']+'/'+args.design+'.def'+
            ' -guide '+os.environ['IFLOW_PRE_RESULT_PATH']+'/'+'route.guide'+
            ' -output '+os.environ['IFLOW_RESULT_PATH']+'/'+args.design+'.def'+
            ' -threads 8'+
            ' -verbose 1'+' | tee -ia '+log_file)
    elif re.search('layout',Flow.get_tool(args.design)[astep]) :
        os.system(proj_path+'/scripts/common/klayoutInsertLef.py '+
            ' -i '+proj_path+'/foundry/'+foundry_sel+'/klayout.lyt'+
            ' -l "'+os.environ['IFLOW_LEF_FILES']+'"'+
            ' -o '+'./klayout.lyt')
        os.system(Tools.get_path(cur_tool_name)+' -zz'
            ' -rd design_name='+args.design+
            ' -rd in_def='+os.environ['IFLOW_PRE_RESULT_PATH']+'/'+args.design+'.def'+
            ' -rd in_gds="'+os.environ['IFLOW_GDS_FILES']+'"'
            ' -rd out_gds='+os.environ['IFLOW_RESULT_PATH']+'/'+args.design+'.gds'+
            ' -rd tech_file='+'./klayout.lyt'+
            ' -rd config_file='+'"" '+
            ' -rd seal_gds='+'"" '+
            ' -rm '+proj_path+'/scripts/common/def2gds.py'+' | tee -ia '+log_file)
        os.system(Tools.get_path(cur_tool_name)+' '+
            ' -l '+proj_path+'/foundry/'+foundry_sel+'/klayout.lyp'+
            ' '+os.environ['IFLOW_RESULT_PATH']+'/'+args.design+'.gds &')
        
    else :
        os.system(Tools.get_path(cur_tool_name)+' '+proj_path+'/scripts/'+
            args.design+'/'+astep+'.'+cur_tool_name+'.tcl'+' | tee -ia '+log_file)
        

    prestep_sel     = astep
    pre_tool_name   = cur_tool_name
    args.preversion = args.version


