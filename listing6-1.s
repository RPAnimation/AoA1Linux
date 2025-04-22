# Listing 6-1
#
# Demonstration of various forms of fadd
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing6-1
#   $listing6-1
#
# or
#
#   $gcc -o listing6-1 -fno-pie -no-pie c.cpp listing6-1.s -lstdc++
#   $listing6-1


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.


            .section    const, "a"
ttlStr:     .asciz      "Listing 6-1"
fmtSt0St1:  .asciz      "st(0):%f, st(1):%f\n"
fmtAdd1:    .asciz      "fadd: st0:%f\n"
fmtAdd2:    .asciz      "faddp: st0:%f\n"
fmtAdd3:    .asciz      "fadd st(1), st(0): st0:%f, st1:%f\n"
fmtAdd4:    .asciz      "fadd st(0), st(1): st0:%f, st1:%f\n"
fmtAdd5:    .asciz      "faddp st(1), st(0): st0:%f\n"
fmtAdd6:    .asciz      "fadd mem: st0:%f\n"

            .balign     16
zero:       .double     0.0
one:        .double     1.0
two:        .double     2.0
minusTwo:   .double     -2.0
        
            .data
            .balign     16
fst0:       .double     0.0
fst1:       .double     0.0
        
            .text
            .extern     printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



# printFP- Prints values of fst0 and (possibly) fst1.
#          Caller must pass in ptr to fmtStr in RDI.

printFP:
            push    rbp
            mov     rsp, rbp
            and     $-16, rsp
                        
            movsd   fst0, xmm0
            movsd   fst1, xmm1
            mov     $2, al      #Two args in XMM regs
            call    printf
            leave
            ret


            
            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp

            finit
        
# Demonstrate various fadd instructions:

            mov     one, rax
            mov     rax, fst1
            mov     minusTwo, rax
            mov     rax, fst0
            lea     fmtSt0St1, rdi
            call    printFP

# fadd (same as faddp)
 
            fldl     one
            fldl     minusTwo
            faddp                    #Pops st(0)!
            fstpl    fst0
            
            lea     fmtAdd1, rdi
            call    printFP            
            
# faddp:
 
            fldl     one
            fldl     minusTwo
            faddp                   #Pops st(0)!
            fstpl    fst0
            
            lea     fmtAdd2, rdi
            call    printFP            
            
# fadd st(1), st(0): st(0)=st(0)+st(1)
 
            fldl     one
            fldl     minusTwo
            fadd     st1, st0
            fstpl    fst0
            fstpl    fst1
            
            lea     fmtAdd3, rdi
            call    printFP            
            
# fadd st(0), st(1): st(1) = st(0)+st(1)
 
            fldl     one
            fldl     minusTwo
            fadd     st0, st1
            fstpl    fst0
            fstpl    fst1
            
            lea     fmtAdd4, rdi
            call    printFP            
            
# faddp st(1), st(0): st(0)=st(0)+st(1)
 
            fldl     one
            fldl     minusTwo
            faddp    st0, st1
            fstpl    fst0
            
            lea     fmtAdd5, rdi
            call    printFP            
            
# faddp mem64
 
            fldl     one
            faddl    two
            fstpl    fst0
            
            lea     fmtAdd6, rdi
            call    printFP            
            
            leave
            ret     #Returns to caller
 