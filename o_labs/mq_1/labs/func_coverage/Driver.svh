`ifndef Driver
`define Driver

//************************
class Driver;
virtual router_if r_if;
int id;
bit[2:0] dest,srce;
Packet pkt2send, pktrecvd;
 mailbox #(Packet) mb;

  function new(int id, mailbox #(Packet) mb);
    this.r_if = v_router_if;
    this.id = id;
    this.mb = mb;
  endfunction 

 task automatic run(); 

  while(1) begin
      mb.get(pkt2send);
      dest = pkt2send.dest;
      srce = pkt2send.srce;
      if(`TRACE_ON) begin
        $display($stime,"  Driver %0d: Packet ID: %0d Dest: %0d Size: %0h\n",id,
                    pkt2send.pkt_id, dest, pkt2send.payload.size());
      end	
      send_dest();
      send_payload();    
  end  
 endtask
 
 task automatic send_dest();
  @(posedge r_if.clock);
  r_if.valid[id] <= 1;
  r_if.stream[id] <= 1;
  @(posedge r_if.clock); 
  for(int i=2; i>=0; i--)
    begin
      r_if.stream[id] <= dest[i]; 
      @(posedge r_if.clock);   
    end
  r_if.stream[id] <= 0;
  wait(r_if.busy[id]);
 endtask

 task automatic send_payload();
   wait(!r_if.busy[id]);
   
  // send packet ID first
  for(int i=7; i>=0; i--) begin
      r_if.stream[id] <= pkt2send.pkt_id[i];
      @(posedge r_if.clock);
    end 
  // send srce next
  for(int i=2; i>=0; i--) begin
      r_if.stream[id] <= pkt2send.srce[i];
      @(posedge r_if.clock);
    end   
  // send dest next
  for(int i=2; i>=0; i--) begin
      r_if.stream[id] <= pkt2send.dest[i];
      @(posedge r_if.clock);
    end   
  // send payload
  for(int i=0; i<pkt2send.payload.size(); i++) 
    for(int j=7; j>=0; j--) begin
      r_if.stream[id] <= pkt2send.payload[i][j];
    @(posedge r_if.clock); 
    end
  r_if.valid[id] <= 0;
  r_if.stream[id] <= 0;

 endtask
endclass :Driver

`endif//*****************************  
