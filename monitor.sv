class monitor extends uvm_monitor;
	`uvm_component_utils(monitor);

	function new(string name="monitor", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	uvm_analysis_port #(packet) mAP;
	virtual DS256_if vIf;
	
	// phases
	virtual function void build_phase;
		mAP = new("mAP", this);
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);

		forever begin
			// wait for rising edge of clock, then sample
			@(posedge vIf.CLK);
			packet pkt = new();
			
			// get data from interface
			pkt.DIN <= vIf.DIN;
			pkt.WR_EN <= vIf.WR_EN;
			pkt.RD_EN <= vIf.RD_EN;
			// no clock
			pkt.SINIT <= vIf.SINIT;
			pkt.FULL <= vIf.FULL;
			pkt.DATA_COUNT <= vIf.DATA_COUNT;
			pkt.WR_ACK <= vIf.WR_ACK;
			pkt.WR_ERR <= vIf.WR_ERR;
			pkt.DOUT <= vIf.DOUT;
			pkt.EMPTY <= vIf.EMPTY;
			pkt.RD_ACK <= vIf.RD_ACK;
			pkt.RD_ERR <= vIf.RD_ERR;

			// write to analysis port
			mAP.write(pkt);
		end // forever
	endtask : run_phase
endclass : monitor
