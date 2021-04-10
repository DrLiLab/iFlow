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
    $RTL_PATH/ips/apb/apb_event_unit/include \
"

if {[info exist VERILOG_INCLUDE_DIRS]} {
    foreach dir $VERILOG_INCLUDE_DIRS {
        lappend vIdirsArgs "-I$dir"
    }
    set vIdirsArgs [join $vIdirsArgs]
}

set VERILOG_FILES " \
$RTL_PATH/rtl/includes/config.sv \
$RTL_PATH/rtl/components/cluster_clock_gating.sv \
$RTL_PATH/rtl/components/generic_fifo.sv \
$RTL_PATH/rtl/components/rstgen.sv \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_axi_biu.sv \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_axi_module.sv \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_lint_biu.sv \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_lint_module.sv \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_crc32.v \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_or1k_biu.sv \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_or1k_module.sv \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_or1k_status_reg.sv \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_top.sv \
$RTL_PATH/ips/adv_dbg_if/rtl/bytefifo.v \
$RTL_PATH/ips/adv_dbg_if/rtl/syncflop.v \
$RTL_PATH/ips/adv_dbg_if/rtl/syncreg.v \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_tap_top.v \
$RTL_PATH/ips/adv_dbg_if/rtl/adv_dbg_if.sv \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_axionly_top.sv \
$RTL_PATH/ips/adv_dbg_if/rtl/adbg_lintonly_top.sv \
$RTL_PATH/ips/riscv/riscv_register_file.sv \
$RTL_PATH/ips/riscv/include/apu_core_package.sv \
$RTL_PATH/ips/riscv/include/riscv_defines.sv \
$RTL_PATH/ips/riscv/include/riscv_tracer_defines.sv \
$RTL_PATH/ips/riscv/riscv_alu.sv \
$RTL_PATH/ips/riscv/riscv_alu_basic.sv \
$RTL_PATH/ips/riscv/riscv_alu_div.sv \
$RTL_PATH/ips/riscv/riscv_compressed_decoder.sv \
$RTL_PATH/ips/riscv/riscv_controller.sv \
$RTL_PATH/ips/riscv/riscv_cs_registers.sv \
$RTL_PATH/ips/riscv/riscv_debug_unit.sv \
$RTL_PATH/ips/riscv/riscv_decoder.sv \
$RTL_PATH/ips/riscv/riscv_int_controller.sv \
$RTL_PATH/ips/riscv/riscv_ex_stage.sv \
$RTL_PATH/ips/riscv/riscv_hwloop_controller.sv \
$RTL_PATH/ips/riscv/riscv_hwloop_regs.sv \
$RTL_PATH/ips/riscv/riscv_id_stage.sv \
$RTL_PATH/ips/riscv/riscv_if_stage.sv \
$RTL_PATH/ips/riscv/riscv_load_store_unit.sv \
$RTL_PATH/ips/riscv/riscv_mult.sv \
$RTL_PATH/ips/riscv/riscv_prefetch_buffer.sv \
$RTL_PATH/ips/riscv/riscv_prefetch_L0_buffer.sv \
$RTL_PATH/ips/riscv/riscv_core.sv \
$RTL_PATH/ips/riscv/riscv_apu_disp.sv \
$RTL_PATH/ips/riscv/riscv_fetch_fifo.sv \
$RTL_PATH/ips/riscv/riscv_L0_buffer.sv \
$RTL_PATH/rtl/core_region.sv        \
$RTL_PATH/rtl/boot_rom_wrap.sv      \
$RTL_PATH/rtl/instr_ram_wrap.sv     \
$RTL_PATH/rtl/sp_ram_wrap.sv        \
$RTL_PATH/rtl/ram_mux.sv            \
$RTL_PATH/rtl/axi_node_intf_wrap.sv \
$RTL_PATH/rtl/pulpino_top.sv        \
$RTL_PATH/rtl/peripherals.sv        \
$RTL_PATH/rtl/periph_bus_wrap.sv    \
$RTL_PATH/rtl/axi2apb_wrap.sv       \
$RTL_PATH/rtl/axi_spi_slave_wrap.sv \
$RTL_PATH/rtl/axi_mem_if_SP_wrap.sv \
$RTL_PATH/rtl/axi_slice_wrap.sv     \
$RTL_PATH/rtl/core2axi_wrap.sv      \
\
$RTL_PATH/ips/apb/apb_uart/apb_uart.vhd \
$RTL_PATH/ips/apb/apb_uart/slib_clock_div.vhd \
$RTL_PATH/ips/apb/apb_uart/slib_counter.vhd \
$RTL_PATH/ips/apb/apb_uart/slib_edge_detect.vhd \
$RTL_PATH/ips/apb/apb_uart/slib_fifo.vhd \
$RTL_PATH/ips/apb/apb_uart/slib_input_filter.vhd \
$RTL_PATH/ips/apb/apb_uart/slib_input_sync.vhd \
$RTL_PATH/ips/apb/apb_uart/slib_mv_filter.vhd \
$RTL_PATH/ips/apb/apb_uart/uart_baudgen.vhd \
$RTL_PATH/ips/apb/apb_uart/uart_interrupt.vhd \
$RTL_PATH/ips/apb/apb_uart/uart_receiver.vhd \
$RTL_PATH/ips/apb/apb_uart/uart_transmitter.vhd \
\
$RTL_PATH/rtl/design_b_top.v \
$RTL_PATH/rtl/design_b_crg.v \
$RTL_PATH/rtl/components/pcl_clock_switch.v \
$RTL_PATH/rtl/components/pcl_sync_cell.v \
$RTL_PATH/rtl/components/std_wrap_delay.v \
$RTL_PATH/rtl/components/std_wrap_ckmux.v \
$RTL_PATH/rtl/components/std_wrap_ckinv.v \
$RTL_PATH/rtl/components/std_wrap_cknand.v \
$RTL_PATH/rtl/components/std_wrap_ckand.v \
$RTL_PATH/rtl/components/std_wrap_ckor.v \
$RTL_PATH/rtl/por_wrap.v \
"

#$RTL_PATH/ips/apb/apb2per/apb2per.sv \
#$RTL_PATH/ips/apb/apb_event_unit/include/defines_event_unit.sv \
#$RTL_PATH/ips/apb/apb_event_unit/apb_event_unit.sv \
#$RTL_PATH/ips/apb/apb_event_unit/generic_service_unit.sv \
#$RTL_PATH/ips/apb/apb_event_unit/sleep_unit.sv \
#$RTL_PATH/ips/apb/apb_pll_if/apb_pll_if.sv \
#$RTL_PATH/ips/apb/apb_gpio/apb_gpio.sv \
#$RTL_PATH/ips/apb/apb_i2c/apb_i2c.sv \
#$RTL_PATH/ips/apb/apb_i2c/i2c_master_bit_ctrl.sv \
#$RTL_PATH/ips/apb/apb_i2c/i2c_master_byte_ctrl.sv \
#$RTL_PATH/ips/apb/apb_i2c/i2c_master_defines.sv \
#$RTL_PATH/ips/apb/apb_node/apb_node.sv \
#$RTL_PATH/ips/apb/apb_node/apb_node_wrap.sv \
#$RTL_PATH/ips/apb/apb_pulpino/apb_pulpino.sv \
#$RTL_PATH/ips/apb/apb_spi_master/apb_spi_master.sv \
#$RTL_PATH/ips/apb/apb_spi_master/spi_master_apb_if.sv \
#$RTL_PATH/ips/apb/apb_spi_master/spi_master_clkgen.sv \
#$RTL_PATH/ips/apb/apb_spi_master/spi_master_controller.sv \
#$RTL_PATH/ips/apb/apb_spi_master/spi_master_fifo.sv \
#$RTL_PATH/ips/apb/apb_spi_master/spi_master_rx.sv \
#$RTL_PATH/ips/apb/apb_spi_master/spi_master_tx.sv \
#$RTL_PATH/ips/apb/apb_timer/apb_timer.sv \
#$RTL_PATH/ips/apb/apb_timer/timer.sv \
#$RTL_PATH/ips/axi/axi2apb/AXI_2_APB.sv \
#$RTL_PATH/ips/axi/axi2apb/AXI_2_APB_32.sv \
#$RTL_PATH/ips/axi/axi2apb/axi2apb.sv \
#$RTL_PATH/ips/axi/axi2apb/axi2apb32.sv \
#$RTL_PATH/ips/axi/axi_mem_if_DP/axi_mem_if_MP_Hybrid_multi_bank.sv \
#$RTL_PATH/ips/axi/axi_mem_if_DP/axi_mem_if_multi_bank.sv \
#$RTL_PATH/ips/axi/axi_mem_if_DP/axi_mem_if_DP_hybr.sv \
#$RTL_PATH/ips/axi/axi_mem_if_DP/axi_mem_if_DP.sv \
#$RTL_PATH/ips/axi/axi_mem_if_DP/axi_mem_if_SP.sv \
#$RTL_PATH/ips/axi/axi_mem_if_DP/axi_read_only_ctrl.sv \
#$RTL_PATH/ips/axi/axi_mem_if_DP/axi_write_only_ctrl.sv \
#$RTL_PATH/ips/axi/axi_node/apb_regs_top.sv \
#$RTL_PATH/ips/axi/axi_node/axi_address_decoder_AR.sv \
#$RTL_PATH/ips/axi/axi_node/axi_address_decoder_AW.sv \
#$RTL_PATH/ips/axi/axi_node/axi_address_decoder_BR.sv \
#$RTL_PATH/ips/axi/axi_node/axi_address_decoder_BW.sv \
#$RTL_PATH/ips/axi/axi_node/axi_address_decoder_DW.sv \
#$RTL_PATH/ips/axi/axi_node/axi_AR_allocator.sv \
#$RTL_PATH/ips/axi/axi_node/axi_ArbitrationTree.sv \
#$RTL_PATH/ips/axi/axi_node/axi_AW_allocator.sv \
#$RTL_PATH/ips/axi/axi_node/axi_BR_allocator.sv \
#$RTL_PATH/ips/axi/axi_node/axi_BW_allocator.sv \
#$RTL_PATH/ips/axi/axi_node/axi_DW_allocator.sv \
#$RTL_PATH/ips/axi/axi_node/axi_FanInPrimitive_Req.sv \
#$RTL_PATH/ips/axi/axi_node/axi_multiplexer.sv \
#$RTL_PATH/ips/axi/axi_node/axi_node.sv \
#$RTL_PATH/ips/axi/axi_node/axi_node_wrap.sv \
#$RTL_PATH/ips/axi/axi_node/axi_node_wrap_with_slices.sv \
#$RTL_PATH/ips/axi/axi_node/axi_regs_top.sv \
#$RTL_PATH/ips/axi/axi_node/axi_request_block.sv \
#$RTL_PATH/ips/axi/axi_node/axi_response_block.sv \
#$RTL_PATH/ips/axi/axi_node/axi_RR_Flag_Req.sv \
#$RTL_PATH/ips/axi/axi_slice/axi_ar_buffer.sv \
#$RTL_PATH/ips/axi/axi_slice/axi_aw_buffer.sv \
#$RTL_PATH/ips/axi/axi_slice/axi_b_buffer.sv \
#$RTL_PATH/ips/axi/axi_slice/axi_buffer.sv \
#$RTL_PATH/ips/axi/axi_slice/axi_r_buffer.sv \
#$RTL_PATH/ips/axi/axi_slice/axi_slice.sv \
#$RTL_PATH/ips/axi/axi_slice/axi_w_buffer.sv \
#$RTL_PATH/ips/axi/axi_slice_dc/axi_slice_dc_master.sv \
#$RTL_PATH/ips/axi/axi_slice_dc/axi_slice_dc_slave.sv \
#$RTL_PATH/ips/axi/axi_slice_dc/dc_data_buffer.v \
#$RTL_PATH/ips/axi/axi_slice_dc/dc_full_detector.v \
#$RTL_PATH/ips/axi/axi_slice_dc/dc_synchronizer.v \
#$RTL_PATH/ips/axi/axi_slice_dc/dc_token_ring_fifo_din.v \
#$RTL_PATH/ips/axi/axi_slice_dc/dc_token_ring_fifo_dout.v \
#$RTL_PATH/ips/axi/axi_slice_dc/dc_token_ring.v \
#$RTL_PATH/ips/axi/axi_spi_slave/axi_spi_slave.sv \
#$RTL_PATH/ips/axi/axi_spi_slave/spi_slave_axi_plug.sv \
#$RTL_PATH/ips/axi/axi_spi_slave/spi_slave_cmd_parser.sv \
#$RTL_PATH/ips/axi/axi_spi_slave/spi_slave_controller.sv \
#$RTL_PATH/ips/axi/axi_spi_slave/spi_slave_dc_fifo.sv \
#$RTL_PATH/ips/axi/axi_spi_slave/spi_slave_regs.sv \
#$RTL_PATH/ips/axi/axi_spi_slave/spi_slave_rx.sv \
#$RTL_PATH/ips/axi/axi_spi_slave/spi_slave_syncro.sv \
#$RTL_PATH/ips/axi/axi_spi_slave/spi_slave_tx.sv \
#$RTL_PATH/ips/axi/core2axi/core2axi.sv \

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















