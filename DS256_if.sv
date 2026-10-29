interface DS256_if(input bit CLK);
  	logic SINIT;
	logic [global_constants::BUS_WIDTH-1:0] DIN;
	logic WR_EN;
	logic RD_EN;
	logic FULL;
	logic [global_constants::COUNT_BITS-1:0] DATA_COUNT;
	logic WR_ACK;
	logic WR_ERR;
	logic [global_constants::BUS_WIDTH-1:0] DOUT;
	logic EMPTY;
	logic RD_ACK;
	logic RD_ERR;

	// CLOCKING BLOCKS
	// want to drive at the negative edge of clock to avoid races/stale data
	clocking drv_cb @(negedge CLK);
		output SINIT;
		output DIN;
		output WR_EN, RD_EN;
	endclocking : drv_cb 

	// sample at posedge, but sample AFTER driver drives & DUT responds
	clocking mon_cb @(posedge CLK);
		default input #1step output #0; // TODO: see if this is sufficient? 

		input SINIT;
		input DIN;
		input WR_EN;
		input RD_EN;
		
		output FULL;
		output DATA_COUNT;
		output WR_ACK;
		output WR_ERR;
		output DOUT;
		output EMPTY;
		output RD_ACK;
		output RD_ERR;
	endclocking : mon_cb
endinterface : DS256_if
