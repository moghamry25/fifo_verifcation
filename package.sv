package fifo_pkg;
    class FIFO_transaction;
        
    
    parameter FIFO_WIDTH = 16;
    bit clk;
    logic data_in;
    rand logic  rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic  wr_ack, overflow,full, empty, almostfull, almostempty, underflow;

    rand int WR_EN_ON_DIST;
    rand int RD_EN_ON_DIST;

    function new(int WR_EN_ON_DIST = 70   , int RD_EN_ON_DIST = 30 );
        this.WR_EN_ON_DIST=WR_EN_ON_DIST;
        this.RD_EN_ON_DIST=RD_EN_ON_DIST;
    endfunction

    constraint assert_reset{
        rst_n dist{0:=2,1:=98};
    } 

    constraint write_enable{
        wr_en dist{1:=WR_EN_ON_DIST,0:=100-WR_EN_ON_DIST};
    }

    constraint read_enable{
        rd_en dist{1:=RD_EN_ON_DIST,0:=100-RD_EN_ON_DIST};
    }

    endclass
endpackage