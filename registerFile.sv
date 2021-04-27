`timescale 1ns / 1ps

module registerFile(
    input logic clock, reset,
    input logic [4:0] rd,
    input logic [31:0] regWriteData,
    input logic reg_WE_L,
	input logic [2:0] funct3,
	//input logic LOAD_TYPE_L,
    input logic [4:0] rs1,
    output logic [31:0] regData1,
    input logic [4:0] rs2,
    output logic [31:0] regData2
    );
    
logic [31:0] registerBank [31:0];


always_ff @(posedge clock)
    begin
        if ((!reg_WE_L) & (rd != 5'b00000)) 
			begin
                registerBank[rd] <= regWriteData;
			end
		else
			begin
				registerBank[rd] <= registerBank[rd];
			end
	end
			

assign regData1 = (rs1 != 0) ? registerBank[rs1] : 0;
assign regData2 = (rs2 != 0) ? registerBank[rs2] : 0;

assign registerBank[5'b00000] = 32'b0;

endmodule