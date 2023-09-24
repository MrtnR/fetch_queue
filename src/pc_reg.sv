module pc_reg#(
	parameter N=32
) (
	input clk,
	input reset,
	input [N-1:0] NewPC,
	input en,
	
	
	output reg [N-1:0] PCValue
);

always@(negedge reset or posedge clk) begin
	if(~reset)
		PCValue <= 'h0;
	else if (en) begin
		PCValue<=NewPC;
	end	
end

endmodule