// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=12)(
  input reset,					// synchronous reset
        clk,
        absjump_en,				// abs. jump enable
  input       [D-1:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr
);

  always_ff @(posedge clk) begin
    if(reset)
	  prog_ctr <= '0;
	// else if(reljump_en)
	//   prog_ctr <= prog_ctr + target;
    else if(absjump_en) //alu should we jump                                                                                                                                                                                                 
	  prog_ctr <= target;
	else
	  prog_ctr <= prog_ctr + 'b1;

  end

endmodule