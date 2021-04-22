#!/usr/bin/python3
#--------------------------------------------------------------------------- 
#             Copyright 2021 PENG CHENG LABORATORY
#--------------------------------------------------------------------------- 
# Author      : liubojun
# Email       : liubj@pcl.ac.cn
# Date        : 2021-04-06
# Project     : 
# Language    : Python
# Description : 
#--------------------------------------------------------------------------- 
import sys
import os
import subprocess
import re
from   data_def import *

#-----------------------------------------------------------
# SMIC110
#-----------------------------------------------------------
smic110 = Foundry(
    name='smic110',
    lib = {
        'std,HD,MAX': (
            '../../../iFlow/foundry/smic110/lib/scc011ums_hd_lvt_ss_v1p08_125c_ccs.lib',
        ),
        'std,HD,MIN': (
            '../../../iFlow/foundry/smic110/lib/scc011ums_hd_lvt_ff_v1p32_-40c_ccs.lib',
            '../../../iFlow/foundry/smic110/lib/scc011ums_hd_hvt_ff_v1p32_-40c_ccs.lib',
            '../../../iFlow/foundry/smic110/lib/scc011ums_hd_rvt_ff_v1p32_-40c_ccs.lib'
        ),
        'dontuse'   : '*HVT* *DEL* *V0* *V24* *V20* *222* *33* *32* *F_DIO* *PULL* *TBUF* SED* SND* SD*',
        'macro,MAX' : (
            '../../../iFlow/foundry/smic110/lib/S011HD1P1024X64M4B0_SS_1.08_125.lib',
            '../../../iFlow/foundry/smic110/lib/S011HD1P128X21M2B0_SS_1.08_125.lib',
            '../../../iFlow/foundry/smic110/lib/S011HD1P256X8M4B0_SS_1.08_125.lib',
            '../../../iFlow/foundry/smic110/lib/S011HD1P512X19M4B0_SS_1.08_125.lib',
            '../../../iFlow/foundry/smic110/lib/S011HD1P512X73M2B0_SS_1.08_125.lib',
            '../../../iFlow/foundry/smic110/lib/S011HDSP4096X64M8B0_SS_1.08_125.lib',
            '../../../iFlow/foundry/smic110/lib/SP013D3WP_V1p7_typ.lib',
            '../../../iFlow/foundry/smic110/lib/S013PLLFN_v1.5.1_typ.lib'
        ),
        'macro,MIN' : (
            '../../../iFlow/foundry/smic110/lib/S011HD1P1024X64M4B0_FF_1.32_-40.lib',
            '../../../iFlow/foundry/smic110/lib/S011HD1P128X21M2B0_FF_1.32_-40.lib',
            '../../../iFlow/foundry/smic110/lib/S011HD1P256X8M4B0_FF_1.32_-40.lib',
            '../../../iFlow/foundry/smic110/lib/S011HD1P512X19M4B0_FF_1.32_-40.lib',
            '../../../iFlow/foundry/smic110/lib/S011HD1P512X73M2B0_FF_1.32_-40.lib',
            '../../../iFlow/foundry/smic110/lib/S011HDSP4096X64M8B0_FF_1.32_-40.lib',
            '../../../iFlow/foundry/smic110/lib/SP013D3WP_V1p7_typ.lib',
            '../../../iFlow/foundry/smic110/lib/S013PLLFN_v1.5.1_typ.lib'
        ),
    },
    lef = {
        'tech'      : (
            '../../../iFlow/foundry/smic110/lef/scc011u_8lm_1tm_thin_ALPA.lef',
        ),
        'std,HD'    : (
            '../../../iFlow/foundry/smic110/lef/scc011ums_hd_hvt.lef',
            '../../../iFlow/foundry/smic110/lef/scc011ums_hd_lvt.lef',
            '../../../iFlow/foundry/smic110/lef/scc011ums_hd_rvt.lef'
        ),
        'macro'     : (
            '../../../iFlow/foundry/smic110/lef/S011HD1P1024X64M4B0.lef',
            '../../../iFlow/foundry/smic110/lef/S011HD1P128X21M2B0.lef',
            '../../../iFlow/foundry/smic110/lef/S011HD1P256X8M4B0.lef',
            '../../../iFlow/foundry/smic110/lef/S011HD1P512X19M4B0.lef',
            '../../../iFlow/foundry/smic110/lef/S011HD1P512X73M2B0.lef',
            '../../../iFlow/foundry/smic110/lef/S011HDSP4096X64M8B0.lef',
            '../../../iFlow/foundry/smic110/lef/SP013D3WP_V1p7_8MT.lef',
            '../../../iFlow/foundry/smic110/lef/S013PLLFN_8m_V1_2_1.lef'
        )
    },
    gds = {
        'std,HD'    : (
            '../../../iFlow/foundry/smic110/gds/scc011ums_hd_hvt.gds',
            '../../../iFlow/foundry/smic110/gds/scc011ums_hd_lvt.gds',
            '../../../iFlow/foundry/smic110/gds/scc011ums_hd_rvt.gds',
        ),
        'macro'     : (
            '../../../iFlow/foundry/smic110/gds/S011HD1P1024X64M4B0.gds',
            '../../../iFlow/foundry/smic110/gds/S011HD1P128X21M2B0.gds',
            '../../../iFlow/foundry/smic110/gds/S011HD1P256X8M4B0.gds',
            '../../../iFlow/foundry/smic110/gds/S011HD1P512X19M4B0.gds',
            '../../../iFlow/foundry/smic110/gds/S011HD1P512X73M2B0.gds',
            '../../../iFlow/foundry/smic110/gds/S011HDSP4096X64M8B0.gds',
            '../../../iFlow/foundry/smic110/gds/SP013D3WP_V1p7_8MT.gds',
            '../../../iFlow/foundry/smic110/gds/S013PLLFN_V1.5.2_1P8M_partial.gds'
        )
    }
)

#-----------------------------------------------------------
# SMIC55
#-----------------------------------------------------------
smic55 = Foundry(
    name='smic55',
    lib = {
        'std,HD,MAX': (
            '../../../iFlow/foundry/smic55/lib/scc55nll_hd_lvt_ss_v1p08_125c_ccs.lib',
            '../../../iFlow/foundry/smic55/lib/scc55nll_hd_hvt_ss_v1p08_125c_ccs.lib',
            '../../../iFlow/foundry/smic55/lib/scc55nll_hd_rvt_ss_v1p08_125c_ccs.lib'
        ),
        'std,HD,MIN': (
            '../../../iFlow/foundry/smic55/lib/scc55nll_hd_hvt_ff_v1p32_-40c_ccs.lib',
            '../../../iFlow/foundry/smic55/lib/scc55nll_hd_lvt_ff_v1p32_-40c_ccs.lib',
            '../../../iFlow/foundry/smic55/lib/scc55nll_hd_rvt_ff_v1p32_-40c_ccs.lib'
        ),
        'dontuse'   : '*HVT* *DEL* *V0* *V24* *V20* *222* *33* *32* *F_DIO* *PULL* *TBUF* SED* SND* SD* *DCAP* VDD* P1* P2* PV* PB* *CLK* PX* PI* PA* PD* *POR*',
        'macro,MAX' : (
            '../../../iFlow/foundry/smic55/lib/S55NLL_CP_V0p2_ss_v1p08_125C.lib',
            '../../../iFlow/foundry/smic55/lib/S55NLLGSPH_X512Y16D32_BW_ss_1.08_125.lib',
            '../../../iFlow/foundry/smic55/lib/S55NLLGVMH_X128Y8D32_ss_1.08_125.lib',
            '../../../iFlow/foundry/smic55/lib/S55NLLPLLGS_ZP1500A_V1.2.8_max.lib',
            '../../../iFlow/foundry/smic55/lib/SP55NLLD2RP_POR12C_OV3_V0p1_ss_v1p08_125C.lib',
            '../../../iFlow/foundry/smic55/lib/SPT55NLLD2RP_OV3_ANALOG_V0p3_ss_V1p08_125C.lib',
            '../../../iFlow/foundry/smic55/lib/SPT55NLLD2RP_OV3_V0p3_ss_V1p08_125C.lib'
        ),
        'macro,MIN' : (
            '../../../iFlow/foundry/smic55/lib/S55NLL_CP_V0p2_ff_v1p32_-40C.lib',
            '../../../iFlow/foundry/smic55/lib/S55NLLGSPH_X512Y16D32_BW_ff_1.32_-40.lib',
            '../../../iFlow/foundry/smic55/lib/S55NLLGVMH_X128Y8D32_ff_1.32_-40.lib',
            '../../../iFlow/foundry/smic55/lib/S55NLLPLLGS_ZP1500A_V1.2.8_min.lib',
            '../../../iFlow/foundry/smic55/lib/SP55NLLD2RP_POR12C_OV3_V0p1_ff_v1p32_-40C.lib',
            '../../../iFlow/foundry/smic55/lib/SPT55NLLD2RP_OV3_ANALOG_V0p3_ff_V1p32_-40C.lib',
            '../../../iFlow/foundry/smic55/lib/SPT55NLLD2RP_OV3_V0p3_ff_V1p32_-40C.lib'
        ),
    },
    lef = {
        'tech'      : (
            '../../../iFlow/foundry/smic55/lef/scc55nll_hd_9lm_2tm.lef',
        ),
        'std,HD'    : (
            '../../../iFlow/foundry/smic55/lef/SCC55NLL_HD_LVT_V2p0.lef',
            '../../../iFlow/foundry/smic55/lef/SCC55NLL_HD_RVT_V2p0.lef',
            '../../../iFlow/foundry/smic55/lef/SCC55NLL_HD_HVT_V2p0.lef'
        ),
        'macro'     : (
            '../../../iFlow/foundry/smic55/lef/S55NLLGSPH_X512Y16D32_BW.lef',
            '../../../iFlow/foundry/smic55/lef/S55NLLGVMH_X128Y8D32.lef',
            '../../../iFlow/foundry/smic55/lef/S55NLLPLLGS_ZP1500A_9m2tm_V1.2.3.lef',
            '../../../iFlow/foundry/smic55/lef/SP55NLLD2RP_POR12C_OV3_V0p2_9MT_2TM.lef',
            '../../../iFlow/foundry/smic55/lef/SPT55NLLD2RP_OV3_ANALOG_V0p3_9MT_2TM.lef',
            '../../../iFlow/foundry/smic55/lef/SPT55NLLD2RP_OV3_V0p3_9MT_2TM.lef'
        )
    },
    gds = {
        'std,HD'    : (
            '../../../iFlow/foundry/smic55/gds/SCC55NLL_HD_LVT_V2p0.gds',
            '../../../iFlow/foundry/smic55/gds/SCC55NLL_HD_RVT_V2p0.gds',
            '../../../iFlow/foundry/smic55/gds/SCC55NLL_HD_HVT_V2p0.gds'
        ),
        'macro'     : (
            '../../../iFlow/foundry/smic55/gds/S011HD1P1024X64M4B0.gds',
        )
    }
)

#-----------------------------------------------------------
# sky130
#-----------------------------------------------------------
sky130 = Foundry(
    name='sky130',
    lib = {
        'std,HS,TYP': (
            '../../../iFlow/foundry/sky130/lib/sky130_fd_sc_hs__tt_025C_1v80.lib',
        ),
        'std,HD,TYP': (
            '../../../iFlow/foundry/sky130/lib/sky130_fd_sc_hd__tt_025C_1v80.lib',
        ),
        'dontuse'   : 'sky130_fd_sc_hs__xor3_1 *2111* *221* *311* *32* *41* *clk* *dly* *nand4* *or4*',
        'macro,TYP' : (
            '../../../iFlow/foundry/sky130/lib/sky130_dummy_io.lib',
            '../../../iFlow/foundry/sky130/lib/sky130_sram_1rw1r_128x256_8_TT_1p8V_25C.lib',
            '../../../iFlow/foundry/sky130/lib/sky130_sram_1rw1r_44x64_8_TT_1p8V_25C.lib',
            '../../../iFlow/foundry/sky130/lib/sky130_sram_1rw1r_64x256_8_TT_1p8V_25C.lib',
            '../../../iFlow/foundry/sky130/lib/sky130_sram_1rw1r_80x64_8_TT_1p8V_25C.lib'
        ),
    },
    lef = {
        'tech'      : (
            '../../../iFlow/foundry/sky130/lef/sky130_fd_sc_hs.tlef',
        ),
        'std,HS'    : (
            '../../../iFlow/foundry/sky130/lef/sky130_fd_sc_hs_merged.lef',
        ),
        'std,HD'    : (
            '../../../iFlow/foundry/sky130/lef/sky130_fd_sc_hd_merged.lef',
        ),
        'macro'     : (
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__com_bus_slice_10um.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__com_bus_slice_1um.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__com_bus_slice_20um.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__com_bus_slice_5um.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__connect_vcchib_vccd_and_vswitch_vddio_slice_20um.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__corner_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__disconnect_vccd_slice_5um.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__disconnect_vdda_slice_5um.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__gpiov2_pad_wrapped.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vccd_hvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vccd_lvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vdda_hvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vdda_lvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vddio_hvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vddio_lvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vssa_hvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vssa_lvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vssd_hvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vssd_lvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vssio_hvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_ef_io__vssio_lvc_pad.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_fd_io__top_xres4v2.lef',
            '../../../iFlow/foundry/sky130/lef/sky130io_fill.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_sram_1rw1r_128x256_8.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_sram_1rw1r_44x64_8.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_sram_1rw1r_64x256_8.lef',
            '../../../iFlow/foundry/sky130/lef/sky130_sram_1rw1r_80x64_8.lef'
        )
    },
    gds = {
        'std,HS'    : (
            '../../../iFlow/foundry/sky130/gds/sky130_fd_sc_hs.gds',
        ),
        'std,HD'    : (
            '../../../iFlow/foundry/sky130/gds/sky130_fd_sc_hd.gds',
        ),
        'macro'     : (
            '../../../iFlow/foundry/sky130/gds/sky130_sram_1rw1r_128x256_8.gds',
            '../../../iFlow/foundry/sky130/gds/sky130_sram_1rw1r_44x64_8.gds',
            '../../../iFlow/foundry/sky130/gds/sky130_sram_1rw1r_64x256_8.gds',
            '../../../iFlow/foundry/sky130/gds/sky130_sram_1rw1r_80x64_8.gds'
        )
    }
)

            #'../../../iFlow/foundry/sky130/lef/sky130_fd_sc_hd.tlef'
