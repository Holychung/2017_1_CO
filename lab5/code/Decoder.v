// 鍾禾翊 0516205 石孟杰 0516228
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemToReg_o,
	MemRead_o,
	MemWrite_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output		   RegDst_o;
output         Branch_o;
output 		   MemToReg_o; 
output 	  	   MemRead_o;
output         MemWrite_o;  

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    		   RegDst_o;
reg            Branch_o;
reg    		   MemToReg_o; 
reg            MemRead_o;
reg    		   MemWrite_o;  

//Parameter
parameter  ALU_op_Rtype = 3'd0;
parameter  ALU_op_Beq = 3'd1;
parameter  ALU_op_Addi = 3'd2;
parameter  ALU_op_Slti = 3'd3;
parameter  ALU_op_Jump = 3'd4;
parameter  ALU_op_SwLw = 3'd5;

always@(*)begin
	case (instr_op_i)
		6'd0: begin //R type 
				ALU_op_o <= ALU_op_Rtype;
				RegWrite_o <= 1'b1;
				ALUSrc_o <= 1'b0;
				RegDst_o <= 1'b1;
				Branch_o <= 1'b0;
				MemToReg_o <= 1'b1;
				MemRead_o <= 1'b0;
				MemWrite_o <= 1'b0;
		end
		6'd2: begin //jump
			ALU_op_o <= ALU_op_Jump;
			RegWrite_o <= 1'b0;
			ALUSrc_o <= 1'b0;
			RegDst_o <= 1'b0;
			Branch_o <= 1'b0;
			MemToReg_o <= 1'b1;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b0;
		end	
		6'd3: begin	//jal			
			ALU_op_o <= ALU_op_Jump;
			RegWrite_o <= 1'b1;
			ALUSrc_o <= 1'b0;
			RegDst_o <= 1'b0;
			Branch_o <=	1'b0;
			MemToReg_o <= 1'b1;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b0;
		end
		6'd4: begin	//beq			
			ALU_op_o <= ALU_op_Beq;
			RegWrite_o <= 1'b0;
			ALUSrc_o <= 1'b0;
			RegDst_o <= 1'b0;
			Branch_o <= 1'b1;
			MemToReg_o <= 1'b1;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b0;
		end
		6'd8: begin	//addi			
			ALU_op_o <= ALU_op_Addi;
			RegWrite_o <= 1'b1;
			ALUSrc_o <= 1'b1;
			RegDst_o <= 1'b0;
			Branch_o <= 1'b0;
			MemToReg_o <= 1'b1;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b0;
		end
		6'd10: begin //slti			
			ALU_op_o <= ALU_op_Slti;
			RegWrite_o <= 1'b1;
			ALUSrc_o <= 1'b1;
			RegDst_o <= 1'b0;
			Branch_o <= 1'b0;
			MemToReg_o <= 1'b1;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b0;
		end
		6'd35: begin //lw			
			ALU_op_o <= ALU_op_SwLw;
			RegWrite_o <= 1'b1;
			ALUSrc_o <= 1'b1;
			RegDst_o <= 1'b0;
			Branch_o <= 1'b0;
			MemToReg_o <= 1'b0;
			MemRead_o <= 1'b1;
			MemWrite_o <= 1'b0;
		end
		6'd43: begin //sw			
			ALU_op_o <= ALU_op_SwLw;
			RegWrite_o <= 1'b0;
			ALUSrc_o <= 1'b1;
			RegDst_o <= 1'b0;
			Branch_o <= 1'b0;
			MemToReg_o <= 1'b1;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b1;
		end
	endcase
end

//Main function

endmodule