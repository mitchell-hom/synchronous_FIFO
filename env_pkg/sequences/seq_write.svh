class seq_write extends uvm_sequence #(packet);
  `uvm_object_utils (seq_write)

	packet pkt;

  function new (string name="seq_write");
		super.new(name);
	endfunction

	virtual task body();
      `uvm_info("seq_write", "Starting body of write sequence", UVM_LOW)
		
		// create stimulus
		pkt = packet::type_id::create("pkt");
		
		// drive for the prescribed number of clock cycles
		start_item(pkt);
      
      	// turn off randomization
      	pkt.rand_mode(0);

      	// set contents of packet
		pkt.SINIT = 0;
		pkt.DIN = '0;
		pkt.WR_EN = '0;
		pkt.RD_EN = '0;

		finish_item(pkt);

      	// WRITE operation
      	for (int i = 0; i < global_constants::BUS_WIDTH; i++) begin
        	// need to instantiate every time
        	pkt = packet::type_id::create("pkt");
        	start_item(pkt);
          	pkt.rand_mode(0);
        	pkt.WR_EN = 1;
        	pkt.DIN = i;
        	finish_item(pkt);
      	end
      
      	// READ operation
      	for (int i = 0; i < global_constants::BUS_WIDTH; i++) begin
        	pkt = packet::type_id::create("pkt");
        	start_item(pkt);
          	pkt.rand_mode(0);
        	pkt.WR_EN = 0;
        	pkt.RD_EN = 1;
        	pkt.DIN = '0;
        	finish_item(pkt);
      	end
      
      	// constrained random
      	// TODO: constraints
      	repeat(10) begin
        	pkt = packet::type_id::create("pkt");
          	start_item(pkt);
          	assert(pkt.randomize());
          	finish_item(pkt);
      	end
		
      `uvm_info("seq_write", "Write sequence complete", UVM_LOW);
	endtask : body
endclass : seq_write
