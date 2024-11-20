// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file #(parameter pw=4)( //less instructions
  input[7:0] dat_in,
  input      clk,
  input      wr_en,           // write enable. jump store = 0
  input[pw-1:0] 		  // write address pointer. pw-1
              rd_addrA,		  // read address pointers
			  rd_addrB,
input[pw : 0] wr_addr,//5 bit wide

  output logic[7:0] datA_out, // read data. isMov1 uses
                    datB_out,
					acc); //isMov2 uses

  logic[7:0] core[2**pw + 1];    // 2-dim array  8 wide  16 deep

// reads are combinational
  assign datA_out = core[rd_addrA];
  assign datB_out = core[rd_addrB];
  assign acc = core[16]; //do i need acc address

// writes are sequential (clocked)
  always_ff @(posedge clk)
    if(wr_en)				   // anything but stores or no ops
      core[wr_addr] <= dat_in; 

endmodule
