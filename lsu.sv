`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2021 11:37:42 AM
// Design Name: 
// Module Name: lsu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lsu
    #(
		parameter ADDR_WIDTH	= 12,
		parameter DATA_WIDTH	= 32
	)
	(
    input logic [DATA_WIDTH-1:0] memoryAddr_in,
    
    input logic [DATA_WIDTH-1:0] memoryData_in,
    
    input logic [DATA_WIDTH-1:0] memoryWriteData,
    
    input logic [2:0] funct3,
    
    input logic STORE_TYPE_L,
    
    output logic [ADDR_WIDTH-1:0] memoryAddr_out,
    
    output logic [DATA_WIDTH-1:0] memoryData_out,
    
    output logic [DATA_WIDTH-1:0] memoryWriteData_val,
    
    output logic [3:0] dataMem_WE_L
    
    
    );
    
   
    
assign memoryAddr_out = memoryAddr_in[13:2];



logic [7:0] readByte;
logic [15:0] readHWord;

logic [3:0] byte_WE_L;
logic [3:0] hWord_WE_L;

// Load Byte Logic
always_comb
    begin
        case(memoryAddr_in[1:0])
            2'b00: readByte = memoryData_in[7:0];
            2'b01: readByte = memoryData_in[15:8];
            2'b10: readByte = memoryData_in[23:16];
            2'b11: readByte = memoryData_in[31:24];
        endcase        
    end

// Load Half Word Logic
always_comb
    begin
        case(memoryAddr_in[1:0])
            2'b00: readHWord = memoryData_in[15:0];
            2'b10: readHWord = memoryData_in[31:16];
        endcase        
    end
    
// Load Logic
always_comb
    begin
        case(funct3)
                3'b000: memoryData_out = {{DATA_WIDTH-8{readByte[7]}},readByte};// LB
                3'b001: memoryData_out = {{DATA_WIDTH/2{readHWord[(DATA_WIDTH/2)-1]}},readHWord};//LH
                3'b010: memoryData_out = memoryData_in;    //LW
                3'b100: memoryData_out = {{DATA_WIDTH-8{1'b0}}, readByte};//LBU
                3'b101: memoryData_out = {{DATA_WIDTH/2{1'b0}}, readHWord};//LHU
                default: memoryData_out = memoryData_in;
            endcase
    end
    

// store byte write enable logic
always_comb
    begin
        case(memoryAddr_in[1:0])
            2'b00: byte_WE_L = 4'b1110;
            2'b01: byte_WE_L = 4'b1101;
            2'b10: byte_WE_L = 4'b1011;
            2'b11: byte_WE_L = 4'b0111;
        endcase
    end

// store half word write enable logic
always_comb
    begin
        case(memoryAddr_in[1:0])
            2'b00: hWord_WE_L = 4'b1100;
            2'b10: hWord_WE_L = 4'b0011;
        endcase
    end
// Store Logic
always_comb
    begin
        if(STORE_TYPE_L)
            dataMem_WE_L = 4'b1111;
        else
            case(funct3[1:0])
                    2'b00: 
                        begin
                            dataMem_WE_L = byte_WE_L;
                            if(memoryAddr_in[1:0] == 2'b00)
                                memoryWriteData_val[7:0] <= memoryWriteData[7:0];
                            if(memoryAddr_in[1:0] == 2'b01)
                                memoryWriteData_val[15:8] <= memoryWriteData[7:0];
                            if(memoryAddr_in[1:0] == 2'b10)
                                memoryWriteData_val[23:16] <= memoryWriteData[7:0];
                            if(memoryAddr_in[1:0] == 2'b11)
                                memoryWriteData_val[31:24] <= memoryWriteData[7:0];            
                        end   
                    2'b01: 
                        begin
                            dataMem_WE_L = hWord_WE_L;
                            if(memoryAddr_in[1:0] == 2'b00)
                                memoryWriteData_val[15:0] <= memoryWriteData[15:0];
                            if(memoryAddr_in[1:0] == 2'b10)
                                memoryWriteData_val[31:16] <= memoryWriteData[15:0];
                        end 
                    2'b10: 
                        begin
                            dataMem_WE_L = 4'b0000;
                            memoryWriteData_val <= memoryWriteData;
                        end 
                    default: dataMem_WE_L = 4'b1111;
                endcase
    end
        

endmodule
