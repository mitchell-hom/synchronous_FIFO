class environment extends uvm_env;
	`uvm_component_utils(environment);

	function new (string name="environment", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	agent Iagent;
	scoreboard Isb;

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		Iagent = agent::type_id::create("Iagent", this);
		Isb = scoreboard::type_id::create("Isb", this);
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		Iagent.Imon.mAP.connect(Isb.mAI);
	endfunction : connect_phase
endclass : environment
