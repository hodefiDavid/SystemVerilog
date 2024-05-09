`include "fifo_env.sv"
program test(fifo_interface fifo_inf);
fifo_env env;

initial begin
env=new(fifo_inf);
env.generator.num_of_generate=100;
env.run();
$display("done test");
end


endprogram