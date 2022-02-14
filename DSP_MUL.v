`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/04 15:21:52
// Design Name: 
// Module Name: DSP_MUL
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


module DSP_mul(clk,init,A_one_init,A_two_init,B_one_init,B_two_init,c_out_1,c_out_2);
`include"karatsuba_parameter.v"
 input clk;
 //input clk_n,clk_p;
 input [N-3:0]A_one_init,A_two_init,B_one_init,B_two_init;
 input init;
 output reg [N-3:0]c_out_1,c_out_2;
 reg [5:0] count;
 reg [N-3:0]p,t;
 reg [1:0] cycle,cycle1;
 reg [N/6-1:0] multiplicand,multiplicand1,multiplicand2,multiplicand3,multiplicand4,multiplicand5,multiplicand6,multiplicand7,multiplicand8;
 reg [N/6-1:0] multiplier,multiplier1,multiplier2,multiplier3,multiplier4,multiplier5,multiplier6,multiplier7,multiplier8;
 wire [N/3-1:0] product,product1,product2,product3,product4,product5,product6,product7,product8;
 
 wire [N/6-1:0]    a11,a12,a13,a14,a15,a16,a21,a22,a23,a24,a25,a26;    
 
  wire flag,flag2;
assign flag = ((cycle1==2)||(cycle1==3))?1:0;
assign flag2= ((cycle1==1)||(cycle1==3) )?1:0;

 always@(posedge clk) begin
  if(init) begin cycle<=0; end
   else cycle<=cycle+1;
end

 always@(posedge clk) begin
 if(init) begin cycle1<=0;end
  else cycle1<=cycle1+1;
end

always@(posedge clk)
 begin 
   if(init) count<=0; 
   else if(count ==11&&cycle1==3)count<=0;
   else if(cycle1 == 3)
      count<=count+1;
 end 
 
reg[N-3:0]Q;
reg [N-3:0]out_2_1,out_1_1;
///////////////////////////////////////////////////////////////////////////Data distribution_1
assign a11= (count ==3||count ==2||count ==6||count ==7||count ==9)?p[219:N*5/6-1]:A_one_init[N-3:N*5/6-1];                                      assign a21=A_two_init[N-3:N*5/6-1];
assign a12= (count ==3||count ==2||count ==6||count ==7||count ==9)?p[5*N/6-2:N*2/3-1]:A_one_init[5*N/6-2:N*2/3-1];                              assign a22=A_two_init[5*N/6-2:N*2/3-1]; 
assign a13= (count ==3||count ==2||count ==6||count ==7||count ==9)?p[N*2/3-2:N/2-1]:A_one_init[N*2/3-2:N/2-1];                                  assign a23=A_two_init[N*2/3-2:N/2-1]; 

assign a14= (count ==3||count ==2||count ==6||count ==7||count ==9)?p[N/2-2:N/3]:A_one_init[N/2-2:N/3];                                       assign a24=A_two_init[N/2-2:N/3];
assign a15= (count ==3||count ==2||count ==6||count ==7||count ==9)?p[N/3-1:N/6]:A_one_init[N/3-1:N/6];                                       assign a25=A_two_init[N/3-1:N/6];  
assign a16= (count ==3||count ==2||count ==6||count ==7||count ==9)?p[N/6-1:0]:A_one_init[N/6-1:0];                                           assign a26=A_two_init[N/6-1:0];
/////////////////////////////////////////////////////////////////////////Data distribution_2
 wire [N/6-1:0]chosse_a11=(count ==0||count ==2 ||count ==3||count ==4||count ==7||count ==9)?a11:(count ==1||count ==5)?a21:(count ==6||count ==8)?x[N-3:N*5/6-1]:(count ==10||count==11)?Q[N-3:N*5/6-1]:0;                      
 wire [N/6-1:0]chosse_a12=(count ==0||count ==2 ||count ==3||count ==4||count ==7||count ==9)?a12:(count ==1||count ==5)?a22:(count ==6||count ==8)?x[5*N/6-2:N*2/3-1]:(count ==10||count==11)?Q[5*N/6-2:N*2/3-1]:0;
 wire [N/6-1:0]chosse_a13=(count ==0||count ==2 ||count ==3||count ==4||count ==7||count ==9)?a13:(count ==1||count ==5)?a23:(count ==6||count ==8)?x[N*2/3-2:N/2-1]:(count ==10||count==11)?Q[N*2/3-2:N/2-1]:0;                      
 wire [N/6-1:0]chosse_a14=(count ==0||count ==2 ||count ==3||count ==4||count ==7||count ==9)?a14:(count ==1||count ==5)?a24:(count ==6||count ==8)?x[N/2-2:N/3]:(count ==10||count==11)?Q[N/2-2:N/3]:0;
 wire [N/6-1:0]chosse_a15=(count ==0||count ==2 ||count ==3||count ==4||count ==7||count ==9)?a15:(count ==1||count ==5)?a25:(count ==6||count ==8)?x[N/3-1:N/6]:(count ==10||count==11)?Q[N/3-1:N/6]:0;                      
 wire [N/6-1:0]chosse_a16=(count ==0||count ==2 ||count ==3||count ==4||count ==7||count ==9)?a16:(count ==1||count ==5)?a26:(count ==6||count ==8)?x[N/6-1:0]:(count ==10||count==11)?Q[N/6-1:0]:0;

 wire [N/6-1:0]chosse_b11=(count ==0||count ==4)?B_one_init[N-3:N*5/6-1]:(count ==2||count ==7)?t[219:N*5/6-1]:(count ==1||count ==5)?B_two_init[N-3:N*5/6-1]:(count ==3||count ==9||count ==10||count==11)?f_thr[N-3:N*5/6-1]:(count == 6||count ==8)?out_2_1[N-3:N*5/6-1]:0;                      
 wire [N/6-1:0]chosse_b12=(count ==0||count ==4)?B_one_init[5*N/6-2:N*2/3-1]:(count ==2||count ==7)?t[5*N/6-2:N*2/3-1]:(count ==1||count ==5)?B_two_init[5*N/6-2:N*2/3-1]:(count ==3||count ==9||count ==10||count==11)?f_thr[5*N/6-2:N*2/3-1]:(count == 6||count ==8)?out_2_1[5*N/6-2:N*2/3-1]:0; 
 wire [N/6-1:0]chosse_b13=(count ==0||count ==4)?B_one_init[N*2/3-2:N/2-1]:(count ==2||count ==7)?t[N*2/3-2:N/2-1]:(count ==1||count ==5)?B_two_init[N*2/3-2:N/2-1]:(count ==3||count ==9||count ==10||count==11)?f_thr[N*2/3-2:N/2-1]:(count == 6||count ==8)?out_2_1[N*2/3-2:N/2-1]:0;              
 wire [N/6-1:0]chosse_b14=(count ==0||count ==4)?B_one_init[N/2-2:N/3]:(count ==2||count ==7)?t[N/2-2:N/3]:(count ==1||count ==5)?B_two_init[N/2-2:N/3]:(count ==3||count ==9||count ==10||count==11)?f_thr[N/2-2:N/3]:(count == 6||count ==8)?out_2_1[N/2-2:N/3]:0; 
 wire [N/6-1:0]chosse_b15=(count ==0||count ==4)?B_one_init[N/3-1:N/6]:(count ==2||count ==7)?t[N/3-1:N/6]:(count ==1||count ==5)?B_two_init[N/3-1:N/6]:(count ==3||count ==9||count ==10||count==11)?f_thr[N/3-1:N/6]:(count == 6||count ==8)?out_2_1[N/3-1:N/6]:0;                      
 wire [N/6-1:0]chosse_b16=(count ==0||count ==4)?B_one_init[N/6-1:0]:(count ==2||count ==7)?t[N/6-1:0]:(count ==1||count ==5)?B_two_init[N/6-1:0]:(count ==3||count ==9||count ==10||count==11)?f_thr[N/6-1:0]:(count == 6||count ==8)?out_2_1[N/6-1:0]:0; 

//////////////////////////////multiplication
 normal_multiplication_compute normal_multiplication_compute_0(.multiplicand(multiplicand),.multiplier(multiplier),.product_final(product));
 normal_multiplication_compute normal_multiplication_compute_1(.multiplicand(multiplicand1),.multiplier(multiplier1),.product_final(product1));
 normal_multiplication_compute normal_multiplication_compute_2(.multiplicand(multiplicand2),.multiplier(multiplier2),.product_final(product2));
 normal_multiplication_compute normal_multiplication_compute_3(.multiplicand(multiplicand3),.multiplier(multiplier3),.product_final(product3));
 normal_multiplication_compute normal_multiplication_compute_4(.multiplicand(multiplicand4),.multiplier(multiplier4),.product_final(product4));
 normal_multiplication_compute normal_multiplication_compute_5(.multiplicand(multiplicand5),.multiplier(multiplier5),.product_final(product5));
 normal_multiplication_compute normal_multiplication_compute_6(.multiplicand(multiplicand6),.multiplier(multiplier6),.product_final(product6));
 normal_multiplication_compute normal_multiplication_compute_7(.multiplicand(multiplicand7),.multiplier(multiplier7),.product_final(product7));
 
 normal_multiplication_compute normal_multiplication_compute_8(.multiplicand(multiplicand8),.multiplier(multiplier8),.product_final(product8));
//////////////////////////////////////////////two additions
reg [N-3:0]addend,augend;
wire [N-3:0]sum_final;
add_sub_gen  your_instance_name(
.a_i(addend),
.b_i(augend),
.sub_i(0),
.c_i(0),
.res_o(sum_final),
.c_o(carry)
);

reg [N-3:0]addend1,augend1;
wire [N-3:0]sum_final1;
reg AddSub_2,CarryI_2;
wire carry1;
add_sub_gen  your_instance_name1(
.a_i(addend1),
.b_i(augend1),
.sub_i(AddSub_2),
.c_i(CarryI_2),
.res_o(sum_final1),
.c_o(carry1)
);

/////////////////////////////////////////////////Multiplier call

//mul1
 always@(posedge clk) begin
    begin  multiplicand<=flag?chosse_a11:chosse_a14;
                   multiplier<=flag2?chosse_b11:chosse_b14;  
            end
 end 

//mul2
 always@(posedge clk) begin
     begin  multiplicand1<=flag?chosse_a11:chosse_a14;
                   multiplier1<=flag2?chosse_b12:chosse_b15;  
            end
 end 

//mul3
 always@(posedge clk) begin
     begin  multiplicand2<=flag?chosse_a12:chosse_a15;
                   multiplier2<=flag2?chosse_b11:chosse_b14;  
            end
 end   

//mul4
 always@(posedge clk) begin
      begin  multiplicand3<=flag?chosse_a11:chosse_a14;
                   multiplier3<=flag2?chosse_b13:chosse_b16;  
            end
 end    
 
//mul5
 always@(posedge clk) begin
        begin  multiplicand4<=flag?chosse_a12:chosse_a15;
                   multiplier4<=flag2?chosse_b12:chosse_b15;  
            end
 end    
   
//mul6
 always@(posedge clk) begin
       begin  multiplicand5<=flag?chosse_a13:chosse_a16;
                   multiplier5<=flag2?chosse_b11:chosse_b14;  
            end
 end    
  
//mul7
 always@(posedge clk) begin
       begin  multiplicand6<=flag?chosse_a13:chosse_a16;
                   multiplier6<=flag2?chosse_b12:chosse_b15;  
            end
 end    
 

//mul8
 always@(posedge clk) begin
       begin  multiplicand7<=flag?chosse_a12:chosse_a15;
                   multiplier7<=flag2?chosse_b13:chosse_b16;  
            end
 end   
//mul9
 always@(posedge clk) begin
       begin  multiplicand8<=flag?chosse_a13:chosse_a16;
                   multiplier8<=flag2?chosse_b13:chosse_b16;  
            end
 end  
//////////////////////////////////////////////////////////////////////////
 reg [N/6-1:0]zho1,zho2,zho3,zho4;
 /////////////////////////////////////////////////////////////////////////
 //s
  reg [N/3-1:0]s0,s1,s2,s3,s4,s5,s6,s7,s8; 
 always@(posedge clk) begin
   s0<=product;
   s1<=product1;
   s2<=product2;
   s3<=product3;
   s4<=product4;
   s5<=product5;
   s6<=product6;
   s7<=product7;
   s8<=product8;
 end
//

/////////////////////////////////////////////////////////////////////////zho
 
 always@(posedge clk) 
 begin
       case (cycle1)
          2'b10:zho1<=s8[N/6-1:0];
          2'b11:zho2<=s8[N/6-1:0];
          2'b00:zho3<=s8[N/6-1:0];
          2'b01:zho4<=s8[N/6-1:0];
       endcase
 end
//////////////////////////////////////////////
wire [N/3-1:0]g11,f11,g12,f12;
CSA_N_4_1 CSA1(s6,s7,{37'b0,s8[N/3-1:N/6]},g11,f11);
CSA_N_4_1 CSA2(s3,s4,s5,g12,f12);

wire [N/6:0]co;
wire [N/6-1:0]s;
assign {co,s} = g11+{f11,1'b0};
wire [N/3-1:0]add1_so,add1_d1o;
wire [N/3-1:0]add1_gout,add1_fout;

reg [N/3-1:0]add1_d1,add1_d2,add1_d3;
reg [N/3-1:0]add1_gin,add1_fin;

reg [N/6:0]add1_cin;
reg [N/6-1:0] add1_sin;

add1 addition1(
.d1(add1_d1),      //   input 
.d2(add1_d2),      //   input
.d3(add1_d3),       //  input
.gin(add1_gin),      // input
.fin(add1_fin),      // input
.coin(add1_cin),      // input
.sin(add1_sin),      // input
.d1o(add1_d1o),      // output
.so(add1_so),        // output
.gout(add1_gout),    // output
.fout(add1_fout));   // output
////////////////////////////////////////////////////////add1
always@(posedge clk) begin 
  add1_d1<=s0;add1_d2<=s1;add1_d3<=s2;
  add1_gin<=g12;add1_fin<=f12;
  add1_cin<=co;add1_sin<=s;
end
/////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////add2
reg [N/3-1:0] add2_sin,add2_gin,add2_fin,add2_d1;
wire [5*N/6-1:0] add2_s;

add2 addition2(
.sin(add2_sin), // input
.gin(add2_gin), // input
.fin(add2_fin), // input
.d1(add2_d1),   //input
.s(add2_s)      //output
);   


always@(posedge clk) begin 
  add2_sin<=add1_so; add2_gin<=add1_gout;
  add2_fin<=add1_fout;add2_d1<=add1_d1o;
end
/////////////////////////////////////////////////////////////////////////////
always@(posedge clk)
      begin
       case(cycle)
         2'b00:begin addend<=0;augend <= {add2_s,zho1};end
         2'b01:begin addend<={sum_final[N-3:N/2-1]};augend <= {add2_s,zho2};end
         2'b10:begin addend<=sum_final;augend <= {add2_s,zho3};end
         2'b11:begin addend<={sum_final[N-3:N/2-1]}; augend <= {add2_s,zho4};end
      endcase
end
///////////////////////////////////////////////////////////////////////////_c
reg [435:0]c;
always@(posedge clk)
begin
     case (cycle)
         2'b01:c[N/2-2:0]<=sum_final[N/2-2:0]; 
         2'b11:c[N-3:N/2-1]<=sum_final[N/2-2:0]; 
         2'b00:c[435:N-2]<=sum_final[N-3:0]; 
         default:;
         endcase
end
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
reg [2*N-1:0]t_1; reg flaa,flaa1;reg[1:0]q_flag;reg [1:0]add_1;

wire flag_add3,flag_add2,flag_add1;
assign flag_add3=(c_out_2>={f_thr_3})?1:0;
assign flag_add2=(c_out_2>={{f_thr,1'b0}})?1:0;
assign flag_add1=(c_out_2>={{f_thr}})?1:0;
wire [N-1:0]barr= flag_add3?{f_thr_3,2'b11}:flag_add2?{{f_thr,1'b0},2'b10}:flag_add1?{f_thr,2'b01}:{{(N-2){1'b0}},2'b00};

always@(posedge clk) q_flag<=barr[1:0];
always@(posedge clk) begin 
 case (cycle)
  2'b00:begin  if(count ==6 || count == 0)t_1[2*N-3:K+N]<=sum_final1[3:0];end
  2'b01:;//
  2'b10:begin if(count ==5 || count == 11)t_1[2*N-1:N]<=sum_final1[K-1:0];if(count ==6|| count == 0)t_1<=(t_1>>N) ; end
  2'b11: if(count==10|| count ==1) t_1[N-1:0]<= sum_final1  ;
 endcase
end

///////////////////////////////////////////////////////////////////////////// t_1

always@(posedge clk) begin 
 case (cycle)
  2'b00:if(count ==1||count ==3)  c_out_1<=sum_final1; 
  2'b01:if(count ==10||count ==1 )c_out_1<=sum_final1;
  2'b10:;
  2'b11:  ;
 endcase
end
reg [219:0]c_out_2_1;
always@(posedge clk)begin
  if((count ==0 &&cycle1 == 3)||(count ==11 &&cycle1 == 3))c_out_2_1<={sum_final[109:0],c[N/2-2:0]};
  if(cycle1==1&&(count ==0||count ==2)) c_out_2<=sum_final1;
  if(cycle1==3&&(count ==0||count ==2)) c_out_2<=sum_final1;
end
///////////////////////////////////////////////////////////////////////////////
reg flag_1,flag_2,add_2;
reg[433:0]c1;
reg[434:0]c2;
reg [N-3:0]out_2,out_1;
reg flag_3,flag_3_1;
always@(posedge clk)
       begin
        case(cycle1)
          2'b00:
                begin 
                   
                    if(count ==3||count ==7)begin addend1<=c[K-1:0];augend1<=c1[K-1:0]; AddSub_2<=1'b0; CarryI_2 <=0;end // c1L+c4L
                    if(count ==4||count ==9)begin addend1<=c[K-1:0];augend1<=out_1[K-1:0]; AddSub_2<=1'b1; CarryI_2 <=1;end // c23L  q
                    if(count ==5||count ==11)begin addend1<=c[K-1:0];augend1<=out_1;     AddSub_2<=1'b0; CarryI_2 <=0;end // c5L+c23L+c1H  q
                    if(count ==0||count==2) begin addend1<=t_1[N-3:0];augend1<=c_out_2_1; AddSub_2<=1'b1; CarryI_2 <=1;end      //3 //jieshu_3
                    if(count ==10||count ==1) begin addend1<=Q;augend1<=out_1_1;           AddSub_2<=1'b0; CarryI_2 <=0;end    //1 wanzheng q 
                end
          2'b01:
                begin 
                    if(count ==0||count ==6)begin addend1<=A_one_init;augend1<=A_two_init;   AddSub_2<=1'b0;  CarryI_2 <=0; end //p   
                    if(count ==1)begin addend1<=B_one_init;augend1<=B_two_init; AddSub_2<=1'b0; CarryI_2 <=0;end //p   
                    if(count ==3||count ==7)begin addend1<=c[435:K];augend1<=c1[433:K]; AddSub_2<=1'b0; CarryI_2 <=0;end  //t  c1H+c4H
                    if(count ==4||count ==9)begin addend1<=c[435:K];augend1<=out_2;AddSub_2<=1'b1;      CarryI_2 <=add_2;end     //t  c23H  r
                    if(count ==5||count ==11)begin addend1<=c[435:K];augend1<=out_2;     AddSub_2<=1'b0; CarryI_2 <=0;end  //r  c4L+c23H+c5H
                    
                    //
                    //
                end
          2'b10:begin    
                    if(count ==6)begin addend1<=B_one_init;augend1<=B_two_init; AddSub_2<=1'b0; CarryI_2 <=0;end //p   
                    if(count ==4||count ==9)begin addend1<=c1[433:K];augend1<=c1[K-1:0];   AddSub_2<=1'b0; CarryI_2 <=0;end //  c23L+c1H  q 
                    if(count ==0||count ==2)  begin addend1<=c_out_2 ;augend1<={barr>>2}; AddSub_2<=1'b1; CarryI_2 <=add_1;end   //jieshu_2   
                    if(count==10|| count ==1) begin addend1<=t_1[N-3:0];augend1<=c_out_1[N-3:K]; AddSub_2<=1'b0; CarryI_2 <=0;end //2 t_1 xiuz 
                end
          2'b11:begin
                    if(count ==4||count ==9)begin addend1<=c2[K-1:0];augend1<=out_2;      AddSub_2<=1'b0; CarryI_2 <=0;end      //r c4L+c23H
                     
                    if(count ==5||count ==11)begin addend1<=c2[434:K];augend1<=out_2;      AddSub_2<=1'b0; CarryI_2 <=0;end      //t    c4L+c23H+c5L//+c5H     
                    if(count ==0||count ==2) begin addend1<=q_flag;augend1<=c_out_1[K-1:0]; AddSub_2<=1'b0; CarryI_2 <=0;end           //4 //jieshu_1                    

                end
       endcase
end

always@(posedge clk) begin 
case(cycle1)
2'b00:begin
        if(count ==5||count ==10) out_2<= sum_final1;   
        if(count ==0)begin    add_1<= flaa;end
        if(count == 2) add_1<= flaa1;
       end
2'b01:begin  
        if(count ==2||count ==6) c1<=c;
        if(count ==3||count==7) begin c2<=c; out_1[K-1:0]<= sum_final1[K-1:0]; flag_1<=sum_final1[K]; end if(count ==4) flaa<=carry1;if(count ==9) flaa1<=carry1;
        if(count ==4||count ==9) c1[K-1:0]<= sum_final1[K-1:0];
        if(count ==5)  out_1_1<=sum_final1; 
        if(count ==0)  out_1_1<=p;
      end
2'b10:begin 
        if(count ==3||count ==7) out_2<= sum_final1;    
        if(count ==4||count ==9)  out_2<= sum_final1[N-3:0];    
        if(count ==3||count ==7) add_2<=!flag_1;
        if(count ==5||count ==11) out_2<= sum_final1[N-3:K]; 
        if(count ==4) out_2_1<=c2[434:218];
        if(count ==7) out_2_1<=c2[434:218];        
        if(count ==8) Q<=c[435:217];
      end
2'b11:begin  
        if(count ==4||count ==9) out_1<= sum_final1[K:0];
         
        if(count ==10) Q<=c[435:217];
      end
endcase
end
//////////////////////////////////p t//////////////////////////////////////
always@(posedge clk) begin 
case(cycle)
2'b00:begin   end
2'b01: begin if(count ==11 ) p<= sum_final1; end
2'b10:begin  if(count ==0||count ==6) p<= sum_final1;if(count==1 ) t<= sum_final1;  end
2'b11:begin if(count ==6 ) t<= sum_final1;  if(count==2||count ==7) p<= c1[K-1:0]; end
endcase
end
 
endmodule
