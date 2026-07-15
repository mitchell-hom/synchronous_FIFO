class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard);

  	bit [global_constants::DEPTH-1:0] compare; // compare data
	bit [global_constants::BUS_WIDTH-1:0] prev_data;
	bit prev_rd_err, prev_wr_err;
	bit prev_rd_ack, prev_wr_ack;
	bit prev_sinit;
  	int count; // count of data in fifo
	int data[$]; // model queue
  	packet pkts[$];
	uvm_analysis_imp #(packet, scoreboard) mAI;
  
	function new(string name, uvm_component parent);
		super.new(name, parent);
      
      	mAI = new("mAI", this);
	endfunction

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase
       	
	// checking
	virtual function void write(packet pkt);
		// RESET 
		if (pkt.SINIT) begin
			prev_sinit = 1;
	
		// not reset; normal operation		
		end else begin
			// just transitioned from SINIT
			if (prev_sinit == 1) begin
				// reset
				count = 0;
				data.delete();
				prev_rd_ack = 0;
				prev_rd_err = 0;
				prev_wr_ack = 0;
				prev_wr_err = 0;
				prev_sinit = 0;
	
			// didn't just transition from SINIT; normal operation
			end else begin
				// compare output pins
				comp_DATA_COUNT(pkt, count);
				comp_EMPTY(pkt, (count == 0) ? 1 : 0);
				comp_FULL(pkt, (count == global_constants::DEPTH) ? 1 : 0);
				comp_RD_ACK(pkt, prev_rd_ack);
				comp_RD_ERR(pkt, prev_rd_err);
				comp_WR_ACK(pkt, prev_wr_ack);
				comp_WR_ERR(pkt, prev_wr_err);
              
              	// reset
              	prev_rd_ack = 0;
              	prev_rd_err = 0;
              	prev_wr_ack = 0;
              	prev_wr_err = 0;
	 
				// compare data
				if (pkt.WR_EN) begin
					// not full; do normal write
					if (count != global_constants::DEPTH) begin
						data.push_back(pkt.DIN);
						count += 1;
						prev_wr_ack = 1;
						prev_wr_err = 0;
                      
                      	`uvm_info("DIN", $sformatf("Data received: %04b", pkt.DIN), UVM_LOW)
					// full, can't write
					end else begin
						prev_wr_ack = 0;
						prev_wr_err = 1;
					end
				end else if (pkt.RD_EN) begin
					// not empty; do normal read
					if (count != 0) begin
						compare = data.pop_front();
						comp_DOUT(pkt, compare);
						count -= 1;
						prev_rd_ack = 1;
						prev_rd_err = 0;
						prev_data = pkt.DOUT;
					// empty, can't read
					end else begin
						comp_DOUT(pkt, prev_data);
						prev_rd_ack = 0;
						prev_rd_err = 1;
					end
				end	
	
				// other misc. items
				// need to make sure data doesn't change unexpectedly out of device
				if ((!pkt.RD_EN) && (pkt.DOUT != prev_data)) begin
					`uvm_error("DOUT", $sformatf("DOUT changed unexpectedly. Expected: %b Actual: %b", prev_data, pkt.DOUT))
				end
	
				// no write and read at the same time
				if (pkt.WR_EN & pkt.RD_EN) begin
					`uvm_error("WR & RD", "WR_EN and RD_EN enabled at same time.")
				end
	
				if ($countones({pkt.RD_ACK, pkt.RD_ERR, pkt.WR_ACK, pkt.WR_ERR}) > 1) begin
					`uvm_error("HANDSHAKE_ERR", ">1 *ACK/*ERR signal HIGH")
				end
			end
		end
	endfunction : write
	
  
  
	// supporting functions
	virtual function void comp_DATA_COUNT(packet pkt, int count);
		if (pkt.DATA_COUNT != count) begin
          `uvm_error("COUNT", $sformatf("DATA_COUNT is incorrect. Expected: %02b Actual: %02b", pkt.DATA_COUNT, count))
		end else begin
			`uvm_info("COUNT", $sformatf("DATA_COUNT correct. Expected: %02b Actual: %02b", pkt.DATA_COUNT, count), UVM_LOW)
		end
	endfunction : comp_DATA_COUNT

	virtual function void comp_DOUT(packet pkt, int compare);
		if (pkt.DOUT != compare) begin
	        	`uvm_error("DOUT", $sformatf("Incorrect data received. Expected: %b Actual: %b", compare, pkt.DOUT))
		end else begin
	                 `uvm_info("DOUT", $sformatf("Data received. Expected: %04b Actual: %b", 4'(compare), pkt.DOUT), UVM_LOW)
	    end 
	endfunction
	
	virtual function void comp_EMPTY(packet pkt, int compare);
		if (pkt.EMPTY != compare) begin
          `uvm_error("EMPTY", $sformatf("Incorrect data received. Expected: %01b Actual: %b", compare, pkt.EMPTY))
		end else begin
          `uvm_info("EMPTY", $sformatf("Data received. Expected: %01b Actual: %b", 1'(compare), pkt.EMPTY), UVM_LOW)
	    end 
	endfunction

  	virtual function void comp_FULL(packet pkt, int compare);
		if (pkt.FULL != compare) begin
          `uvm_error("FULL", $sformatf("Incorrect data received. Expected: %01b Actual: %b", compare, pkt.FULL))
		end else begin
          `uvm_info("FULL", $sformatf("Data received. Expected: %01b Actual: %b", 1'(compare), pkt.FULL), UVM_LOW)
	    end 
	endfunction
	
	virtual function void comp_RD_ACK(packet pkt, int compare);
		if (pkt.RD_ACK != compare) begin
	        	`uvm_error("RD_ACK", $sformatf("Incorrect RD_ACK received. Expected: %01b Actual: %01b", compare, pkt.RD_ACK))
		end else begin
	                 `uvm_info("RD_ACK", $sformatf("RD_ACK correct. Expected: %01b Actual: %b", 1'(compare), pkt.RD_ACK), UVM_LOW)
	    end 
	endfunction : comp_RD_ACK

	virtual function void comp_RD_ERR(packet pkt, int compare);
		if (pkt.RD_ERR != compare) begin
	        	`uvm_error("RD_ERR", $sformatf("Incorrect RD_ERR received. Expected: %01b Actual: %01b", compare, pkt.RD_ERR))
		end else begin
	                 `uvm_info("RD_ERR", $sformatf("RD_ERR correct. Expected: %01b Actual: %b", 1'(compare), pkt.RD_ERR), UVM_LOW)
	    end 
	endfunction : comp_RD_ERR
	
	virtual function void comp_WR_ACK(packet pkt, int compare);
		if (pkt.WR_ACK != compare) begin
	        	`uvm_error("WR_ACK", $sformatf("Incorrect WR_ACK received. Expected: %01b Actual: %01b", compare, pkt.WR_ACK))
		end else begin
	                 `uvm_info("WR_ACK", $sformatf("WR_ACK correct. Expected: %01b Actual: %b", 1'(compare), pkt.WR_ACK), UVM_LOW)
	    end 
	endfunction : comp_WR_ACK

	virtual function void comp_WR_ERR(packet pkt, int compare);
		if (pkt.WR_ERR != compare) begin
	        	`uvm_error("WR_ERR", $sformatf("Incorrect WR_ERR received. Expected: %01b Actual: %01b", compare, pkt.WR_ERR))
		end else begin
	                 `uvm_info("WR_ERR", $sformatf("WR_ERR correct. Expected: %01b Actual: %b", 1'(compare), pkt.WR_ERR), UVM_LOW)
	    end 
	endfunction : comp_WR_ERR
endclass : scoreboard
