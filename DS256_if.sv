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
		
		input FULL;
		input DATA_COUNT;
		input WR_ACK;
		input WR_ERR;
		input DOUT;
		input EMPTY;
		input RD_ACK;
		input RD_ERR;
	endclocking : mon_cb
  
	modport mon_mp (clocking mon_cb);
    	modport drv_mp (clocking drv_cb);
endinterface : DS256_ifndinterface : DS256_if
