
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

endtask

task do_test();

    $display("Test 2 - Instruction Fetch Queue Continuous Reading");
    @(negedge vif.empty);
    repeat(8) begin
        @(posedge vif.i_clk);
            vif.inst_rd_en = 1'b1;
    end
    #20 vif.inst_rd_en = 1'b0;
    repeat(8) begin
        @(posedge vif.i_clk);
            vif.inst_rd_en = 1'b1;
    end
    #20 vif.inst_rd_en = 1'b0;
    $display("Test 2: Done");
    $stop();

endtask

endclass