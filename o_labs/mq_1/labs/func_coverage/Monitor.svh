`ifndef Monitor
`define Monitor

//*******************************
class Monitor;
virtual router_if r_if;
reg[7:0] p_id;
int id;
bit[2:0] srce, dest;
reg[7:0] payload[$], pkt2cmp_payload[$];
Packet pktrecvd;

  mailbox #(Packet) log_mb;

  function new(int id, mailbox #(Packet) log_mb);
    this.id = id;
    this.r_if = v_router_if;
    this.log_mb = log_mb;
  endfunction 

 task automatic capture_payload();
  reg[7:0] datum;
  pkt2cmp_payload = '{};
  
  wait(r_if.valido[id])
  @(posedge r_if.clock);
  // get packet id first
  for(int i=7; i>=0; i--)                
    begin                                
      p_id[i] = r_if.streamo[id];        
      @(posedge r_if.clock);             
    end                                                                     
  // get srce next
  for(int i=2; i>=0; i--)                
    begin                                
      srce[i] = r_if.streamo[id];        
      @(posedge r_if.clock);             
    end                                                                     
  // get dest next
  for(int i=2; i>=0; i--)                
    begin                                
      dest[i] = r_if.streamo[id];        
      @(posedge r_if.clock);             
    end                                                                     
  while(r_if.valido[id]) 
    begin
      for(int i=7; i>=0; i--) 
        begin
          datum[i] = r_if.streamo[id];
          @(posedge r_if.clock);
        end
        pkt2cmp_payload.push_back(datum);
    end
  if(`TRACE_ON) 
    $display("Monitor %0d Received %0d ",id, pkt2cmp_payload.size()," bytes");
 endtask

 task automatic run();
  //
  // Since payload size can't be predicted, capture_payload() uses a queue ( pkt2cmp_payload )
  // which then gets converted to Packet - pktrecvd
  //
  static int pkts_recvd;
  pkts_recvd = 0;

  $display("Starting Monitor %0d ",id);

  while(1) begin
    capture_payload();
    pktrecvd = new();
    pktrecvd.pkt_id = p_id;  // put in packet id
    pktrecvd.srce = srce;
    pktrecvd.dest = dest;
    pktrecvd.payload = new[pkt2cmp_payload.size()];
    for (int i=0; i<pkt2cmp_payload.size(); i++) begin
      pktrecvd.payload[i] = pkt2cmp_payload[i];
     if(`TRACE_ON)
        $display("Mon: %0d Packet Id: %0d	payload[%0d] = %0h Srce: %0d Dest: %d", id,
      pktrecvd.pkt_id, i,
      pktrecvd.payload[i], pktrecvd.srce, pktrecvd.dest) ;
    end  
    log_mb.put(pktrecvd);
  end
 endtask

endclass : Monitor

`endif//*****************************  
