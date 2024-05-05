class fpu_test_patternset extends fpu_test_base;
	`uvm_component_utils(fpu_test_patternset)

  function new(string name = "fpu_test_patternset", uvm_component parent=null);
		super.new(name, parent);
	endfunction // 

  function void build_phase(uvm_phase phase);
    // see if a deliberate bug is to be added and choose appropriate monitor to override
    // there is no argvalue, it is either set or not.
    string args[$];
    if ((uvm_cmdline_proc.get_arg_matches("+ADDBUG",args))==1)
    begin
      // override fpu_monitor base with the 'buggy' monitor.
      fpu_monitor_base::type_id::set_type_override(fpu_monitor_fpu_tb_bug::get_type());   
    end
    else
    begin
      // override fpu_monitor base with the normal monitor, not the one that adds a bug.
      fpu_monitor_base::type_id::set_type_override(fpu_monitor_fpu_no_tb_bug::get_type());   
    end

    super.build_phase(phase);
    
    //get infomation about patternfile, and add to agent config object
    // must be after super.build, where agent config object is created
    //function declared below main_phase
    get_patternfile_info(m_config.patternset_filename, m_config.patternset_maxcount);     
    factory.print;
  endfunction // new

  task main_phase(uvm_phase phase);
    fpu_sequence_patternset  s_seq;
    // raise the objectcion so that test will not stop early.
    phase.raise_objection(this, "Start of Main Sequence");
   
    s_seq = fpu_sequence_patternset::type_id::create("s_seq");
   	s_seq.start(m_seqr, null);
     
    uvm_report_info(get_type_name(), "Stopping test...", UVM_LOW );      
    // test is over, so now drop the objection.
    phase.drop_objection(this, " End of stimulus generation");
    
  endtask

  function void get_patternfile_info(output string filename, int maxcount);
    string maxcount_str;
    // get name
    if ((uvm_cmdline_proc.get_arg_value("+PATTERNSET_FILENAME=",filename))!=1)
    begin
      uvm_report_fatal("PLASARG_EXTRACT", "Could not extract +PATTERSET_FILENAME argument", UVM_LOW );           
    end
    else
    begin
      uvm_report_info("PLASARG_EXTRACT", $sformatf("PATTERNSET_FILENAME argument is %s", filename), UVM_HIGH );           
    end
    // now get maxcount, it is extracted as a string, so use the atoi string method to get the int version
    if ((uvm_cmdline_proc.get_arg_value("+PATTERNSET_MAXCOUNT=",maxcount_str))!=1)
    begin
      uvm_report_fatal("PLASARG_EXTRACT", "Could not extract +PATTERSET_MAXCOUNT argument", UVM_LOW );           
    end
    else
    begin
      uvm_report_info("PLASARG_EXTRACT", $sformatf("PATTERNSET_MAXCOUNT argument is %s", maxcount_str), UVM_HIGH );           
    end
    maxcount = maxcount_str.atoi;
  endfunction
  
endclass