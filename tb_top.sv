`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
import DS256_env_pkg::*;

module tb_top;
	logic clk, sinit;
  
  	// clock generation at specified frequency
	//always #global_constants::PERIOD clk =~ clk;
	//always #10 clk =~ clk; // TODO fix this
  	always #10 clk =~ clk;

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
  
  	// run verification
  	initial begin
      uvm_config_db#(virtual DS256_if)::set(null, "*", "DS256_if", Iif);
      run_test();
    end

  	// initialize values
  	initial begin
      	clk = 0;
      	sinit = 1;
      
      	#10;
      	sinit = 0;
    end      	

	// write data to output file
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1, tb_top); 
	end 
endmodule : tb_top