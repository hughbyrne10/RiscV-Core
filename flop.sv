module flop#(parameter WIDTH = 32) 
    (
    input logic clock, reset,
    input logic [WIDTH-1:0] d, 
    output logic [WIDTH-1:0] q
);

always_ff@(posedge clock, negedge reset) 
    if (!reset) 
        q <= 0;
    else
        q <= d; 
        
endmodule