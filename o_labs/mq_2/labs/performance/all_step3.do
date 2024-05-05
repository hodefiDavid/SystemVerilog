onbreak {resume}

# create library
if [file exists work] {
    vdel -all
}
vlib work

if [file exists dut_gate_lib] {
    vdel -lib dut_gate_lib -all
}
vlib dut_gate_lib

# start clock
quietly set before_run [clock seconds]

# execute run 1 with seed = 1
vlog -work dut_gate_lib -quiet +define+TIMING -f vlog_v.f
vlog -quiet -f vlog_sv.f
vopt -quiet top -L dut_gate_lib +nocheckALL -sdfmin /top/fpu_dut=../../fpu/netlist/verilog/fpu_flat.sdf -o top_optimized
vsim +UVM_TESTNAME=fpu_test_random_sequence -onfinish stop -quiet -c top_optimized -nosva +nowarnTFMPC -sv_seed 1 +count=300 
run -all 
quit -sim

# execute run 2 with seed = 10
vsim +UVM_TESTNAME=fpu_test_random_sequence -onfinish stop -quiet -c top_optimized -nosva +nowarnTFMPC -sv_seed 10 +count=300 
run -all
quit -sim

# execute run 3 with seed = 100
vsim +UVM_TESTNAME=fpu_test_random_sequence -onfinish stop -quiet -c top_optimized -nosva +nowarnTFMPC -sv_seed 100 +count=300 
run -all
quit -sim

# stop clock
quietly set after_run [clock seconds]

# calculate total run time
quietly set total_run [expr $after_run - $before_run]
quietly set minutes_run [expr $total_run / 60]
quietly set seconds_run [expr $total_run - [expr $minutes_run * 60] ]

# display time
echo ""
echo "Total Run Time: " $minutes_run " Minutes " $seconds_run " Seconds"
echo ""

# exit simulation

