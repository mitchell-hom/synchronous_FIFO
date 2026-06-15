module tb_top;
	import uvm_pkg::*;
	import DS256_env_pkg::*;
	
	reg clk;

	// clock generation at specified frequency
	always #PERIOD clk = ~= clk;

	DS256_if Iif(clk);
	DS256 Idut(	.DIN(Iif.DIN),
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
		#10;
		Itest = new();
		Itest.Ienv.vIf = Iif;
		Itest.run();

		#10;
		$finish;
	end

	initial begin
		$dumpvars;
		$dumpfile ("dump.vcd"); // TODO: correct file type?
	end // initial begin...
endmodule : tb_top
