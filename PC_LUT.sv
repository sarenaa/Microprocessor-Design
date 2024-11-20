module PC_LUT #(parameter D=12)( //this file unsused
  input       [ 4:0] addr,	   // target 4 values 5 bit wide
  output logic[D-1:0] target);

  always_comb case(addr) //las t5 bits
    0: target = 21;   // absolute jump. or in assembler lut.txt
	1: target = 20;   // go ahead 20 spaces
	2: target = '1;   // go back 1 space   1111_1111_1111. 
	//not using relative branch.
	//write target base on where to jump. abs jump: put address.

	default: target = 'b0;  // hold PC 

  endcase
//make sure each instruction work in machinecode.txt pretest.
// finish compile .sv, convert p1 to asembly, do assembly.
//debug. after quartus do modelsim.
endmodule

/*

	   pc = 4    0000_0000_0100	  4
	             1111_1111_1111	 -1

                 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
      0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */
