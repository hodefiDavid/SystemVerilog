vlog -sv counter.sv interface.sv 
vlog top.sv
vopt +acc top -o opt_test
vsim opt_test
run 0
# run -all