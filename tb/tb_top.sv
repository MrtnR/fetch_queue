module tb_top;

    reg i_clk;
    reg rst_n;

    wire [31:0] w_pc_in;
    wire w_rd_en;
    wire w_abort;

    wire [127:0] w_dout;
    wire w_dout_valid;

    wire [31:0] w_pc_out;
    wire [31:0] w_inst;
    wire w_empty;
    `ifdef DEBUG
    wire w_IFQ_FULL;
    `endif
    reg r_inst_rd_en;
    reg [31:0] r_jmp_addr;
    reg r_jmp_valid;

    i_cache dut_cache(
        .pc_in(w_pc_in),
        .rd_en(w_rd_en),
        .abort(w_abort),

        .Dout(w_dout),
        .Dout_valid(w_dout_valid)
    );

    IFQ dut(
        .clk(i_clk),
        .rst(rst_n),

    // To the Instruction cache
        .pc_in(w_pc_in),
        .cache_rd_en(w_rd_en),
        .cache_abort(w_abort),
        .dout(w_dout),
        .dout_valid(w_dout_valid),

    // To the Dispatch
        .pc_out(w_pc_out),
        .inst(w_inst),
        .empty(w_empty),
        .IFQ_FULL(w_IFQ_FULL),
        .inst_rd_en(r_inst_rd_en),
        .jmp_branch_address(r_jmp_addr),
        .jmp_branch_valid(r_jmp_valid)
    );

    initial begin
        $display("Instruction Fetch Queue + Instruction Cache Testbench");
        i_clk = 1'b0;
        rst_n = 1'b0;
        r_inst_rd_en = 1'b0;
        r_jmp_addr = 'h0;
        r_jmp_valid = 1'b0;
        #10 rst_n = 1'b1;
    end

    initial begin
        forever #5 i_clk = ~i_clk;
    end

    initial begin
        $display("Test 1 - Instruction Fetch Queue fillment and emptying");
        wait(w_IFQ_FULL);
        $display("IFQ Full, requesting instructions");
        @(posedge i_clk);
        repeat(16) begin
            @(posedge i_clk);
                r_inst_rd_en = 1'b1;
        end
        #5 r_inst_rd_en = 1'b0;
        $display("Test 1: Passed");
        $display("Reseting DUT");
        #5 rst_n = 1'b0;
        #5 rst_n = 1'b1;
    end
        

endmodule