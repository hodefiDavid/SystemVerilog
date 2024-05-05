/*****************************************************************************
SystemVerilog testbench to call an imported C routine that reads a file

For the Mastering Questa learning path, Creating and Debugging DPI
chapter, lab 1.
*****************************************************************************/

module test();

  //LAB: Import the DPI-C c_fmread() function with a string input, and a return type of int

   initial begin
     //LAB: Declare an int variable, size

     //LAB: Call c_fmread(), passing in the file name "mem.dat", and store the return value in size

     //LAB: Display the value of size
   end

endmodule : test
