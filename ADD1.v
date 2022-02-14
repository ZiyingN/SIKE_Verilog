`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/20 21:07:33
// Design Name: 
// Module Name: add1
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


module add1#(parameter N=222)(d1,d2,d3,gin,fin,coin,sin,d1o,so,gout,fout);

input [N/3-1:0]d1,d2,d3;
input [N/3-1:0]gin,fin;
input [N/6:0]coin;
input [N/6-1:0]sin;

output [N/3-1:0]d1o;
wire [N/6:0]co;
output [N/3-1:0]so;
output [N/3-1:0]gout,fout;
assign d1o=d1;
assign so[N/6-1:0] = sin;
wire [N/3:0] g12,f12;
CSA_N_4 CSA1({1'b0,gin},{fin,{1'b0}},{37'b0,coin},g12,f12);

assign {co,so[N/3-1:N/6]} = g12+{f12,1'b0};
CSA_N_4_1 CSA2(d2,d3,{36'b0,co},gout,fout);

/*
input [N/3-1:0]d1,d2,d3;
input [N/3-1:0]gin,fin;
input [N/6:0]coin;
input [N/6-1:0]sin;

output [N/3-1:0]d1o;
output [N/6:0]co;
output [N/3-1:0]so;

assign d1o=d1;
assign so[N/6-1:0] = sin;
wire [N/3:0] g12,f12;
CSA_N_4 CSA1({1'b0,gin},{fin,{1'b0}},{37'b0,coin},g12,f12);
wire [N/6:0]co2;
assign {co2,so[N/3-1:N/6]} = g12+{f12,1'b0};
wire [N/3-1:0]g13,f13;
CSA_N_4_1 CSA2(d2,d3,{37'b0,co2},g13,f13);

assign {co,so[N/3-1:N/6]} = g13+{f13,1'b0};*/
endmodule
