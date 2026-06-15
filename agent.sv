class agent extends uvm_agent;
	`uvm_component_utils(agent);

	function new(string name="agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	// handles
	driver Idrv;
	monitor Imon;
	uvm_sequencer #(packet) Iseq;

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		Idrv = driver::type_id::create("Idrv", this);
		Imon = monitor::type_id::create("Imon", this);
		Iseq  = uvm_sequencer#(packet)::type_id::create("Iseq", this);
	endfunction : build_phase	

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		Idrv.seq_item_port.connect(Iseq.seq_item_export);
	endfunction : connect_phase
endclass : agent
