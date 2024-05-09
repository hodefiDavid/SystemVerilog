vlog -sv Memory.sv  environment.sv random_test.sv top.sv 
vopt +acc top -o opt_test
vsim opt_test
run 0
# run -all