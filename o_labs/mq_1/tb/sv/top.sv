`timescale 1ns/1ns

module top;
   import uvm_pkg::*;
   import fpu_test_pkg::*;
   
   bit clk  = 1'b0;
   bit stop = 1'b0;
   
   fpu_pin_if fpu_pins(clk);

   fpu fpu_dut(.clk_i(fpu_pins.clk),
	       .opa_i(fpu_pins.opa),
	       .opb_i(fpu_pins.opb),
	       .fpu_op_i(fpu_pins.fpu_op),
	       .rmode_i(fpu_pins.rmode),
	       .output_o(fpu_pins.outp),
	       .start_i(fpu_pins.start),
	       .ready_o(fpu_pins.ready),
	       .ine_o(fpu_pins.ine),
	       .overflow_o(fpu_pins.overflow),
	       .underflow_o(fpu_pins.underflow),
	       .div_zero_o(fpu_pins.div_zero),
	       .inf_o(fpu_pins.inf),
	       .zero_o(fpu_pins.zero),
	       .qnan_o(fpu_pins.qnan),
	       .snan_o(fpu_pins.snan));


initial begin
   // put the virtual interface into the configuration database before runnign the test
   uvm_config_db #(virtual fpu_pin_if)::set(uvm_top,"uvm_test_top", "VIRTUAL_INTERFACE", fpu_pins);
   // now set test off
   run_test();
   stop = 1'b1;
end

initial begin
   #10 clk = 1'b1; // posedges on 10, 20, 30...
   while(stop == 1'b0) begin
      #5 clk = 1'b0;
      #5 clk = 1'b1;
   end
end
   
endmodule

