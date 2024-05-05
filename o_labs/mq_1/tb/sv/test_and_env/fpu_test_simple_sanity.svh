class fpu_test_simple_sanity extends fpu_test_base;
  `uvm_component_utils(fpu_test_simple_sanity)

  function new(string name = "fpu_test_simple_sanity", uvm_component parent=null);
    super.new(name, parent);
  endfunction // new

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
    factory.print;
  endfunction // new


  task main_phase(uvm_phase phase);
    fpu_sequence_simple_sanity  s_seq;
    // raise the objectcion so that test will not stop early.
    phase.raise_objection(this, "Start of Main Sequence");
   
    s_seq = fpu_sequence_simple_sanity::type_id::create("s_seq");
   	s_seq.start(m_seqr, null);
     
    uvm_report_info(get_type_name(), "Stopping test...", UVM_LOW );      
    // test is over, so now drop the objection.
    phase.drop_objection(this, " End of stimulus generation");
    
  endtask

endclass
