module instructionMem(
    input clock,
    input logic reset,
    input logic [31:0] instrMemAddr,
    output logic [31:0] instruction
    );
    
logic [31:0] memory [127:0];

initial
        $readmemb("instructions.mem", memory);



logic [31:0] ram_read_data;

	
assign instruction[31:24] = ~reset ? 32'b0 : memory[instrMemAddr/4][31:24];
assign instruction[23:16] = ~reset ? 32'b0 : memory[instrMemAddr/4][23:16];
assign instruction[15:8] = ~reset ? 32'b0 : memory[instrMemAddr/4][15:8];
assign instruction[7:0] = ~reset ? 32'b0 : memory[instrMemAddr/4][7:0]; 

endmodule
