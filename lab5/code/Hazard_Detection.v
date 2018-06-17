// 鍾禾翊 0516205 石孟杰 0516228
// CO project 5 - Hazard Detection
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Hazard_Detection(
	EX_Mem_Read,
	EX_rt,
	ID_rs,
	ID_rt,
	MEM_Branch,
	PC_Write,
	IF_ID_Write,
	IF_Flush,
	ID_Flush,
	EX_Flush
);

input EX_Mem_Read;
input [4:0]	EX_rt;
input [4:0]	ID_rs;
input [4:0]	ID_rt;
input MEM_Branch;

output PC_Write;
output IF_ID_Write;
output IF_Flush;
output ID_Flush;
output EX_Flush;

reg PC_Write;
reg IF_ID_Write;
reg IF_Flush;
reg ID_Flush;
reg EX_Flush;

wire stall;

assign stall = ( EX_Mem_Read & ( (EX_rt == ID_rs) || (EX_rt == ID_rt) ) ) == 1;

always@(*)begin
	// stall  
 	if( stall ) begin
		IF_Flush <= 1'b0;
		ID_Flush <= 1'b1;
		EX_Flush <= 1'b0;
    	PC_Write <= 1'b0;
		IF_ID_Write <= 1'b0; 
    end
 	else begin
 		IF_Flush <= 1'b0;
		ID_Flush <= 1'b0;
		EX_Flush <= 1'b0;
    	PC_Write <= 1'b1;
		IF_ID_Write <= 1'b1;
 	end

 	// branch predict fail
	if( MEM_Branch ) begin 
 		IF_Flush <= 1'b1;
		ID_Flush <= 1'b1;
		EX_Flush <= 1'b1;
    	PC_Write <= 1'b1;
		IF_ID_Write <= 1'b1;		 
	end
end

endmodule 