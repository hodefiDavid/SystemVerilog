`ifndef BaseScoreboard
`define BaseScoreboard

//**********************************
class BaseScoreboard;
  mailbox #(Packet) stim_mb, mon_mb;
  Packet check [ int ];
  int s_pkt_cnt, m_pkt_cnt, pkt_mismatch;
  Packet s_pkt, m_pkt;
  int errors;
  shortreal current_coverage;
  bit[3:0] srce, dest;

 function new(mailbox #(Packet) stim_mb = null, 
              mailbox #(Packet) mon_mb = null ); 
    this.stim_mb = stim_mb;
    this.mon_mb = mon_mb;
 endfunction : new

 task report();
    $display("\n%0d packets sent, %0d packets received, %0d errors, hammering %0d\n", 
              s_pkt_cnt, m_pkt_cnt, pkt_mismatch, hammer);
 endtask : report

 task automatic run1();
    while(1) begin
      stim_mb.get(s_pkt);
      ++s_pkt_cnt;
      
      check[s_pkt.pkt_id] = s_pkt;
      report;	
    end	 
 endtask	 	

 virtual task automatic run2();
   while(1) begin                                                                   
     mon_mb.peek(m_pkt);    // non-destructive read                                                          
     if (check.exists(m_pkt.pkt_id)) begin
        mon_mb.get(m_pkt);  // repeat read destructively                                                           
        ++m_pkt_cnt;                                                                                                         
       case( m_pkt.compare(check[m_pkt.pkt_id]) )                                   
         0: begin
              $display("Compare error",,m_pkt.pkt_id,, check[m_pkt.pkt_id].pkt_id);
              pkt_mismatch++; $stop;
            if(`TRACE_ON)                                                           
              s_pkt.display; check[s_pkt.pkt_id].display;                           
            end                                                                     
         1: begin
              check.delete(m_pkt.pkt_id);
              srce = s_pkt.srce;
              dest = s_pkt.dest;
            end
       endcase
       end 
     else                                                                      
         $display("WARNING: Unexpected situation. Packet received from Monitor before Stimulus");                                                                            
//     report;                                                                        
    end
 endtask
 
 task automatic run();
   fork
     run1;
     run2;
   join_none
   #1;
 endtask
 
endclass : BaseScoreboard

`endif//*****************************  
