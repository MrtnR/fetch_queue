`timescale 1ns / 1ns

module tb_i_cache;

    reg i_clk;
    reg rst_n;
    reg [31:0] r_clk_cntr;

    reg [31:0] r_pc_in;
    reg r_rd_en;
    reg r_abort;

    wire [127:0] w_dout;
    wire w_dout_valid;
    

    i_cache dut_cache(
        // Inputs
        .pc_in(r_pc_in),
        .rd_en(r_rd_en),
        .abort(r_abort),
        // Outputs
        .Dout(w_dout),
        .Dout_valid(w_dout_valid)
    );
    

    // Initial conditions
    initial begin
        $display("Start simulation");
        i_clk           =  1'b1; // Start cklock in rising edge
        r_clk_cntr      = 32'h0;
        r_pc_in         = 32'h0;
        r_rd_en         =  1'b1;
        r_abort         =  1'b0;
        $display("Reset system");
        rst_n           =  1'b1; // Pulse rst to reset system
        #1 rst_n        =  1'b0;
        #1 rst_n        =  1'b1;
        
    end
    
    // Clock signal
    always begin 
    
        #5 i_clk        = ~i_clk; r_clk_cntr = r_clk_cntr + 1'b1;
        
    end
        
    // Abort signal
    always begin 
    
        #400 r_abort      = ~r_abort;
        
    end
     
    // Read signal
    always begin 
    
        #200 r_rd_en      = ~r_rd_en;
        
    end
    
    always begin 
            
        $display("1. Increment PC counter.");
        
        #10
        r_pc_in         = r_pc_in + 32'b1;
        
        $display(" r_pc_in: %0h\n r_rd_en: %0h\n r_abort: %0h\n", r_pc_in, r_rd_en, r_abort);
       
       
    end

endmodule