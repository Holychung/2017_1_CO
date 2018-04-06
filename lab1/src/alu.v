`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
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

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
			  //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;
wire		zero_tmp;

wire   [32-1:0] result_tmp;
wire	        overflow_tmp;
wire   [32-1:0] cin_out;
wire		cout_tmp;
wire            set;
wire		cin_first;

assign cin_first = ( (ALU_control == 4'b0110) || (ALU_control == 4'b0111) ) ? 1'b1 : 1'b0;

//              alu_top( src1, src2, less, A_invert, B_invert, cin, operation, result, cout);
alu_top         alu_0(src1[0], src2[0], set, ALU_control[3], ALU_control[2], cin_first, ALU_control[1:0], result_tmp[0], cin_out[0]);

alu_top         alu_1(src1[1], src2[1], 1'b0, ALU_control[3], ALU_control[2], cin_out[0], ALU_control[1:0], result_tmp[1], cin_out[1]);
alu_top         alu_2(src1[2], src2[2], 1'b0, ALU_control[3], ALU_control[2], cin_out[1], ALU_control[1:0], result_tmp[2], cin_out[2]);
alu_top         alu_3(src1[3], src2[3], 1'b0, ALU_control[3], ALU_control[2], cin_out[2], ALU_control[1:0], result_tmp[3], cin_out[3]);
alu_top         alu_4(src1[4], src2[4], 1'b0, ALU_control[3], ALU_control[2], cin_out[3], ALU_control[1:0], result_tmp[4], cin_out[4]);
alu_top         alu_5(src1[5], src2[5], 1'b0, ALU_control[3], ALU_control[2], cin_out[4], ALU_control[1:0], result_tmp[5], cin_out[5]);
alu_top         alu_6(src1[6], src2[6], 1'b0, ALU_control[3], ALU_control[2], cin_out[5], ALU_control[1:0], result_tmp[6], cin_out[6]);
alu_top         alu_7(src1[7], src2[7], 1'b0, ALU_control[3], ALU_control[2], cin_out[6], ALU_control[1:0], result_tmp[7], cin_out[7]);
alu_top         alu_8(src1[8], src2[8], 1'b0, ALU_control[3], ALU_control[2], cin_out[7], ALU_control[1:0], result_tmp[8], cin_out[8]);
alu_top         alu_9(src1[9], src2[9], 1'b0, ALU_control[3], ALU_control[2], cin_out[8], ALU_control[1:0], result_tmp[9], cin_out[9]);
alu_top         alu_10(src1[10], src2[10], 1'b0, ALU_control[3], ALU_control[2], cin_out[9], ALU_control[1:0], result_tmp[10], cin_out[10]);
alu_top         alu_11(src1[11], src2[11], 1'b0, ALU_control[3], ALU_control[2], cin_out[10], ALU_control[1:0], result_tmp[11], cin_out[11]);
alu_top         alu_12(src1[12], src2[12], 1'b0, ALU_control[3], ALU_control[2], cin_out[11], ALU_control[1:0], result_tmp[12], cin_out[12]);
alu_top         alu_13(src1[13], src2[13], 1'b0, ALU_control[3], ALU_control[2], cin_out[12], ALU_control[1:0], result_tmp[13], cin_out[13]);
alu_top         alu_14(src1[14], src2[14], 1'b0, ALU_control[3], ALU_control[2], cin_out[13], ALU_control[1:0], result_tmp[14], cin_out[14]);
alu_top         alu_15(src1[15], src2[15], 1'b0, ALU_control[3], ALU_control[2], cin_out[14], ALU_control[1:0], result_tmp[15], cin_out[15]);
alu_top         alu_16(src1[16], src2[16], 1'b0, ALU_control[3], ALU_control[2], cin_out[15], ALU_control[1:0], result_tmp[16], cin_out[16]);
alu_top         alu_17(src1[17], src2[17], 1'b0, ALU_control[3], ALU_control[2], cin_out[16], ALU_control[1:0], result_tmp[17], cin_out[17]);
alu_top         alu_18(src1[18], src2[18], 1'b0, ALU_control[3], ALU_control[2], cin_out[17], ALU_control[1:0], result_tmp[18], cin_out[18]);
alu_top         alu_19(src1[19], src2[19], 1'b0, ALU_control[3], ALU_control[2], cin_out[18], ALU_control[1:0], result_tmp[19], cin_out[19]);
alu_top         alu_20(src1[20], src2[20], 1'b0, ALU_control[3], ALU_control[2], cin_out[19], ALU_control[1:0], result_tmp[20], cin_out[20]);
alu_top         alu_21(src1[21], src2[21], 1'b0, ALU_control[3], ALU_control[2], cin_out[20], ALU_control[1:0], result_tmp[21], cin_out[21]);
alu_top         alu_22(src1[22], src2[22], 1'b0, ALU_control[3], ALU_control[2], cin_out[21], ALU_control[1:0], result_tmp[22], cin_out[22]);
alu_top         alu_23(src1[23], src2[23], 1'b0, ALU_control[3], ALU_control[2], cin_out[22], ALU_control[1:0], result_tmp[23], cin_out[23]);
alu_top         alu_24(src1[24], src2[24], 1'b0, ALU_control[3], ALU_control[2], cin_out[23], ALU_control[1:0], result_tmp[24], cin_out[24]);
alu_top         alu_25(src1[25], src2[25], 1'b0, ALU_control[3], ALU_control[2], cin_out[24], ALU_control[1:0], result_tmp[25], cin_out[25]);
alu_top         alu_26(src1[26], src2[26], 1'b0, ALU_control[3], ALU_control[2], cin_out[25], ALU_control[1:0], result_tmp[26], cin_out[26]);
alu_top         alu_27(src1[27], src2[27], 1'b0, ALU_control[3], ALU_control[2], cin_out[26], ALU_control[1:0], result_tmp[27], cin_out[27]);
alu_top         alu_28(src1[28], src2[28], 1'b0, ALU_control[3], ALU_control[2], cin_out[27], ALU_control[1:0], result_tmp[28], cin_out[28]);
alu_top         alu_29(src1[29], src2[29], 1'b0, ALU_control[3], ALU_control[2], cin_out[28], ALU_control[1:0], result_tmp[29], cin_out[29]);
alu_top         alu_30(src1[30], src2[30], 1'b0, ALU_control[3], ALU_control[2], cin_out[29], ALU_control[1:0], result_tmp[30], cin_out[30]);
alu_bottom      alu_31(src1[31], src2[31], 1'b0, ALU_control[3], ALU_control[2], cin_out[30], ALU_control[1:0], result_tmp[31], cin_out[31], set, overflow_tmp);


assign cout_tmp = cin_out[31];
assign zero_tmp = (result_tmp == 32'b0) ? 1'b1 : 1'b0;

always@( posedge clk or negedge rst_n ) 
begin
	
	if(!rst_n) begin
	    result    <= 1'b0;
  		zero      <= 1'b0;
		cout      <= 1'b0;
    	overflow  <= 1'b0;
	end
	else begin
		result <= result_tmp;
		zero <= zero_tmp;
		overflow <= overflow_tmp;
		cout <= ( (ALU_control == 4'b0010) || (ALU_control == 4'b0110) ) ? cout_tmp : 1'b0;
	end
end

endmodule 