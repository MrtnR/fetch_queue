module i_cache(
    input [31:0] pc_in,
    input rd_en,
    input abort,

    output logic [127:0] Dout,
    output logic Dout_valid
);

reg [31:0] cache [255:0];
wire [15:0] pc_read;
wire [15:0] dout_cl_0_addr;
wire [15:0] dout_cl_1_addr;
wire [15:0] dout_cl_2_addr;
wire [15:0] dout_cl_3_addr;
wire [31:0] dout_cl_0;
wire [31:0] dout_cl_1;
wire [31:0] dout_cl_2;
wire [31:0] dout_cl_3;


// Hook less significant bits to 0s
assign pc_read = {4'h0, pc_in[31:4]};
//assign pc_read = {pc_in[31:4], 4'h0};

// Assign instructions addresses
assign dout_cl_0_addr = (pc_read<<2)+2'h0;
assign dout_cl_1_addr = (pc_read<<2)+2'h1;
assign dout_cl_2_addr = (pc_read<<2)+2'h2;
assign dout_cl_3_addr = (pc_read<<2)+2'h3;
// Assign instructions in cache line fields
assign dout_cl_0 = cache[dout_cl_0_addr];
assign dout_cl_1 = cache[dout_cl_1_addr];
assign dout_cl_2 = cache[dout_cl_2_addr];
assign dout_cl_3 = cache[dout_cl_3_addr];

// Populate memory
initial begin
    int i;
    for (int i = 0; i < 256; i+=12) begin
       
        cache[i+0] = 32'hffff_ffff;   // Invalid instruction
        cache[i+1] = $urandom();      // Valid instruction
        cache[i+2] = $urandom();      // Valid instruction
        cache[i+3] = $urandom();      // Valid instruction
        
        cache[i+4] = $urandom();      // Valid instruction
        cache[i+5] = $urandom();      // Valid instruction
        cache[i+6] = $urandom();      // Valid instruction
        cache[i+7] = $urandom();      // Valid instruction
        
        cache[i+8] = $urandom();      // Valid instruction
        cache[i+9] = $urandom();      // Valid instruction
        cache[i+10] = 32'h0;          // Invalid instruction
        cache[i+11] = $urandom();     // Valid instruction
        
    end
end


// RAM
always @ (pc_read, rd_en) begin
    if(rd_en) begin
                
        Dout = {dout_cl_3,
                dout_cl_2,
                dout_cl_1,
                dout_cl_0};
        
        // Dout_valid when inst != 0s and != ffs
        if( (dout_cl_3 != 32'h0) &&
            (dout_cl_2 != 32'h0) &&
            (dout_cl_1 != 32'h0) &&
            (dout_cl_0 != 32'h0) &&
            (dout_cl_3 != 32'hffff_ffff) &&
            (dout_cl_2 != 32'hffff_ffff) &&
            (dout_cl_1 != 32'hffff_ffff) &&
            (dout_cl_0 != 32'hffff_ffff) )
            Dout_valid = 1'b1;
        else
            Dout_valid = 1'b0;
            
    end else begin
        Dout_valid = 1'b0;
        Dout = Dout;
    end
end


endmodule