class fifo_generator;
mailbox mlbx;
virtual fifo_interface vinf;
transaction trans;
int num_of_generate;
int num_of_random_test_generate;
//int num_of_1_by_1_generate;

event generator_done;

function new(mailbox mlbx);
this.mlbx=mlbx;
endfunction


task main();

repeat(num_of_generate) begin
trans=new();
if (!trans.randomize())
$error("transaction randomize failed at time %t",$time);
mlbx.put(trans); 
trans.display("GENERATOR");
end
-> generator_done;
endtask



endclass

/*

task test_only_write();
trans=new();
trans.only_write.constraint_mode(1);
trans.only_read.constraint_mode(0);
if (!trans.randomize())
$error("transaction randomize failed at time %t",$time);
mlbx.put(trans); 
trans.display("GENERATOR");
endtask

task test_only_read();
trans=new();
trans.only_write.constraint_mode(0);
trans.only_read.constraint_mode(1);
if (!trans.randomize())
$error("transaction randomize failed at time %t",$time);
mlbx.put(trans); 
trans.display("GENERATOR");
endtask


*/
/*task test_all_random();
//trans.only_write.constraint_mode(0);
//trans.only_read.constraint_mode(0);
repeat(num_of_random_test_generate) begin
trans=new();
if (!trans.randomize())
$error("transaction randomize failed at time %t",$time);
mlbx.put(trans); 
trans.display("GENERATOR");
end
endtask


*/