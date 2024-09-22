module ram(data_out,data_in,wr,addr,cs);
parameter adder_size=10,word_size=8,memory_size=1023;
input [adder_size-1:0] addr;
input [word_size-1:0] data_in;
input wr,cs;
output reg [word_size-1:0] data_out;
reg [word_size-1:0] mem [memory_size-1:0];

//assign data_out=mem[addr];
always @(wr or cs or addr or data_in)
begin
	if(wr)begin
	mem[addr]=data_in;
end
	assign data_out = mem[addr];
	//if(wr)   mem[addr]=data_in;
end
endmodule


module ram_test;
reg [9:0]address;
wire[7:0]data_out;
reg [7:0]data_in;
reg write,select,read;
integer k,myseed;


ram RAM(data_out,data_in,write,address,select);
initial begin
	   for(k=0;k<=1023;k=k+1)
		begin
		   data_in=(k+k)%254;read=0;write=1;select=1;
		   #02 address = k; write=0;select =0;
		end
		repeat (20)
			begin
			#02 address= $random(myseed)%1024;
			write =0;select=1;
			$display("address:  %5d,data: %4d",address,data_out);

end
end
//#100 $finish
initial myseed=35;
endmodule
