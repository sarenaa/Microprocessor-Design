// combinational -- no clock
// sample -- change as desired
module alu(
  input[3:0] alu_cmd,    // ALU instructions 4 bit wide opcode
  input[7:0] inA, inB, acc,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  output logic[7:0] rslt,

  output logic je, //absjump eneable, send to pc.sv
  //              pari,     // reduction XOR (output)
	// 		   zero      // NOR (output)
  output logic sc_o, //shift carr yout
  output logic[7:0] store //store
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  store = 'b00000000; //8bit wide
  // zero = !rslt;
  // pari = ^rslt;
  je = 1; //jumps default. if statements are for not jump
  case(alu_cmd)
    4'b0000: rslt = acc; //LOAD pass in address. 
	  4'b0001: begin //STORE
    rslt = acc; //set addresss input
    store = inA; //set data output
    end
    4'b0010: rslt = inA ^ acc; //XOR. 
    //inA general purpose . inB 0-3. accumulator
    4'b0011: begin   //COUNT1s 
    rslt = inA[0] + inA[1] + inA[2] + inA[3] + inA[4] + inA[5] + inA[6] + inA[7]; //add until inA = 7
    end
    4'b0100:  {sc_o,rslt} = inA + acc + sc_i;// ADD 2 8-bit unsigned; automatically makes carry-out
   
	  4'b0101: rslt = inA;    //mov1. setting result = to something . acc or inA
    
    4'b0110:  rslt = acc;//mov2 . overwrite register
   
	  // 4'b1000: begin
    // //JLT
    // if(inA <  inB) begin //inB using it on jump only. only time there's 2 register input
    //   je = 1; //should i 0 or 1
    // end //actuall jump in PC. alu compare only
    // end
    // 4'b1001: begin
    // //JLE
    // if(inA <=  inB) begin //inB using it on jump only. only time there's 2 register input
    //   je = 1;
    // end //compare. 
    // end
    // 4'b1010: begin
    // //JGE. prob dont need
    // if(inA >=  inB) begin //inB using it on jump only. only time there's 2 register input
    //   je = 1;
    // end
    // end


  endcase
end
   
endmodule