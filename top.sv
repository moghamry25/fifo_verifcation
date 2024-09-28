module top;
    
bit clk;

initial begin
    forever begin
        #10 clk =~clk;
    end
end

fifo vif(clk);
FIFO_tb tb(vif);
FIFO dut(vif);
fifo_monitor mon(vif);
 


endmodule