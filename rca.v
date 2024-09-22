module fulladder(a,b,c,s,carry);
input a,b,c;
output s,carry;
assign s=a^b^c;
assign carry=(a&b)|(b&c)|(c&a);
//$display ("a=%b b=%b s=%b c=%b",a,b,s,c);endmodule

modeule rca(rca_a,rca_b,rca_cin,rcasum,cout);
input [3:0]rca_a;
input [3:0]rca_b;
input rca_cin;
output [3:0]rca_sum;
wire [3:0]c;
fulladder(rca_a[0],rca_b[0],rca_cin,rcasum[0],c[0]);
fulladder(rca_a[1],rca_b[1],c[0],rcasum[1],c[1]);
fulladder(rca_a[2],rca_b[2],c[1],rcasum[2],c[2]);
fulladder(rca_a[3],rca_b[3],c[2],rcasum[3],c[3]);

endmodule



