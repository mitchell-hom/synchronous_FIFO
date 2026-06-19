class test extends uvm_test;
	`uvm_component_utils(test)
	
	function new(string name="test", uvm_component parent=null);
		super.new(name, parent);
	endfunction 

	environment Ienv;
	virtual DS256_if vIf;

	// phases
	virtual function void build_phase(uvm_phase phase);
		uvm_config_db#(virtual DS256_if)::set(this, "Ienv.Iagent.*", "DS256_if", vIf); 

		super.build_phase(phase);

		if (!uvm_config_db#(virtual DS256_if)::get(this, "", "vIf", vIf)) begin
			`uvm_fatal("vIf_test_error", "could not find virtual interface");
		end
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		seq_startup Istartup = seq_startup::type_id::create("Istartup");
		phase.raise_objection(this); // make sure sim doesn't end while this is running
		
		// run 
		Istartup.start(Ienv.Iagent.Iseq);
		#200; // TODO: better way to do this?
		phase.drop_objection(this); // can end now
	endtask : run_phase
endclass : test
