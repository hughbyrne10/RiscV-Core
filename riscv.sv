`timescale 1ns / 1ps


interface risc_if();
	// DataPath Outputs, Controller Inputs
	logic [4:0] opcode;
	logic [2:0] funct3_datap;
	logic instr30;
	logic EQ, ALTB, ALTBU;
	
	// DataPath Inputs, Controller Outputs
	logic sel_PCNext;
	logic [1:0] sel_DataToReg;
	logic sel_MUX1;
	logic sel_MUX2;
	logic reg_WE_L;
	logic sel_adderAin;
	logic [2:0] funct3_contr;
	logic sel_rs1;
	logic subSra;
	
	modport if_mod_dp ( input funct3_contr, sel_DataToReg, sel_MUX1, sel_MUX2, reg_WE_L, sel_adderAin, sel_PCNext, sel_rs1, subSra,
					    output EQ, ALTB, ALTBU, opcode, funct3_datap, instr30
						);				   
    modport if_mod_contr ( input EQ, ALTB, ALTBU, opcode, funct3_datap, instr30,
						   output funct3_contr, sel_DataToReg, sel_MUX1, sel_MUX2, reg_WE_L, sel_adderAin, sel_PCNext, sel_rs1, subSra
					      );
endinterface


module riscv(
	input logic clock,
	input logic reset	
);

risc_if risc_if_inst();

controller controlUnit1(clock, risc_if_inst);

datapath datapath1(clock, reset, risc_if_inst);


endmodule
