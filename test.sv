class test extends uvm_test;
	`uvm_component_utils(test)
	
	function new(string name="test", uvm_component parent=null);
		super.new(name, parent);
	endfunction 

	environment Ienv;
	//uvm_component myTop; // need for verilator
	virtual DS256_if vIf;

	// phases
	virtual function void build_phase(uvm_phase phase);
		uvm_config_db#(virtual DS256_if)::set(this, "Ienv.Iagent.*", "DS256_if", vIf); // TODO: what is this line???
		//myTop = uvm_top;
		//uvm_config_db#(virtual DS256_if)::set(null, "*Ienv.Iagent*", "DS256_if", vIf); // TODO: need "." before *? 
		//uvm_resource_db#(virtual DS256_if)::set(.scope("*Ienv.Iagent*"), .name("DS256_if"), .val(vIf));
		super.build_phase(phase);

		if (!uvm_config_db#(virtual DS256_if)::get(this, "", "vIf", vIf)) begin
			`uvm_fatal("vIf_test_error", "could not find virtual interface");
		end
		//uvm_config_db#(DS256_vif_wrapper)::set(null, "*Ienv.Iagent*", "DS256_vif_wrapper", wIf);
		//Ienv.Iagent.Idrv.vIf = tb_top.Iif;
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
