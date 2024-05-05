onerror {resume}
onbreak {resume}


if [file exists work] {
    vdel -all
}
vlib work

vlog -f vlog.f

vsim -voptargs=+acc top
#vsim -voptargs=+acc -classdebug top
