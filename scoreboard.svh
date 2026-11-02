class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard);

	uvm_analysis_imp #(packet, scoreboard) mAI;
	int compare;
  	logic [global_constants::BUS_WIDTH-1:0] wr_queue[$];
    logic [global_constants::BUS_WIDTH-1:0] rd_queue[$];
	
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
        print_pkt(pkt);
		// TODO reset
		if (pkt.SINIT) begin
			// reset pointers
			// reset memory
			// reset outputs
		end else begin			
          	//// READ CHECKING ////
          	// output read data/compare
          	if (rd_queue.size() > 0) begin
				compare = rd_queue.pop_front();
				comp_DOUT(pkt, compare);
			end
          
            if (pkt.WR_EN) begin
				// successful write
              	if (wr_queue.size() < global_constants::DEPTH) begin
                  	wr_queue.push_back(pkt.DIN);
				end // TODO: rejected write
			end
          
            //// READ OPERATION ////
            // register read command         
          	if (pkt.RD_EN) begin
				// successful read
              	if (wr_queue.size() > 0) begin
                    // push to read queue                   
                  	rd_queue.push_back(wr_queue.pop_front());
				end // TODO: rejected read
			end
          
          	// TODO: read and write at the same time
		end // else
	endfunction : write
       	
	
  
	// supporting functions
  	virtual function void print_pkt(packet pkt);
      	$display($time);
    	$display("PACKET RECEIVED AT MONITOR: ");
    	$display("WR_EN: %1b", pkt.WR_EN);
      	$display("DIN: %04b", pkt.DIN);
    	$display("RD_EN, %1b", pkt.RD_EN);
        $display("DOUT: %04b", pkt.DOUT);
       	$display("");
    endfunction : print_pkt
    
	virtual function void comp_DATA_COUNT(packet pkt, int count);
		if (pkt.DATA_COUNT != count) begin
          `uvm_error("COUNT", $sformatf("DATA_COUNT is incorrect. Expected: %03b Actual: %03b", count, pkt.DATA_COUNT))
		end else begin
          `uvm_info("COUNT", $sformatf("DATA_COUNT correct. Expected: %03b Actual: %03b", count, pkt.DATA_COUNT), UVM_LOW)
		end
	endfunction : comp_DATA_COUNT

	virtual function void comp_DOUT(packet pkt, int compare);
		if (pkt.DOUT != compare) begin
          `uvm_error("DOUT", $sformatf("Incorrect data received. Expected: %04b Actual: %b", compare, pkt.DOUT))
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
