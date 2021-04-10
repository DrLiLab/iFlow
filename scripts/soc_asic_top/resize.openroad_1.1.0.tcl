#===========================================================
#   set environment variable
#===========================================================
source ../../scripts/common/set_env.tcl

#===========================================================
#   set tool related parameter
#===========================================================
set WIRE_RC_LAYER       "METAL3"
set MAX_FANOUT          "32" 
set TIEHI_CELL_AND_PORT "HVT_PULLHD1 Z" 
set TIELO_CELL_AND_PORT "HVT_PULLHD0 Z" 

#===========================================================
#   main running
#===========================================================
# Read lef
foreach lef $LEF_FILES {
    read_lef $lef
}

# Read liberty files
foreach libFile $LIB_FILES {
    read_liberty $libFile
}

# Read def file
read_def $PRE_RESULT_PATH/$DESIGN.def
# Read sdc file
read_sdc $SDC_FILE

# Set res and cap
set_wire_rc -layer $WIRE_RC_LAYER

# pre report
log_begin $RPT_PATH/pre_resize.rpt

puts "\n=========================================================================="
puts "report_checks"
puts "--------------------------------------------------------------------------"
report_checks

puts "\n=========================================================================="
puts "report_tns"
puts "--------------------------------------------------------------------------"
report_tns

puts "\n=========================================================================="
puts "report_wns"
puts "--------------------------------------------------------------------------"
report_wns

puts "\n=========================================================================="
puts "report_design_area"
puts "--------------------------------------------------------------------------"
report_design_area
#log_end

# Set the dont use list
#set dont_use_cells ""
#foreach cell $DONT_USE_CELLS {
#    lappend dont_use_cells [get_full_name [get_lib_cells */$cell]]
#}

# Set the buffer cell
set buffer_cell [get_lib_cell */LVT_BUFHDV16]

# Do not buffer chip-level designs
#puts "Perform port buffering..."
#buffer_ports -buffer_cell $buffer_cell

# Perform resizing
puts "Perform resizing..."
#resize -resize -dont_use $dont_use_cells
#resize -resize -dont_use {*/*DEL* */*V0 */*V1}

# Repair max cap
puts "Repair max cap..."
repair_max_cap -buffer_cell $buffer_cell

# Repair max slew
puts "Repair max slew..."
repair_max_slew -buffer_cell $buffer_cell

# Repair tie lo fanout
puts "Repair tie lo fanout..."
puts "******************************************"
set tielo_cell_name [lindex $TIELO_CELL_AND_PORT 0]
puts "******************************************"
set tielo_lib_name [get_name [get_property [get_lib_cell */$tielo_cell_name] library]]
set tielo_pin $tielo_lib_name/$tielo_cell_name/[lindex $TIELO_CELL_AND_PORT 1]
repair_tie_fanout -max_fanout 1 $tielo_pin

# Repair tie hi fanout
puts "Repair tie hi fanout..."
set tiehi_cell_name [lindex $TIEHI_CELL_AND_PORT 0]
set tiehi_lib_name [get_name [get_property [get_lib_cell */$tiehi_cell_name] library]]
set tiehi_pin $tiehi_lib_name/$tiehi_cell_name/[lindex $TIEHI_CELL_AND_PORT 1]
repair_tie_fanout -max_fanout 1 $tiehi_pin

# Repair max fanout
puts "Repair max fanout..."
repair_max_fanout -max_fanout $MAX_FANOUT -buffer_cell $buffer_cell

# Repair hold
#puts "Repair hold"
#repair_hold_violations -buffer_cell $buffer_cell

# post report
log_begin $RPT_PATH/post_resize.rpt

puts "\n=========================================================================="
puts "report_floating_nets"
puts "--------------------------------------------------------------------------"
report_floating_nets

puts "\n=========================================================================="
puts "report_checks"
puts "--------------------------------------------------------------------------"
report_checks

puts "\n=========================================================================="
puts "report_tns"
puts "--------------------------------------------------------------------------"
report_tns

puts "\n=========================================================================="
puts "report_wns"
puts "--------------------------------------------------------------------------"
report_wns

puts "\n=========================================================================="
puts "report_design_area"
puts "--------------------------------------------------------------------------"
report_design_area

log_end

# write output
write_def       $RESULT_PATH/$DESIGN.def
write_verilog   $RESULT_PATH/$DESIGN.v
exit

