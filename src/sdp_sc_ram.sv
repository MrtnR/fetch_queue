module sdp_sc_ram #(parameter Word_Length = 8, parameter W_DEPTH = 16, parameter IN_WIDTH = 128)
(

input   clk,
// Memory interface
input we,
input re,
input [IN_WIDTH-1:0] data_wr,
input [$clog2(W_DEPTH)-1:0] addr_wr,
input [$clog2(W_DEPTH)-1:0] addr_rd,
output logic [Word_Length-1:0] data_rd
);

// Declare a RAM variable
logic [Word_Length-1:0]  ram [W_DEPTH-1:0];

//Variable to hold the registered read adddres
logic [$clog2(W_DEPTH)-1:0]  addr_logic;

always_ff@(posedge clk) begin
    
    if(we) begin
        ram[addr_wr] <= data_wr[31:0];
        ram[addr_wr+32'h1] <= data_wr[63:32];
        ram[addr_wr+32'h2] <= data_wr[95:64];
        ram[addr_wr+32'h3] <= data_wr[127:96];
    end

    if (re) begin
        data_rd <= ram[addr_rd];
    end
end

endmodule
