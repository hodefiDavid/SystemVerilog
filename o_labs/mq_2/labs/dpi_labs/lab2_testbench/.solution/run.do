# Compile SV code
vlog -dpiheader dpiheader.h test.sv

# Compile C code
vlog c_tb.c -ccflags -g

# Optimize for debug
vopt +acc=lnr test -o test_debug

# Simulate
vsim test_debug
