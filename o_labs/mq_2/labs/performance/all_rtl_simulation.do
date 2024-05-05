onbreak {resume}

# create library
if [file exists work] {
    vdel -all 
}
vlib work

if [file exists dut_lib] {
    vdel -lib dut_lib -all
}
vlib dut_lib

# start clock
quietly set before_run [clock seconds]

# execute run 1 with seed = 1
vcom -work dut_lib -novopt -debugVA -cover sbectf -f vhdl.f
vlog -f vlog_sv.f
vsim +UVM_TESTNAME=fpu_test_random_sequence -L dut_lib -onfinish stop -c top -nosva -sv_seed 1 +count=300
run -all
quit -sim

# execute run 2 with seed = 10
vsim +UVM_TESTNAME=fpu_test_random_sequence -L dut_lib -onfinish stop -c top -nosva -sv_seed 10 +count=300
run -all
quit -sim

# execute run 3 with seed = 100
vsim +UVM_TESTNAME=fpu_test_random_sequence -L dut_lib -onfinish stop -c top -nosva -sv_seed 100 +count=300
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
# quit -f
