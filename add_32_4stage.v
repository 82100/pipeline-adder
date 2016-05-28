module add_32_4stage(c_out,sum,a,b,c_in,clock);
parameter size = 32 ;
parameter half = size / 2 ;         //16

parameter shalf = half / 2 ;        //8
parameter thalf = shalf + half ;    //24

parameter double = 2 * size ;       //64
parameter triple = 3 * half ;       //48
parameter size1 = shalf - 1 ;       //7
parameter size2 = half - 1 ;        //15
parameter size3 = half + size1 ;    //23
parameter size4 = size - 1 ;        //31
parameter size5 = shalf + 1 ;       //9
parameter R1 = 1 ;                  //1
parameter L1 = shalf ;              //8
parameter R2 = size5 ;              //9
parameter L2 = half ;               //16
parameter R3 = size5 + shalf ;      //17
parameter L3 = thalf ;              //24
parameter R4 = size - shalf + 1 ;   //25
parameter L4 = size ;               //32
parameter R5 = 2 * half + 1 ;       //33
parameter L5 = size + shalf ;       //40
parameter R6 = size + shalf + 1 ;   //41
parameter L6 = size + half ;        //48
parameter R7 = size + half + 1 ;    //49
parameter L7 = double - shalf;      //56
parameter R8 = double - shalf + 1 ; //57
parameter L8 = double ;             //64

input [size4 : 0]   a,b ;
input               c_in , clock ;

output [size4 : 0]  sum ;
output              c_out ;

reg [L8 : 0] IR ;
reg [L7 : 0] FR ;
reg [L6 : 0] SR ;
reg [L5 : 0] TR ;
reg [L4 : 0] OR ;

assign {c_out , sum } = OR ;

always @(posedge clock)
begin
    // Load Input register

    IR[0] <= c_in ;

    IR[L1 : R1] <= a[size1 : 0 ] ;
    IR[L2 : R2] <= b[size1 : 0 ] ;

    IR[L3 : R3] <= a[size2 : shalf] ;
    IR[L4 : R4] <= b[size2 : shalf] ;

    IR[L5 : R5] <= a[size3 : half] ;
    IR[L6 : R6] <= b[size3 : half] ;

    IR[L7 : R7] <= a[size4 :thalf ] ;
    IR[L8 : R8] <= b[size4 :thalf ] ;
end

always @(negedge clock)
begin
    // Load First register

    { FR[shalf] , FR[size1 : 0 ] } = IR[L1 : R1] + IR[L2 : R2] + IR[0] ;

    FR[L2 : R2] <= IR[L3 : R3] ;
    FR[L3 : R3] <= IR[L4 : R4] ;

    FR[L4 : R4] <= IR[L5 : R5] ;
    FR[L5 : R5] <= IR[L6 : R6] ;

    FR[L6 : R6] <= IR[L7 : R7] ;
    FR[L7 : R7] <= IR[L8 : R8] ;
end

always @(posedge clock)
begin
    // Load Second register

    SR[size1 : 0 ] <= FR[size1 : 0 ] ;

    { SR[half] , SR[size2 : shalf] } = FR[L2: R2] + FR[L3 : R3] + FR[shalf] ;

    SR[ 24:17 ] <= FR[L4 : R4] ;
    SR[ 32:25 ] <= FR[L5 : R5] ;

    SR[ 40:33 ] <= FR[L6 : R6] ;
    SR[ 48:41 ] <= FR[L7 : R7] ;
end

always @(negedge clock)
begin
    // Load Third register

    TR[size1 : 0 ] <= SR[size1 : 0 ] ;
    TR[size2 : shalf] <= SR[size2 : shalf] ;

    { TR[thalf] , TR[size3 : half] } = SR[L3 : R3] + SR[L4 : R4] + SR[half] ;

    TR[ 32:25 ] <= SR[L5 : R5] ;
    TR[ 40:33 ] <= SR[L6 : R6] ;
end

always @(posedge clock)
begin
    // Load output register

    OR[size1 : 0 ] <= TR[size1 : 0 ] ;
    OR[size2 : shalf] <= TR[size2 : shalf] ;
    OR[size3 : half] <= TR[size3 : half] ;

    { OR[size] , OR[size4 : thalf] } = TR[L4 : R4] + TR[L5 : R5] + TR[thalf] ;
end

endmodule 