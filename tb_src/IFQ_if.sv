interface IFQ_if;

logic i_clk;
logic rst_n;

logic [31:0] i_cache_pc;
logic cache_rd_en;
logic cache_abort;
logic [127:0] cache_dout;
logic cache_dout_valid;


logic [31:0] dispatch_pc;
logic [31:0] inst;
logic empty;
logic ifq_full;
logic inst_rd_en;
logic [31:0] jmp_br_addr;
logic jmp_br_valid;

endinterface