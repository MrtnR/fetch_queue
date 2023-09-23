module i_cache(
    input [31:0] pc_in,
    input rd_en,
    input abort,

    output [127:0] Dout,
    output Dout_valid
);

reg [31:0] cache [255:0];

always @ (pc_in, rd_en) begin
    if(rd_en) begin
        Dout = {cache[pc_in+'3],cache[pc_in+'2],cache[pc_in+'1],cache[pc_in]};
        Dout_valid = 1'b1;
    end else begin
        Dout_valid = 1'b0;
        Dout = {'z};
    end
end


endmodule