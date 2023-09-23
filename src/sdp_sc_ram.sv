module sdp_sc_ram #(parameter Word_Length = 8, parameter W_DEPTH = 16)
(

input   clk,
// Memory interface
input we,
input re,
input [Word_Length-1:0] data_wr,
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
        ram[addr_wr] <= data_wr;
    end

     if (re) begin
        data_rd <= ram[addr_rd];
    end
end

endmodule
