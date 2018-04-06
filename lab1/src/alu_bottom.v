//0516205,0516228
`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_bottom 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module alu_bottom(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
	       cout,
	       set,
	       overflow
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output	      cout;
output        set;
output reg    overflow;

wire	      fa_sum, cout_temp;

reg           src1_temp, src2_temp, result;

full_adder FA(fa_sum, cout_temp, src1_temp, src2_temp, cin);
assign set = fa_sum;
assign cout = ( (operation == 2'b10) || (operation == 2'b11) ) ? cout_temp : 1'b0;

always@(*) begin
	src1_temp = ((src1) & (~A_invert)) | ((~src1) & (A_invert));
	src2_temp = ((src2) & (~B_invert)) | ((~src2) & (B_invert));
	
	case(operation)
		2'b00: result <= src1_temp & src2_temp;
		2'b01: result <= src1_temp | src2_temp;
		2'b10: result <= fa_sum;
		2'b11: result <= 1'b0;
	endcase
end

//overflow detection
always@(*)begin
    if( operation == 2'b10 || operation == 2'b11)begin
        case( {src1, src2, fa_sum, B_invert} )
            4'b0010: overflow <= 1'b1;
            4'b0111: overflow <= 1'b1;
            4'b1100: overflow <= 1'b1;
            4'b1001: overflow <= 1'b1;
            default: overflow <= 1'b0;
        endcase
    end
    else 
        overflow <= 1'b0;
end
     
endmodule 