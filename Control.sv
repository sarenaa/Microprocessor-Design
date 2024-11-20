// control decoder
module Control #(parameter opwidth = 3, mcodebits = 9)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need). 
  //input port for values to compare. from reg file.
  input[7:0] compareA, compareB, //3,2
  input clk,
  output logic RegDst, Branch, isMov1, isMov2,
     MemtoReg, MemWrite, ALUSrc, RegWrite, AccWrite, //write acc
    output logic[3:0] rd_A, rd_B, //16 reg 2^4.
    output logic [4:0] addr, //5 bit wide

  output logic[opwidth:0] ALUOp);	   // for up to 8 ALU operations. was opwidth-1
	 //flag, compare, jump if flag=1. pcwriteenable=1, send addr into lut
  logic[2:0] compareflag; //3 bit wide

always_comb begin
// defaults
  addr = instr[4:0];
  RegDst 	=   'b0;   // 1: not in place  just leave 0
  Branch 	=   'b0;   // 1: branch (jump)                                              need
  MemWrite  =	'b0;   // 1: store to memory                                            need
  ALUSrc 	=	'b0;   // 1: immediate  0: second reg file output
  AccWrite = 'b1; //0: dont write to acc???
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations               need
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in    need
  ALUOp	    =   instr[8:5]; // y = a+0;                                                    need
  //or rd_A = 0; // general register. ex: add. mov to
  rd_A = instr[8:5]; //to do: set rd_A default = 1st 4 bits. NOT the jmps. 
  //confused is rd_A a data or address
  rd_B = 0; //read 2 register only jumps
  isMov1 = 0;
  isMov2 = 0;
// sample values only -- use what you need
case(instr[8:5])    // override defaults with exceptions
  'b0000:  begin					// load
        MemWrite = 'b0;      //dont write to memory
        ALUOp = 'b0000; //do i need set variables not changing
        MemtoReg = 'b1;
			 end
       
  'b0001: begin //store
        MemWrite = 'b1;      // write to data mem
        RegWrite = 'b0;      // typically don't also load reg_file
        ALUOp = 'b0001;
  end 

  'b0010 : begin //xor
    if(instr[4] ==  0) begin 
      rd_A = 1;
      rd_B = 3 ;
    end
    else begin 
      rd_A = 2;
      rd_B = 4;
    end
  end

  'b0101: begin //mov1 
    AccWrite = 'b1; //move stuff to acc
    rd_A = instr[4:1]; //should be specific register not r0 only
    isMov1 = 1;
  end
  'b0110: begin //mov2. move stuff out of acc 
    AccWrite = 'b0;
    rd_A = instr[4:1]; //should be specific register not r0 only
    isMov2 = 1;
  end

'b1000: begin
    //JLT. 3 things
    Branch = compareflag[2];
    RegWrite = 'b0; //dont write to reg
    ALUOp = 1000;
    // addr = instr[4:0];
    end

'b1001: begin //JEQ
    Branch = compareflag[1];
    RegWrite = 'b0; //dont write to reg
    ALUOp = 1001;
    // addr = instr[4:0];
end

'b1010: begin //JGT
    Branch = compareflag[0];
    RegWrite = 'b0; //dont write to reg
    ALUOp = 1010;
    // addr = instr[4:0];
end

'b1011: begin //compare
  rd_A = instr[4:2];
  rd_B = instr[1:0];
  RegWrite = 'b0;
end
//took out instruction whwere only opcode changes. instr took care of it.
endcase
end

//compare
always@(posedge clk) begin 
  if(instr[8:5] == 'b1011 ) begin
    compareflag[2] <= (compareA < compareB);
    compareflag[1] <= (compareA == compareB);
    compareflag[0] <= (compareA > compareB); //fix if syntax
end

end
	
endmodule