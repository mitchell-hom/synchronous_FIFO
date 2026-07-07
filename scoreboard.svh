class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard);
  
  	bit [global_constants::DEPTH-1:0] compare; // compare data
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
          	// clear queue
        	data.delete();
          	count = 0; // TODO: when does this get sampled?
          
        // everything else
      	end else begin
          	// count 
          	if (count != pkt.DATA_COUNT) begin
              	`uvm_error("COUNT", $sformatf("DATA_COUNT incorrect. Expected: %02b Actual: %02b", count, pkt.DATA_COUNT))
            end else begin
              	`uvm_info("COUNT", $sformatf("DATA_COUNT correct. Expected: %02b Actual: %02b", count, pkt.DATA_COUNT), UVM_LOW)
            end
          
          	// full
          	if (count == global_constants::DEPTH) begin
              	if (pkt.FULL != 1) begin
                  	`uvm_error("FULL", "FULL not correct for full queue.")
                end else begin
                  	`uvm_info("FULL", "FULL correct for full queue.", UVM_LOW)
                end 
            end else begin
              	if (pkt.FULL != 0) begin
                  	`uvm_error("FULL", "FULL not correct for non-full queue.")
                end else begin
                  	`uvm_info("FULL", "FULL correct for non-full queue.", UVM_LOW)
                end 
            end
          
          	// empty
          	if (count == 0) begin
          		if (pkt.EMPTY != 1) begin
              		`uvm_error("EMPTY", "EMPTY not correct for EMPTY queue.")
                end else begin
                  `uvm_info("EMPTY", "EMPTY correct for EMPTY queue.", UVM_LOW)
                end 
            end else begin
              	if (pkt.EMPTY != 0) begin
                  `uvm_error("EMPTY", "EMPTY not correct for non-empty queue.")
                end else begin
                  `uvm_info("EMPTY", "EMPTY correct for non-EMPTY queue.", UVM_LOW)
                end 
            end
          
          	// ERROR: WR_EN and RD_EN both on
          	if (pkt.WR_EN & pkt.RD_EN) begin
            	`uvm_error("WR_RD_EN", "Both WR_EN and RD_EN detected.")
              
              	// check error signals
              	if (pkt.RD_ERR != 1) begin
                	`uvm_error("RD_ERR", "RD_ERR not HIGH when both WR_EN and RD_EN HIGH")
              	end
              
              	if (pkt.WR_ERR != 1) begin
                  `uvm_error("WR_ERR", "WR_ERR not HIGH when both WR_EN and RD_EN HIGH")
                end
              
                // check ack signals
              	if (pkt.RD_ACK != 0 ) begin
                  `uvm_error("RD_ACK", "RD_ACK not LOW when both WR_EN and RD_EN HIGH")
                end
              
              	if (pkt.WR_ACK != 0) begin
                  `uvm_error("RD_ACK", "RD_ACK not LOW when both WR_EN and RD_EN HIGH")
              	end
              
              
            // write
            end else if (pkt.WR_EN) begin
              	// ERROR: FULL
              	if (count >= global_constants::DEPTH) begin
                  	if (pkt.WR_ERR != 1) begin
                    	`uvm_error("WR_ERR", "WR_ERR not HIGH when writing to full FIFO.")
                    end else begin
                      	`uvm_info("WR_ERR", "WR_ERR correct for write to full FIFO", UVM_LOW)
                    end

                // no error: add to expected array
                end else begin
              		data.push_back(pkt.DIN);
              		count += 1;
                end
              
              
             // read
            end else if (pkt.RD_EN) begin
              	// ERROR: empty
              	if (count == 0) begin
                  	`uvm_error("RD_ERR", "RD_ERR not HIGH when reading from empty FIFO.")
                    end else begin
                      `uvm_info("WR_ERR", "RD_ERR correct for read from empty FIFO", UVM_LOW)
                    end
                end else begin
              		compare = data.pop_front();
              		count -= 1;
              
                	// do comparison
              		if (pkt.DOUT != compare) begin
            			`uvm_error("SB_READ", $sformatf("Incorrect data received. Expected: %b Actual: %b", compare, pkt.DOUT))
					end else begin
                  		`uvm_info("SB_READ", $sformatf("Data received. Expected: %04b Actual: %b", 4'(compare), pkt.DOUT), UVM_LOW)
                	end // else
            	end
        	end
    endfunction : write
endclass : scoreboard
