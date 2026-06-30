class packet extends uvm_sequence_item;
	rand bit [BUS_WIDTH-1:0] DIN;
        rand bit WR_EN;
        rand bit RD_EN;
        bit CLK;
        rand bit SINIT;
       	bit FULL;
        bit [COUNT_BITS-1:0] DATA_COUNT;
        bit WR_ACK;
        bit WR_ERR;
        bit [BUS_WIDTH-1:0] DOUT;
        bit EMPTY;
        bit RD_ACK;
        bit RD_ERR;

	// get all the bells n whistles (methods) for these guys
	`uvm_object_utils_begin(packet)
		`uvm_field_int(DIN);
		`uvm_field_int(WR_EN);
		`uvm_field_int(RD_EN);
		`uvm_field_int(CLK);
		`uvm_field_int(SINIT);
		`uvm_field_int(FULL);
		`uvm_field_int(DATA_COUNT);
		`uvm_field_int(WR_ACK);
		`uvm_field_int(WR_ERR);
		`uvm_field_int(DOUT);
		`uvm_field_int(EMPTY);
		`uvm_field_int(RD_ACK);
		`uvm_field_int(RD_ERR);
	`uvm_object_utils_end

	function new(string name="packet");
		super.new(name);
	endfunction
  
  	// supporting functions
  	function bit is_write();
      	if (!SINIT && WR_EN && !RD_EN) begin
      		return 1;
        end else begin
          	return 0;
        end
    endfunction : is_write
          
    function bit is_read();
      	if (!SINIT && RD_EN && !WR_EN) begin
      		return 1;
        end else begin
          	return 0;
        end
    endfunction : is_read
endclass : packet
