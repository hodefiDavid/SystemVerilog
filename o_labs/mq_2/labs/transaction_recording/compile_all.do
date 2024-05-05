onerror {resume}
onbreak {resume}


if [file exists work] {
    vdel -all
}
vlib work

#source clean.do

vcom -f vhdl.f
vlog -f vlog.f 
