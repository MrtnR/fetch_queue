
class test3;

string name;

virtual IFQ_if vif;

function new(string test_name = "Test3", virtual IFQ_if _if);
    this.name = test_name;
    vif = _if;
endfunction

task init_if();

    vif.inst_rd_en = 1'b0;
    vif.jmp_br_addr = 'h0;
    vif.jmp_br_valid = 1'b0;
endtask

task do_test();

    $display("Test 3 - Branch request");
    repeat(2) begin
        @(posedge vif.i_clk);
    end
    $display("Start reading instructions");
    @(negedge vif.empty); vif.inst_rd_en = 1'b1;
    repeat(16) begin
         @(posedge vif.i_clk);
    end
    $display("Stop reading instructions");
    @(posedge vif.i_clk) vif.inst_rd_en = 1'b0;
    repeat(2) begin
        @(posedge vif.i_clk);
    end
    $display("Set branch address and branch valid");
    @(posedge vif.i_clk);
    vif.jmp_br_addr = $urandom_range(0,127);
    vif.jmp_br_valid = 1'b1;
    vif.inst_rd_en = 1'b0;
    @(posedge vif.i_clk);
    vif.jmp_br_valid = 1'b0;
    @(negedge vif.empty); vif.inst_rd_en = 1'b1;
    repeat(8) begin
        @(posedge vif.i_clk);
    end

    $display("Test 3 - Done");
    $stop();

endtask

endclass