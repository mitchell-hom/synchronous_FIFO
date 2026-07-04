class environment extends uvm_env;
	`uvm_component_utils(environment);

	agent Iagent;
	scoreboard Iscoreboard;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		Iagent = agent::type_id::create("Iagent", this);
		Iscoreboard = scoreboard::type_id::create("Iscoreboard", this);
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		Iagent.monAP.connect(Iscoreboard.mAI);
	endfunction : connect_phase
endclass : environment
