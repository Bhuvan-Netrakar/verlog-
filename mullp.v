module MUl_datapath(lda,ldb,ldp,cltp,decb,data_in,clk,eqz);
input lda,ldb,ldp,cltp,decb,clk;
input [15:0]data_in;
output eqz;
wire [15:0]x,y,z,bout,bus;

PIPO1 A(x,bus,lda,clk);
PIPO2 P(y,z,ldp,cltp,clk);
CONTR B(Bout,buss,ldb,decb,clk);
ADD AD(z,x,y);
eqz comp(eqz,bout);
endmodule

module PIPO1(dout,din,ld,clk);
input  ld,clk;
input [15:0]din;
output reg [15:0]dout;
//output [15:0]x;

always @(posedge clk)
	if(ld) dout <= din;//////
endmodule 

module ADD (out,in1,in2);
input[15:0]in1,in2;
///input ld,clk;
output reg [15:0]out;
always @(*)
out = in1+in2;
endmodule


module PIPO2(dout,din,ld,clr,clk);
input [15:0]din;
input ld,clr,clk;
output reg [15:0]dout;
always @(posedge clk)
 if(clr) 
	dout<=16'b00;
else if(id) dout<=din;////
endmodule


module eqz(eqz,data);
output eqz;
input [15:0]data;

assign eqz=(data==0);
endmodule

module CNTR(dout,din,ld,dec,clk);
	input [15:0] din;
	input ld,dec,clk;
	output reg [15:0]dout;
	
	always@(posedge clk)
	  if(ld) dout<=din;
	  else if(dec) dout<=dout-1;
endmodule


module controller(lda,ldb,ldp,clrp,decb,done,clk,eqz,start);
	input clk,eqz,start;
	output reg lda,ldb,ldp,clrp,decb,done;
       
	reg[2:0]state;
	parameter s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011;
	

	always@(posedge clk)
	begin
	    case(state)
		s0: 
		    if(start) state <=s1;
		s1:
		   state<=s2;
		s2:
		   state <=s3;
		s3:
		  state <= #2 if(eqz) state<=s4;/////
			//else if state<=s3;
		s4:
		  state <= s4;
		default :state<=s0;
endcase
end
always @(state)
	begin
	  case(state)
	     s0: begin #1 lda=0;ldb=0;ldp=0;clrp=0;dec=0;end
	     s1: begin #1 lda=0;end
	     s2: begin #1 lda=0;ldb=1;ldp=1;end
	     s3: begin #1 lda=0;ldb=0;ldp=1;clrp=1;end
	     s4: begin #1 done=1;ldb=0;ldp=0;decb=0;end
	     default: begin #1 lda=0;ldb=0;ldp=0;clrp=0;decb=0;end
endcase
end
endmodule

module MUL_test;
reg [15:0] data_in;
reg clk,start;
wire done;
MUl_datapath dp(eqz,ldA,ldB,ldP,crtP,decB,data_in,clk);
controller CON(ldA,ldB,ldP,clrP,decB,done,clk,eqz,start);
initial 
	begin
	    clk=1'b0;
	    #3 start= 1'b0;
	    #500 $finish;
	end
always #5 clk=~clk;
 
initial begin
	#17 data_in=17;
	#10 data_in=5;
end

initial begin
$monitor($time,"%d,%b",dp.Y,done);
end 
endmodule



