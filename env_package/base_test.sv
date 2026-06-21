class base_test extends uvm_test;
	`uvm_component_utils(base_test)

	environment Ienvironment;
	virtual DS256_if vIf;

	function new(string name="base_test", uvm_component parent=null);
		super.new(name, parent);
		$display("base_test working properly!");
	endfunction 

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if (!uvm_config_db#(virtual DS256_if)::get(this, "", "vIf", vIf)) begin // null b/c of compiler
			`uvm_fatal("vIf_test_error", "could not find virtual interface");
		end

		Ienvironment = environment::type_id::create("Ienvironment", this);
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		seq_startup Istartup = seq_startup::type_id::create("Istartup");

		// make sure sim doesn't end while this is running
		phase.raise_objection(this); 
		
		// compiler-specific
		//Istartup.starting_phase = null;
	
		// wait for driver to be fully active
		@(negedge vIf.SINIT);
		@(posedge vIf.CLK);
		//#15;

		// run 
		Istartup.start(Ienvironment.Iagent.Isequencer);
		#200; // TODO: better way to do this?

		// can end now
		phase.drop_objection(this); 
	endtask : run_phase

	
	virtual function void phase_started(uvm_phase phase); 
		if (phase.is(uvm_run_phase::get())) begin
			if (phase.get_objection().get_objection_count(this) == 0) begin
				`uvm_info("HOPPER_FIX", "catching time-zero fatal error", UVM_LOW)
				phase.raise_objection(this, "Verilator Core Stabilizer");

				// force sim time
				fork 
					begin
						#50;
						phase.drop_objection(this, "Verilator Core Stabilizer");
					end
				join_none
			end // if (phase.get...)
		end // if (phase.is...)
	endfunction : phase_started
	

	// stalls ending of phases; compiler-specific
	/*
	virtual function void phase_ready_to_end(uvm_phase phase); 
		if (phase.is(uvm_run_phase::get())) begin
			if (phase.get_objection().get_objection_count(this) == 0) begin
				`uvm_info("HOPPER_FIX", "catching time-zero fatal error", UVM_LOW)
				phase.raise_objection(this, "Verilator Engine Anchor");

				// force sim time
				fork begin
					#10;
					phase.drop_objection(this, "Verilator Engine Anchor");
				end
				join_none
			end // if (phase.get...)
		end // if (phase.is...)
	endfunction : phase_ready_to_end
	*/
endclass : base_test
