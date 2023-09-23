module bin_counter_load #(
parameter DW=4
)(
input           clk,
input           rst,
input           enb,
input           clr,
input           ld,
input  [DW-1:0] ld_val,
output [DW-1:0] count
);

logic [DW-1:0] count_r;

always_ff@(posedge clk, negedge rst)begin: counter
    if (!rst)
        count_r     <=  '0;
    else if (enb)
        count_r     <= count_r + 1'b1;
    else if (clr)
        count_r     <= '0;
    else if (ld)
        count_r     <= ld_val;
end:counter

assign count    =   count_r;

endmodule
