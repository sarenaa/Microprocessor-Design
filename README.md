# Microprocessor-Design
I designed a microprocessor using accumulator architecture to find hamming distance between 2 numbers

How to run cpu:  (see assembly.asm),
 no changes were made to LUT. 
 Use instr_ROM to load the half words into memory. 
Changes made to base design:
 I used accumulator architecture.
  I wrote test.txt (see tests.asm) to test separate instructions such as
add, xor, and count1s in modelsim.
I added extra ports in top level such as .AccWrite(AccWrite) to indicate
writing to the accumulator register.
