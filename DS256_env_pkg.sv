package DS256_env_pkg;
	import global_constants::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	// testbench files
	`include "packet.sv"
	`include "seq_startup.sv"
	`include "driver.sv"
	`include "monitor.sv"
	`include "agent.sv"
	`include "scoreboard.sv"
	`include "environment.sv"
	`include "test.sv"
endpackage : DS256_env_pkg
