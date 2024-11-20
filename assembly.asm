### Assembly Code
```assembly

//0-63

LOAD MEM[R0] //load datamem[0]to r16. asume R0 = 0
MOV2 R1 //address. r0 is address icnrementing only. store 1st 1/2 word in R1
//will increment address in r0
MOV1 R15 //moves a 1 from r15 to r16. aka increment by 1. r15 always=1
ADD R0 //add 1 (in r0) to R16. 
MOV2 R0 //move 1 from r16 to r0



LOAD MEM[R0] //now data mem[1] loads into r16
MOV2 R2 //store 2nd 1/2 word in R12
MOV1 R15 //move a 1 from r15 to r16. 
ADD R0 //r0 val = r16 val + r0 val. r0 increments
MOV2 R0 //move 2 from r16 to r0

LOAD MEM[R0] //data mem [2] load into r16
MOV2 R3 //store 3rd halfword in R3
MOV1 R15 //move a 1 from r15 to r16.  //same
ADD R0 //r0 val = r16 val + r0 val. r0 increments //same
MOV2 R0 //move 2 from r16 to r0 //same

LOAD MEM[R0] //data mem [3] load into r16
MOV2 R4 //store 4th halfword in R4
MOV1 R15 //move a 1 from r15 to r16.  //same
ADD R0 //r0 val = r16 val + r0 val. r0 increments //same
MOV2 R0 //move 2 from r16 to r0 //same


//for loop jumps later. outer moves 1st. inner moves 2nd

//outer
LOAD MEM[R0] //load datamem[0]to r16. asume R0 = 0
MOV2 R1 //address. r0 is address icnrementing only. store 1st 1/2 word in R1
//will increment address in r0
MOV1 R15 //moves a 1 from r15 to r16. aka increment by 1. r15 always=1
ADD R0 //add 1 (in r0) to R16. move it to r0 next
MOV2 R0 //move 1 from r16 to r0

LOAD MEM[R0] //now data mem[1] loads into r16
MOV2 R2 //store 2nd 1/2 word in R12
MOV1 R15 //move a 1 from r15 to r16. 
ADD R0 //r0 val = r16 val + r0 val. r0 increments
MOV2 R0 //move 2 from r16 to r0

LOAD MEM[R0] //data mem [2] load into r16
MOV2 R3 //store 3rd halfword in R3
MOV1 R15 //move a 1 from r15 to r16.  //same
ADD R0 //r0 val = r16 val + r0 val. r0 increments //same
MOV2 R0 //move 2 from r16 to r0 //same

LOAD MEM[R0] //data mem [3] load into r16
MOV2 R4 //store 4th halfword in R4
MOV1 R15 //move a 1 from r15 to r16.  //same
ADD R0 //r0 val = r16 val + r0 val. r0 increments //same
MOV2 R0 //move 2 from r16 to r0 //same



//inner loop
LOAD MEM[R0] //load datamem[0]to r16. asume R0 = 0
MOV2 R1 //address. r0 is address icnrementing only. store 1st 1/2 word in R1
//will increment address in r0
MOV1 R15 //moves a 1 from r15 to r16. aka increment by 1. r15 always=1
ADD R0 //add 1 (in r0) to R16. move it to r0 next
MOV2 R0 //move 1 from r16 to r0

LOAD MEM[R0] //now data mem[1] loads into r16
MOV2 R2 //store 2nd 1/2 word in R12
MOV1 R15 //move a 1 from r15 to r16. 
ADD R0 //r0 val = r16 val + r0 val. r0 increments
MOV2 R0 //move 2 from r16 to r0

//move stuff in out of accumulator then xor.
if(instr[4] == 0) begin //look in control unit logic
MOV1 R1 //move R1 half word to R16
XOR R3 //xor R16(accumulator) with R3
COUNT1S R7 //count1s in R3, store back to R16
end
else begin
MOV1 R2 //move R2 half word to R16
XOR R4 //xor acc w R4
COUNT1S R6 //store 1st dist in R6
end
MOV2 R7 //move 2nd dist to R7
ADD R6 //accumulator R16 has curr dist, 1st dist + 2nd dist.

//end 2 for loop

MOV2 R8 //move stuff out of acc. r8 now has currdist//reg8=dm[64]
LOAD dm[64] //load dm[64] to acc
MOV2 R9 //move dm[64 to r9]
LOAD dm[65]
MOV2 R10 //move dm[65] to R10



if(R8 < R9) begin 
JGT [R8,R9]
//false. increment i j base on condition
MOV1 R8
STORE R8 //store currdist to acc store to [64]
end
if(R8 > R9) begin
//true
MOV1 R9
STORE R9 // store to 65
JGT [R8,R9]

R11 = 0 //i. how to convert if else statement to branch. how to convert loop to branch.
//r0 is j
//innner loop
if(pc== final instr) done = 1 //done testing.

//1. get p1 work in asm then verilog. b-
//2. make small test for load/store/alu work. c+ no p1 working *** less asm
//3. asembler if u finish p1