class driver extends uvm_driver #(packet);
	`uvm_component_utils(driver);

	virtual DS256_if vIf;

	function new(string name="driver", uvm_component parent=null); 
		super.new(name, parent);
	endfunction 

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

                if (!uvm_config_db#(virtual DS256_if)::get(null, "*", "vIf", vIf)) begin
                        `uvm_fatal("VIF_ERROR", "Could not retrieve virtual interface.")
                end
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
		@(posedge vIf.CLK); // TODO make sure this happens at edge of clock (rising or falling)
		vIf.DIN <= pkt.DIN;
		vIf.WR_EN <= pkt.WR_EN;
		vIf.RD_EN <= pkt.RD_EN;
		vIf.SINIT <= pkt.SINIT;
	endtask : drive_pkt
endclass : driver
