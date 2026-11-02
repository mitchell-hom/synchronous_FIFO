class base_test extends uvm_test;
	`uvm_component_utils(base_test)

	environment Ienvironment;

	function new(string name, uvm_component parent);
		super.new(name, parent);
    endfunction 
  
    // output text
  	virtual function void end_of_elaboration_phase(uvm_phase phase);
    	UVM_FILE run_log;
      	uvm_root top;
      	run_log = $fopen("run.log", "w");
      
      	top = uvm_root::get();
      
      	top.set_report_default_file(run_log);
      
      	top.set_report_severity_action(UVM_INFO,  UVM_DISPLAY | UVM_LOG); 
      	top.set_report_severity_action(UVM_ERROR, UVM_DISPLAY | UVM_LOG | UVM_COUNT);
  	endfunction : end_of_elaboration_phase

	// phases
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		Ienvironment = environment::type_id::create("Ienvironment", this);
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
      	seq_write Iwrite;
      
		// make sure sim doesn't end while this is running
		phase.raise_objection(this); 
      
      	// instantiate sequence
      	Iwrite = seq_write::type_id::create("Iwrite");

		// run 
		Iwrite.start(Ienvironment.Iagent.Isequencer);
      	#30;
      
		// can end now
		phase.drop_objection(this); 
	endtask : run_phase
endclass : base_test
