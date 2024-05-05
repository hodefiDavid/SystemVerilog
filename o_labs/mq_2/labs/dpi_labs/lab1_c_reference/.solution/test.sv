/*****************************************************************************
SystemVerilog testbench to call an imported C routine that reads a file

For the Mastering Questa learning path, Creating and Debugging DPI
chapter, lab 1.
*****************************************************************************/

module test();

  //LAB: Import the DPI-C c_fmread() function with a string input, and a return type of int
  import "DPI-C" function int c_fmread(input string fname);

  initial begin
     //LAB: Declare an int variable, size
    int size;

     //LAB: Call fmread(), passing in the file name, and store the return value in size
    size = c_fmread("mem.dat");

     //LAB: Display the value of size
    $display("c_fmread() returned a memory size of %0d", size);
  end
endmodule : test
