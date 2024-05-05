# ensure we start afresh, so deleted work if it exists.
if [file exists work] {
   vdel -all
}
vlib work
vlog +cover=bcesfx *.v
vcom +cover=bcesfx Tx.vhd Arb.vhd Buffers.vhd Fifo.vhd  
vcom +cover=bcesfx Fs_add.vhd Post.vhd Delta.vhd testdel.vhd