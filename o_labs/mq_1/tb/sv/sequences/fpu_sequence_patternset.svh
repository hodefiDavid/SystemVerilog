class fpu_sequence_patternset extends uvm_sequence #(fpu_request, fpu_response);
  `uvm_object_utils(fpu_sequence_patternset)

  fpu_agent_config m_config;
//  string patternset_filename;
//  int patternset_maxcount;

  function new(string name = "fpu_sequence_patternset");
    super.new(name);
  endfunction // new


  task body();
    if (!uvm_config_db #(fpu_agent_config)::get(m_sequencer,"","AGENT_CONFIG", m_config))
    begin
      uvm_report_fatal("CONFIG_DB", "COuldn't get m_config from database in patternset sequence", UVM_LOW );
    end  
    pattern_stimulus(m_config.patternset_filename, m_config.patternset_maxcount);
  endtask // body

  task pattern_stimulus( input string filename = "pattern.vec", input int max_count = -1 );
    fpu_request req;
    int    fid = 0;
    int    code = 0;
    int    pattern_count = 0;
    string line, stmp;
    bit[31:0] av, bv, rv, ov, rdv;
    shortreal rf;
    single_float_t av_f, bv_f, rv_f;
    op_t ov_s;
    round_t  rdv_s;
      
    if (max_count == -1) 
      uvm_report_info(get_type_name, $psprintf("Loading patternset: %s, using ALL patterns in patternset", filename, max_count), UVM_MEDIUM, `__FILE__, `__LINE__ );
    else
      uvm_report_info(get_type_name, $psprintf("\n ******  Loading patternset: %s, using %0d patterns", filename, max_count), UVM_MEDIUM,`__FILE__, `__LINE__ );

    fid = $fopen(filename, "r");
    if (!fid) 
    begin
      uvm_report_fatal(get_type_name, $psprintf("Cant open file %f",filename),UVM_LOW);
      $stop;
    end
      
    while ( !$feof(fid) && ( max_count == -1 || (pattern_count <= max_count)) )  
    begin
	    // operand A
	    code = $fscanf(fid, "%8h", av);
	    // operand B
	    code = $fscanf(fid, "%8h", bv);  
	    // op mode
	    code = $fscanf(fid, "%3b", ov);  
	    // round mode
	    code = $fscanf(fid, "%2b", rdv);  
	    
	    req = fpu_request::type_id::create("req");  
      start_item(req);
      // the inline constraints didn't seem to like the casting, so did it first.
      av_f = single_float_t'(av);
      bv_f = single_float_t'(bv);
      ov_s = op_t'(ov);
      rdv_s = round_t'(rdv);
      if (!req.randomize() with {
                             req.a.operand == av_f;
                             req.b.operand == bv_f;
	                           req.op        == ov_s;
                             req.round     == rdv_s;
                             } )
      begin
        $error("fpu_sequence_setup:: randomisation failed on transation  of patternset transaction %0d",pattern_count);
      end
      finish_item(req);

	    // result
 	    code = $fscanf(fid, "%8h", rv);  
	    rf = rv;
		   
	    if ((pattern_count % 10)==0)
	    begin 
	      uvm_report_info(get_type_name, $sformatf("Loading patterset %0d...", pattern_count), UVM_HIGH );
	    end  
	    pattern_count++;
	     
    end // while not EOF
    $fclose(fid);
  endtask // pattern_stimulus
endclass

