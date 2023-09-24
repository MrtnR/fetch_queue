module IFQ_ctrl(
    input clk,
    input reset,

    input dout_valid,
    input rd_enable,
    input branch_valid,
    input fifo_empty,
    input fifo_full,

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
        if(state != RST && state != IDLE)
            pc_cnt <= pc_cnt + 4'h1;
        if( pc4_en )
            pc_cnt <= 4'h0;
    end
end

always_comb begin
    case (state)
        RST: begin
            next = OUT_RST;
        end
        OUT_RST: begin
            if(dout_valid)
                next = INST1;
            else
                next = IDLE;
        end
        INST0: begin
            next = INST1;
        end
        INST1: begin
            next = INST2;
        end
        INST2: begin
            next = INST3;
        end
        INST3: begin
            next = IDLE;
        end
        IDLE: begin
            if(fifo_full)
                next = IDLE;
            if(fifo_empty || (~fifo_full && ~fifo_empty))
                next = INST0;
            else
                next = IDLE;
        end

        default: begin
            next = IDLE;
        end
    endcase
end

always_comb begin
    case (state)
        RST: begin
            cache_en = 1'b0;
            bypass = 1'b0;
            push_fifo = 1'b0;
        end
        OUT_RST: begin
            cache_en = 1'b1;
            bypass = 1'b1;
            push_fifo = 1'b1;        
        end
        INST0: begin
            cache_en = 1'b1;
            bypass = 1'b0;
            push_fifo = 1'b1;         
        end
        INST1: begin
            cache_en = 1'b0;
            bypass = 1'b0;
            push_fifo = 1'b1;       
        end
        INST2: begin
            cache_en = 1'b0;
            bypass = 1'b0;
            push_fifo = 1'b1;
        end
        INST3: begin
            cache_en = 1'b0;
            bypass = 1'b0;
            push_fifo = 1'b1;
        end
        IDLE: begin
            cache_en = 1'b0;
            bypass = 1'b0;
            push_fifo = 1'b0;
        end

        default: begin
            cache_en = 1'b0;
            bypass = 1'b0;
            push_fifo = 1'b0;
        end
    endcase
end

assign pc4_en = ( pc_cnt == 4'h4) ? 1'b1 : 1'b0;
assign pop_fifo = rd_enable;

endmodule