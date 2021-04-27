`timescale 1ns / 1ps

module datapath(
	input logic clock, reset, 
	risc_if.if_mod_dp risc_if_inst
    );

logic [31:0] instruction;

assign risc_if_inst.opcode = instruction[6:2];
assign risc_if_inst.funct3_datap = instruction[14:12];


logic sel_immALU;

logic [31:0] adderOut;
logic [31:0] aluOut;
logic [31:0] immALU;
logic [31:0] pcNext;
logic [31:0] pc;
logic [31:0] instructionNext;
logic [31:0] imm;
logic [31:0] adderAin;

logic [4:0] rd;
logic [4:0] rs1, rs2;
logic [31:0] regData1;
logic [31:0] regData2;
logic [31:0] regWriteData;

logic [31:0] muxOut1;
logic [31:0] muxOut2;

logic [31:0] dataMemOut;

logic [11:0] memAddr_val;
logic [31:0] dataMemOut_val;
logic [3:0] dataMem_WE_L;
logic [31:0] memWriteData_val;

logic R_TYPE_L;
assign R_TYPE_L = (instruction[6:0] == 7'b0110011) ? 1'b0 : 1'b1;
logic STORE_TYPE_L;
assign STORE_TYPE_L = (instruction[6:0] == 7'b0100011) ? 1'b0 : 1'b1;


assign rd = instruction[11:7];
assign rs1 = risc_if_inst.sel_rs1 ? 5'b00000 : instruction[19:15]; 
assign rs2 = instruction[24:20]; 

assign risc_if_inst.instr30 = instruction[30];

//Program Counter
mux_twoToOne #(32) mux_PCNext(adderOut, aluOut, risc_if_inst.sel_PCNext, pcNext);

flop #(32) pcRegister(clock, reset, pcNext, pc);

//Immediate Decoder
decoderImm decoderImm(instruction, imm);


//Adder
mux_twoToOne #(32) mux_adderAIn(32'b100, imm, risc_if_inst.sel_adderAin, adderAin);

adder pcAdder(adderAin, pc, adderOut);


//Register File
//and a(sel_immALU, instruction[5],instruction[2]);

//mux_twoToOne #(32) mux_immALU(aluOut, imm, sel_immALU, immALU);

mux_threeToOne #(32) mux_regIn(dataMemOut_val, aluOut, adderOut, risc_if_inst.sel_DataToReg, regWriteData);

registerFile regFile(clock, reset, rd, regWriteData, risc_if_inst.reg_WE_L, risc_if_inst.funct3_contr, rs1, regData1, rs2, regData2);


//ALU
mux_twoToOne #(32) mux_ALU1(pc, regData1, risc_if_inst.sel_MUX1, muxOut1);

mux_twoToOne #(32) mux_ALU2(regData2, imm, risc_if_inst.sel_MUX2, muxOut2);

alu alu(muxOut1, muxOut2, risc_if_inst.subSra, R_TYPE_L, risc_if_inst.funct3_contr, imm[4:0], risc_if_inst.EQ, risc_if_inst.ALTB, risc_if_inst.ALTBU, aluOut);

//Memory
instructionMem instructionMem(clock, reset, pc, instruction);

//flop instrReg(clock, reset, instructionNext, instruction);

dataMem dataMem(clock, memAddr_val, memWriteData_val, dataMem_WE_L, dataMemOut);

lsu lsu1(aluOut, dataMemOut, regData2,risc_if_inst.funct3_datap, STORE_TYPE_L, memAddr_val, dataMemOut_val, memWriteData_val,dataMem_WE_L);

endmodule
