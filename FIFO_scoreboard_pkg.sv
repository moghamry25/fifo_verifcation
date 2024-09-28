package fifo_scoreboard;
    import fifo_pkg::*;
    import share_pkg::*;
    
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    class fifo_scoreboard;

    logic  [FIFO_WIDTH-1:0] data_out_ref;
    logic  wr_ack_ref, overflow_ref,full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

    localparam max_fifo_addr = $clog2(FIFO_DEPTH);

    logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

    logic [max_fifo_addr-1:0] wr_ptr_ref, rd_ptr_ref;
    logic [max_fifo_addr:0] count_ref;

    function void check_data(FIFO_transaction f_ref);
    reference_model(f_ref);

    if ( 
        (wr_ack_ref != f_ref.wr_ack) || 
        (overflow_ref != f_ref.overflow) || 
        (underflow_ref != f_ref.underflow) || 
        (full_ref != f_ref.full) || 
        (empty_ref != f_ref.empty) || 
        (almostempty_ref != f_ref.almostempty) || 
        (almostfull_ref != f_ref.almostfull)) begin   

        error_count = error_count + 1;
        $display("ERROR DETECTED!!!");
        $display("Expected values: ");

        $display("  wr_ack         = %0b | Received: %0b", wr_ack_ref, f_ref.wr_ack);
        $display("  overflow       = %0b | Received: %0b", overflow_ref, f_ref.overflow);
        $display("  underflow      = %0b | Received: %0b", underflow_ref, f_ref.underflow);
        $display("  full           = %0b | Received: %0b", full_ref, f_ref.full);
        $display("  empty          = %0b | Received: %0b", empty_ref, f_ref.empty);
        $display("  almostempty    = %0b | Received: %0b", almostempty_ref, f_ref.almostempty);
        $display("  almostfull     = %0b | Received: %0b", almostfull_ref, f_ref.almostfull);
        
        $stop;
    end else begin
        correct_count = correct_count + 1;

    end
endfunction

function void reference_model(FIFO_transaction f_ref);
    
    if (!f_ref.rst_n) begin
        
        
        full_ref = 0;
        empty_ref = 1;
        almostfull_ref = 0;
        almostempty_ref = 0;
        overflow_ref = 0;
        underflow_ref = 0;
        wr_ack_ref = 0 ;
        wr_ptr_ref = 0 ;
        rd_ptr_ref = 0 ;
        count_ref = 0 ;
    end 
    else begin
        
        if (({f_ref.wr_en, f_ref.rd_en} == 2'b11) && empty_ref  ) begin
		mem[wr_ptr_ref] = f_ref.data_in;
		wr_ack_ref = 1;
		wr_ptr_ref = wr_ptr_ref + 1;
		
	end
    else if (({f_ref.wr_en, f_ref.rd_en} == 2'b11) && !empty_ref && !full_ref ) begin
		mem[wr_ptr_ref] = f_ref.data_in;
		wr_ack_ref = 1;
		wr_ptr_ref = wr_ptr_ref + 1;
		
	end
	else if (({f_ref.wr_en, f_ref.rd_en}  == 2'b10) && count_ref < FIFO_DEPTH) begin
		mem[wr_ptr_ref] = f_ref.data_in;
		wr_ack_ref = 1;
		wr_ptr_ref = wr_ptr_ref + 1;
	end
	else if ({f_ref.wr_en, f_ref.rd_en}  == 2'b00) begin
		
	end
	else begin 
		wr_ack_ref = 0; 
		if (full_ref && f_ref.wr_en&&!f_ref.rd_en) //3
			overflow_ref = 1;
		else
			overflow_ref = 0;
	end

     if ((({f_ref.wr_en, f_ref.rd_en} == 2'b11) && full_ref ) ) begin
		data_out_ref = mem[rd_ptr_ref];
		rd_ptr_ref = rd_ptr_ref + 1;
	end
    else if ((({f_ref.wr_en, f_ref.rd_en} == 2'b11) && !full_ref &&!empty_ref ) ) begin
		data_out_ref = mem[rd_ptr_ref];
		rd_ptr_ref = rd_ptr_ref + 1;
	end
	else if ((({f_ref.wr_en, f_ref.rd_en} == 2'b11) && !empty_ref ) ) begin
		data_out_ref = mem[rd_ptr_ref];
		rd_ptr_ref = rd_ptr_ref + 1;
		count_ref = count_ref - 1 ; 
	end
	else if (({f_ref.wr_en, f_ref.rd_en} == 2'b01) && count_ref != 0&&!empty_ref) begin
		data_out_ref = mem[rd_ptr_ref];
		rd_ptr_ref = rd_ptr_ref + 1;
	end
	else if ({f_ref.wr_en, f_ref.rd_en} == 2'b00) begin
		
	end
	else begin
	  if ((!empty_ref && ({f_ref.wr_en, f_ref.rd_en} == 2'b11)) ||(({f_ref.wr_en, f_ref.rd_en} == 2'b01)&&empty_ref)) begin
		underflow_ref = 1 ;
	  end
	  else begin
		underflow_ref = 0 ; 
	  end
	end

        if	( ({f_ref.wr_en, f_ref.rd_en} == 2'b10) && !full_ref) 
			count_ref = count_ref + 1;
		else if ( ({f_ref.wr_en, f_ref.rd_en} == 2'b01) && !empty_ref)
			count_ref = count_ref - 1;
		else if (({f_ref.wr_en, f_ref.rd_en} == 2'b11) && full_ref  ) begin
			count_ref = count_ref - 1;
		end
		else if (({f_ref.wr_en, f_ref.rd_en} == 2'b11) && empty_ref ) begin
			count_ref = count_ref + 1;
		end
        else begin
            
        end

        full_ref = (count_ref == FIFO_DEPTH)? 1 : 0;
        almostempty_ref = (count_ref == 1)? 1 : 0;
        almostfull_ref = (count_ref == FIFO_DEPTH-1)? 1 : 0;
        empty_ref = (count_ref == 0)? 1 : 0;
    end
        
    endfunction

    endclass
    
endpackage