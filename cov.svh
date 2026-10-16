// want this to be a component so that it is persistent 
// throughout the entire simulation
class cov extends uvm_component;
  	`uvm_component_utils(cov);
  
  	// IO for this component (coverage collector)
  	uvm_analysis_imp #(packet, cov) ai;
  	packet pkt;
  
  	logic CLK;
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
  	
  	function new (string name, uvm_component parent);
    	super.new(name, parent);
      
      	// TODO: all cg's
      	all_pins = new();
      
      	// instantiate analysis implementation
      	ai = new("ai", this);
  	endfunction 
  
  	// write function for analysis imp
  	function void write(packet thisPkt);
    	this.pkt = thisPkt;
      // TODO: sample all cg's
        all_pins.sample();
    endfunction : write
  
    // do all pins get exercised?
  	covergroup all_pins;
        cp_CLK : coverpoint pkt.CLK {
          	bins low = {0};
          	bins high = {1};
        }
      
      	cp_SINIT : coverpoint pkt.SINIT {
          	bins reset = {1};
          	bins normal = {0};
        }
      
      	// are all values for bus taken?
     	cp_DIN : coverpoint pkt.DIN {
        	bins all_DIN_vals[] = {
        						4'h0,
        						4'h1,
        						4'h2,
        						4'h3,
        						4'h5,
                                4'h6,
                                4'h7,
                                4'h8,
                                4'h9,
                                4'ha,
                                4'hb,
                                4'hc,
                                4'hd,
                                4'he,
                                4'hf}; 
        }
      
      	cp_WR_EN : coverpoint pkt.WR_EN {
          	bins en = {1};
          	bins dis = {0};
        }
      
      	cp_RD_EN : coverpoint pkt.RD_EN {
          	bins en = {1};
          	bins dis = {0};
      	}
      
      	cp_FULL : coverpoint pkt.FULL {
        	bins true = {1};
        	bins false = {0};
        }
      
      	cp_DATA_COUNT : coverpoint pkt.DATA_COUNT {
            bins empty = {0};
            bins one = {1};
            bins two = {2};
            bins three = {3};
      	}
      
      	cp_WR_ACK : coverpoint pkt.WR_ACK {
          	bins true = {1};
            bins false = {0};
      	}
      
        cp_WR_ERR : coverpoint pkt.WR_ERR {
            bins true = {1};
            bins false = {0};
        }
      
        cp_DOUT : coverpoint pkt.DOUT {
          bins all_DOUT_vals[] = {
                            4'h0,
                            4'h1,
                            4'h2,
                            4'h3,
                            4'h5,
                            4'h6,
                            4'h7,
                            4'h8,
                            4'h9,
                            4'ha,
                            4'hb,
                            4'hc,
                            4'hd,
                            4'he,
                            4'hf}; 
        }
      
        cp_EMPTY : coverpoint pkt.EMPTY {
            bins true = {1};
            bins false = {0};
        }
      
        cp_RD_ACK : coverpoint pkt.RD_ACK {
            bins true = {1};
            bins false = {0};
        }
      
        cp_RD_ERR : coverpoint pkt.RD_ERR {
            bins true = {1};
            bins false = {0};
        }
      
        // CROSS COVERAGE
  		wr_rd_cross : cross cp_RD_EN, cp_WR_EN;
  		wr_din_cross : cross cp_DIN, cp_WR_EN;
  		rd_dout_cross : cross cp_DOUT, cp_RD_EN;
    endgroup : all_pins
endclass : cov
