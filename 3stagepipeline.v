module threestagepipeline(A,B,C,D,F,clk);
parameter N=10;

input [N-1:0] A,B,C,D;
input clk;
output [N-1:0]F;
reg [N-1:0] L12_x1,L12_x2,L12_D,L23_D,L23_x3,L34_F;

assign F=L23_x3;

always @(posedge clk)

begin
 	L12_x1 <= #4 A+B;
	L12_x2 <= #4 C-D;
	L12_D <= D;
end   ///stage 1

always @(posedge clk)

begin
	L23_x3 <=#4 L12_x1+L12_x2;
	L23_D <=L12_D;
end///stage 2

always @(posedge clk)
begin
	L34_F<=#6 L23_x3*L23_D;
end///stage 3

endmodule



module pipeline_tb;
parameter  N=10;
wire [N-1:0]F;
reg [N-1:0]A,B,C,D;
reg clk;
threestagepipeline my_pipeline(A,B,C,D,F,clk);
initial clk=0;
always #10 clk=~clk;
initial begin
#5 A=10;B=15;C=18;D=15;
#25 A=13;B=32;C=30;D=21;

end
initial begin
$monitor("A:%d,B:%d,C:%d,D:%d",A,B,C,D);
$monitor("time:%d,F:%d",$time,F);
#100 $finish;
end
endmodule
