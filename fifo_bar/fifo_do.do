vlog fifo.sv
vlog top.sv
vopt +acc top -o opt_test 
vsim opt_test
run 0

add wave -position end  sim:/top/f_interface/clk
add wave -position end  sim:/top/f_interface/rd
add wave -position end  sim:/top/f_interface/wr
add wave -position end  sim:/top/f_interface/wdata
add wave -position end  sim:/top/f_interface/rdata
add wave -position end  sim:/top/f_interface/empty
add wave -position end  sim:/top/f_interface/full
add wave -position end  sim:/top/t1/env.scoreboard.scbd_rdata
add wave -position end  sim:/top/t1/env.scoreboard.scbd_full
add wave -position end  sim:/top/t1/env.scoreboard.scbd_empty
#add wave -position end  sim:/top/dut/pointer
add wave -position end  sim:/top/t1/env.generator.num_of_generate
add wave -position end  sim:/top/t1/env.driver.number_of_drive
restart -f
#wave.do 

run -all