# Listing 5-12
#
# Accessing a parameter on the stack
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing5-12
#   $listing5-12
#
# or
#
#   $gcc -o listing5-12 -fno-pie -no-pie c.cpp listing5-12.s -lstdc++
#   $listing5-12


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 5-12"
fmtStr1:    .asciz      "Value of parameter: %d\n"
        
            .data
value1:     .int    20
value2:     .int    30
        
            .text
            .extern printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret


            .equ    theParm, 16

ValueParm:
            push    rbp
            mov     rsp, rbp
            
            lea     fmtStr1, rdi
            mov     theParm(rbp), esi
            mov     $0, al
            call    printf
            
            leave
            ret



# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp
            sub     $16, rsp        #Only need 4, but keep stack 16-byte aligned
        
            mov     value1, eax
            mov     eax, (rsp)      #Pass parameter on stack
            call    ValueParm
            
            mov     value2, eax
            mov     eax, (rsp)
            call    ValueParm
            
# Clean up stack:

            leave
            ret     #Returns to caller
        
