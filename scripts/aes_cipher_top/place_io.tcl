#BOTTOM---------
placePort clk_i                     {1260000 60000 1262000 62000}  met5 ; placeInst  u_clk/u_in                   1220000  210965 MX ""
placePort reset_i                   {1360000 60000 1362000 62000}  met5 ; placeInst  u_reset/u_in                 1320000  210965 MX ""
placePort en_i                      {1460000 60000 1462000 62000}  met5 ; placeInst  u_en/u_in                    1420000  210965 MX ""
placePort rocc_cmd_ready_i          {1560000 60000 1562000 62000}  met5 ; placeInst  u_rocc_cmd_ready/u_in        1520000  210965 MX ""
placePort rocc_resp_v_i             {1660000 60000 1662000 62000}  met5 ; placeInst  u_rocc_resp_v/u_in           1620000  210965 MX ""
placePort rocc_mem_req_v_i          {1760000 60000 1762000 62000}  met5 ; placeInst  u_rocc_mem_req_v/u_in        1720000  210965 MX ""
placePort fsb_node_v_i              {1860000 60000 1862000 62000}  met5 ; placeInst  u_fsb_node_v_i/u_in          1820000  210965 MX ""
placePort fsb_node_yumi_i           {1960000 60000 1962000 62000}  met5 ; placeInst  u_fsb_node_yumi/u_in         1920000  210965 MX ""
placePort rocc_ctrl_i_busy_         {2060000 60000 2062000 62000}  met5 ; placeInst  u_rocc_ctrl_i_busy/u_in      2020000  210965 MX ""
placePort rocc_ctrl_i_interrupt_    {2160000 60000 2162000 62000}  met5 ; placeInst  u_rocc_ctrl_i_interrupt/u_in 2120000  210965 MX ""
for {set i 0} {$i < 8} {incr i 1} {
    placePort "rocc_resp_data_i\[$i\]" "[expr 2260000 + 100000*$i] 60000 [expr 2262000 + 100000*$i] 62000"  met5 
    placeInst "u_rocc_resp_data_i/u_io\\\[$i\\\]/u_in" [expr 2220000 + 100000*$i] 210965 MX ""
}
for {set i 0} {$i < 8} {incr i 1} {
    placePort "fsb_node_data_i\[$i\]" "[expr 3060000 + 100000*$i] 60000 [expr 3062000 + 100000*$i] 62000"  met5 
    placeInst "u_fsb_node_data_i/u_io\\\[$i\\\]/u_in" [expr 3020000 + 100000*$i] 210965 MX ""
}
for {set i 0} {$i < 16} {incr i 1} {
    placePort "rocc_cmd_data_o_${i}" "[expr 3860000 + 100000*$i] 60000 [expr 3862000 + 100000*$i] 62000"  met5 
    placeInst "u_rocc_cmd_data_o_${i}_/u_io" [expr 3820000 + 100000*$i] 210965 MX ""
}

#RIGHT--------
for {set i 0} {$i < 32} {incr i 1} {
    placePort "rocc_mem_req_data_i\[$i\]" "6418000 [expr 1340000 + 100000*$i] 6420000 [expr 1342000 + 100000*$i]"  met5 
    placeInst "u_rocc_mem_req_data_i/u_io\\\[$i\\\]/u_in" 6269035 [expr 1300000 + 100000*$i] MXR90 ""
}

placePort rocc_cmd_v_o              {6418000 4540000 6420000 4542000}  met5 ; placeInst  u_rocc_cmd_v/u_io              6269035 4500000 MXR90 ""
placePort rocc_resp_ready_o         {6418000 4640000 6420000 4642000}  met5 ; placeInst  u_rocc_resp_ready/u_io         6269035 4600000 MXR90 ""
placePort rocc_mem_req_ready_o      {6418000 4740000 6420000 4742000}  met5 ; placeInst  u_rocc_mem_req_ready/u_io      6269035 4700000 MXR90 ""
placePort rocc_mem_resp_v_o         {6418000 4840000 6420000 4842000}  met5 ; placeInst  u_rocc_mem_resp_v/u_io         6269035 4800000 MXR90 ""
placePort fsb_node_ready_o          {6418000 4940000 6420000 4942000}  met5 ; placeInst  u_fsb_node_ready/u_io          6269035 4900000 MXR90 ""
placePort fsb_node_v_o              {6418000 5040000 6420000 5042000}  met5 ; placeInst  u_fsb_node_v_o/u_io            6269035 5000000 MXR90 ""
placePort rocc_ctrl_o_s_            {6418000 5140000 6420000 5142000}  met5 ; placeInst  u_rocc_ctrl_o_s/u_io           6269035 5100000 MXR90 ""
placePort rocc_ctrl_o_exception_    {6418000 5240000 6420000 5242000}  met5 ; placeInst  u_rocc_ctrl_o_exception/u_io   6269035 5200000 MXR90 ""
placePort rocc_ctrl_o_host_id_      {6418000 5340000 6420000 5342000}  met5 ; placeInst  u_rocc_ctrl_o_host_id/u_io     6269035 5300000 MXR90 ""

#LEFT--------
for {set i 0} {$i < 40} {incr i 1} {
    placePort "rocc_mem_resp_data_o_$i" "60000 [expr 340000 + 140000*$i] 62000 [expr 342000 + 140000*$i]"  met5 
    placeInst "u_rocc_mem_resp_data_o_${i}_/u_io" 210965 [expr 300000 + 140000*$i] R90 ""
}

#TOP--------
for {set i 0} {$i < 24} {incr i 1} {
    placePort "rocc_mem_resp_data_o_[expr $i+40]" "[expr 1340000 + 100000*$i] 6265000 [expr 1342000 + 100000*$i] 6267000"  met5 
    placeInst "u_rocc_mem_resp_data_o_[expr $i+40]_/u_io" [expr 1300000 + 100000*$i] 6116035 R0 ""
}

for {set i 0} {$i < 8} {incr i 1} {
    placePort "fsb_node_data_o_$i" "[expr 4040000 + 100000*$i] 6265000 [expr 4042000 + 100000*$i] 6267000"  met5 
    placeInst "u_fsb_node_data_o_${i}_/u_io" [expr 4000000 + 100000*$i] 6116035 R0 ""
}

