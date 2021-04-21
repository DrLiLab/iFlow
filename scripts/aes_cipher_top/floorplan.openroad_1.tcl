#===========================================================
#   set environment variable
#===========================================================
source ../../scripts/common/set_env.tcl

#===========================================================
#   set tool related parameter
#===========================================================
set SDC_FILE            "$RTL_PATH/${DESIGN}.openroad.sdc"
set DIE_AREA            "0.0    0.0    6480    6327" 
set CORE_AREA           "219.84 219.78 6260.16 6107.22" 
set TRACKS_INFO_FILE    "$PROJ_PATH/foundry/$FOUNDRY/tracks.info" 
set PLACE_SITE          "unit" 
#set IP_GLOBAL_CFG       "$PROJ_PATH/scripts/$DESIGN/IP_global.cfg"

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

# Read verilog
read_verilog $PRE_RESULT_PATH/$DESIGN.v

link_design $DESIGN
read_sdc $SDC_FILE

proc placeInst {inst_name ptx pty orient {lib_cell ""}} {
    set db [::ord::get_db]
    set tech [$db getTech]
    set block [[$db getChip] getBlock]
    if {[set inst [$block findInst $inst_name]] == "NULL"} {
        set inst [odb::dbInst_create $block [$db findMaster $lib_cell] $inst_name]
    }

    $inst setOrigin $ptx $pty
    $inst setOrient $orient
    $inst setPlacementStatus "FIRM"
}

proc placePort {port_name bd_box metal} {
    set db [::ord::get_db]
    set tech [$db getTech]
    set block [[$db getChip] getBlock]
    set layer [$tech findLayer $metal]
    set term [$block findBTerm $port_name]
    set pin [odb::dbBPin_create $term]
    odb::dbBox_create $pin $layer [lindex $bd_box 0] \
                                  [lindex $bd_box 1] \
                                  [lindex $bd_box 2] \
                                  [lindex $bd_box 3]
    $pin setPlacementStatus "FIRM"
}
proc placePadcell {port_name metal inst_pad_name ptx pty orient } {
    set db    [::ord::get_db]
    set tech  [$db getTech]
    set block [[$db getChip] getBlock]
    set layer [$tech findLayer $metal]
    set inst_name [regsub {/\w+\s*$} $inst_pad_name ""]
    set pad_name  [regsub {.*/} $inst_pad_name ""]
    if {[set term [$block findBTerm $port_name]] == "NULL"} {
        puts "Error: cannot find port : $port_name!\n"
        return
    }
    if {[set inst [$block findInst $inst_name]] == "NULL"} {
        puts "Error: cannot find inst : $inst_name!\n"
        return
    }
    set net [$term getNet]
    foreach iterm [$net getITerms] {
        $iterm setSpecial
    }
    $term setSpecial
    $net setSpecial

    set pin [odb::dbBPin_create $term]
    $inst setOrigin $ptx $pty
    $inst setOrient $orient
    $inst setPlacementStatus "FIRM"

    set mterm [[$inst getMaster] findMTerm $pad_name]
    set mpin [lindex [$mterm getMPins] 0]
    foreach geometry [$mpin getGeometry] {
        if {[[$geometry getTechLayer] getName] == $metal} {
            set pin_box [pdngen::transform_box [$geometry xMin] [$geometry yMin] [$geometry xMax] [$geometry yMax] [$inst getOrigin] [$inst getOrient]]
            odb::dbBox_create $pin $layer {*}$pin_box
            $pin setPlacementStatus "FIRM"
        }
    } 

}

# Initialize floorplan using ICeWall FOOTPRINT
# ----------------------------------------------------------------------------
if {[info exists strategy_file]} {
    ICeWall load_footprint $strategy_file

    initialize_floorplan \
        -die_area  [ICeWall get_die_area] \
        -core_area [ICeWall get_core_area] \
        -tracks    [ICeWall get_tracks] \
        -site      $PLACE_SITE

    ICeWall init_footprint $sigmap_file

# Initialize floorplan using CORE_UTILIZATION
# ----------------------------------------------------------------------------
} elseif {[info exists CORE_UTILIZATION] && $CORE_UTILIZATION != "" } {
  initialize_floorplan -utilization $CORE_UTILIZATION \
                       -aspect_ratio $CORE_ASPECT_RATIO \
                       -core_space $CORE_MARGIN \
                       -tracks $TRACKS_INFO_FILE \
                       -site $PLACE_SITE

# Initialize floorplan using DIE_AREA/CORE_AREA
# ----------------------------------------------------------------------------
} else {
    initialize_floorplan -die_area $DIE_AREA \
                         -core_area $CORE_AREA \
                         -tracks $TRACKS_INFO_FILE \
                         -site $PLACE_SITE

    source $PROJ_PATH/scripts/$DESIGN/place_io_1.tcl
    source $PROJ_PATH/scripts/$DESIGN/place_block.tcl
}


# pre report
log_begin $RPT_PATH/init.rpt

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
#write_sdc      $RESULT_PATH/$DESIGN.sdc
exit

