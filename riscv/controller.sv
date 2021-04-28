`timescale 1ns / 1ps

module controller(
    input logic clock, 
	risc_if.if_mod_contr risc_if_inst
);

logic branchID;
logic branchInstr;
logic sel_funct;

// sel_DataToReg
assign risc_if_inst.sel_DataToReg = {risc_if_inst.opcode[4], risc_if_inst.opcode[2]};

// sel_PCNext
and a1(risc_if_inst.sel_PCNext, risc_if_inst.opcode[4], risc_if_inst.opcode[0]);

// sel_rs1
and a2(risc_if_inst.sel_rs1, risc_if_inst.opcode[3] ,risc_if_inst.opcode[2], risc_if_inst.opcode[0]);

// funct set to all 0s for LUI and AUIPC
//always_comb
//    begin
//        if(risc_if_inst.opcode == (lui || auipc || stype))
//            risc_if_inst.funct3_contr = 3'b000;
//        else
//            risc_if_inst.funct3_contr = risc_if_inst.funct3_datap;         
//    end
//assign risc_if_inst.funct3_contr = sel_funct ? 3'b000 : risc_if_inst.funct3_datap;


// sel_adderAIn logic
always_comb
	begin
		case(risc_if_inst.funct3_datap)
			3'b000: branchID = risc_if_inst.EQ;
			3'b001: branchID = ~risc_if_inst.EQ;
			3'b100: branchID = risc_if_inst.ALTB;
			3'b101: branchID = ~risc_if_inst.ALTB;
			3'b110: branchID = risc_if_inst.ALTBU;
			3'b111: branchID = ~risc_if_inst.ALTBU;
			default: branchID = 1'b0;
		endcase
	end

and a4(branchInstr, risc_if_inst.opcode[4] , ~risc_if_inst.opcode[2], ~risc_if_inst.opcode[0]);

and a5(risc_if_inst.sel_adderAin, branchInstr, branchID);

//
always_comb
    begin
        casex(risc_if_inst.opcode[4:0])
			// LUI
			5'b01101:
			    begin
                    risc_if_inst.reg_WE_L <= 1'b0; 
                    risc_if_inst.sel_MUX1 <= 1'b1;
                    risc_if_inst.sel_MUX2 <= 1'b1;
                    risc_if_inst.funct3_contr = 3'b000;
                    risc_if_inst.subSra = 1'b0;
                    //risc_if_inst.dataMem_WE_L <= 4'b1111;
                end
			// AUIPC
            5'b00101:
                begin
                    risc_if_inst.reg_WE_L <= 1'b0; 
                    risc_if_inst.sel_MUX1 <= 1'b0;
                    risc_if_inst.sel_MUX2 <= 1'b1;
                    risc_if_inst.funct3_contr = 3'b000;
                    risc_if_inst.subSra = 1'b0;
					//risc_if_inst.dataMem_WE_L <= 4'b1111;
                end
			// JAL
            5'b11011:
                begin
                    risc_if_inst.reg_WE_L <= 1'b0; 
                    risc_if_inst.sel_MUX1 <= 1'b0;
                    risc_if_inst.sel_MUX2 <= 1'b1;
                    risc_if_inst.funct3_contr = risc_if_inst.funct3_datap;
                    risc_if_inst.subSra = 1'b0;
					//risc_if_inst.dataMem_WE_L <= 4'b1111;
                end
            // JALR            
            5'b11001:
                begin
                    risc_if_inst.reg_WE_L <= 1'b0; 
                    risc_if_inst.sel_MUX1 <= 1'b1;
                    risc_if_inst.sel_MUX2 <= 1'b1;
                    risc_if_inst.funct3_contr = risc_if_inst.funct3_datap;
                    risc_if_inst.subSra = 1'b0;
					//risc_if_inst.dataMem_WE_L <= 4'b1111;
                end

			// B-TYPE
            5'b11000:
                begin
                    risc_if_inst.reg_WE_L <= 1'b1; 
                    risc_if_inst.sel_MUX1 <= 1'b1;
                    risc_if_inst.sel_MUX2 <= 1'b0;
                    risc_if_inst.funct3_contr = risc_if_inst.funct3_datap;
                    risc_if_inst.subSra = 1'b0;
					//risc_if_inst.dataMem_WE_L <= 4'b1111;
                end
			// LOAD
            5'b000xx:
                begin
					risc_if_inst.reg_WE_L <= 1'b0; 
                    risc_if_inst.sel_MUX1 <= 1'b1;
                    risc_if_inst.sel_MUX2 <= 1'b1;
                    risc_if_inst.funct3_contr = 3'b000;
                    risc_if_inst.subSra = 1'b0;
					//risc_if_inst.dataMem_WE_L <= 4'b1111;
                end
			// Store
			5'b010xx: 
                begin
					risc_if_inst.reg_WE_L <= 1'b1; 
                    risc_if_inst.sel_MUX1 <= 1'b1;
                    risc_if_inst.sel_MUX2 <= 1'b1;
                    risc_if_inst.funct3_contr = 3'b000;
                    risc_if_inst.subSra = 1'b0;
                    //risc_if_inst.dataMem_WE_L <= 4'b0000; 
                end
			// R-I-Type
            5'b00100:
                begin
					risc_if_inst.reg_WE_L <= 1'b0; 
                    risc_if_inst.sel_MUX1 <= 1'b1;
                    risc_if_inst.sel_MUX2 <= 1'b1;
                    risc_if_inst.funct3_contr = risc_if_inst.funct3_datap;
                    if(risc_if_inst.funct3_datap == 3'b101)
                        risc_if_inst.subSra = risc_if_inst.instr30;
                    else
                        risc_if_inst.subSra = 1'b0;
					//risc_if_inst.dataMem_WE_L <= 4'b1111;
                end
			// R-Type
            5'b01100: 
                begin
                    risc_if_inst.reg_WE_L = 1'b0; 
                    risc_if_inst.sel_MUX1 = 1'b1;
                    risc_if_inst.sel_MUX2 = 1'b0;
                    risc_if_inst.funct3_contr = risc_if_inst.funct3_datap;
                    risc_if_inst.subSra = risc_if_inst.instr30;
					//risc_if_inst.dataMem_WE_L <= 4'b1111;
                end
            default: 
                begin
                    risc_if_inst.reg_WE_L <= 1'b1; 
                    risc_if_inst.sel_MUX1 <= 1'b0;
                    risc_if_inst.sel_MUX2 <= 1'b0;
                    risc_if_inst.funct3_contr = risc_if_inst.funct3_datap;
                    risc_if_inst.subSra = 1'b0;
					//risc_if_inst.dataMem_WE_L <= 4'b1111;
                end
        endcase
    end

property luicheck;
@(posedge clock) risc_if_inst.opcode[4:0] ==  5'b01101 
    |-> (~risc_if_inst.reg_WE_L and risc_if_inst.sel_MUX1 
    and risc_if_inst.sel_MUX2);// and risc_if_inst.dataMem_WE_L <= 4'b1111);
 endproperty 
luiP: assert property (luicheck) else $display("luicheck FAIL");

property auipccheck;
@(posedge clock) risc_if_inst.opcode[4:0] == 5'b00101 
    |-> (~risc_if_inst.reg_WE_L and 
                    ~risc_if_inst.sel_MUX1 and
                    risc_if_inst.sel_MUX2);// and
					//risc_if_inst.dataMem_WE_L <= 4'b1111);
 endproperty 
auipcP: assert property (auipccheck) else $display("auipccheck FAIL");

endmodule
