# assume you have two files: design.v which is the design, and top.v for the testbench.
# for better user experience, create run.do file which will include the following lines.
# run it from the library where your files in. the command is "do run.do" from Questa transcript. enjoy :)

vlog adder.v 
vlog adder4b_tb.v 
vlog test_adder.v 

vopt +acc top -o opt_test
vsim opt_test

run 0
do wave.do
run -all
