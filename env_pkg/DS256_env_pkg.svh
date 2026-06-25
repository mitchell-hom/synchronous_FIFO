package DS256_env_pkg;
	import global_constants::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	// testbench files; these need to be in hierarchical order
	`include "packet.svh"
	// sequences
	`include "./sequences/seq_startup.svh"
	// end sequences
	`include "driver.svh"
	`include "monitor.svh"
	`include "agent.svh"
	`include "scoreboard.svh"
	`include "environment.svh"
	`include "base_test.svh"
endpackage : DS256_env_pkg
