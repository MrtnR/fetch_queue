
class test1;

string name;

virtual IFQ_if vif;

function new(string name = "Test 1", virtual IFQ_if _if);
    this.name = name;
    vif = _if;
endfunction

task init_if();

    vif.inst_rd_en = 1'b0;
    vif.jmp_br_addr = 'h0;
    vif.jmp_br_valid = 1'b0;

endtask

task do_test();
     $display("Test 1 - Instruction Fetch Queue fillment and emptying");
    wait(vif.ifq_full);
    $display("IFQ Full, requesting instructions");
    @(posedge vif.i_clk);
    repeat(16) begin
        @(posedge vif.i_clk);
            vif.inst_rd_en = 1'b1;
    end
    #5 vif.inst_rd_en = 1'b0;
    $display("Test 1: Passed");
endtask


endclass