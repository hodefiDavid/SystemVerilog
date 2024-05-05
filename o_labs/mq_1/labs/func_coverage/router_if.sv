interface router_if(input logic clock);
  import env_pkg::*;
  logic  rst ;
  logic [7:0] valid ;
  logic [7:0] stream ;
  logic [7:0] streamo ;
  logic [7:0] busy ;
  logic [7:0] valido ;
  
/*
// not using it in this lab, but to show what could be done.
modport TB(
    output  rst,
    output  valid,
    output  stream,
    output  clock,
    input  streamo,
    input  busy,
    input  valido );
*/
endinterface: router_if

