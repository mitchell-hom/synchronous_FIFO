class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard);
  
  	int compare; // compare data
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
		
      	// instantiate analysis implementation
      	//mAI = new("mAI", this);
	endfunction : build_phase
  
  	virtual function void check_phase(uvm_phase phase);
    	super.check_phase(phase);
   
      	`uvm_info("SB_CHECK", "starting check phase", UVM_LOW)
      
      	// iterate through captured packets
      	foreach (pkts[i]) begin
          	// track WRITE operations
			// sync to clock edge done in monitor
          	if (pkts[i].WR_EN  && !pkts[i].SINIT && !pkts[i].FULL) begin
            	data.push_back(pkts[i].DIN); 
          
			// track READ operations
            end else if (pkts[i].RD_EN && !pkts[i].SINIT && !pkts[i].EMPTY) begin
				compare = data.pop_front();
              
            	if (pkts[i].DOUT != compare) begin
            	`	uvm_error("SB_READ", $sformatf("Incorrect data received. Expected: %b Actual: %b", compare, pkts[i].DOUT))
				end else begin
            		`uvm_info("SB_READ", $sformatf("Data received. Expected: %b Actual: %b", compare, pkts[i].DOUT), UVM_LOW)
                end // else
            end // else if
    	end // foreach
	endfunction : check_phase
    
  	
	// other functions
  	// capture data for later comparison
  	virtual function void write(packet pkt);
      	packet pkt_cpy;
      	$cast(pkt_cpy, pkt.clone());
      
      	pkts.push_back(pkt_cpy);
    endfunction : write
endclass : scoreboard
