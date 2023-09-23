
module FIFO_Mod #(parameter Depth_Of_FIFO = 64, parameter DATA_WIDTH = 32)(
    input clk,
    input reset,

    input flush,
    input [1:0]offset,

    //Writter
    input [DATA_WIDTH-1:0] DataInput,
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

logic push_and_NoFull;
logic rFull;
logic rEmpty;
logic [countWD-1:0]pushCount;
logic [countWD-1:0]popCount;

bin_counter_load #(.DW(countWD)) pull_Counter (
    .clk(clk),
    .rst(reset),
    .enb(pop),
    .ld(flush),
    .ld_val({3'b000, offset})
    .count(popCount)
);

bin_counter_load #(.DW(countWD)) push_Counter (
    .clk(clk),
    .rst(reset),
    .enb(push),
    .ld(flush),
    .ld_val('h0)
    .count(pushCount)
);

sdp_dc_ram #( .Word_Length(DATA_WIDTH), .W_DEPTH(Depth_Of_FIFO)) ram
(
    .clk(clk),
    .we(push_and_NoFull),
    .re(pop),
    .data_wr(DataInput),
    .addr_wr(pushCount[countWD-2:0]),
    .addr_rd(popCount[countWD-2:0]),
    .data_rd(DataOutput)
);

always_comb begin
    if (pushCount == popCount) begin
        rFull = '0;
        rEmpty = '1;
    end
    else if ((pushCount[countWD-1] != popCount[countWD-1]) && (pushCount[countWD-2:0] == popCount[countWD-2:0])) begin
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
