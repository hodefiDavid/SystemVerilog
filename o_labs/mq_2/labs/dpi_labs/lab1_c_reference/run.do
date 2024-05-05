# Questa script to compile, optimize, and run Lab 1 for the DPI chapter

# Compile SV code
vlog -dpiheader dpiheader.h test.sv

# Compile C code
vlog fmread.c -ccflags -g

# Optimize for debug
vopt +acc=lnr test -o test_debug

# Load and Simulate
vsim fmread.c test_debug -do "run -all"
