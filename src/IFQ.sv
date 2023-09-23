module IFQ(
    input clk,
    input rst,

    // To the Instruction cache
    output [31:0] pc_in,
    output cache_rd_en,
    output cache_abort,
    input [127:0] dout,
    input [31:0] dout_valid,

    // To the Dispatch
    output [31:0] pc_out,
    output [31:0] inst,
    output empty,
    input inst_rd_en,
    input [31:0] jmp_branch_address,
    input jmp_branch_valid,
);

wire [31:0] inst_to_fifo;
wire [4:0] write_pointer;
wire [4:0] read_pointer;

mux_4to1 (
    .a(dout[31:0]),
    .b(dout[63:32]),
    .c(dout[95:64]),
    .d(dout[127:96]),

    .sel(read_pointer[1:0]),

    .o(inst_to_fifo)
)

FIFO #( .Depth_Of_FIFO(16) ) i_queue(
    .clk(clk),
    .reset(reset),

    .flush(jmp_branch_valid),
    .offset(jmp_branch_address[3:2]),

    //Writter
    .DataInput(inst_to_fifo),
    .push(),
    .full(),
    .wp(write_pointer),

    //Reading
    .DataOutput(),
    .empty(empty),
    .pop(),
    .rp(read_pointer)
);


endmodule