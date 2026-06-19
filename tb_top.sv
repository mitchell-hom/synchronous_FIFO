module tb_top;
	import uvm_pkg::*;
	import DS256_env_pkg::*;

	reg clk;

	// clock generation at specified frequency
	//always #global_constants::PERIOD clk =~ clk;
	always #10 clk =~ clk; // TODO fix this

	DS256_if Iif(clk);
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
	test Itest;

	// meat and potatoes
	initial begin
		// VIRTUAL; because we have to pass in as virtual
		uvm_config_db#(virtual DS256_if)::set(null, "uvm_test_top", "vIf", Iif);
		run_test("test");

		#10;
		$finish; // TODO: do I need this???
	end

	// write data
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars; 
	end // initial begin...
endmodule : tb_top
