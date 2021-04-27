`timescale 1ns / 1ps

module dataMem
	#(
		parameter ADDR_WIDTH	= 12,
		parameter DATA_WIDTH	= 32,
		parameter DEPTH		= 4096,
		parameter DEPTH_TEST = 10
	)
	(
    input logic clock,
    input logic [ADDR_WIDTH-1:0] dataMem_addr,
    input logic [DATA_WIDTH-1:0] dataMem_in,
    input logic [3:0] dataMem_WE_L,
    output logic [31:0] dataMem_out
    );
	
logic [DATA_WIDTH-1:0] ram [DEPTH-1:0]; 

logic [DATA_WIDTH-1:0] ram_read_data;

// Synchronous write
always@(posedge clock)
	begin
		if (dataMem_WE_L[0] == 1'b0)
			ram[dataMem_addr][7:0] <= dataMem_in[7:0];
		if (dataMem_WE_L[1] == 1'b0)
			ram[dataMem_addr][15:8] <= dataMem_in[15:8];
		if (dataMem_WE_L[2] == 1'b0)
			ram[dataMem_addr][23:16] <= dataMem_in[23:16];
		if (dataMem_WE_L[3] == 1'b0)
			ram[dataMem_addr][31:24] <= dataMem_in[31:24];

	end    


assign ram_read_data = ram[dataMem_addr[ADDR_WIDTH-1:0]];

assign dataMem_out = ram_read_data;

endmodule
