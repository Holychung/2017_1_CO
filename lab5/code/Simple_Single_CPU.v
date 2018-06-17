// 鍾禾翊 0516205 石孟杰 0516228
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
wire reg_write, alu_src, branch, alu_zero, branch_sel;

wire mem_read, mem_write, mux_alu_branch_type_result, mux_branch_or_pcadd4_select;
wire [31:0] dm_result, write_back_data, mux_branch_or_pcadd4_result, jump_addr;
wire [1:0] jump, mem_to_reg, branch_type, reg_dst;

assign {op, rs, rt, rd, shamt, funct} = instr_data;
assign immdt = instr_data[15:0];
assign branch_sel = alu_zero & branch;
assign jump_addr = { pc_plus4[31:28], instr_data[25:0], 2'b00 };

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

MUX_4to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(rt),
        .data1_i(rd),
        .data2_i(5'd31),
        .data3_i(5'd0),
        .select_i(reg_dst),
        .data_o(rd_addr)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(rs) ,  
        .RTaddr_i(rt) ,  
        .RDaddr_i(rd_addr) ,  
        .RDdata_i(write_back_data), 
        .RegWrite_i (reg_write),
        .RSdata_o(rs_result) ,  
        .RTdata_o(rt_result)   
        );
	
Decoder Decoder(
        .instr_op_i(op), 
        .instr_func_i(funct),
	    .RegWrite_o(reg_write), 
	    .ALU_op_o(alu_op),   
	    .ALUSrc_o(alu_src),   
	    .RegDst_o(reg_dst),
        .Branch_o(branch),
        .Jump_o(jump),
        .MemToReg_o(mem_to_reg),
        .MemRead_o(mem_read),
        .MemWrite_o(mem_write),
        .BranchType_o(branch_type)
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
        .pc_plus4(pc_plus4),
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
		
MUX_4to1 #(.size(32)) Mux_PC_Source(
        .data0_i(jump_addr),
        .data1_i(mux_branch_or_pcadd4_result),
        .data2_i(rs_result),
        .data3_i(32'd0),
        .select_i(jump),
        .data_o(pc_after)
        );	

Data_Memory Data_Memory(
        .clk_i(clk_i),
        .addr_i(alu_result),
        .data_i(rt_result),
        .MemRead_i(mem_read),
        .MemWrite_i(mem_write),
        .data_o(dm_result)
        );

MUX_4to1 #(.size(32)) Mux_WriteBack(
        .data0_i(alu_result),
        .data1_i(dm_result),
        .data2_i(sign_extended),
        .data3_i(32'b0),
        .select_i(mem_to_reg),
        .data_o(write_back_data)
        );      

MUX_2to1 #(.size(32)) Mux_Branch_or_PCAdd4(
        .data0_i(pc_plus4),
        .data1_i(adder2_result),
        .select_i(mux_branch_or_pcadd4_select),
        .data_o(mux_branch_or_pcadd4_result)
        );      

MUX_4to1 #(.size(1)) Mux_ALU_Branch_type(
        .data0_i(alu_zero),
        .data1_i(alu_zero | alu_result[31]),
        .data2_i(alu_result[31]),
        .data3_i(!alu_zero),
        .select_i(branch_type),
        .data_o(mux_alu_branch_type_result)
        );      

and     G1(mux_branch_or_pcadd4_select, branch, mux_alu_branch_type_result);


endmodule
		  


