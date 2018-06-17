// 鍾禾翊 0516205 石孟杰 0516228
// CO project 5 - Forwarding Unit
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Forwarding_Unit(
    EX_rs,
    EX_rt,
    MEM_rd,
    WB_rd,
    MEM_Reg_Write,
    WB_Reg_Write,
    Forward_A,
    Forward_B
);

input [4:0]EX_rs;
input [4:0]EX_rt;
input [4:0]MEM_rd;
input [4:0]WB_rd;

input MEM_Reg_Write;
input WB_Reg_Write;

output [1:0] Forward_A;
output [1:0] Forward_B;

reg [1:0] Forward_A;
reg [1:0] Forward_B;


always @(*) begin
    // Forward_A
    // EX hazard
    if( MEM_Reg_Write & ( MEM_rd != 0 ) & ( MEM_rd == EX_rs ) )
        Forward_A = 2'b01;
    // MEM hazard
    else if( WB_Reg_Write & ( WB_rd != 0) & ~( ( MEM_Reg_Write & (MEM_rd!=0 ) ) & MEM_rd == EX_rs ) & ( WB_rd == EX_rs ) )   
        Forward_A = 2'b10;
    else 
        Forward_A = 2'b00;

    // Forward_B
    // EX hazard
    if( MEM_Reg_Write & ( MEM_rd != 0 ) & ( MEM_rd == EX_rt ) )
        Forward_B = 2'b01;
    // MEM hazard
    else if( WB_Reg_Write & ( WB_rd != 0) & ~( ( MEM_Reg_Write & (MEM_rd!=0 ) ) & MEM_rd == EX_rt ) & ( WB_rd == EX_rt ) ) 
        Forward_B = 2'b10;
    else 
        Forward_B = 2'b00;
end

endmodule