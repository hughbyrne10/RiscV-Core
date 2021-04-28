`timescale 1ns / 1ps

module mux_twoToOne #(parameter WIDTH = 32) (
    input logic [WIDTH-1:0] d0, d1, 
    input logic sel, 
    output logic [WIDTH-1:0] y
);

assign y = sel ? d1 : d0; 

endmodule