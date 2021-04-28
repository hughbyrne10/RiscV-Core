`timescale 1ns / 1ps

module alu(
    input logic [31:0] aIn, 
    input logic [31:0] bIn,
    input logic subSra,
    input logic R_RI_TYPE_L,
    input logic [2:0] funct3,
    input logic [4:0] shamt,
    output logic EQ, ALTB, ALTBU,
    output logic [31:0] aluOut
    );
    
logic signed [31:0] SaIn; 
logic signed [31:0] SbIn;  

assign SaIn = aIn;
assign SbIn = bIn;

assign EQ = (aIn == bIn) ? 1'b1 : 1'b0;
assign ALTB = (SaIn < SbIn) ? 1'b1 : 1'b0;  
assign ALTBU = (aIn < bIn) ? 1'b1 : 1'b0;
    
always_comb 
    case(funct3)
        3'b000: aluOut = subSra ? aIn - bIn : aIn + bIn;//(!R_RI_TYPE_L && subSra) ? aIn - bIn : aIn + bIn; // add
        3'b010: aluOut = ALTB ? {31'b0, 1'b1} : 32'b0;
        3'b011: aluOut = ALTBU ? {31'b0, 1'b1} : 32'b0;
        default:
            begin
                aluOut = aluOut;
            end
    endcase
        
endmodule