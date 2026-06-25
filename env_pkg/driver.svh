class driver extends uvm_driver #(packet);
	`uvm_component_utils(driver);

	virtual DS256_if vIf;

  function new(string name, uvm_component parent); 
		super.new(name, parent);
	endfunction 

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      	// try to retrieve virtual interface; if not, throw error
      assert(uvm_config_db#(virtual DS256_if)::get(this, "", "DS256_if", vIf));
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
      	packet pkt;
      
		forever begin
          	// synchronize; wait for clock edge
          	@vIf.CLK;
          
			// get item from sequencer, drive it to virtual interface
			seq_item_port.get_next_item(pkt);
          
          	// drive contents of packet to interface
			vIf.DIN <= pkt.DIN;
			vIf.WR_EN <= pkt.WR_EN;
			vIf.RD_EN <= pkt.RD_EN;
			//vIf.SINIT <= pkt.SINIT; // TODO: necessary?
          
          	// handshaking with sequencer; lets it know we're done here
			seq_item_port.item_done();
		end // forever
	endtask : run_phase
endclass : driver