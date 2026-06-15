class driver extends uvm_driver(packet);
	`uvm_component_utils(driver);

	function new(string name="driver"); // TODO: need to add something for uvm parent attribute?
		super.new(name);
	endfunction : new

	virtual DS256_if vIf;

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		forever begin
			packet pkt;

			// get item from sequencer, drive it to virtual interface
			seq_item_port.get_next_item(pkt);
			drive_pkt(pkt);
			seq_item_port.item_done();
		end // forever
	endtask : run_phase

	// other functions/tasks
	virtual task drive_pkt(packet pkt);
		@(posedge vIf.CLK); // make sure this happens at rising edge of clock
		vIf.DIN <= pkt.DIN;
		vIf.WR_EN <= pkt.WR_EN;
		vIf.RD_EN <= pkt.RD_EN;
		vIf.SINIT <= pkt.SINIT;
	endtask : drive_pkt
endclass : driver
