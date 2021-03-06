// 鍾禾翊 0516205 石孟杰 0516228
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Control(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
parameter ALU_AND  = 4'd0;
parameter ALU_OR   = 4'd1;
parameter ALU_ADD  = 4'd2;
parameter ALU_SUB  = 4'd6;
parameter ALU_SLT  = 4'd7;
parameter ALU_NOR  = 4'd12;    
parameter ALU_BEQ  = 4'd6;   
parameter ALU_ADDI = 4'd2;
parameter ALU_SLTI = 4'd7;
parameter ALU_JAL = 4'd8;
parameter ALU_MULT = 4'd3;

//Select exact operation
always @(*) begin
	//R-type instrucitons 
    //ALUOp_i == 0
	if(ALUOp_i == 3'b000) begin
		case(funct_i)
			6'd32: ALUCtrl_o <= ALU_ADD;
			6'd34: ALUCtrl_o <= ALU_SUB;
			6'd36: ALUCtrl_o <= ALU_AND;
			6'd37: ALUCtrl_o <= ALU_OR;
			6'd42: ALUCtrl_o <= ALU_SLT;
			6'd24: ALUCtrl_o <= ALU_MULT;
		endcase
	end

	//I-type instrucitons
	else begin
		case(ALUOp_i) 
			3'b001: ALUCtrl_o <= ALU_BEQ;
			3'b010: ALUCtrl_o <= ALU_ADDI;
			3'b011: ALUCtrl_o <= ALU_SLTI;
			3'b100: ALUCtrl_o <= ALU_JAL; // Jump, JAL
			3'b101: ALUCtrl_o <= ALU_ADD; // LW, SW
		endcase
	end
end


endmodule     





                    
                    