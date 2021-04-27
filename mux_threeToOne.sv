`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2021 08:55:47 PM
// Design Name: 
// Module Name: mux_threeToOne
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


module mux_threeToOne #(parameter WIDTH = 32) (
    input logic [WIDTH-1:0] d0, d1, d2, 
    input logic [1:0] sel, 
    output logic [WIDTH-1:0] y
);

always_comb
    begin
        case(sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;        
        endcase
    end

endmodule
