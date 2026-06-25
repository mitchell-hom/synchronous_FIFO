class agent extends uvm_agent;
	`uvm_component_utils(agent);

	function new(string name="agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	// handles
	driver Idriver;
	uvm_analysis_port #(packet) monAP;
	monitor Imonitor;
	uvm_sequencer #(packet) Isequencer;

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		monAP = new("monAP", this);
		Idriver = driver::type_id::create("Idriver", this);
		Imonitor = monitor::type_id::create("Imonitor", this);
		Isequencer  = uvm_sequencer#(packet)::type_id::create("Isequencer", this);
	endfunction : build_phase	

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		Idriver.seq_item_port.connect(Isequencer.seq_item_export);
	endfunction : connect_phase
endclass : agent
