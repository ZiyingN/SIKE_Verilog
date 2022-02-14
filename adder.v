`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/20 16:42:54
// Design Name: 
// Module Name: adder
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


module adder#(parameter N = 8)(a,b,cin,s,cout);
input [N-1:0]a,b;
input cin;
output [N-1:0]s;
output cout;

assign {cout,s} = a+b+cin;

endmodule
