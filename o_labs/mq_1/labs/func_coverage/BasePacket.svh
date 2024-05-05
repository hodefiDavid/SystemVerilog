`ifndef BasePacket
`define BasePacket

class BasePacket;
  string name;
//  int pkt_id;
  bit[7:0] pkt_id;
  rand bit[3:0] srce;
  rand bit[3:0] dest;
  rand reg[7:0] payload[];

  constraint payload_sz {
    payload.size() inside { [1:4] };
  }


  function new(string name = "Packet Object");
    this.name = name;
    payload = new[1];
  endfunction


  function void display(string prefix = "NOTE");
    int i;
    $display("pkt_id = %0d",pkt_id);
    $display("%0d [%s] %s: srce = %0d, dest = %0d", $stime,prefix, name, srce, dest);
    $display("%0d [%s] %s: payload size = %0d",$stime, prefix, name, payload.size());
    for (i=0; i<payload.size(); i++)
      $display("%0d [%s] %s: payload[%0d] = %0h",$stime, prefix, name, i, payload[i]);
  endfunction


endclass

`endif//*****************************  
