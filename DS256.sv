// synchronous FIFO
// depth: 4
// bus width: 4

/* NOTE: this design assumes that 1 timestep is significantly less than the period of the clock
this is because of the flagging for the FIFO being full, which updates the timestep AFTER
the data is latched */

module DS256 (	input [global_constants::BUS_WIDTH-1:0] DIN,
		input WR_EN,
		input RD_EN,
		input CLK,
		input SINIT,
		output reg FULL,
		output reg [global_constants::COUNT_BITS-1:0] DATA_COUNT, 
		output reg WR_ACK,
		output reg WR_ERR,
		output reg [global_constants::BUS_WIDTH-1:0] DOUT,
		output reg EMPTY,
		output reg RD_ACK,
		output reg RD_ERR);

	bit [global_constants::COUNT_BITS-1:0] count;
	bit [global_constants::DEPTH-1:0] rPtr, wPtr;
	reg [global_constants::DEPTH-1:0] array [global_constants::BUS_WIDTH-1:0];
	reg fullFlag, emptyFlag;

	always_ff @(posedge CLK) begin
		// SINIT; synchronous reset
		if (SINIT) begin
			array <= '{global_constants::DEPTH{'0}}; // clear memory
			// reset pointers
			wPtr <= 0; 
			rPtr <= 0;
			count <= 0;	
          
          	fullFlag <= 0;
          	emptyFlag <= 1;

			// reset output pins
			//DATA_COUNT <= 0;		
			EMPTY <= 1;
			FULL <= 0;

		// no SINIT; normal operation
		end else begin
          	// reset handshaking
          	WR_ACK <= 0;
          	WR_ERR <= 0;
          	RD_ACK <= 0;
          	RD_ERR <= 0;
          
			// WRITE operation
			if (WR_EN) begin
				// ERRORS
				if (fullFlag | RD_EN) begin
					WR_ERR <= 1;
					WR_ACK <= 0;
				// no error; do a write
				end else begin
					// write
					array[wPtr] <= DIN;

					// update pointer
                  	wPtr <= (wPtr == global_constants::DEPTH-1) ? 0 : wPtr + 1;
					//wPtr <= wPtr + 1;
					count <= count + 1;

					// set output pins
					WR_ACK <= 1;
					WR_ERR <= 0;		
				end
			end // WRITE operation

			// READ operation
			if (RD_EN) begin
				// ERRORS
				if (emptyFlag | WR_EN) begin
					RD_ERR <= 1;
					RD_ACK <= 0;
				// no error; do a read
				end else begin
					// read
					DOUT <= array[rPtr];

					// update pointer
					//rPtr <= rPtr + 1;
                 	rPtr <= (rPtr == global_constants::DEPTH-1) ? 0 : rPtr + 1;
					count <= count - 1;

					// set output pins
					RD_ACK <= 1;
					RD_ERR <= 0;
				end 
			end // READ operation
          
          	// full/empty handshaking
            if (count == '0) begin
            	FULL <= 0;
              	fullFlag <= 0;
              	EMPTY <= 1;
              	emptyFlag <= 0;
            end else if (count == global_constants::DEPTH) begin
              	FULL <= 1;
              	fullFlag <= 1;
              	EMPTY <= 0;
              	emptyFlag <= 0;
            end else begin
              	FULL <= 0;
              	fullFlag <= 0;
              	EMPTY <= 0;
              	emptyFlag <= 0;
            end
		end // normal operation (non-reset)	
	end // always_ff...
  
  	always_comb begin
    	if (SINIT) begin
      		DATA_COUNT = 0;
      	end else begin
        	DATA_COUNT = count;
      end
    end
endmodule : DS256;
