//16 bits 2stage pipelined adder
module test(c_out,sum,a,b,c_in,clk);
parameter size = 16;
parameter half = size/2; 		// half = 8
parameter double = 2*size; 		//double = 32
parameter triple = 3*half; 		//triple = 24
parameter size1 = half-1; 		//size1 = 7
parameter size2 = size-1; 		//size2 = 15
parameter size3 = half+1; 		//size3 = 9
parameter r1 = 1; 
parameter l1 = half; 			//l1 = 8
parameter r2 = size3; 			//r2 = 9
parameter l2 = size; 			//l2 = 16
parameter r3 = size+ 1; 		//r3 = 17
parameter l3 = size + half; 	//l3 = 24
parameter r4 = double - half +1;//r4 = 25
parameter l4 = double; 			//l4 = 32

input [size2: 0] a,b; 			//input a,b [15:0]
input c_in, clk;
output [size2: 0] sum; 			//ouput sum [15:0]
output c_out;

reg [double: 0] ir; 			//reg ir [32:0] //input register
reg [triple: 0] pr; 			//reg pr [24:0] //pipeline register
reg [size: 0] OR; 				//reg OR [16:0] //ouput register

assign{c_out, sum} = OR;
always@(posedge clk)
begin
	//load input register
	ir[0] <= c_in;
	ir[l1:r1] <= a[size1: 0];
	ir[l2:r2] <= b[size1: 0];
	ir[l3:r3] <= a[size2: half];
	ir[l4:r4] <= b[size2: half];
	
	//load pipeline register
	pr[l3:r3] <= ir[l4:r4];
	pr[l2:r2] <= ir[l3:r3];
	pr[half:0] <= ir[l2:r2] + ir[l1:r1] +ir[0];

	//load output register
	OR <= {{1'b0,pr[l3:r3]} + {1'b0,pr[l2:r2]} + pr[half] , pr[size1:0]};
end
endmodule