class fpu_sequence_setup extends uvm_sequence #(fpu_request, fpu_response);
 `uvm_object_utils(fpu_sequence_setup)

  int num_scenarios;
  
  function new(string name = "fpu_sequence_setup");
    super.new(name);
  endfunction // new

  task body();
    fpu_request req;
    num_scenarios = $urandom_range(2,10);
    for(int unsigned i = 0; i < num_scenarios; i++) 
    begin  
      req = fpu_request::type_id::create("req");  
      start_item(req);
      if (!req.randomize() with {
                             req.a.mode == C_Zero;
                             req.b.mode == C_Zero;
                             } )
      begin
        $error("fpu_sequence_setup:: randomisation failed on transation %0d",i);
      end
      finish_item(req);
    end
  endtask // body
endclass

/*  replaced
`uvm_do_with( req, {
                    req.a.mode == C_Zero;
                    req.b.mode == C_Zero;
                    } )
*/  
