#===========================================================
#   set environment variable
#===========================================================
source ../../scripts/common/set_env.tcl

#===========================================================
#   set tool related parameter
#===========================================================
set MERGED_LIB_FILE         "$PROJ_PATH/foundry/$FOUNDRY/lib/merged.lib"
set BLACKBOX_V_FILE         "$PROJ_PATH/foundry/$FOUNDRY/verilog/std_blackbox.v" 
#set VERILOG_TOP_PARAMS      ""
set CLKGATE_MAP_FILE        "$PROJ_PATH/foundry/$FOUNDRY/verilog/cells_clkgate.v" 
set LATCH_MAP_FILE          "$PROJ_PATH/foundry/$FOUNDRY/verilog/cells_latch.v" 
set BLACKBOX_MAP_TCL        "$PROJ_PATH/foundry/$FOUNDRY/blackbox_map.tcl" 
set CLOCK_PERIOD            "5.0" 
set TIEHI_CELL_AND_PORT     "LVT_PULLHD1 Z" 
set TIELO_CELL_AND_PORT     "LVT_PULLHD0 Z" 
set MIN_BUF_CELL_AND_PORTS  "LVT_BUFHDV1 I Z" 

#===========================================================
#   main running
#===========================================================
yosys -import

# Don't change these unless you know what you are doing
set stat_ext    "_stat.rep"
set gl_ext      "_gl.v"
set abc_script  "+read_constr,$SDC_FILE;strash;ifraig;retime,-D,{D},-M,6;strash;dch,-f;map,-p,-M,1,{D},-f;topo;dnsize;buffer,-p;upsize;"

# Setup verilog include directories
set vIdirsArgs ""
set VERILOG_INCLUDE_DIRS "\
$RTL_PATH/amba/rtl \
$RTL_PATH/top \
$RTL_PATH/dev/sdcard/rtl \
$RTL_PATH/dev/ethmac/rtl \
$RTL_PATH/dev/spi/rtl \
$RTL_PATH/dev/uart/rtl \
"

if {[info exist VERILOG_INCLUDE_DIRS]} {
  foreach dir $VERILOG_INCLUDE_DIRS {
    lappend vIdirsArgs "-I$dir"
  }
  set vIdirsArgs [join $vIdirsArgs]
}

set VERILOG_FILES " \
$RTL_PATH/dev/ethmac/rtl/ethmac_defines.v \
$RTL_PATH/dev/sdcard/rtl/sd_defines.v \
$RTL_PATH/amba/rtl/amba_define.v \
$RTL_PATH/top/global_define.v \
$RTL_PATH/top/soc_asic_top.v \
$RTL_PATH/top/soc_top.v \
$RTL_PATH/cpu/Top.v \
$RTL_PATH/dev/sdram/rtl/sdram_top.v \
$RTL_PATH/dev/sdram/rtl/sdram_apb_slave.v \
$RTL_PATH/dev/sdram/rtl/sdram_axi.v \
$RTL_PATH/dev/sdram/rtl/sdram_axi_core.v \
$RTL_PATH/dev/sdram/rtl/sdram_axi_pmem.v \
$RTL_PATH/dev/sdcard/rtl/sd_bd.v \
$RTL_PATH/dev/sdcard/rtl/sd_cmd_serial_host.v \
$RTL_PATH/dev/sdcard/rtl/sd_crc_7.v \
$RTL_PATH/dev/sdcard/rtl/sd_rx_fifo.v \
$RTL_PATH/dev/sdcard/rtl/sdc_controller.v \
$RTL_PATH/dev/sdcard/rtl/sd_clock_divider.v \
$RTL_PATH/dev/sdcard/rtl/sd_controller_wb.v \
$RTL_PATH/dev/sdcard/rtl/sd_data_master.v \
$RTL_PATH/dev/sdcard/rtl/sd_fifo_rx_filler.v \
$RTL_PATH/dev/sdcard/rtl/sdc_controller_apb.v \
$RTL_PATH/dev/sdcard/rtl/sd_cmd_master.v \
$RTL_PATH/dev/sdcard/rtl/sd_crc_16.v \
$RTL_PATH/dev/sdcard/rtl/sd_data_serial_host.v \
$RTL_PATH/dev/sdcard/rtl/sd_fifo_tx_filler.v \
$RTL_PATH/dev/sdcard/rtl/sd_tx_fifo.v \
$RTL_PATH/dev/ethmac/rtl/eth_clockgen.v \
$RTL_PATH/dev/ethmac/rtl/eth_maccontrol.v \
$RTL_PATH/dev/ethmac/rtl/eth_random.v \
$RTL_PATH/dev/ethmac/rtl/eth_rxaddrcheck.v \
$RTL_PATH/dev/ethmac/rtl/eth_shiftreg.v \
$RTL_PATH/dev/ethmac/rtl/eth_txethmac.v \
$RTL_PATH/dev/ethmac/rtl/ethmac_apb.v \
$RTL_PATH/dev/ethmac/rtl/eth_cop.v \
$RTL_PATH/dev/ethmac/rtl/eth_macstatus.v \
$RTL_PATH/dev/ethmac/rtl/eth_receivecontrol.v \
$RTL_PATH/dev/ethmac/rtl/eth_rxcounters.v \
$RTL_PATH/dev/ethmac/rtl/eth_spram_256x32.v \
$RTL_PATH/dev/ethmac/rtl/eth_txstatem.v \
$RTL_PATH/dev/ethmac/rtl/eth_crc.v \
$RTL_PATH/dev/ethmac/rtl/eth_miim.v \
$RTL_PATH/dev/ethmac/rtl/eth_register.v \
$RTL_PATH/dev/ethmac/rtl/eth_rxethmac.v \
$RTL_PATH/dev/ethmac/rtl/eth_transmitcontrol.v \
$RTL_PATH/dev/ethmac/rtl/eth_wishbone.v \
$RTL_PATH/dev/ethmac/rtl/eth_fifo.v \
$RTL_PATH/dev/ethmac/rtl/eth_outputcontrol.v \
$RTL_PATH/dev/ethmac/rtl/eth_registers.v \
$RTL_PATH/dev/ethmac/rtl/eth_rxstatem.v \
$RTL_PATH/dev/ethmac/rtl/eth_txcounters.v \
$RTL_PATH/dev/ethmac/rtl/ethmac.v \
$RTL_PATH/dev/ethmac/rtl/rmii/ethmac_rmii_apb.v \
$RTL_PATH/dev/ethmac/rtl/rmii/mii2rmii.v \
$RTL_PATH/dev/ethmac/rtl/smii/ethmac_smii_apb.v \
$RTL_PATH/dev/ethmac/rtl/smii/smii_base.v \
$RTL_PATH/dev/ethmac/rtl/smii/smii.v \
$RTL_PATH/dev/ethmac/rtl/smii/smii-duty-low/smii_top.v \
$RTL_PATH/dev/ethmac/rtl/smii/smii-duty-low/smii_if.v \
$RTL_PATH/dev/ethmac/rtl/smii/smii-duty-low/smii_sync.v \
$RTL_PATH/dev/uart/rtl/uart_apb.v \
$RTL_PATH/dev/gpio/rtl/gpio_apb.v \
$RTL_PATH/dev/gpio/rtl/gpio_top.v \
$RTL_PATH/amba/rtl/apb_mux.v \
$RTL_PATH/amba/rtl/apb_demux.v \
$RTL_PATH/amba/rtl/axi2apb.v \
$RTL_PATH/amba/rtl/axi_afifo.v \
$RTL_PATH/amba/rtl/async_fifo.v \
$RTL_PATH/amba/rtl/async_fifo_org.v \
$RTL_PATH/amba/rtl/apb_afifo.v \
$RTL_PATH/amba/rtl/apb2axi.v \
$RTL_PATH/dev/spi/rtl/spi_defines.v \
$RTL_PATH/dev/spi/rtl/spi_clgen.v \
$RTL_PATH/dev/spi/rtl/spi_shift.v \
$RTL_PATH/dev/spi/rtl/spi_top.v \
$RTL_PATH/dev/spi/rtl/spi_flash.v \
"

# read verilog files
foreach file $VERILOG_FILES {
  read_verilog -sv {*}$vIdirsArgs $file
}


# Read blackbox stubs of standard cells. This allows for standard cell (or
# structural netlist support in the input verilog
read_verilog $BLACKBOX_V_FILE

# Apply toplevel parameters (if exist
if {[info exist VERILOG_TOP_PARAMS]} {
  dict for {key value} $VERILOG_TOP_PARAMS {
    chparam -set $key $value $DESIGN
  }
}


# Read platform specific mapfile for OPENROAD_CLKGATE cells
if {[info exist CLKGATE_MAP_FILE]} {
  read_verilog $CLKGATE_MAP_FILE
}

# Use hierarchy to automatically generate blackboxes for known memory macro.
# Pins are enumerated for proper mapping
if {[info exist BLACKBOX_MAP_TCL]} {
  source $BLACKBOX_MAP_TCL
}

# generic synthesis
#synth  -top $DESIGN -flatten
synth  -top $DESIGN

# Optimize the design
opt -purge  

# technology mapping of latches
if {[info exist LATCH_MAP_FILE]} {
  techmap -map $LATCH_MAP_FILE
}

# technology mapping of flip-flops
dfflibmap -liberty $MERGED_LIB_FILE
opt -undriven

# Technology mapping for cells
abc -D [expr $CLOCK_PERIOD * 1000] \
    -constr "$SDC_FILE" \
    -liberty $MERGED_LIB_FILE \
    -script $abc_script \
    -showtmp

# technology mapping of constant hi- and/or lo-drivers
hilomap -singleton \
        -hicell {*}$TIEHI_CELL_AND_PORT \
        -locell {*}$TIELO_CELL_AND_PORT

# replace undef values with defined constants
setundef -zero

# Splitting nets resolves unwanted compound assign statements in netlist (assign {..} = {..}
splitnets

# insert buffer cells for pass through wires
insbuf -buf {*}$MIN_BUF_CELL_AND_PORTS

# remove unused cells and wires
opt_clean -purge

# reports
tee -o $RPT_PATH/synth_check.txt check
tee -o $RPT_PATH/synth_stat.txt stat -liberty $MERGED_LIB_FILE

# write synthesized design
#write_verilog -norename -noattr -noexpr -nohex -nodec $RESULTS_DIR/1_1_yosys.v
write_verilog -noattr -noexpr -nohex -nodec $RESULT_PATH/$DESIGN.v















