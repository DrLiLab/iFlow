placePadcell  clk_i                   met5  u_clk/u_in/PAD                    1220000  210965  MX
placePadcell  reset_i                 met5  u_reset/u_in/PAD                  1320000  210965  MX 
placePadcell  en_i                    met5  u_en/u_in/PAD                     1420000  210965  MX  
placePadcell  rocc_cmd_ready_i        met5  u_rocc_cmd_ready/u_in/PAD         1520000  210965  MX  
placePadcell  rocc_resp_v_i           met5  u_rocc_resp_v/u_in/PAD            1620000  210965  MX  
placePadcell  rocc_mem_req_v_i        met5  u_rocc_mem_req_v/u_in/PAD         1720000  210965  MX  
placePadcell  fsb_node_v_i            met5  u_fsb_node_v_i/u_in/PAD           1820000  210965  MX  
placePadcell  fsb_node_yumi_i         met5  u_fsb_node_yumi/u_in/PAD          1920000  210965  MX  
placePadcell  rocc_ctrl_i_busy_       met5  u_rocc_ctrl_i_busy/u_in/PAD       2020000  210965  MX  
placePadcell  rocc_ctrl_i_interrupt_  met5  u_rocc_ctrl_i_interrupt/u_in/PAD  2120000  210965  MX  
for {set i 0} {$i < 8} {incr i 1} {
    placePadcell "rocc_resp_data_i\[$i\]" met5 "u_rocc_resp_data_i/u_io\\\[$i\\\]/u_in/PAD" [expr 2220000 + 100000*$i] 210965 MX 
}
for {set i 0} {$i < 8} {incr i 1} {
    placePadcell "fsb_node_data_i\[$i\]" met5 "u_fsb_node_data_i/u_io\\\[$i\\\]/u_in/PAD" [expr 3020000 + 100000*$i] 210965 MX 
}
for {set i 0} {$i < 16} {incr i 1} {
    placePadcell "rocc_cmd_data_o_${i}" met5 "u_rocc_cmd_data_o_${i}_/u_io/PAD" [expr 3820000 + 100000*$i] 210965 MX 
}

#RIGHT--------
for {set i 0} {$i < 32} {incr i 1} {
    placePadcell "rocc_mem_req_data_i\[$i\]" met5 "u_rocc_mem_req_data_i/u_io\\\[$i\\\]/u_in/PAD" 6269035 [expr 1300000 + 100000*$i] MXR90 
}

placePadcell rocc_cmd_v_o           met5 u_rocc_cmd_v/u_io/PAD              6269035 4500000 MXR90 
placePadcell rocc_resp_ready_o      met5 u_rocc_resp_ready/u_io/PAD         6269035 4600000 MXR90 
placePadcell rocc_mem_req_ready_o   met5 u_rocc_mem_req_ready/u_io/PAD      6269035 4700000 MXR90 
placePadcell rocc_mem_resp_v_o      met5 u_rocc_mem_resp_v/u_io/PAD         6269035 4800000 MXR90 
placePadcell fsb_node_ready_o       met5 u_fsb_node_ready/u_io/PAD          6269035 4900000 MXR90 
placePadcell fsb_node_v_o           met5 u_fsb_node_v_o/u_io/PAD            6269035 5000000 MXR90 
placePadcell rocc_ctrl_o_s_         met5 u_rocc_ctrl_o_s/u_io/PAD           6269035 5100000 MXR90 
placePadcell rocc_ctrl_o_exception_ met5 u_rocc_ctrl_o_exception/u_io/PAD   6269035 5200000 MXR90 
placePadcell rocc_ctrl_o_host_id_   met5 u_rocc_ctrl_o_host_id/u_io/PAD     6269035 5300000 MXR90 

#LEFT--------
for {set i 0} {$i < 40} {incr i 1} {
    placePadcell "rocc_mem_resp_data_o_$i" met5 "u_rocc_mem_resp_data_o_${i}_/u_io/PAD" 210965 [expr 300000 + 140000*$i] R90 
}

#TOP--------
for {set i 0} {$i < 24} {incr i 1} {
    placePadcell "rocc_mem_resp_data_o_[expr $i+40]" met5 "u_rocc_mem_resp_data_o_[expr $i+40]_/u_io/PAD" [expr 1300000 + 100000*$i] 6116035 R0 
}

for {set i 0} {$i < 8} {incr i 1} {
    placePadcell "fsb_node_data_o_$i" met5 "u_fsb_node_data_o_${i}_/u_io/PAD" [expr 4000000 + 100000*$i] 6116035 R0 
}


