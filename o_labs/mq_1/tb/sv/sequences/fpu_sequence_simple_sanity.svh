class fpu_sequence_simple_sanity extends uvm_sequence #(fpu_request, fpu_response);
  `uvm_object_utils(fpu_sequence_simple_sanity)
 
  int num_scenarios;
                                               
  function new(string name = "fpu_sequence_simple_sanity");
    super.new(name);
  endfunction // new


  task body();
    fpu_request req;
    num_scenarios = $urandom_range(1,10)*10;
      
    for(int unsigned i = 0; i < num_scenarios; i++) 
    begin
      req = fpu_request::type_id::create("req");  
      start_item(req);
      if (!req.randomize() with {
                             req.a.mode == C_Valid;
                             req.b.mode == C_Valid;
                             } )
      begin
        $error("fpu_sequence_setup:: randomisation failed on transation %0d",i);
      end
      finish_item(req);
    end
  endtask // body
endclass
