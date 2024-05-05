onerror {resume}
onbreak {resume}



if [file exists work] {
    vdel -all
}
vlib work

vcom -f vhdl.f
vlog -f vlog.f

vsim +UVM_TESTNAME=fpu_test_random_sequence -assertdebug -voptargs=+acc -l top.log -wlf top.wlf top

do wave.do
set StdArithNoWarnings 1
set NumericStdNoWarnings 1
#run 1000
#run -all

#coverage save top.ucdb