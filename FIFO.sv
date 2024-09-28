module FIFO(fifo.DUT vif);

localparam max_fifo_addr = $clog2(vif.FIFO_DEPTH);

reg [vif.FIFO_WIDTH-1:0] mem [vif.FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge vif.clk or negedge vif.rst_n) begin
	if (!vif.rst_n) begin
		wr_ptr <= 0;	
		vif.wr_ack   <= 0 ;
		vif.overflow <= 0 ;		
	end
	else if (({vif.wr_en, vif.rd_en} == 2'b11) && vif.empty  ) begin
		mem[wr_ptr] <= vif.data_in;
		vif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		
	end
	else if (({vif.wr_en, vif.rd_en} == 2'b11) && !vif.empty && !vif.full  ) begin
		mem[wr_ptr] <= vif.data_in;
		vif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		
	end
	else if (({vif.wr_en, vif.rd_en} == 2'b10) && count < vif.FIFO_DEPTH) begin
		mem[wr_ptr] <= vif.data_in;
		vif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else if ({vif.wr_en, vif.rd_en} == 2'b00) begin
		
	end
	else begin 
		vif.wr_ack <= 0; 
		if (vif.full && vif.wr_en&&!vif.rd_en) 
			vif.overflow <= 1;
		else
			vif.overflow <= 0;
	end
end

always @(posedge vif.clk or negedge vif.rst_n) begin
	if (!vif.rst_n) begin
		rd_ptr <= 0;
		vif.underflow <= 0 ;
	end
	else if ((({vif.wr_en, vif.rd_en} == 2'b11) && vif.full ) ) begin
		vif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else if ((({vif.wr_en, vif.rd_en} == 2'b11) && !vif.full && !vif.empty) ) begin
		vif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		
	end
	else if (({vif.wr_en, vif.rd_en} == 2'b01) && count != 0&&!vif.empty) begin
		vif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else if ({vif.wr_en, vif.rd_en} == 2'b00) begin
		
	end
	else begin
	  if (vif.rd_en&&!vif.wr_en&&vif.empty) begin
		vif.underflow <= 1 ;
	  end
	  else begin
		vif.underflow <= 0 ; 
	  end
	end
end

always @(posedge vif.clk or negedge vif.rst_n) begin
	if (!vif.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({vif.wr_en, vif.rd_en} == 2'b10) && !vif.full) 
			count <= count + 1;
		else if ( ({vif.wr_en, vif.rd_en} == 2'b01) && !vif.empty)
			count <= count - 1;
		else if (({vif.wr_en, vif.rd_en} == 2'b11) && vif.full  ) begin
			count <= count - 1;
		end
		else if (({vif.wr_en, vif.rd_en} == 2'b11) && vif.empty ) begin
			count <= count + 1;
		end	
		else begin
			
		end
	end
end



assign vif.full = (count == vif.FIFO_DEPTH)? 1 : 0;
assign vif.empty = (count == 0)? 1 : 0;
assign vif.almostfull = (count == vif.FIFO_DEPTH-1)? 1 : 0; 
assign vif.almostempty = (count == 1)? 1 : 0;

`ifdef ASSERTIONS_ON
    

almostempty:assert property (@(posedge vif.clk) (count==1) |-> (vif.almostempty==1));
almostfull:assert property (@(posedge vif.clk) (count == vif.FIFO_DEPTH-1) |-> (vif.almostfull==1));
empty:assert property (@(posedge vif.clk) (count == 0) |-> (vif.empty==1));
full:assert property (@(posedge vif.clk) (count == vif.FIFO_DEPTH) |-> (vif.full==1));
overflow:assert property (@(posedge vif.clk) disable iff(!vif.rst_n)(vif.full && vif.wr_en && !vif.rd_en) |=> vif.overflow == 1)
else $error("Overflow should be 1 when FIFO is full, write enable is asserted, and read enable is not asserted.");
underflow:assert property (@(posedge vif.clk)disable iff(!vif.rst_n) (vif.rd_en&&!vif.wr_en&&vif.empty) |=>vif.underflow==1);


`endif

endmodule