class test2;

string name;

virtual IFQ_if vif;

function new(string test_name = "Test2", virtual IFQ_if _if);
    this.name = test_name;
    this.vif = _if;
endfunction

task do_test();

$display("Test 2 - Instruction Fetch Queue Continuous Reading");
        repeat(8) begin
            @(posedge i_clk);
                r_inst_rd_en = 1'b1;
            @(posedge i_clk);
                r_inst_rd_en = 1'b0;
        end
        #10 r_inst_rd_en = 1'b0;
        repeat(4) begin
            @(posedge i_clk);
                r_inst_rd_en = 1'b1;
            @(posedge i_clk);
                r_inst_rd_en = 1'b0;
        end
        #10 r_inst_rd_en = 1'b0;
        $display("Test 2: Done");
        $display("Reseting DUT");
        #5 rst_n = 1'b0;
        #15 rst_n = 1'b1;

endtask

endclass