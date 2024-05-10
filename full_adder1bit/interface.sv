interface inf(input logic clk,rst);
  
  //declare the signals
bit i_a;
bit i_b;
bit i_cin;
bit o_carry;
bit o_sum;

  modport DUT(input i_a, i_b, i_cin, output o_carry ,o_sum);
  
endinterface