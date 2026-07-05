class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard);
  
  	bit [global_constants::DEPTH-1:0] compare; // compare data
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
          
  		// TODO: handshaking?
        // TODO: data offset by one clock edge
        // everything else
      	end else begin
        	// write
          	if (pkt.WR_EN) begin
              	data.push_back(pkt.DIN);
            end else if (pkt.RD_EN) begin
              	compare = data.pop_front();
              
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
