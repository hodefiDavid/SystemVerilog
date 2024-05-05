vlog -sv counter.sv interface.sv 
vlog top.sv
vopt +acc top -o opt_test
vsim opt_test
run 0
# run -all
# vlog -sv -coverage counter.sv interface.sv 
# vlog top.sv
# vopt +acc +cover top -o opt_test
# vsim -coverage opt_test
# run 0
# run -all