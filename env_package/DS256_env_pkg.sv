package DS256_env_pkg;
	import global_constants::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	// testbench files; these need to be in hierarchical order
	`include "packet.sv"
	// sequences
	`include "./sequences/seq_startup.sv"
	// end sequences
	`include "driver.sv"
	`include "monitor.sv"
	`include "agent.sv"
	`include "scoreboard.sv"
	`include "environment.sv"
	`include "base_test.sv"
endpackage : DS256_env_pkg
