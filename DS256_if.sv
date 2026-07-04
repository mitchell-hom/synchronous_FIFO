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
  
  	// helps to sample at the correct part of timestep
  clocking cb @(posedge CLK);
    	// define when things get sampled
    	default input #1step output #0;
    
    	// testbench outputs
    	output WR_EN;
    	output RD_EN;
    
    	// testbench inputs
      	input FULL; 
      	input DATA_COUNT;
      	input WR_ACK;
      	input WR_ERR;
      	input DOUT;
      	input EMPTY;
      	input RD_ACK;
      	input RD_ERR;
    endclocking : cb
endinterface : DS256_if
