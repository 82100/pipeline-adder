module add_32_pipe_2stage(c_out,sum,a,b,c_in,clock);
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

output [size2 : 0]  sum ;
output              c_out ;

reg [double : 0] IR ;
reg [triple : 0] PR ;
reg [size : 0]   OR ;

assign {c_out , sum } = OR ;

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