import mti_fli::*;

class fpu_comparator #(type T = fpu_response) extends uvm_component;
  `uvm_component_param_utils(fpu_comparator #(T))
   
  uvm_analysis_export #( T ) before_export , after_export;

  local uvm_tlm_analysis_fifo #( T ) before_fifo , after_fifo;
  int m_matches , m_mismatches = 0;


  function new( string name, uvm_component parent ) ;
    super.new( name, parent );
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      
    before_export = new("before_export" , this );
    after_export = new("after_export" , this );

    before_fifo = new("before" , this );
    after_fifo = new("after" , this );

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    before_export.connect( before_fifo.analysis_export );
    after_export.connect( after_fifo.analysis_export );
  endfunction


  task run_phase(uvm_phase phase);
    T b;
    T a;
    //insert error 
    T old_b; 
      
    string s;
   
    forever 
    begin
      old_b = new("old_b");
      if ( b != null)
        old_b = b;
        
      after_fifo.get( a );
      before_fifo.get( b );
      
      //  ******* insert error - use old_b instead of b *******    
      if( !a.compare( old_b ) ) 
      //if( !a.compare( b ) ) 
      begin
        //s = $sformatf("Comparator Mismatch: DUT response %s, differs from REF-model response %s" , a.convert2string() , b.convert2string() );
        s = $sformatf("Comparator Mismatch: DUT response %s, differs from REF-model response %s" , a.convert2string() , old_b.convert2string() );
        uvm_report_error(get_type_name(), s, UVM_LOW ,`__FILE__,`__LINE__);
        m_mismatches++;
      end
      else 
      begin
        s = $sformatf("Comparator Match: %s " , b.convert2string() );
        uvm_report_info(get_type_name(), s, UVM_HIGH, `__FILE__,`__LINE__);
        m_matches++;
      end  
    end
    
  endtask


  function void report_phase(uvm_phase phase);
    string cmd;
      
    // Use the FLI via DPI to get access to the Questa CLI
    //cmd = $sformatf("coverage attr  -name Match -value %d",    m_matches);
    //if (mti_Cmd(cmd)) begin assert (0); end

    //cmd = $sformatf("coverage attr  -name Mismatch -value %d", m_mismatches);  
    //if (mti_Cmd(cmd)) assert (0);
    
  endfunction

  function void flush();
    m_matches = 0;
    m_mismatches = 0;
    before_fifo.flush();
    after_fifo.flush();
  endfunction

endclass
