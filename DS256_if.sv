interface DS256_if(input bit CLK, input bit SINIT);
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
endinterface : DS256_if