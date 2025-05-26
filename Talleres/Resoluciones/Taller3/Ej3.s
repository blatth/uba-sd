addi x0, x0, 0
addi x0, x0, 0
addi x11, x0, 4 
lw x12, 0, x11 
addi x13, x0, 4 
lw x13, 0, x13 
lw x13, 0, x13 
beq x12, x13, -20
jal x0, 8 
jal x0, 0
lui x14, 0xfffa6
addi x14, x14, -1539
add x12, x14, x12
sw x11, 40, x12
jal x0, -20
