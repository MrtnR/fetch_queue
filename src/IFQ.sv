module IFQ(
    input clk,
    input rst,

    // To the Instruction cache
    output [31:0] pc_in,
    output cache_rd_en,
    output cache_abort,
    input [127:0] dout,
    input dout_valid,

    // To the Dispatch
    output [31:0] pc_out,
    output [31:0] inst,
    output empty,
    input inst_rd_en,
    input [31:0] jmp_branch_address,
    input jmp_branch_valid,
);

wire [31:0] inst_to_fifo;
wire [31:0] inst_from_fifo;
wire [31:0] bypass_inst;
wire [4:0] write_pointer;
wire [4:0] read_pointer;

wire bypass_sel;
wire fifo_empty;
wire fifo_full;

mux_4to1 fifo_write(
    .a(dout[31:0]),
    .b(dout[63:32]),
    .c(dout[95:64]),
    .d(dout[127:96]),

    .sel(read_pointer[1:0]),

    .o(inst_to_fifo)
);

mux_4to1 fifo_bypass(
    .a(dout[31:0]),
    .b(dout[63:32]),
    .c(dout[95:64]),
    .d(dout[127:96]),

    .sel(read_pointer[1:0]),

    .o(bypass_inst)
);

IFQ_ctrl q_ctrl(
    .clk(clk),
    .reset(reset),

    .dout_valid(dout_valid),
    .rd_enable(inst_rd_en),
    .branch_valid(jmp_branch_valid),
    .fifo_empty(fifo_empty),
    .fifo_full(fifo_full),

    .cache_en(),
    .bypass(),
    .pop_fifo(),
    .push_fifo()
);

FIFO #( .Depth_Of_FIFO(16) ) i_queue(
    .clk(clk),
    .reset(reset),

    .flush(jmp_branch_valid),
    .offset(jmp_branch_address[3:2]),

    //Writter
    .DataInput(inst_to_fifo),
    .push(),
    .full(fifo_full),
    .wp(write_pointer),

    //Reading
    .DataOutput(inst_from_fifo),
    .empty(fifo_empty),
    .pop(),
    .rp(read_pointer)
);

mux_2to1 inst_mux(
    .a(inst_from_fifo),
    .b(bypass_inst),

    .sel(bypass_sel),
    
    .o(inst)
)

endmodule