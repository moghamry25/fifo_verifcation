
import share_pkg::*;
import fifo_pkg::*;
module FIFO_tb(fifo.TEST vif);

FIFO_transaction q = new () ;

initial begin
    
        vif.rst_n=0;
        @(negedge vif.clk);
        vif.rst_n=1;
    for (int i = 0  ; i < 30000 ; i++ ) begin
         
        @(negedge vif.clk);
        
        assert(q.randomize());

        vif.rst_n=q.rst_n;
        vif.wr_en=q.wr_en;
        vif.rd_en=q.rd_en;
        vif.data_in=i;
        q.wr_ack=vif.wr_ack;
        q.full=vif.full;
        q.empty=vif.empty;
        q.almostfull=vif.almostfull;
        q.almostempty=vif.almostempty;
        q.underflow=vif.underflow;
        q.overflow=vif.overflow;
       
    end
    test_finsh = 1 ;
    
end
    
endmodule
