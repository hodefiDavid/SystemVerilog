#transcript file ""

proc zapit { flt } {
  foreach item [glob -nocomplain $flt] {
    if {[ file exist $item]} {
      eval file delete -force $item
    }
  }
}

zapit work
zapit *.wlf
zapit *.log
zapit *.ucdb
#zapit *.do
zapit *.txt 
zapit transcript.*
zapit top_*
zapit *.vstf
zapit *~ 
zapit *.dat 
zapit *.db 
zapit *.bak 
#zapit *.o 
#zapit *.so 
#zapit *.dll 
#zapit dpiheader.h
zapit covreport
zapit vsim.*
#zapit vplan.do
zapit ranktest.*
zapit Regression_*
zapit *.fl
#zapit run_*
zapit dump.*
zapit expanded.sv
