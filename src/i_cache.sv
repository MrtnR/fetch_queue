module i_cache(
    input [31:0] pc_in,
    input rd_en,
    input abort,

    output logic [127:0] Dout,
    output logic Dout_valid
);

reg [31:0] cache [255:0];

initial begin
    int i;
    for (int i = 0; i < 256; i++) begin
        cache[i] = $urandom();
    end
end

always @ (pc_in, rd_en) begin
    if(rd_en) begin
        Dout = {cache[pc_in+'h3],cache[pc_in+'h2],cache[pc_in+'h1],cache[pc_in]};
        Dout_valid = 1'b1;
    end else begin
        Dout_valid = 1'b0;
        Dout = Dout;
    end
end


endmodule