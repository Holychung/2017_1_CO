//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [31:0] pc_after, pc_now, pc_plus4, instr_data, alu_result, rs_result, rt_result, sign_extended, alu_input2, shifted, adder2_result;

wire [2:0] alu_op;
wire [3:0] alu_control;
wire [4:0] rs, rt, rd, shamt, rd_addr;
wire [5:0] op, funct;
wire [15:0] immdt;

wire reg_dst, reg_write, alu_src, branch, alu_zero, branch_sel;

assign {op, rs, rt, rd, shamt, funct} = instr_data;
assign immdt = instr_data[15:0];
assign branch_sel = alu_zero & branch;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_after) ,   
	    .pc_out_o(pc_now) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(pc_now),     
	    .sum_o(pc_plus4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_now),  
	    .instr_o(instr_data)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(rt),
        .data1_i(rd),
        .select_i(reg_dst),
        .data_o(rd_addr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(rs) ,  
        .RTaddr_i(rt) ,  
        .RDaddr_i(rd_addr) ,  
        .RDdata_i(alu_result)  , 
        .RegWrite_i (reg_write),
        .RSdata_o(rs_result) ,  
        .RTdata_o(rt_result)   
        );
	
Decoder Decoder(
        .instr_op_i(op), 
	    .RegWrite_o(reg_write), 
	    .ALU_op_o(alu_op),   
	    .ALUSrc_o(alu_src),   
	    .RegDst_o(reg_dst),   
		.Branch_o(branch)   
	    );

ALU_Ctrl AC(
        .funct_i(funct),   
        .ALUOp_i(alu_op),   
        .ALUCtrl_o(alu_control) 
        );
	
Sign_Extend SE(
        .data_i(immdt),
        .data_o(sign_extended)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rt_result),
        .data1_i(sign_extended),
        .select_i(alu_src),
        .data_o(alu_input2)
        );	
		
ALU ALU(
        .src1_i(rs_result),
	    .src2_i(alu_input2),
	    .ctrl_i(alu_control),
	    .result_o(alu_result),
		.zero_o(alu_zero)
	    );
		
Adder Adder2(
        .src1_i(pc_plus4),     
	    .src2_i(shifted),     
	    .sum_o(adder2_result)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(sign_extended),
        .data_o(shifted)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_plus4),
        .data1_i(adder2_result),
        .select_i(branch_sel),
        .data_o(pc_after)
        );	

endmodule
		  


