# Listing 7-5
#
# Demonstration of memory indirect jumps
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing7-5
#   $listing7-5
#
# or
#
#   $gcc -o listing7-5 -fno-pie -no-pie c.cpp listing7-5.s -lstdc++
#   $listing7-5



            .equ    maxLen, 256
            .equ    EINVAL, 22          #"Magic" C stdlib constant, invalid argument
            .equ    ERANGE, 34          #Value out of range

            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 7-5"
fmtStr1:    .asciz      "Before indirect jump\n"
fmtStr2:    .asciz      "After indirect jump\n"
            

            .text
            .extern     printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



            
            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp
            
            lea     fmtStr1, rdi
            mov     $0, al
            call    printf
            jmp     *memPtr
            
memPtr:     .quad   ExitPoint

ExitPoint:  lea     fmtStr2, rdi
            mov     $0, al
            call    printf
            
            leave
            ret     #Returns to caller
        
