# Listing 6-3
#
# Demonstration of various forms of fmul
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing6-3
#   $listing6-3
#
# or
#
#   $gcc -o listing6-3 -fno-pie -no-pie c.cpp listing6-3.s -lstdc++
#   $listing6-3


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 6-3"
fmtSt0St1:  .asciz      "st(0):%f, st(1):%f\n"
fmtMul1:    .asciz      "fmul: st0:%f\n"
fmtMul2:    .asciz      "fmulp: st0:%f\n"
fmtMul3:    .asciz      "fmul st(1), st(0): st0:%f, st1:%f\n"
fmtMul4:    .asciz      "fmul st(0), st(1): st0:%f, st1:%f\n"
fmtMul5:    .asciz      "fmulp st(1), st(0): st0:%f\n"
fmtMul6:    .asciz      "fmul mem: st0:%f\n"

zero:       .double     0.0
three:      .double     3.0
minusTwo:   .double     -2.0
        
            .data
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
        
# Demonstrate various fmul instructions:

            mov     three, rax
            mov     rax, fst1
            mov     minusTwo, rax
            mov     rax, fst0
            lea     fmtSt0St1, rdi
            call    printFP

# fmul (same as fmulp)
 
            fldl    three
            fldl    minusTwo
            fmulp                  #Pops st(0)!
            fstpl   fst0
            
            lea     fmtMul1, rdi
            call    printFP            
            
# fmulp:
 
            fldl    three
            fldl    minusTwo
            fmulp                   #Pops st(0)!
            fstpl   fst0
            
            lea     fmtMul2, rdi
            call    printFP            
            
# fmul st0, st1
 
            fldl    three
            fldl    minusTwo
            fmul    st0, st1
            fstpl   fst0
            fstpl   fst1
            
            lea     fmtMul3, rdi
            call    printFP            
            
# fmul st1, st0
 
            fldl    three
            fldl    minusTwo
            fmul    st1, st0
            fstpl   fst0
            fstpl   fst1
            
            lea     fmtMul4, rdi
            call    printFP            
            
# fmulp st0, st1
 
            fldl    three
            fldl    minusTwo
            fmulp   st0, st1
            fstpl   fst0
            
            lea     fmtMul5, rdi
            call    printFP            
            
# fmulp mem64
 
            fldl    three
            fmull   minusTwo
            fstpl   fst0
            
            lea     fmtMul6, rdi
            call    printFP            
            
            leave
            ret     #Returns to caller
        
