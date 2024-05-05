class fpu_sequence_neg_sqr extends uvm_sequence #(fpu_request, fpu_response);
  `uvm_object_utils(fpu_sequence_neg_sqr)
 
  int num_scenarios;
                                               
  function new(string name = "fpu_sequence_neg_sqr");
    super.new(name);
  endfunction // new


  task body();
    num_scenarios = $urandom_range(1,10)*10;
      
    for(int unsigned i = 0; i < num_scenarios; i++) 
    begin
      req = fpu_request::type_id::create("req");  
      start_item(req);
      if (!req.randomize() with {
                             req.op == OP_SQR; 
                              } )
      begin
        $error("fpu_sequence_fair:: randomisation failed on transation %0d",i);
      end
      finish_item(req);
    end
  endtask // body
                                             
endclass
