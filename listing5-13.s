# Listing 5-13
#
# Accessing a reference parameter on the stack
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing5-13
#   $listing5-13
#
# or
#
#   $gcc -o listing5-13 -fno-pie -no-pie c.cpp listing5-13.s -lstdc++
#   $listing5-13


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 5-13"
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

# Stack on entry
#
# RBP
# +16:  theParm (pointer)
# +8:   return address
# +0:   saved RBP

            .equ    theParm, 16

RefParm:
            push    rbp
            mov     rsp, rbp
                        
            lea     fmtStr1, rdi
            mov     theParm(rbp), rax    #Dereference parameter
            mov     (rax), rsi
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
        
            lea     value1, rax
            mov     rax, (rsp)      #Store address on stack
            call    RefParm
            
            lea     value2, rax
            mov     rax, (rsp)
            call    RefParm
            
# Clean up stack:

            leave
            ret     #Returns to caller
        

