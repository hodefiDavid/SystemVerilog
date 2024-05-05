# ensure we start afresh, so deleted work if it exists.
if [file exists work] {
   vdel -all
}
vlib work
vlog *.v
vcom Tx.vhd Arb.vhd Buffers.vhd Fifo.vhd  
vcom Fs_add.vhd Post.vhd Delta.vhd testdel.vhd