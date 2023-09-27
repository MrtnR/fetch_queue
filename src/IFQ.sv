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
    `ifdef DEBUG
    output IFQ_FULL,
    `endif
    input inst_rd_en,
    input [31:0] jmp_branch_address,
    input jmp_branch_valid
);

wire [31:0] inst_to_fifo;
wire [31:0] inst_from_fifo;
wire [31:0] bypass_inst;
wire [4:0] write_pointer;
wire [4:0] read_pointer;

wire bypass_sel;
wire fifo_empty;
wire fifo_full;

wire w_pc_en;
wire w_cache_en;
wire w_wr_fifo;
wire w_rd_fifo;

wire w_pc4_en;
wire [31:0] new_pc;
wire [31:0] next_pc;
wire [31:0] curr_pc;

mux_4to1 fifo_write(
    .a(dout[31:0]),
    .b(dout[63:32]),
    .c(dout[95:64]),
    .d(dout[127:96]),

    .sel(write_pointer[1:0]),

    .o(inst_to_fifo)
);

mux_4to1 fifo_bypass(
    .a(dout[31:0]),
    .b(dout[63:32]),
    .c(dout[95:64]),
    .d(dout[127:96]),

    .sel(write_pointer[1:0]),

    .o(bypass_inst)
);

IFQ_ctrl q_ctrl(
    .clk(clk),
    .reset(rst),

    .dout_valid(dout_valid),
    .rd_enable(inst_rd_en),
    .branch_valid(jmp_branch_valid),
    .fifo_empty(fifo_empty),
    .fifo_full(fifo_full),

    .pc4_en(w_pc4_en),
    .cache_en(w_cache_en),
    .bypass(bypass_sel),
    .pop_fifo(w_rd_fifo),
    .push_fifo(w_wr_fifo)
);

FIFO_Mod #( .Depth_Of_FIFO(16) ) i_queue(
    .clk(clk),
    .reset(rst),

    .flush(jmp_branch_valid),
    .offset(jmp_branch_address[3:2]),

    //Writter
    .DataInput(inst_to_fifo),
    .push(w_wr_fifo),
    .full(fifo_full),
    .wp(write_pointer),

    //Reading
    .DataOutput(inst_from_fifo),
    .empty(fifo_empty),
    .pop(w_rd_fifo),
    .rp(read_pointer)
);

mux_2to1 inst_mux(
    .a(inst_from_fifo),
    .b(bypass_inst),

    .sel(bypass_sel),
    
    .o(inst)
);

mux_2to1 pc_mux(
    .a(next_pc),
    .b(jmp_branch_address),

    .sel(jmp_branch_valid),
    
    .o(new_pc)
);

pc_reg pc(
    .clk(clk),
	.reset(rst),
	.NewPC(new_pc),
	.en(1'b1),

	.PCValue(curr_pc)
);

pc_reg mirror_pc(
    .clk(clk),
    .reset(rst),
    .NewPC(new_pc),
    .en(w_pc4_en),

    .PCValue(pc_in)
);

assign cache_abort = 1'b0;
assign cache_rd_en = w_cache_en & ~fifo_full;
assign next_pc = curr_pc + 4'h1;
//assign pc_in = curr_pc;
assign empty = fifo_empty;
`ifdef DEBUG
assign IFQ_FULL = fifo_full;
`endif


endmodule