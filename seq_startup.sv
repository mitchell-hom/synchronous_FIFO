class seq_startup extends uvm_sequence #(packet);
	`uvm_object_utils (seq_startup)

	packet pkt;

	function new (string name="seq_startup");
		super.new(name);
	endfunction : new

	virtual task body();
		`uvm_info("Starting body of startup sequence")
		
		// create stimulus
		pkt = packet::type_id::create("pkt");
		
		// drive for the prescribed number of clock cycles
		start_item(pkt);
		pkt.SINIT = 1'b1;
		pkt.DIN = '0;
		pkt.WR_EN = '0;
		pkt.RD_EN = '0;
		finish_item(pkt);

		repeat(STARTUP_CYCLES-1) begin
			start_item(pkt);
			finish_item(pkt);
		end // repeat
		
		`uvm_info("Startup sequence complete");
	endtask : body
endclass : seq_startup
