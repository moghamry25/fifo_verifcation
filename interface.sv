interface fifo(clk);

input bit clk ;

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

logic  [FIFO_WIDTH-1:0] data_in;
logic  rst_n, wr_en, rd_en;
logic  [FIFO_WIDTH-1:0] data_out;
logic  wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

modport DUT (
input data_in,clk,rst_n, wr_en, rd_en,
output data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow
);

modport TEST (
input clk,data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow,
output data_in,rst_n, wr_en, rd_en
);

modport MONITOR(
input data_in,clk,rst_n, wr_en, rd_en,
data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow
);
    

endinterface
