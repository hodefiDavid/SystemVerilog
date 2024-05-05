onerror {resume}
onbreak {resume}


do clean.do

if [file exists work] {
    vdel -all
}
vlib work

if [file exists dut_lib] {
    vdel -lib dut_lib -all
}
vlib dut_lib
vcom -work dut_lib -novopt -debugVA -cover sbectf -f vhdl.f
vopt  -pdu -o bbox -work dut_lib fpu
#use implicit pre-compiled UVM library  -L mti_uvm would remove a warning.

vlog -f vlog.f +define+SVA+SVA_DUT
vopt +acc=rpna+/top/. -L dut_lib top -o optimized

