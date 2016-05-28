module add_32_pipe(c_out,a,b,c_in,clock,seg7_1,seg7_2,seg7_3,seg7_4,seg7_5,seg7_6,seg7_7,seg7_8);
	parameter size = 32 ;
	parameter half = size/2 ;
	parameter double = 2 * size ;
	parameter triple = 3 * half ;
	parameter size1 = half-1 ;  //15
	parameter size2 = size-1 ;  //31
	parameter size3 = half+1 ;  //17
	parameter R1 = 1 ;          //1
	parameter L1 = half ;
	parameter R2 = size3 ;
	parameter L2 = size ;
	parameter R3 = size + 1 ;
	parameter L3 = size + half ;
	parameter R4 = double - half + 1 ;
	parameter L4 = double ;

	input [size2 : 0]   a,b ;
	input               c_in , clock ;

	output [6 : 0]  	seg7_1,seg7_2,seg7_3,seg7_4,seg7_5,seg7_6,seg7_7,seg7_8 ;
	output              c_out ;

	reg [double : 0] IR ;
	reg [triple : 0] PR ;
	reg [size : 0]   OR ;

	assign c_out = OR[size] ;
	HexDigit (seg7_1,OR[3:0]);
	HexDigit (seg7_2,OR[7:4]);
	HexDigit (seg7_3,OR[11:8]);
	HexDigit (seg7_4,OR[15:12]);
	HexDigit (seg7_5,OR[19:16]);
	HexDigit (seg7_6,OR[23:20]);
	HexDigit (seg7_7,OR[27:24]);
	HexDigit (seg7_8,OR[31:28]);

	always @(posedge clock)
	begin
	    // Load input register

	    IR[0] <= c_in ;

	    IR[L1 : R1] <= a[size1 : 0] ;
	    IR[L2 : R2] <= b[size1 : 0] ;

	    IR[L3 : R3] <= a[size2 : half] ;
	    IR[L4 : R4] <= b[size2 : half] ;
	end

	always @(negedge clock)
	begin
	    // Load pipeline register

	    { PR[half] , PR[size1 : 0] } = IR[L1 : R1] + IR[L2 : R2] + IR[0] ;

	    PR[L2 : R2] <= IR[L3 : R3] ;
	    PR[L3 : R3] <= IR[L4 : R4] ;
	end

	always @(posedge clock)
	begin
	    // Load output register

	    OR[size1 : 0] <= PR[size1 : 0] ;
	    { OR[size] , OR[size2 : half] } = PR[L2 : R2] + PR[L3 : R3] + PR[half];
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