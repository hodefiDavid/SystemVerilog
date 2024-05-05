# WHDL SystemVerilog for Verification Course
#  - Setup & simulation script for
#  Router complete

onbreak {resume}
onerror {resume}

if [file exists work] {
    vdel -all
}
vlib work

echo "#"
echo "# NOTE: Starting simulator and running DEMO ..."
echo "#"

# compile & run first simulation
vlog  +acc=a +define+TRACE_ON=0 ./env_pkg.sv ./top.sv ./router_if.sv  ./router.sv
vsim  -assertdebug -warning 7061 -msgmode both -displaymsgmode both -cvgperinstance -cvgbintstamp top

# run simulation
#The lab requires you to run in stages, so this has been commented out.
#run -all
