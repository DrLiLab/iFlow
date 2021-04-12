#===========================================================
#   set environment variable
#===========================================================
source ../../scripts/common/set_env.tcl

#===========================================================
#   set tool related parameter
#===========================================================

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

# Report timing before CTS
puts "\n=========================================================================="
puts "report_checks"
puts "--------------------------------------------------------------------------"
report_checks

# Run CTS
#clock_tree_synthesis -lut_file "$RESULT_PATH/lut.txt" \
#                     -sol_list "$RESULT_PATH/sol_list.txt" \
#                     -root_buf "$CTS_BUF_CELL" \
#                     -wire_unit 20
configure_cts_characterization     \
    -sqr_cap  2.60e-2 \
    -sqr_res  0.7 \
    -max_cap 5.0e-12 \
    -max_slew  5.0e-10 \

    #-cap_inter  1.6e-12 \
    #-slew_inter 4.0e-10 

clock_tree_synthesis \
    -buf_list {LVT_CLKBUFHDV4} \
    -root_buf {LVT_CLKBUFHDV12} \
    -out_path $RESULT_PATH/

set_placement_padding -global -left 2 -right 2
detailed_placement
check_placement

# write output
write_def       $RESULT_PATH/$DESIGN.def
write_verilog   $RESULT_PATH/$DESIGN.v
exit

