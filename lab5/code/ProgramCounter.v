// 鍾禾翊 0516205 石孟杰 0516228
//Subject:     CO project 2 - PC
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ProgramCounter(
    clk_i,
	rst_i,
	pc_write,
	pc_in_i,
	pc_out_o
	);
     
//I/O ports
input clk_i;
input rst_i;
input [32-1:0] pc_in_i;
input pc_write;

output [32-1:0] pc_out_o;
 
//Internal Signals
reg    [32-1:0] pc_out_o;
 
//Parameter

    
//Main function
always @(posedge clk_i) begin
    if(~rst_i)
	    pc_out_o <= 0;
	else
	    pc_out_o <= (pc_write == 1'b1) ? pc_in_i : pc_out_o;
end

endmodule



                    
                    