`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/20 15:36:47
// Design Name: 
// Module Name: compact
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


module compact(a1,b1,a2,b2,A_out,B_out);
input a1,b1,a2,b2;
output A_out,B_out;

wire g2 = a2 & b2;
wire p2 = a2 ^ b2;

assign A_out =  g2 | (p2 & a1);
assign B_out =  g2 | (p2 & b1);
endmodule
