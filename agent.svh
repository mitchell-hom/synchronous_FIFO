class agent extends uvm_agent;
	`uvm_component_utils(agent);
  
  	// handles
	driver Idriver;
  	cov Icov;
	uvm_analysis_port #(packet) monAP;
	monitor Imonitor;
	uvm_sequencer #(packet) Isequencer;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		monAP = new("monAP", this);
		Idriver = driver::type_id::create("Idriver", this);
		Imonitor = monitor::type_id::create("Imonitor", this);
		Isequencer  = uvm_sequencer#(packet)::type_id::create("Isequencer", this);
      	Icov = cov::type_id::create("Icov", this);
	endfunction : build_phase	

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
      
      	// connect ports
		Idriver.seq_item_port.connect(Isequencer.seq_item_export);
      	Imonitor.monAP.connect(monAP);
      	Imonitor.monAP.connect(Icov.ai);
	endfunction : connect_phase
endclass : agent
