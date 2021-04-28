`timescale 1ns / 1ps

module decoderImm(
    input logic [31:0] instruction,
    output logic [31:0] imm

    );
    
logic [4:0] opcode;
assign opcode = instruction [6:2];


always_comb
	casex(opcode[4:0])
			5'b0x101: imm = {instruction[31:12], {12{1'b0}}}; // U Type 
			5'bxxx1x: imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J Type
			5'b010xx: imm = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]}; // S type
			//5'b110x0: imm = {{20{instruction[31]}}, instruction[30:20]}; // I Type ->CHECK DECODING OF I-TYPE
			5'b11001: imm = {{20{instruction[31]}}, instruction[31:20]};
			5'b00100: imm = {{20{instruction[31]}}, instruction[31:20]};
			5'b00000: imm = {{20{instruction[31]}}, instruction[31:20]}; // LOAD
			5'b11000: imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
			
			default: imm = imm;
	endcase
endmodule