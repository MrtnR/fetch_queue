module mux_4to1  #(
    parameter DATA_WIDTH = 32
)(
    input [DATA_WIDTH-1:0]a,
    input [DATA_WIDTH-1:0]b,
    input [DATA_WIDTH-1:0]c,
    input [DATA_WIDTH-1:0]d,

    input [1:0]sel,

    output reg [DATA_WIDTH-1:0]o
);

always @ (*) begin
    case (sel)
        2'b00: o <= a;
        2'b01: o <= b;
        2'b10: o <= c;
        2'b11: o <= d;
    endcase
end

endmodule