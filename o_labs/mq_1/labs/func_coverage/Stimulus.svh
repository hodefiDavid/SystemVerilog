`ifndef Stimulus
`define Stimulus

//***********************
class Stimulus;
 int id = 0, driv_num; //, hammer;
 Packet pkt2send;
 mailbox #(Packet) mb[], log_mb;
 static int packet_id = 1;  
 
 function new( int driv_num = 8); 
   this.id = 0; 
   $display("stim settings: driv_num = %0d, mb.size = %0d",this.driv_num, this.mb.size());              
 endfunction              

 function void connect( input mailbox #(Packet) log_mb,  driv_mb[] );
   this.mb = driv_mb;  // assign dynamic array of handles!
   this.log_mb = log_mb; 
 endfunction

 task automatic run();
  static int pkts_generated;
  pkts_generated = 0;
  $display("Building random payloads for ports [0:%0d]",mb.size()-1) ;
  
  while(1) begin
      pkt2send = new(packet_id++);
      if (pkt2send.randomize() with {dest == hammer;} ) begin
        if(`TRACE_ON) begin 
          pkt2send.display(); $display;
  	  $display;
	end  
	mb[pkt2send.srce].put(pkt2send);
	log_mb.put(pkt2send); 
        pkts_generated++;
  	end  
      else begin
  	$display("Port: %0d  Failed to Randomize Packet (pkt2snd). Aborting test.", id);
  	$finish;
      end
   end   
 endtask
 
endclass : Stimulus

`endif//*****************************  
