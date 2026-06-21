class seq_startup extends uvm_sequence #(packet);
	`uvm_object_utils (seq_startup)

	packet pkt;

	function new (string name="seq_startup");
		super.new(name);
	endfunction

	virtual task body();
		`uvm_info("seq_startup", "Starting body of startup sequence", UVM_LOW)
		
		// create stimulus
		pkt = packet::type_id::create("pkt");
		
		// drive for the prescribed number of clock cycles
		start_item(pkt);

		pkt.SINIT = 1'b1;
		pkt.DIN = '0;
		pkt.WR_EN = '0;
		pkt.RD_EN = '0;
		void'(pkt.SINIT.rand_mode(0));
		void'(pkt.DIN.rand_mode(0));
		void'(pkt.WR_EN.rand_mode(0));
		void'(pkt.RD_EN.rand_mode(0));

		if (!pkt.randomize()) begin
			`uvm_fatal("seq_startup", "randomization failed")
		end

		finish_item(pkt);

		repeat(STARTUP_CYCLES-1) begin
			start_item(pkt);
			// forces sequencer to wait for clock edge???
			pkt.SINIT = 1'b1; // experiment to see if it runs
			finish_item(pkt);
		end // repeat
		
		`uvm_info("seq_startup", "Startup sequence complete", UVM_LOW);
	endtask : body
endclass : seq_startup
