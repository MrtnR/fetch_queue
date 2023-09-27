
class test2;

string name;

virtual IFQ_if vif;

function new(string test_name = "Test2", virtual IFQ_if _if);
    this.name = test_name;
    vif = _if;
endfunction

task init_if();

    vif.inst_rd_en = 1'b0;
    vif.jmp_br_addr = 'h0;
    vif.jmp_br_valid = 1'b0;
    vif.rst_n = 1'b1;
endtask

task do_test();

    $display("Test 2 - Instruction Fetch Queue Continuous Reading");
        repeat(8) begin
            @(posedge vif.i_clk);
                vif.inst_rd_en = 1'b1;
            @(posedge vif.i_clk);
                vif.inst_rd_en = 1'b0;
        end
        #10 vif.inst_rd_en = 1'b0;
        repeat(4) begin
            @(posedge vif.i_clk);
                vif.inst_rd_en = 1'b1;
            @(posedge vif.i_clk);
                vif.inst_rd_en = 1'b0;
        end
        #10 vif.inst_rd_en = 1'b0;
        $display("Test 2: Done");
        $display("Reseting DUT");
        #5 vif.rst_n = 1'b0;
        #15 vif.rst_n = 1'b1;

endtask

endclass