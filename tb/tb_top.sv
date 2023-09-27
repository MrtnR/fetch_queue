module tb_top;

import tb_package::*;

    IFQ_if top_if();
    test1 t1;

    i_cache dut_cache(
        .pc_in(top_if.i_cache_pc),
        .rd_en(top_if.cache_rd_en),
        .abort(top_if.cache_abort),

        .Dout(top_if.cache_dout),
        .Dout_valid(top_if.cache_dout_valid)
    );

    IFQ dut(
        .clk(top_if.i_clk),
        .rst(top_if.rst_n),

    // To the Instruction cache
        .pc_in(top_if.i_cache_pc),
        .cache_rd_en(top_if.cache_rd_en),
        .cache_abort(top_if.cache_abort),
        .dout(top_if.cache_dout),
        .dout_valid(top_if.cache_dout_valid),

    // To the Dispatch
        .pc_out(top_if.dispatch_pc),
        .inst(top_if.inst),
        .empty(top_if.empty),
        `ifdef DEBUG
        .IFQ_FULL(top_if.ifq_full),
        `endif
        .inst_rd_en(top_if.inst_rd_en),
        .jmp_branch_address(top_if.jmp_br_addr),
        .jmp_branch_valid(top_if.jmp_br_valid)
    );

    initial begin
        $display("Instruction Fetch Queue + Instruction Cache Testbench");
        top_if.i_clk = 1'b0;
        top_if.rst_n = 1'b0;
        #10 top_if.rst_n = 1'b1;
    end

    initial begin
        forever #5 top_if.i_clk = ~top_if.i_clk;
    end

    initial begin
       `ifdef TEST_1
            //Instantiate and setup test 1
            t1 = new("Test 1: fill and empty IFQ", top_if);
            t1.init_if();
            t1.do_test();
       `elsif TEST_2
            //Instantiate and setup test 1
       `elsif TEST_3
            //Instantiate and setup test 1
       `else
            //Throw error message and end
       `endif
    end
        

endmodule