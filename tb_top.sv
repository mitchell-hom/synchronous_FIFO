`timescale 1ns/1ps

import uvm_pkg::*;
import DS256_env_pkg::*;
`include "uvm_macros.svh"

module tb_top;
	logic clk, sinit;

	// clock generation at specified frequency
	//always #global_constants::PERIOD clk =~ clk;
	//always #10 clk =~ clk; // TODO fix this
	initial begin 
		clk = 0;
		forever begin
			#10 clk =~ clk;
		end
	end

	DS256_if Iif(clk, sinit);
	DS256 Idut(	.CLK(Iif.CLK), 
			.DIN(Iif.DIN),
			.WR_EN(Iif.WR_EN),
			.RD_EN(Iif.RD_EN),
			.SINIT(Iif.SINIT),
			.FULL(Iif.FULL),
			.DATA_COUNT(Iif.DATA_COUNT),
			.WR_ACK(Iif.WR_ACK),
			.WR_ERR(Iif.WR_ERR),
			.DOUT(Iif.DOUT),
			.EMPTY(Iif.EMPTY),
			.RD_ACK(Iif.RD_ACK),
			.RD_ERR(Iif.RD_ERR));
	base_test Itest;

	// initialize
	initial begin
		sinit = 1;
		#10;
		sinit = 0;
	end

	// meat and potatoes
	initial begin
		// VIRTUAL; because we have to pass in as virtual
		uvm_config_db#(virtual DS256_if)::set(uvm_root::get(), "*", "vIf", Iif);
		//run_test("test");
	end

	// run test
	initial begin
		run_test("base_test");
	end

	// write data
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1, tb_top); 
	end // initial begin...
endmodule : tb_top
