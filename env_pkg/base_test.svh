class base_test extends uvm_test;
	`uvm_component_utils(base_test)

	environment Ienvironment;

	function new(string name, uvm_component parent);
		super.new(name, parent);
    endfunction 

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		Ienvironment = environment::type_id::create("Ienvironment", this);
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
      	seq_startup Istartup;
      
		// make sure sim doesn't end while this is running
		phase.raise_objection(this); 
      
      	// instantiate sequence
     	Istartup = seq_startup::type_id::create("Istartup");

		// run 
		Istartup.start(Ienvironment.Iagent.Isequencer);
      	// TODO add uvm info here
      	#10;
      
		// can end now
		phase.drop_objection(this); 
	endtask : run_phase
endclass : base_test