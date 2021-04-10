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

# Read def files
read_def $PRE_RESULT_PATH/$DESIGN.def

tapcell \
    -endcap_cpp     "2" \
    -distance       32.5 \
    -tapcell_master "LVT_FILLTIEHD" \
    -endcap_master  "LVT_F_FILLHD1" \
    -halo_width_x   "30"    \
    -halo_width_y   "30"

# write output
write_def       $RESULT_PATH/$DESIGN.def
write_verilog   $RESULT_PATH/$DESIGN.v
exit

