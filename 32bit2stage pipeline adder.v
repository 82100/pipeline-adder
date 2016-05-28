//16 bits 2stage pipelined adder
module test(c_out,sw,clock,seg7_1,seg7_2,seg7_3,seg7_4,seg7_5,seg7_6,seg7_7,seg7_8);
	parameter size = 32;
	parameter half = size/2; 		// half = 16
	parameter double = 2*size; 		//double = 64
	parameter triple = 3*half; 		//triple = 48
	parameter size1 = half-1; 		//size1 = 15
	parameter size2 = size-1; 		//size2 = 31
	parameter size3 = half+1; 		//size3 = 17
	parameter r1 = 1; 
	parameter l1 = half; 			//l1 = 16
	parameter r2 = size3; 			//r2 = 17
	parameter l2 = size; 			//l2 = 32
	parameter r3 = size+ 1; 		//r3 = 33
	parameter l3 = size + half; 	//l3 = 48
	parameter r4 = double - half +1;//r4 = 49
	parameter l4 = double; 			//l4 = 64

	input  [1 : 0]		sw;
	input  clk;
	output [6 : 0]  	seg7_1,seg7_2,seg7_3,seg7_4,seg7_5,seg7_6,seg7_7,seg7_8 ;
	output c_out;

	reg [double: 0] ir; 			//reg ir [64:0] //input register
	reg [triple: 0] pr; 			//reg pr [48:0] //pipeline register
	reg [size: 0] OR; 				//reg OR [32:0] //ouput register
	reg [size2 : 0 ] a,b;
	reg c_in ;

	always @(sw)
	begin
		case(sw)
			2'b00: 
			begin 
				a = 32'h0081001a ; 
				b = 32'h0410405e ;
				c_in = 0;
			end
			2'b01: 
			begin
				a = 32'h1001011a ; 
				b = 32'h0802045e ;
				c_in = 1;
			end
			2'b10: 
			begin
				a = 32'h420100d5 ; 
				b = 32'h01008021 ;
				c_in = 1;
			end
			2'b11: 
			begin
				a = 32'hc410021d ; 
				b = 32'hc2084007 ;
				c_in = 0;
			end
		endcase
	end

	assign c_out = OR[size] ;
	HexDigit (seg7_1,OR[3:0]);
	HexDigit (seg7_2,OR[7:4]);
	HexDigit (seg7_3,OR[11:8]);
	HexDigit (seg7_4,OR[15:12]);
	HexDigit (seg7_5,OR[19:16]);
	HexDigit (seg7_6,OR[23:20]);
	HexDigit (seg7_7,OR[27:24]);
	HexDigit (seg7_8,OR[31:28]);

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


module HexDigit(segs, num);
	input [7:0] num	;		//the hex digit to be displayed
	output [6:0] segs ;		//actual LED segments
	reg [6:0] segs ;
	always @ (num)
	begin
		case (num)
				4'h0: segs = 7'b1000000;
				4'h1: segs = 7'b1111001;
				4'h2: segs = 7'b0100100;
				4'h3: segs = 7'b0110000;
				4'h4: segs = 7'b0011001;
				4'h5: segs = 7'b0010010;
				4'h6: segs = 7'b0000010;
				4'h7: segs = 7'b1111000;
				4'h8: segs = 7'b0000000;
				4'h9: segs = 7'b0010000;
				4'ha: segs = 7'b0001000;
				4'hb: segs = 7'b0000011;
				4'hc: segs = 7'b1000110;
				4'hd: segs = 7'b0100001;
				4'he: segs = 7'b0000110;
				4'hf: segs = 7'b0001110;
				default segs = 7'b1111111;
		endcase
	end
endmodule
