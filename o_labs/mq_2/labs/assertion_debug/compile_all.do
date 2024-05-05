onerror {resume}
onbreak {resume}


if [file exists work] {
    vdel -all
}
vlib work

vcom -novopt -debugVA -f vhdl.f
vlog -f vlog.f +define+SVA+SVA_SPEC
