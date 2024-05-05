# Questa script to compile, optimize, and run Lab 2 for the DPI chapter

# Compile SV code
vlog -dpiheader dpiheader.h test.sv

# Compile C code
vlog c_tb.c -ccflags -g

# Optimize for debug
vopt +acc=lnr test -o test_debug

# Load image
vsim test_debug
