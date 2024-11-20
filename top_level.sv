// sample top level design
module DUT(
  input        clk, start, req, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 4;             		  // ALU command bit width
  wire[D-1:0] target, 			 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   dm_out, rslt, datA,datB, compareA, compareB, acc, store;		  // from RegFile. put acc here

 wire[4:0]    muxA; //decide write to general reg or acc
              // muxB;             
              
  logic sc_in,  je, isMov1, isMov2,				  // shift/carry out from/to ALU
   	              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  //wire  relj;                     // from control to PC; relative jump enable
  logic[3:0] rd_A; //WIDTH ISSUE
  logic[3:0] rd_B; //only 2 bits wide. only use during jump. was [1:0]
  logic sc_clr,
		sc_en,
        MemWrite,
        ALUSrc,		              // immediate switch. 
        immed,
        AccWrite; //signal write to acc
  logic [7:0] reg_in;
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[3:0] rd_addrA, rd_addrB;    // address pointers to reg_file
  wire[4:0] addr; //5 bit wide 
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset(start)    ,
         .clk              ,
		// .reljump_en (relj),
		 .absjump_en (absj),
		 .target           ,
		 .prog_ctr          );  

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

// control decoder
  Control ctl1(.instr(mach_code),
  .clk,
  .RegDst  (), //unused
  .Branch  (absj)  ,                                                                                        
  .MemWrite , 
  .ALUSrc   , 
  .RegWrite   ,     
  .MemtoReg(MemtoReg), 
  .rd_A,
  .rd_B(rd_B),
  .ALUOp(alu_cmd),
  .compareA(compareA),
  .compareB(compareB),
  .AccWrite(AccWrite), //yes
  .addr(addr),
  .isMov1(isMov1),
  .isMov2(isMov2)
  );

logic[3:0] opcode;
always_comb begin 
  if(MemtoReg) reg_in = dm_out; //load, move , alu
  else if(isMov1) reg_in = datA; //datA is specified register
  else if (isMov2) reg_in = acc; //mov stuff out of 
  else reg_in = rslt;
end


//expected 9, found 7???
  reg_file #(.pw(4)) rf1(.dat_in(reg_in),	   // loads, most ops
              .clk         ,
              // .start(start),//??
              // .req(req),//??
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_A), // ???
              .wr_addr (muxA),      // not rd_b. write to ADDRESS of acc or general register. decide by mux
              .datA_out(datA),
              .datB_out(datB),
              .acc(acc)); 

//2. write to acc or general  3. make signal
  assign muxA = AccWrite? 16 : rd_A; 
  //to do: only read, dont write on mov
 // assign muxB = ALUSrc? immed : datB;

  alu alu1(.alu_cmd(alu_cmd),
         .inA    (datA), //what is datA???
         .acc (acc), //.acc the data from acc (8bit)
		 .inB    (datB),
		 .sc_i   (sc),   // output from sc register
		 .rslt       ,
		 .sc_o   (sc_o), // input to sc register
     .je(je), //added
     .store(store) //added
  );  

  dat_mem dm(.dat_in(datB)  ,  // from reg_file
             .clk           ,
			 .wr_en  (MemWrite), // stores
			 .addr   (datA),
             .dat_out(dm_out)); //register or data mem for load store

// registered flags from ALU
  always_ff @(posedge clk) begin
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr == 128; //length of program
 
endmodule