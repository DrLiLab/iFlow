#===========================================================
#   set environment variable
#===========================================================
source ../../scripts/common/set_env.tcl

#===========================================================
#   set tool related parameter
#===========================================================
set WIRE_RC_LAYER   "METAL3"
set PLACE_DENSITY   "0.45"

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

set_wire_rc -layer $WIRE_RC_LAYER

global_placement -density $PLACE_DENSITY

global_placement -incremental -overflow 0.05 -density $PLACE_DENSITY

# write output
write_def       $RESULT_PATH/$DESIGN.def
write_verilog   $RESULT_PATH/$DESIGN.v
exit

