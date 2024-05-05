class fpu_sequence_random extends fpu_sequence_setup;
  `uvm_object_utils(fpu_sequence_random)
   
  function new(string name = "fpu_sequence_random");
    super.new(name);
  endfunction // new


  task body();
    super.body();  // this will declare num_scenarios, and run the sequence setup body
    // change value of num_scenarios from that used for setup
    
    num_scenarios = $urandom_range(1,10)*10;

    for(int unsigned i = 0; i < num_scenarios; i++) 
    begin
      req = fpu_request::type_id::create("req");  
      start_item(req);
      if (!req.randomize() with {
                             req.op dist {OP_ADD :=10, OP_SUB := 10, OP_MUL := 10, OP_DIV := 10,  OP_SQR := 1}; 
                              } )
      begin
        $error("fpu_sequence_fair:: randomisation failed on transation %0d",i);
      end
      finish_item(req);
    end
  endtask // body
                                             
endclass
