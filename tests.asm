//test each instruction. load store add mov
//simple testings
//turn ti machine Code binary. txt 9 bit binary//put in testbench
//no assembler: 

//test add_______________________________________________________
//test adding 2 nums using my logic.  store result to mem
// 
LOAD MEM[R5] //load mem w location stored in r0
0000 0101 0 //last bit dont care. r5=0
MOV2 R1 //move from acc to R1.
0110 0001 0

LOAD MEM[R0] //load mem addr 0 into acc (r16)
0000 0000 0

ADD R1
0100 0001 0

STORE MEM[R0] //overwrite dm[0] w the sum
0001 0000 0

//change testbench, convert every asm line to binary, then run in modelsim. quartus ok.
//_______________________________________________________________

//test xor
LOAD MEM[R5] //load mem w location stored in r0
0000 0101 0 //last bit dont care. r5=0
MOV2 R1 //move from acc to R1.
0110 0001 0

LOAD MEM[R0] //load mem addr 0 into acc (r16)
0000 0000 0

XOR R5 //xor acc w R5
0010 0101 0

STORE MEM[R1] //overrite dm[1] w xor result of halfword1 and halfword2
0001 0001 0
//_________________________________________________________________________

//test count1s
LOAD MEM[R5] //load mem w location stored in r0
0000 0101 0 //last bit dont care. r5=0
MOV2 R1 //move from acc to R1.
0110 0001 0

LOAD MEM[R0] //load mem addr 0 into acc (r16)
0000 0000 0

XOR R5 //xor acc w R5
0010 0101 0 //acc now holds XOR value of 2 halfwords

COUNT1S R6 //count1s of the xor value in acc, store count1s to R6
0011 0110 0

STORE MEM[R1] //overrite dm[1] w xor result of halfword1 and halfword2
0001 0001 0
//____________________________________________________________________________
//jlt
 //test how to specify where to jump
