module IFQ(
    input clk,
    input rst,

    // To the Instruction cache
    output [31:0] pc_in,
    output logic cache_rd_en,
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
reg [31:0] bypass_inst;
wire [4:0] write_pointer;
wire [4:0] read_pointer;

reg r_wr_fifo;
reg r_rd_fifo;
wire w_full_fifo;
wire w_empty_fifo;

reg do_bypass;

wire w_pc4_en;
wire [31:0] w_next_pc4;
wire [31:0] w_next_pc16;

always_comb begin
    if( ~w_full_fifo || w_empty_fifo ) begin
        cache_rd_en = 1'b1;
        r_wr_fifo = 1'b1;
    end
    if( w_full_fifo ) begin
        cache_rd_en = 1'b0;
        r_wr_fifo = 1'b0;
    end
end

always_comb begin
    do_bypass = ( write_pointer == 5'h00 && read_pointer == 5'h00 && inst_rd_en) ? 1'b1 : 1'b0;
end

always_comb begin
    case(read_pointer[1:0])
    2'b00: begin
        bypass_inst = dout[31:0];
    end
    2'b01: begin
        bypass_inst = dout[63:32];
    end
    2'b10: begin
        bypass_inst = dout[95:64];
    end
    2'b11: begin
        bypass_inst = dout[127:96];
    end
    endcase
end

mux_2to1 inst_bypass(
    .a(inst_from_fifo),
    .b(bypass_inst),

    .sel(do_bypass),

    .o(inst)
);

FIFO_Mod_Async #( .Depth_Of_FIFO(16) ) i_queue(
    .clk(clk),
    .reset(rst),

    .flush(jmp_branch_valid),
    .offset(jmp_branch_address[3:2]),

    //Writter
    .DataInput(dout),
    .push(r_wr_fifo),
    .full(w_full_fifo),
    .wp(write_pointer),

    //Reading
    .DataOutput(inst_from_fifo),
    .empty(w_empty_fifo),
    .pop(inst_rd_en),
    .rp(read_pointer)
);

mux_2to1 mux_pc4(
    .a(pc_out + 'h4),
    .b(jmp_branch_address),

    .sel(jmp_branch_valid),
    
    .o(w_next_pc4)
);

mux_2to1 mux_pc16(
    .a(pc_in + 'h10),
    .b(jmp_branch_address),

    .sel(jmp_branch_valid),
    
    .o(w_next_pc16)
);

pc_reg pc_4(
    .clk(clk),
	.reset(rst),
	.NewPC(w_next_pc4),
	.en(inst_rd_en|jmp_branch_valid),

	.PCValue(pc_out)
);

pc_reg pc_16(
    .clk(clk),
    .reset(rst),
    .NewPC(w_next_pc16),
    .en(cache_rd_en|jmp_branch_valid),

    .PCValue(pc_in)
);

assign cache_abort = 1'b0;
//assign cache_rd_en = w_cache_en & ~fifo_full;
//assign next_pc = curr_pc + 4'h1;
//assign pc_in = curr_pc;
assign empty = w_empty_fifo;
`ifdef DEBUG
assign IFQ_FULL = w_full_fifo;
`endif
//assign pc_out = curr_pc;

endmodule