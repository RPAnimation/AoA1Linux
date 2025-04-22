# Listing 5-4
#
# Preserving registers (caller) example
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing5-4
#   $listing5-4
#
# or
#
#   $gcc -o listing5-4 -fno-pie -no-pie c.cpp listing5-4.s -lstdc++
#   $listing5-4


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 5-4"
space:      .asciz      " "
asterisk:   .asciz      "*, %d\n"

            .data
saveRBX:    .quad       0
        
            .text
            .extern     printf

# Return program title to C++ program:

              .global   getTitle
getTitle:
              lea       ttlStr, rax
              ret




# print40Spaces-
# 
#  Prints out a sequence of 40 spaces
# to the console display.

print40Spaces:
                push    rbp
                mov     $40, ebx
printLoop:      lea     space, rdi
                call    printf
                dec     ebx
                jnz     printLoop #Until ebx==0
                pop     rbp
                ret


# Here is the "asmMain" function.

                .global asmMain
asmMain:
                push    rbx
                
                mov     $20, rbx
astLp:          mov     rbx, saveRBX
                call    print40Spaces
                lea     asterisk, rdi
                mov     saveRBX, rsi
                mov     $0, al
                call    printf
                mov     saveRBX, rbx
                dec     rbx
                jnz     astLp

                pop     rbx
                ret     #Returns to caller

