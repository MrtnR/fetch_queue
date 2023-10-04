// Coder:       Abisai Ramirez Perez
// Date:        June 2th, 2019
// Name:        cntr_mod_n_ovf.sv
// Description: This is a counter mod-n with a flag for indicating 
//              overflow.

// This is a Mod-n counter with overflow indication and its package. 
// Coder:       Abisai Ramirez Perez
// Date:        June 2th, 2019
// Name:        cntr_mod_n_ovf.sv
// Description: This is a counter mod-n with a flag for indicating 
//              overflow.

// This is a Mod-n counter with overflow indication and its package. 
module cntr_mod_n_ovf
(
input                   clk,
input                   rst,
input                   enb,
input		[7:0]		count_max,
output logic   			ovf
);

logic [7:0] cntr;

always_ff@(posedge clk, negedge rst) begin: counter
    if (!rst)
        cntr    <=  '0;
    else if (ovf)
		  cntr    <=  '0;
    else if (enb)
        if (cntr >= count_max)
            cntr    <= '0;
        else
            cntr    <= cntr + 1'b1;
end:counter

always_comb begin: comparator
    if (cntr >= count_max)
        ovf     =   1'b1;    
    else
        ovf     =   1'b0;
end:comparator


endmodule


