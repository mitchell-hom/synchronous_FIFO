package global_constants;
	// parameters for this specific implementation
	parameter int BUS_WIDTH = 4;
	parameter int COUNT_BITS = 3; // amount of bits required to represent amount of data in FIFO
	parameter int DEPTH = 4;
	parameter int PERIOD = 6; // table 6: 6.3 ns period chosen for data width=8 (closest)

	// testbench-related
	parameter int STARTUP_CYCLES = 4; // number of clock cycles SINIT is high for at startup 
endpackage : global_constants
