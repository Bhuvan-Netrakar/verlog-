module duel_port_ram(address,data_in,data_out,cs,write,read,reset);
input cs,write,read,reset;
parameter address_size=10,word_size=8,memory_size=1024;
input [word_size-1:0]data_in;
output reg [word_size-1:0]data_out;
reg [word_size-1:0]mem[memory_size-1:0];
integer i;
always@(read or write or address or reset or data_in )
begin
if(reset)
begin
for(i=0;i<memory_size;i=i+1)
begin
mem[i]=0;
data_out=0;
end 
else 
if(cs)
begin 
if(write)
begin 
mem[address]=data_in;
end
else
if(read)
begin 
data_out=mem[address];
end 
end 

module duel_port_ram_tb;
reg cs,read,write,reset;
reg[7:0]data_in;
wire [7:0]data_out;
reg[9:0]address;
integer k,myseed;
duel_port_ram uut(.address(address),.data_in(data_in),.data_out(data_out),.cs(cs),.write(write),.read(read),.reset(reset));
initial begin
myseed =35;
reset=0;
//write to memory
for (k=0;k<1023;k=k+1)
begin
data_in=(k+k);
write=1,read=0;cs=1;
#2 address=k;
#2, write=0;
cs=0;
end 
// read from mem
for (k=0;k<=1023;k=k+1)
begin 
data_out=$random(myseed);
write=0;read=1;cs=1;
#2 address=k;
#2 write =0;
read 0;
$display ("address =%5d,data_out=%4d",address,data_out);
end
endmodule 


