`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/04 15:21:52
// Design Name: 
// Module Name: add2
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


module add2#(parameter N=222)(sin,gin,fin,d1,s);

input [N/3-1:0] sin,gin,fin,d1;
output [5*N/6-1:0]s;

assign s[N/3-1:0] = sin;

wire [N/6:0]co1;
assign {co1,s[N/2-1:N/3]} = gin+{fin,1'b0};

assign s[N*5/6-1:N/2] = co1+d1;

endmodule