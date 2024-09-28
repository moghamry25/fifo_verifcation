import fifo_pkg::*;
import fifo_scoreboard::*;
import package_fifo::*;
import share_pkg::*;
module fifo_monitor(fifo.MONITOR vif);

FIFO_transaction q = new () ;
fifo_scoreboard score  = new();
FIFO_coverage cove = new();

initial begin

        forever begin
        @(negedge vif.clk);
        q.rst_n=vif.rst_n;
        q.wr_en=vif.wr_en;
        q.rd_en=vif.rd_en;
        q.data_in=vif.data_in;
        q.data_out=vif.data_out;
        q.wr_ack=vif.wr_ack;
        q.full=vif.full;
        q.empty=vif.empty;
        q.almostfull=vif.almostfull;
        q.almostempty=vif.almostempty;
        q.underflow=vif.underflow;
        q.overflow=vif.overflow;
        q.clk=vif.clk;
       
        fork          
             begin
               cove.sample_data(q);  
            end
            begin             
                @(posedge vif.clk);
               score.check_data(q);
               
            end
        join
        if (test_finsh) begin
            $display("END OF SIMULATION ");
            $display("ERROR COUNT IS %0d , CORRECT COUNT IS %0d ",error_count,correct_count);
            $stop;
        end

        end
end    
endmodule



