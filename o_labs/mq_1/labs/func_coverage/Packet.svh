`ifndef Packet
`define Packet

//*******************************
class Packet extends BasePacket;

  constraint valid {
    dest inside { [0:7] };
    srce inside { [0:7] };
  }
  
  function new(bit[7:0] p_id = 1);
    pkt_id = p_id;
  endfunction  

  function bit compare(Packet to ); 
    Packet pkt;
    string msg = "ERROR - Packet miscompare in  " ;
    if(to == null) begin
      $display(msg,"Target handle is null !!!");
      return(0);
    end
    if($cast(pkt, to)) begin
    this.display();
    pkt.display();
      if(this.pkt_id != pkt.pkt_id) begin
        $display(msg," pkt_id field ",,this.pkt_id,,pkt.pkt_id);
        return(0);
      end
      if(this.srce != pkt.srce) begin
        $display(msg," srce field ",,this.srce,,pkt.srce);
        return(0);
      end
      if(this.dest != to.dest) begin
        $display(msg," dest field ",,this.dest,,to.dest);
        return(0);
      end
      if (this.payload.size() != pkt.payload.size()) begin
        $display(msg," Payload Size ",,this.payload.size(),,pkt.payload.size());
        return(0);
      end
      for (int i=0; i<this.payload.size(); i++) begin
        if (this.payload[i] == pkt.payload[i]) ;
        else begin
          $display(msg," Payload Content ");
          return(0);
        end
      end
      return(1);
    end
    else
      $display("ERROR: Can only compare objects of the same Class!!!");
      return(0);
  endfunction

endclass

`endif//*****************************  
