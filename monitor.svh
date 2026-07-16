class monitor extends uvm_monitor;
	`uvm_component_utils(monitor);

	uvm_analysis_port #(packet) monAP;
	virtual DS256_if vIf;

	function new(string name, uvm_component parent);
		super.new(name, parent);
      
      	monAP = new("monAP", this);
	endfunction
	
	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		//monAP = new("monAP", this);

      	// try to retrieve interface
      	if (!uvm_config_db#(virtual DS256_if)::get(this, "", "DS256_if", vIf)) begin
        	`uvm_fatal("MONITOR_NO_VIF", "Could not retrieve virtual interface in monitor")
        end
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		packet pkt;

      	// uvm monitor doesn't have functionality, so we don't call parent
      	// class's run phase
		forever begin
			// wait for edge of clock, then sample
          	@(posedge vIf.CLK); 
			
          	// instantiate packet
          	pkt = packet::type_id::create("pkt");
          
			// get data from interface
			// needs to be blocking bc pkt isn't persistent;
          	// gets dynamically created and destroyed throughout
          	// simulation
			pkt.DIN = vIf.DIN;
			pkt.WR_EN = vIf.WR_EN;
			pkt.RD_EN = vIf.RD_EN; 
			pkt.CLK = vIf.CLK;
			pkt.SINIT = vIf.SINIT;
			pkt.FULL = vIf.FULL;
			pkt.DATA_COUNT = vIf.DATA_COUNT;
			pkt.WR_ACK = vIf.WR_ACK;
			pkt.WR_ERR = vIf.WR_ERR;
			pkt.EMPTY = vIf.EMPTY;
			pkt.RD_ACK = vIf.RD_ACK;
			pkt.RD_ERR = vIf.RD_ERR;
          
          	//#1; // offset for read
          	pkt.DOUT = vIf.DOUT;

			// write to analysis port
			monAP.write(pkt);
		end // forever
	endtask : run_phase
endclass : monitor
