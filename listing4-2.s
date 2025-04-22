# Listing 4-2
#
# Pointer constant demonstration
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing4-2
#   $listing4-2
#
# or
#
#   $gcc -o listing4-2 -fno-pie -no-pie c.cpp listing4-2.s -lstdc++
#   $listing4-2


            .include    "regs.inc"      #Use Intel register names


            .section    const, "a"
ttlStr:     .asciz      "Listing 4-2"
fmtStr:     .ascii      "pb's value is %ph\n"
            .asciz      "*pb's value is %d\n"
        
            .data
b:          .byte    0
            .byte    1, 2, 3, 4, 5, 6, 7
        
# Create a pointer constant, which holds the
# address of the third element of array "b"

            .equ    pb, b+2
        
            .text
            .extern printf


# Return program title to C++ program:

            .global getTitle
getTitle:
            lea ttlStr, rax
            ret


# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbx             #To align stack
            
# Remember: printf parameters are:
#
#   al: must be zero.
#  rdi: format string
#  rsi: 1st argument (for format string)
#  rdx: 2nd argument
#  rcx: 3rd argument
#  r8:  4th argument
#  r9:  5th argument
#
# Don't forget: "$" precedes constant (immediate) operands.
#
# "$" in front of a variable name (pb in this case)
# substitutes the address of the object rather than
# the value. This is comparable to the "&" operator in C/C++.  

            mov     $0, al          #No XMM/float arguments
            lea     fmtStr, rdi     #1st parm: format string
            mov     $pb, rsi        #Takes address of pb, like LEA
            movzbq  (rsi), rdx      #Second parm
            call    printf
            
            pop     rbx             #Clean up stack
            ret                     #Returns to caller
        

