onerror {resume}
onbreak {resume}


if [file exists work] {
    vdel -all
}
vlib work

vcom -novopt -debugVA -f vhdl.f
vlog -f vlog.f +define+SVA+SVA_SPEC

vsim +UVM_TESTNAME=fpu_test_random_sequence -assertdebug -displaymsgmode both -msgmode both -voptargs=+acc top

set StdArithNoWarnings 1
set NumericStdNoWarnings 1