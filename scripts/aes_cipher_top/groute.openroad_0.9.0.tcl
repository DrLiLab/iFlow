#===========================================================
#   set environment variable
#===========================================================
source ../../scripts/common/set_env.tcl

#===========================================================
#   set tool related parameter
#===========================================================
set SDC_FILE        "$RTL_PATH/${DESIGN}.openroad.sdc"
set MAX_ROUTING_LAYER   "6" 
set WIRE_RC_LAYER       "met3" 

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
# Read SDC file
read_sdc $SDC_FILE

set db      [::ord::get_db]
set block   [[$db getChip] getBlock]
set tech    [$db getTech]

set layer_M2 [$tech findLayer met2]
set layer_M3 [$tech findLayer met3]
set layer_M4 [$tech findLayer met4]
set layer_M5 [$tech findLayer met5]
set layer_M6 [$tech findLayer met6]
set layer_M7 [$tech findLayer met7]

set distance 500

set allInsts [$block getInsts]

set cnt 0

foreach inst $allInsts {
    set master [$inst getMaster]
    set name [$master getName]
    set loc_llx [lindex [$inst getLocation] 0]
    set loc_lly [lindex [$inst getLocation] 1]

    #[string match "S013PLL*" $name]||
    if {[string match "sky130_sram_1rw1r*" $name]} {
        puts "create route block around $name"
        set w [$master getWidth]
        set h [$master getHeight]
        puts "$name loc : $loc_llx $loc_lly"

        set llx_Mx [expr $loc_llx - $distance] 
        set lly_Mx [expr $loc_lly - $distance] 
        set urx_Mx [expr $loc_llx + $w + $distance] 
        set ury_Mx [expr $loc_lly + $h + $distance] 

        #set obs_M2 [odb::dbObstruction_create $block $layer_M2 $llx_Mx $lly_Mx $urx_Mx $ury_Mx]
        #set obs_M3 [odb::dbObstruction_create $block $layer_M3 $llx_Mx $lly_Mx $urx_Mx $ury_Mx]
        #set obs_M4 [odb::dbObstruction_create $block $layer_M4 $llx_Mx $lly_Mx $urx_Mx $ury_Mx]
        #set obs_M5 [odb::dbObstruction_create $block $layer_M5 $llx_Mx $lly_Mx $urx_Mx $ury_Mx]
        #set obs_M6 [odb::dbObstruction_create $block $layer_M6 $llx_Mx $lly_Mx $urx_Mx $ury_Mx]
        #set obs_M7 [odb::dbObstruction_create $block $layer_M7 $llx_Mx $lly_Mx $urx_Mx $ury_Mx]

        incr cnt
    }
}

if {$cnt != 0} {
    puts "\[INFO\] created $cnt routing blockages over macros"
}

set_global_routing_layer_adjustment $MAX_ROUTING_LAYER 0.5
fastroute -output_file $RESULT_PATH/route.guide \
          -report_congestion $RPT_PATH/congestion.rpt \
          -layer 2-$MAX_ROUTING_LAYER \
          -unidirectional_routing true \
          -overflow_iterations 200 \
          -verbose 2    \
          -allow_overflow

# write output
write_def       $RESULT_PATH/$DESIGN.def
write_verilog   $RESULT_PATH/$DESIGN.v
exit

