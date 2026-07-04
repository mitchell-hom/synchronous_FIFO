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
      	device_rst();
      	intlv();
      	il_rq();
     	rand_cmds();
	endtask : body
  
  	// multiple writes in a row
  	// also tests overflow
  	virtual task multi_wr();
      `uvm_info("SEQ_WRITE", "Starting multi write", UVM_LOW)

      	for (int i = 0; i < global_constants::DEPTH; i++) begin
          	pkt = packet::type_id::create("pkt");
          	start_item(pkt);
          	assert(pkt.randomize() with {SINIT == 0; WR_EN == 1; RD_EN == 0;});
          	finish_item(pkt);
      	end
    endtask : multi_wr
  
  	// multiple reads in a row
  	virtual task multi_rd();
      	`uvm_info("SEQ_READ", "Starting multi read", UVM_LOW)

      	for (int i = 0; i < global_constants::DEPTH; i++) begin
          	pkt = packet::type_id::create("pkt");
          	start_item(pkt);
          	assert(pkt.randomize() with {SINIT == 0; RD_EN == 1; WR_EN == 0;});
          	finish_item(pkt);
      	end
    endtask : multi_rd
  
  	// basic reset
  	virtual task device_rst();
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
  	endtask : device_rst
  
  	// interleaved
  	virtual task intlv();
      	`uvm_info("SEQ_INTLV", "Starting interleave", UVM_LOW)

      	repeat(10) begin
          	pkt = packet::type_id::create("pkt");
          	start_item(pkt);
       		assert(pkt.randomize() with {SINIT == 0; WR_EN == 1; RD_EN == 0;});
          	finish_item(pkt);
          
          	pkt = packet::type_id::create("pkt");
          	start_item(pkt);
          	assert(pkt.randomize() with {SINIT == 0; RD_EN == 1; WR_EN == 0;});
          	finish_item(pkt);
      	end
    endtask : intlv
  
  	// illegal requests
    virtual task il_rq();
      `uvm_info("SEQ_il_rq", "Starting illegal request", UVM_LOW)
      
      	// reset
      	device_rst();
      
      	// background writes
      	repeat(global_constants::DEPTH - 1) begin
      		pkt = packet::type_id::create("pkt");
          	start_item(pkt);
      		assert(pkt.randomize() with {SINIT == 0; WR_EN == 1; RD_EN == 0;});
          	finish_item(pkt);
        end

      	// start actual illegal commands
      	// write and read requests high at same time
        pkt = packet::type_id::create("pkt");
      	start_item(pkt);
      	pkt.c_legal_cmd.constraint_mode(0);
		assert(pkt.randomize() with {SINIT == 0; WR_EN == 1; RD_EN == 1;});
      	finish_item(pkt);
      
      	// SINIT high while read is enabled
        pkt = packet::type_id::create("pkt");
        start_item(pkt);
        pkt.c_legal_cmd.constraint_mode(0);
      	assert(pkt.randomize() with {SINIT == 1; RD_EN == 1; WR_EN == 0;});            	finish_item(pkt);

      	
		// background read
      	pkt = packet::type_id::create("pkt");
      	start_item(pkt);
      	assert(pkt.randomize() with {SINIT == 0; WR_EN == 0; RD_EN == 1;});
      	finish_item(pkt);
    endtask : il_rq
  
  	// TODO: random
  	virtual task rand_cmds();
      `uvm_info("SEQ_rand_cmds", "Starting random commands", UVM_LOW)
		
      repeat(100) begin
          	pkt = packet::type_id::create("pkt");
        	start_item(pkt);
          	assert(pkt.randomize());
        	finish_item(pkt);
      	end
    endtask : rand_cmds
endclass : seq_write
