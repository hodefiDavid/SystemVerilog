 `ifndef Scoreboard
 `define Scoreboard
 
 //****************************
 class Scoreboard extends BaseScoreboard;
 static bit[0:7] cov_met;
 shortreal cross_cvg[8];
 int took[8];

  covergroup hammering();
    s: coverpoint srce[2:0];
    d0: coverpoint dest[2:0]
    	{ bins d0 = {0};}
    s_d0:   cross s, d0;
    d1: coverpoint dest[2:0]
    	{ bins d1 = {1};}
    s_d1:   cross s, d1;
    d2: coverpoint dest[2:0]
    	{ bins d2 = {2};}
    s_d2:   cross s, d2;
    d3: coverpoint dest[2:0]
    	{ bins d3 = {3};}
    s_d3:   cross s, d3;
    d4: coverpoint dest[2:0]
    	{ bins d4 = {4};}
    s_d4:   cross s, d4;
    d5: coverpoint dest[2:0]
    	{ bins d5 = {5};}
    s_d5:   cross s, d5;
    d6: coverpoint dest[2:0]
    	{ bins d6 = {6};}
    s_d6:   cross s, d6;
    d7: coverpoint dest[2:0]
    	{ bins d7 = {7};}
    s_d7:   cross s, d7;
  endgroup
  
  
  function new(mailbox #(Packet) stim_mb = null, 
	       mailbox #(Packet) mon_mb = null ); 
     hammering = new();	       
     this.stim_mb = stim_mb;
     this.mon_mb = mon_mb;
  endfunction : new
 
  task automatic run2();
     while(1) begin
       this.mon_mb.peek(m_pkt);  // non-destructive read
       if (check.exists(m_pkt.pkt_id)) begin
	 ++m_pkt_cnt;
	 this.mon_mb.get(m_pkt); // repeat read destructively
#0	 case( m_pkt.compare(check[m_pkt.pkt_id]) )
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
	      hammering.sample();

       	      cross_cvg[0] = hammering.s_d0.get_coverage();
       	      cross_cvg[1] = hammering.s_d1.get_coverage();
       	      cross_cvg[2] = hammering.s_d2.get_coverage();
       	      cross_cvg[3] = hammering.s_d3.get_coverage();
       	      cross_cvg[4] = hammering.s_d4.get_coverage();
       	      cross_cvg[5] = hammering.s_d5.get_coverage();
       	      cross_cvg[6] = hammering.s_d6.get_coverage();
       	      cross_cvg[7] = hammering.s_d7.get_coverage();
	      
	      for(int i = 0; i<8; i++)
	      	cov_met[i] = (cross_cvg[i] == 100);


	      $display("Coverage: \tH0: %.1f,  \tH1: %.1f,  \tH2: %.1f,  \tH3: %.1f,  \tH4: %.1f,  \tH5: %.1f,  \tH6: %.1f,  \tH7: %.1f",
       	      	cross_cvg[0],
       	      	cross_cvg[1],
       	      	cross_cvg[2],
       	      	cross_cvg[3],
       	      	cross_cvg[4],
       	      	cross_cvg[5],
       	      	cross_cvg[6],
       	      	cross_cvg[7]  );
	    end
       endcase 
       end
       else 
	  $display("WARNING: Unexpected situation. Packet received from Monitor before Stimulus");
       
     end
  endtask
 
 
 endclass : Scoreboard
 
 `endif
