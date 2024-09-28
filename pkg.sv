package package_fifo;
    import fifo_pkg::*;
    class FIFO_coverage;
        FIFO_transaction F_cvg_txn;

        covergroup g1;
        write :     coverpoint F_cvg_txn.wr_en;
        read:       coverpoint F_cvg_txn.rd_en;
        write_ack:  coverpoint F_cvg_txn.wr_ack;
        OVERFFLOW:  coverpoint F_cvg_txn.overflow;
        UNDERFLOW:  coverpoint F_cvg_txn.underflow;
        FULL:       coverpoint F_cvg_txn.full;
        EMPTY:      coverpoint F_cvg_txn.empty;
        Almost_empty:coverpoint F_cvg_txn.almostempty;
        Almost_full:coverpoint F_cvg_txn.almostfull;

        crossofwriteack : cross write,read,write_ack{
            ignore_bins rd = binsof(write)intersect{0}&&binsof(read)intersect{1}&&binsof(write_ack)intersect{1};}
        crossoffull     : cross write,read,FULL{
            ignore_bins rd_full = binsof(write)intersect{0}&&binsof(read)intersect{1}&&binsof(FULL)intersect{1};
            ignore_bins wr_rd_full = binsof(write)intersect{1}&&binsof(read)intersect{1}&&binsof(FULL)intersect{1};}
        crossofempty     : cross write,read,EMPTY{
            ignore_bins wr_empty = binsof(write)intersect{1}&&binsof(read)intersect{0}&&binsof(EMPTY)intersect{1};
            ignore_bins w_r_empty = binsof(write)intersect{1}&&binsof(read)intersect{1}&&binsof(EMPTY)intersect{1};}
        crossofOVERFFLOW     : cross write,read,OVERFFLOW{
            ignore_bins rd_overflow = binsof(write)intersect{0}&&binsof(read)intersect{1}&&binsof(OVERFFLOW)intersect{1};
            ignore_bins w_r_overflow = binsof(write)intersect{1}&&binsof(read)intersect{1}&&binsof(OVERFFLOW)intersect{1};}
        crossofUNDERFLOW     : cross write,read,UNDERFLOW{
            ignore_bins wr_underflow = binsof(write)intersect{1}&&binsof(read)intersect{0}&&binsof(UNDERFLOW)intersect{1};
            ignore_bins wr_ed_underflow = binsof(write)intersect{1}&&binsof(read)intersect{1}&&binsof(UNDERFLOW)intersect{1};}
        crossofAlmost_empty     : cross write,read,Almost_empty;
        crossofAlmost_full     : cross write,read,Almost_full;

        endgroup

        function new();
            g1=new();
        endfunction

        function void sample_data(FIFO_transaction F_txn );
            this.F_cvg_txn = F_txn;
            g1.sample();
        endfunction
    endclass


endpackage

