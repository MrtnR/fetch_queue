module mux_2to1  #(
    parameter DATA_WIDTH = 32
)(
    input [DATA_WIDTH-1:0]a,
    input [DATA_WIDTH-1:0]b,

    input sel,

    output reg [DATA_WIDTH-1:0]o
);

always @ (*) begin
   o <= (sel) ? b : a;
end

endmodule