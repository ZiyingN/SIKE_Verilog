`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/04 19:53:50
// Design Name: 
// Module Name: normal_multiplication_compute
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


module normal_multiplication_compute#(N=222)(
    input [N/6-1:0] multiplicand,
    input [N/6-1:0] multiplier,
    output  [N/3-1:0] product_final
    );
    
    assign product_final = multiplicand * multiplier;
    
endmodule
