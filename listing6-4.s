# Listing 6-4
#
# Demonstration of various forms of fdiv/fdivr
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing6-4
#   $listing6-4
#
# or
#
#   $gcc -o listing6-4 -fno-pie -no-pie c.cpp listing6-4.s -lstdc++
#   $listing6-4


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 6-4"
fmtSt0St1:  .asciz      "st(0):%f, st(1):%f\n"
fmtDiv1:    .asciz      "fdiv: st0:%f\n"
fmtDiv2:    .asciz      "fdivp: st0:%f\n"
fmtDiv3:    .asciz      "fdiv st(1), st(0): st0:%f, st1:%f\n"
fmtDiv4:    .asciz      "fdiv st(0), st(1): st0:%f, st1:%f\n"
fmtDiv5:    .asciz      "fdivp st(1), st(0): st0:%f\n"
fmtDiv6:    .asciz      "fdiv mem: st0:%f\n"
fmtDiv7:    .asciz      "fdivr st(1), st(0): st0:%f, st1:%f\n"
fmtDiv8:    .asciz      "fdivr st(0), st(1): st0:%f, st1:%f\n"
fmtDiv9:    .asciz      "fdivrp st(1), st(0): st0:%f\n"
fmtDiv10:   .asciz      "fdivr mem: st0:%f\n"

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

        
# Demonstrate various fdiv instructions:

            mov     three, rax
            mov     rax, fst1
            mov     minusTwo, rax
            mov     rax, fst0
            lea     fmtSt0St1, rdi
            call    printFP

# See the note about the Gas bug in listing6-0.s
# The following code was modified to produce the
# the same output as the MASM version in Ao64A.
# This involved swapping some fdiv/fdivr instructions
# in order to work around the Gas bug.
#
#
# fdiv (same as fdivp)
 
            fldl    three
            fldl    minusTwo
            fdivrp                   #Gas Bug!
            fstpl   fst0
            
            lea     fmtDiv1, rdi
            call    printFP            
            
# fdivp:
 
            fldl    three
            fldl    minusTwo
            fdivrp                   #Gas Bug!
            fstpl   fst0
            
            lea     fmtDiv2, rdi
            call    printFP            
            
# fdiv st0, st1
 
            fldl    three
            fldl    minusTwo
            fdivr   st0, st1         #Gas Bug!
            fstpl   fst0
            fstpl   fst1
            
            lea     fmtDiv3, rdi
            call    printFP            
            
# fdiv st1, st0
 
            fldl    three
            fldl    minusTwo
            fdiv    st1, st0
            fstpl   fst0
            fstpl   fst1
            
            lea     fmtDiv4, rdi
            call    printFP            
            
# fdivp st0, st1
 
            fldl    three
            fldl    minusTwo
            fdivrp  st0, st1           #Gas Bug!
            fstpl   fst0
            
            lea     fmtDiv5, rdi
            call    printFP            
            
# fdiv mem64
 
            fldl    three
            fdivl   minusTwo
            fstpl   fst0
            
            lea     fmtDiv6, rdi
            call    printFP            
            
            
            
# fdivr st0, st1
 
            fldl    three
            fldl    minusTwo
            fdiv    st0, st1            #Gas Bug!
            fstpl   fst0
            fstpl   fst1
            
            lea     fmtDiv7, rdi
            call    printFP            
            
# fdivr st1, st0
 
            fldl    three
            fldl    minusTwo
            fdivr   st1, st0
            fstpl   fst0
            fstpl   fst1
            
            lea     fmtDiv8, rdi
            call    printFP            
            
# fdivrp st0, st1
 
            fldl    three
            fldl    minusTwo
            fdivp   st0, st1           #Gas Bug!
            fstpl   fst0
            
            lea     fmtDiv9, rdi
            call    printFP            
            
# fdivr mem64
 
            fldl    three
            fdivrl  minusTwo
            fstpl   fst0
            
            lea     fmtDiv10, rdi
            call    printFP            
            
            leave
            ret     #Returns to caller
