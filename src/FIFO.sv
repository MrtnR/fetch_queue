
module FIFO_Mod_Async #(parameter Depth_Of_FIFO = 64, parameter DATA_WIDTH = 32, parameter IN_WIDTH=128)(
    input clk,
    input reset,

    input flush,
    input [1:0]offset,

    //Writter
    input [IN_WIDTH-1:0] DataInput,
    input push,
    output full,
    output [($clog2(Depth_Of_FIFO)+1)-1:0] wp,

    //Reading
    output [DATA_WIDTH-1:0] DataOutput,
    output empty,
    input pop,
    output [($clog2(Depth_Of_FIFO)+1)-1:0] rp
    );

localparam countWD = ($clog2(Depth_Of_FIFO)+1);

logic rOvf;
logic push_and_NoFull;
logic rFull;
logic rEmpty;
logic [countWD-1:0]pushCount;
logic [countWD-1:0]popCount;
logic [countWD-1:0]truePopCount;

bin_counter_load #(.DW(countWD)) pull_Counter (
    .clk(clk),
    .rst(reset),
    .enb(pop),
    .ld(flush),
    .ld_val({3'b000, offset}),
    .count(popCount)
);

bin_counter_load #(.DW(countWD)) truePull_Counter (
    .clk(clk),
    .rst(reset),
    .enb(rOvf),
    .ld(flush),
    .ld_val({3'b000, offset}),
    .count(truePopCount)
);

bin_counter_load #(.DW(countWD), .INC(4)) push_Counter (
    .clk(clk),
    .rst(reset),
    .enb(push),
    .ld(flush),
    .ld_val({3'b000, offset}),
    .count(pushCount)
);

sdp_sc_ram #( .Word_Length(DATA_WIDTH), .W_DEPTH(Depth_Of_FIFO)) ram
(
    .clk(clk),
    .we(push_and_NoFull),
    .re(pop),
    .data_wr(DataInput),
    .addr_wr(pushCount[countWD-2:0]),
    .addr_rd(popCount[countWD-2:0]),
    .data_rd(DataOutput)
);

cntr_mod_n_ovf popCountEn(
    .clk(clk),
    .rst(reset),
    .enb(pop),
    .count_max(8'h7),
    .ovf(rOvf)
);

always_comb begin
    if (pushCount == truePopCount) begin
        rFull = '0;
        rEmpty = '1;
    end
    else if ((pushCount[countWD-1] != popCount[countWD-1]) && (pushCount[countWD-2:0] == popCount[countWD-2:0]) || ( (pushCount - popCount) >= 5'hC)) begin
        rFull = '1;
        rEmpty = '0;
    end
    else begin
        rFull = '0;
        rEmpty = '0;
    end
end


assign push_and_NoFull = (~full) ? push : '0;

assign empty = rEmpty;
assign full = rFull;
assign wp = pushCount;
assign rp = popCount;

endmodule // FIFO
