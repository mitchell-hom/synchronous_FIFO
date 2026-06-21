class monitor extends uvm_monitor;
	`uvm_component_utils(monitor);

	uvm_analysis_port #(packet) monAP;
	virtual DS256_if vIf;

	function new(string name="monitor", uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		monAP = new("monAP", this);

		if (!uvm_config_db#(virtual DS256_if)::get(null, "*", "vIf", vIf)) begin
			`uvm_fatal("VIF_ERROR", "Could not retrieve virtual interface.")
		end
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		packet pkt;

		super.run_phase(phase);

		forever begin
			// wait for edge of clock, then sample
			@(vIf.CLK);
			pkt = new();
			
			// get data from interface
			// need to be blocking bc pkt is temporary; might
			// disappear before assignment
			pkt.DIN = vIf.DIN;
			pkt.WR_EN = vIf.WR_EN;
			pkt.RD_EN = vIf.RD_EN;
			// no clock
			pkt.SINIT = vIf.SINIT;
			pkt.FULL = vIf.FULL;
			pkt.DATA_COUNT = vIf.DATA_COUNT;
			pkt.WR_ACK = vIf.WR_ACK;
			pkt.WR_ERR = vIf.WR_ERR;
			pkt.DOUT = vIf.DOUT;
			pkt.EMPTY = vIf.EMPTY;
			pkt.RD_ACK = vIf.RD_ACK;
			pkt.RD_ERR = vIf.RD_ERR;

			// write to analysis port
			monAP.write(pkt);
		end // forever
	endtask : run_phase
endclass : monitor
