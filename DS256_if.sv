interface DS_256_if.sv(input bit CLK);
	logic [BUS_WIDTH-1:0] DIN;
	logic WR_EN;
	logic RD_EN;
	//logic CLK;
	logic SINIT;
	logic FULL;
	logic [COUNT_BITS-1:0] DATA_COUNT;
	logic WR_ACK;
	logic WR_ERR;
	logic [BUS_WIDTH-1:0] DOUT;
	logic EMPTY;
	logic RD_ACK;
	logic RD_ERR;
endinterface : DS_256_if.sv
