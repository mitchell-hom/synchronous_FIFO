class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard);

	function new(string name="scoreboard", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	int compare; // compare data
	int data[$]; // model queue
	uvm_analysis_imp #(packet, scoreboard) mAI;

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mAI = new("mAI", this);
	endfunction : build_phase

	// write to analysis implementation
	// TODO: add more checking here
	virtual function void write(packet pkt);
		// track WRITE operations
		// sync to clock edge done in monitor
		if (pkt.WR_EN  & !pkt.SINIT & !pkt.FULL) begin
			data.push_back(pkt.DIN); // TODO: will data widths work out here???
		// track READ operations
		end else if (pkt.RD_EN & !pkt.SINIT & !pkt.EMPTY) begin
			compare = data.pop_front();
			// TODO: actually compare
			// for now, just write out values
			`uvm_info(get_type_name(), $sformatf("read data: %0d", compare), UVM_LOW);
		end
		// TODO everything else
	endfunction : write
endclass : scoreboard
