class seq_write extends uvm_sequence #(packet);
  	`uvm_object_utils (seq_write)

	packet pkt;

  	function new (string name="seq_write");
		super.new(name);
	endfunction

	virtual task body();
    	`uvm_info("seq_write", "Starting body of write sequence", UVM_LOW)
      
     	multi_wr();
      	multi_rd();
      	RESET();
      	intlv();
      	il_rq();
     	rand_cmds();
	endtask : body
 	
  
  	// BASIC OPERATION
    // basic reset
  	virtual task RESET();
    	`uvm_info("SEQ_RST", "Starting device reset", UVM_LOW)

		pkt = packet::type_id::create("pkt");
    	start_item(pkt);
    
    	pkt.rand_mode(0);
    	pkt.WR_EN = 0;
    	pkt.RD_EN = 0;
    	pkt.SINIT = 1;
    	
    	finish_item(pkt);
    
    	pkt = packet::type_id::create("pkt");
    	start_item(pkt);
    
    	pkt.rand_mode(0);
    	pkt.WR_EN = 0;
    	pkt.RD_EN = 0;
    	pkt.SINIT = 0;
    	
    	finish_item(pkt);
  	endtask : RESET
  
  	// basic write operation
  	task WRITE(input din=0, input is_valid=0);
    	pkt = packet::type_id::create("pkt");
      	start_item(pkt);
      	
    	// default: randomize data
      	if (is_valid == 0) begin
    		if (!pkt.randomize() with {SINIT == 0; WR_EN == 1; RD_EN == 0;}) begin
          		`uvm_fatal("SEQ_RAND", "Could not randomize packet in WRITE")
			end
        // don't randomize, set as specified value
        end else begin
        	if (!pkt.randomize() with {SINIT == 0; WR_EN == 1; RD_EN == 0; DIN == din;}) begin
          		`uvm_fatal("SEQ_RAND", "Could not randomize packet in WRITE")
			end
        end
    
      	finish_item(pkt);
    endtask : WRITE
      
  	// basic read operation
  	task READ();
    	pkt = packet::type_id::create("pkt");
      	start_item(pkt);
      	
      	pkt.SINIT = 0;
      	pkt.WR_EN = 0;
      	pkt.RD_EN = 1;

      	finish_item(pkt);
    endtask : READ
  
  	// wait n clock cycles
  	task WAIT(int n=1);
      	repeat(n) begin
        	pkt = packet::type_id::create("pkt");
      		start_item(pkt);
      
      		pkt.SINIT = 0;
      		pkt.WR_EN = 0;
      		pkt.RD_EN = 0;
      		pkt.DIN = 0;
      
      		finish_item(pkt);
        end
    endtask : WAIT
  
  
  	// OTHER SEQUENCES ////
  	// multiple writes in a row
  	// also tests overflow
  	virtual task multi_wr();
      	`uvm_info("SEQ_WRITE", "Starting multi write", UVM_LOW)

      	// do writes until full, then overflow it 
      	repeat(global_constants::DEPTH * 2) begin
        	WRITE();
      	end
    endtask : multi_wr
  
  	// multiple reads in a row
  	virtual task multi_rd();
      	`uvm_info("SEQ_READ", "Starting multi read", UVM_LOW)

      	// do reads until empty, then continue
      	repeat(global_constants::DEPTH * 2) begin
          	READ();
      	end
    endtask : multi_rd

  	// interleaved
  	virtual task intlv();
      	`uvm_info("SEQ_INTLV", "Starting interleave", UVM_LOW)

      repeat(15) begin
          	WRITE();
          	READ();
      	end
    endtask : intlv
  
  	// illegal requests
    virtual task il_rq();
      `uvm_info("SEQ_il_rq", "Starting illegal request", UVM_LOW)
      
      	// reset
      	RESET();
      
      	// background writes
      	repeat(global_constants::DEPTH - 1) begin
          	WRITE();
        end

      	// start actual illegal commands
      	// write and read requests high at same time
        pkt = packet::type_id::create("pkt");
      	start_item(pkt);
      	pkt.c_legal_cmd.constraint_mode(0);
      	if (!pkt.randomize() with {SINIT == 0; WR_EN == 1; RD_EN == 1;}) begin
        	`uvm_fatal("SEQ_RAND", "Could not randomize packet in sequence il_rq");
      	end
      	finish_item(pkt);
      
      	// SINIT high while read is enabled
        pkt = packet::type_id::create("pkt");
        start_item(pkt);
        pkt.c_legal_cmd.constraint_mode(0);
      	if (!pkt.randomize() with {SINIT == 1; RD_EN == 1; WR_EN == 0;}) begin
          `uvm_fatal("SEQ_RAND", "Could not randomize packet in sequence il_rq")
      	end
        finish_item(pkt);

      	
		// background read
      	READ();
    endtask : il_rq
  
  	virtual task rand_cmds();
      `uvm_info("SEQ_rand_cmds", "Starting random commands", UVM_LOW)
		
      	repeat(100) begin
          	pkt = packet::type_id::create("pkt");
        	start_item(pkt);
        	if (!pkt.randomize()) begin
              `uvm_fatal("SEQ_RAND", "Could not randomize packet in sequence rand_cmds")
        	end
        	finish_item(pkt);
      	end
    endtask : rand_cmds
endclass : seq_write
