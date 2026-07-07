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
  
  	clocking mon_cb @(posedge CLK);
      	// from perspective of tb
      	// input = input to testbench
    	default input #1step;
      
      	// gets sampled 1 timestep before clock edge
      	input RD_EN;
    endclocking : mon_cb
endinterface : DS256_if
