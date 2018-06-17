`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/*
wire mux_branch_or_pcadd4_select;
wire [31:0]  mux_branch_or_pcadd4_result, jump_addr;
wire [1:0] jump, branch_type ;
*/

/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [31:0] pc_plus4, pc_after, pc_now, instr_data;

/**** ID stage ****/
wire [31:0] rs_result, rt_result, sign_extended, ID_pc_plus4, ID_intr_data;
wire [4:0] rs, rt, rd, shamt, rd_addr;
wire [5:0] op, funct;
wire [15:0] immdt;
wire reg_write;

//control signal



/**** EX stage ****/
wire [31:0] alu_result, shifted, adder2_result, EX_pc_plus4, EX_rs_result, EX_rt_result, EX_sign_extended;
wire [2:0] alu_op, EX_alu_op;
wire alu_zero, alu_src, EX_reg_write, EX_mem_to_reg, EX_branch, EX_mem_read, EX_mem_write, EX_reg_dst, EX_alu_src;
wire [3:0] alu_control;
wire [4:0] EX_rt, EX_rd, EX_write_reg;
wire [31:0] alu_input2;
wire 	    reg_dst;

//control signal


/**** MEM stage ****/
wire mem_read, mem_write, branch, branch_sel, MEM_reg_write, MEM_mem_to_reg, MEM_branch, MEM_mem_read, MEM_mem_write, MEM_alu_zero, MEM_pc_src;
wire [31:0] dm_result, MEM_adder2_result, MEM_alu_result, MEM_rt_result;
wire [4:0]  MEM_write_reg;

//control signal


/**** WB stage ****/
wire [31:0] WB_dm_result, WB_alu_result, WB_write_back_data;
wire 	    mem_to_reg, WB_reg_write, WB_mem_to_reg;
wire [4:0] WB_write_reg;
//control signal



assign {op, rs, rt, rd, shamt, funct} = ID_intr_data;
assign immdt = ID_intr_data[15:0];


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
        .data0_i(pc_plus4),
        .data1_i(MEM_adder2_result),
        .select_i(MEM_pc_src),
        .data_o(pc_after)
);

ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_after),   
	    .pc_out_o(pc_now) 
);

Instruction_Memory IM(
      .addr_i(pc_now),  
	    .instr_o(instr_data)    
);
			
Adder Add_pc(
        .src1_i(pc_now),     
	    .src2_i(32'd4),     
	    .sum_o(pc_plus4)    
);

		
Pipe_Reg #(.size(32)) IF_ID_pc_plus4(       //N is the total length of input/output
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(pc_plus4),
  		.data_o(ID_pc_plus4)
);

Pipe_Reg #(.size(32)) IF_ID_intr_data(       //N is the total length of input/output
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(instr_data),
  		.data_o(ID_intr_data)
);

//Instantiate the components in ID stage
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(ID_intr_data[25:21]) ,  
        .RTaddr_i(ID_intr_data[20:16]),  
        .RDaddr_i(WB_write_reg) ,  
        .RDdata_i(WB_write_back_data), 
        .RegWrite_i (WB_reg_write),
        .RSdata_o(rs_result) ,  
        .RTdata_o(rt_result)   
);

Decoder Control(
		.instr_op_i(ID_intr_data[31:26]),
	    .RegWrite_o(reg_write), 
	    .ALU_op_o(alu_op),   
	    .ALUSrc_o(alu_src),   
	    .RegDst_o(reg_dst),
        .Branch_o(branch),
        .MemToReg_o(mem_to_reg),
        .MemRead_o(mem_read),
        .MemWrite_o(mem_write)
);

Sign_Extend Sign_Extend(
        .data_i(ID_intr_data[15:0]),
        .data_o(sign_extended)
);	


Pipe_Reg #(.size(1)) ID_EX_reg_write(       
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(reg_write),
  		.data_o(EX_reg_write)
);

Pipe_Reg #(.size(1)) ID_EX_mem_to_reg(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(mem_to_reg),
      .data_o(EX_mem_to_reg)
);

Pipe_Reg #(.size(1)) ID_EX_branch(       
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(branch),
  		.data_o(EX_branch)
);

Pipe_Reg #(.size(1)) ID_EX_mem_read(       
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(mem_read),
  		.data_o(EX_mem_read)
);

Pipe_Reg #(.size(1)) ID_EX_mem_write(       
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(mem_write),
  		.data_o(EX_mem_write)
);

Pipe_Reg #(.size(1)) ID_EX_reg_dst(       
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(reg_dst),
  		.data_o(EX_reg_dst)
);

Pipe_Reg #(.size(3)) ID_EX_alu_op(       
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(alu_op),
  		.data_o(EX_alu_op)
);

Pipe_Reg #(.size(1)) ID_EX_alu_src(       
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(alu_src),
  		.data_o(EX_alu_src)
);

Pipe_Reg #(.size(32)) ID_EX_pc_plus4(       //N is the total length of input/output
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(ID_pc_plus4),
  		.data_o(EX_pc_plus4)
);

Pipe_Reg #(.size(32)) ID_EX_rs_result(       //N is the total length of input/output
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(rs_result),
  		.data_o(EX_rs_result)
);

Pipe_Reg #(.size(32)) ID_EX_rt_result(       //N is the total length of input/output
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(rt_result),
  		.data_o(EX_rt_result)
);

Pipe_Reg #(.size(32)) ID_EX_sign_extended(       //N is the total length of input/output
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(sign_extended),
  		.data_o(EX_sign_extended)
);

Pipe_Reg #(.size(5)) ID_EX_rt(       //N is the total length of input/output
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(ID_intr_data[20:16]),
  		.data_o(EX_rt)
);

Pipe_Reg #(.size(5)) ID_EX_rd(       //N is the total length of input/output
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(ID_intr_data[15:11]),
  		.data_o(EX_rd)
);

//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
        .data_i(sign_extended),
        .data_o(shifted)
);

ALU ALU(
        .src1_i(rs_result),
		.src2_i(alu_input2),
        .pc_plus4(pc_plus4),
	    .ctrl_i(alu_control),
	    .result_o(alu_result),
	    .zero_o(alu_zero)
);
		
ALU_Control ALU_Control(
        .funct_i(EX_sign_extended[5:0]),   
        .ALUOp_i(EX_alu_op),   
        .ALUCtrl_o(alu_control) 
);

MUX_2to1 #(.size(32)) Mux1(
	    .data0_i(EX_rt_result),
        .data1_i(EX_sign_extended),
        .select_i(EX_alu_src),
        .data_o(alu_input2)
);
		
MUX_2to1 #(.size(5)) Mux2(
		.data0_i(EX_rt),
        .data1_i(EX_rd),
        .select_i(EX_reg_dst),
        .data_o(EX_write_reg)
);

Adder Add_pc_branch(
	    .src1_i(EX_pc_plus4),     
	    .src2_i(shifted),     
	    .sum_o(adder2_result) 
);



Pipe_Reg #(.size(1)) EX_MEM_reg_write(       
		.clk_i(clk_i),
   		.rst_i(rst_i),
   		.data_i(EX_reg_write),
  		.data_o(MEM_reg_write)
);

Pipe_Reg #(.size(1)) EX_MEM_mem_to_reg(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(EX_mem_to_reg),
      .data_o(MEM_mem_to_reg)
);

Pipe_Reg #(.size(1)) EX_MEM_branch(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(EX_branch),
      .data_o(MEM_branch)
);

Pipe_Reg #(.size(1)) EX_MEM_mem_read(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(EX_mem_read),
      .data_o(MEM_mem_read)
);

Pipe_Reg #(.size(1)) EX_MEM_mem_write(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(EX_mem_write),
      .data_o(MEM_mem_write)
);

Pipe_Reg #(.size(32)) EX_MEM_adder2_result(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(adder2_result),
      .data_o(MEM_adder2_result)
);

Pipe_Reg #(.size(1)) EX_MEM_alu_zero(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(alu_zero),
      .data_o(MEM_alu_zero)
);

Pipe_Reg #(.size(32)) EX_MEM_alu_result(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(alu_result),
      .data_o(MEM_alu_result)
);

Pipe_Reg #(.size(32)) EX_MEM_rt_result(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(EX_rt_result),
      .data_o(MEM_rt_result)
);

Pipe_Reg #(.size(5)) EX_MEM_write_reg(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(EX_write_reg),
      .data_o(MEM_write_reg)
);

//Instantiate the components in MEM stage
Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(MEM_alu_result),
        .data_i(MEM_rt_result),
        .MemRead_i(MEM_mem_read),
        .MemWrite_i(MEM_mem_write),
        .data_o(dm_result)
);

and G1(MEM_pc_src, MEM_branch, MEM_alu_zero);



Pipe_Reg #(.size(1)) MEM_WB_reg_write(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(MEM_reg_write),
      .data_o(WB_reg_write)
);

Pipe_Reg #(.size(1)) MEM_WB_mem_to_reg(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(MEM_mem_to_reg),
      .data_o(WB_mem_to_reg)
);

Pipe_Reg #(.size(32)) MEM_WB_dm_result(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(dm_result),
      .data_o(WB_dm_result)
);

Pipe_Reg #(.size(32)) MEM_WB_alu_result(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(MEM_alu_result),
      .data_o(WB_alu_result)
);

Pipe_Reg #(.size(5)) MEM_WB_write_reg(       
    .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(MEM_write_reg),
      .data_o(WB_write_reg)
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
        .data0_i(WB_dm_result),
        .data1_i(WB_alu_result),
        .select_i(WB_mem_to_reg),
        .data_o(WB_write_back_data)
);

/****************************************
signal assignment
****************************************/

endmodule

