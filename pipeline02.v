module piplineex2(rs1,rs2,rd,func,addr,clk1,clk2,zout);
input [3:0]rs1,rs2,rd,func;
input [7:0]addr;
input clk1,clk2;
output [15:0]zout;

reg[15:0] L12_A,L12_B,L23_Z,L34_Z;
reg [3:0] L12_rd,L12_func,L23_rd;
reg[7:0] L12_addr,L23_addr,L34_addr;

reg [15:0]regbank[0:15];
reg [15:0] mem[0:255];

assign zout=L34_Z;

always @(posedge clk1)
begin
	L12_A <= #02 regbank[rs1];
	L12_B <= #02 regbank[rs2];
	L12_rd <= #02 rd;
	L12_func <= #02 func;
	L12_addr <= #02 addr;
end  ///stage 1(loding a b rd func into regester///

always @(negedge clk2)
begin
case(func)
 
 0:
	L23_Z<= #02 L12_A + L12_B;
 1:
	L23_Z<= #02 L12_A - L12_B;
 2:
	L23_Z<= #02 L12_A * L12_B;
3:
	L23_Z<= #02 L12_A / L12_B;
 4:
	L23_Z<= #02 L12_A & L12_B;
 5:
	L23_Z<= #02 L12_A | L12_B;
 6:
	L23_Z<= #02 L12_A ^ L12_B;
 7:
	L23_Z<= #02 ~L12_A;
 8:
	L23_Z<= #02 ~L12_B;
 9:
	L23_Z<= #02 L12_A >> 1;
 10:
	L23_Z<= #02 L12_A << 1; 
 default:
	L23_Z <=#2 16'hxxxx;
endcase

L23_rd <= #02 L12_rd;
L23_addr <= #02 L12_addr;

end  ////stage 2 ALU operation using case ////

always @(posedge clk1)
 begin
	regbank[L23_rd] <= #02 L23_Z;
	L34_Z <= #02 L23_Z;
	L34_addr <= #02 L23_addr;
end

always@(posedge clk2)
begin
     mem[L34_addr] <= #02 L34_Z;
end
endmodule

//module pipeline02_test;
//wire [15:0] zout;
///reg [3:0] rs1,rs2,rd,func;
//reg [7:0] addr;
//reg clk1,clk2;
//integer k;
//piplineex2 mypipe(rs1,rs2,rd,func,addr,clk1,clk2,zout);
//always #5 clk1=~clk1;
//always #5 clk2=~clk2;
//initial
	//begin
	///clk1 =0;clk2 =0;
	///repeat (20)
	///	begin
///		#05 clk1=1 ;#05 clk1=0;
///		#05 clk2=1; #05 clk2=0;
///		end
//end
///initial
// begin
	///for(k=0;k<=16;k=k+1)
	   //mypipe.regbank[k]=k;
//end
	
//initial
	//begin
	//#5 rs1=5;rs2=4;rd=10;func= 0;addr=125; 
	//#20 rs1=10;rs2=5;rd=14;func= 1;addr=127;//sub
	//#20 rs1=3;rs2=8;rd=12;func= 2;addr=126;//mull
	//#20 rs1=10;rs2=2;rd=16;func= 3;addr=128;//div
	//#20 rs1=1'b01;rs2=1'b01;func=4;addr=129;//and
	//#20 rs1=1'b01;rs2=1'b00;func=5;addr=130;//or
	//#20 rs1=1'b01;rs2=1'b00;func=6;addr=131;//exor
	
//#60 for(k=0;k<131;k=k+1)
 //$display ("mem[%3d]:%3d",k,mypipe.mem[k]);
//end///
//initial
///begin
 
	//$monitor ("time: %3d,f=%3d",$time,zout);
//#300 $finish;
//end
///endmodule



