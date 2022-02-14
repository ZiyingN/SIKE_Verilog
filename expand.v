`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/20 15:18:03
// Design Name: 
// Module Name: expand
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


module expand(a1,a2,b1,b2,S_in,s1,s2);
input a1,b1,a2,b2,S_in;
output s1,s2;

wire p1 = a1^b1;
wire p2 = a2^b2;
wire P_all = p1 & p2;
wire c1 = S_in^P_all;
wire g1 = a1&b1;
wire c2 = g1|(p1&c1);

assign s1 = p1^c1;
assign s2 = p2^c2;
 
endmodule
