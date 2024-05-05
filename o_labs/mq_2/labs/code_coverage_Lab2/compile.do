# ensure we start afresh, so deleted work if it exists.
if [file exists work] {
   vdel -all
}
vlib work
vlog +cover=bcesfx -coverudp *.v
vcom +cover=bcesfx -coverudp Tx.vhd Arb.vhd Buffers.vhd Fifo.vhd  
vcom +cover=bcesfx -coverudp Fs_add.vhd Post.vhd Delta.vhd testdel.vhd