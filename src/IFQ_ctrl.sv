module IFQ_ctrl(
    input clk,
    input reset,

    input dout_valid,
    input rd_enable,
    input branch_valid,
    input fifo_empty,
    input fifo_full,

    output logic flush,
    output logic pc4_en,
    output logic cache_en,
    output logic bypass,
    output logic pop_fifo,
    output logic push_fifo
);

localparam IDLE = 'h0;
localparam RST = 'h1;
localparam OUT_RST = 'h2;
localparam INST0 = 'h3;
localparam INST1 = 'h4;
localparam INST2 = 'h5;
localparam INST3 = 'h6;
localparam DO_FLUSH = 'h7;


logic [4:0] state;
logic [4:0] next;

logic [3:0] pc_cnt;

logic advance_bypass;

always_ff@(posedge clk, negedge reset)begin
    if(~reset)
        state <= RST;
    else
        state <= next;
end

always_ff@(posedge clk, negedge reset)begin
    if(~reset)
        pc_cnt <= 4'h0;
    else begin
        if(rd_enable)
            pc_cnt <= (pc4_en || flush) ? 4'h0 : pc_cnt + 4'h1;
    end
end


assign pc4_en = ( pc_cnt == 4'h3) ? 1'b1 : 1'b0;
assign pop_fifo = advance_bypass|rd_enable;

endmodule