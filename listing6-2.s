# Listing 6-2
#
# Demonstration of various forms of fsub/fsubrl
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing6-2
#   $listing6-2
#
# or
#
#   $gcc -o listing6-2 -fno-pie -no-pie c.cpp listing6-2.s -lstdc++
#   $listing6-2


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.


            .section    const, "a"
ttlStr:     .asciz      "Listing 6-2"
fmtSt0St1:  .asciz      "st(0):%f, st(1):%f\n"
fmtSub1:    .asciz      "fsub: st0:%f\n"
fmtSub2:    .asciz      "fsubp: st0:%f\n"
fmtSub3:    .asciz      "fsub st(1), st(0): st0:%f, st1:%f\n"
fmtSub4:    .asciz      "fsub st(0), st(1): st0:%f, st1:%f\n"
fmtSub5:    .asciz      "fsubp st(1), st(0): st0:%f\n"
fmtSub6:    .asciz      "fsub mem: st0:%f\n"
fmtSub7:    .asciz      "fsubr st(1), st(0): st0:%f, st1:%f\n"
fmtSub8:    .asciz      "fsubr st(0), st(1): st0:%f, st1:%f\n"
fmtSub9:    .asciz      "fsubrp st(1), st(0): st0:%f\n"
fmtSub10:   .asciz      "fsubr mem: st0:%f\n"

zero:        .double    0.0
three:       .double    3.0
minusTwo:    .double    -2.0
        
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
        
# Demonstrate various fsub instructions:

            mov     three, rax
            mov     rax, fst1
            mov     minusTwo, rax
            mov     rax, fst0
            lea     fmtSt0St1, rdi
            call    printFP

# fsub (same as fsubp)
 
            fldl    three
            fldl    minusTwo
            fsubrp                  #Gas bug, should be fsubp
            fstpl   fst0
            
            lea     fmtSub1, rdi
            call    printFP            

# See the note about the Gas bug in listing6-0.s
# The following code was modified to produce the
# the same output as the MASM version in Ao64A.
# This involved swapping some fsub/fsubr instructions
# in order to work around the Gas bug.
#            
# fsubp:
 
            fldl   three
            fldl    minusTwo
            fsubrp                  #Gas Bug, should be fsubp
            fstpl   fst0
            
            lea     fmtSub2, rdi
            call    printFP            
            
# fsub st(0), st(1)                 
                                    
            fldl    three           
            fldl    minusTwo        
            fsubr   st0, st1         #Gas Bug, should be fsubp      
            fstpl   fst0            
            fstpl   fst1            
                                    
            lea     fmtSub3, rdi    
            call    printFP            
            
# fsub st1, st0
 
            fldl    three
            fldl    minusTwo
            fsub    st1, st0
            fstpl   fst0
            fstpl   fst1
            
            lea     fmtSub4, rdi
            call    printFP            
            
# fsubp st0, st1
 
            fldl    three
            fldl    minusTwo
            fsubrp  st0, st1         #Gas Bug, should be fsubp
            fstpl   fst0
            
            lea     fmtSub5, rdi
            call    printFP            
            
# fsub mem64
 
            fldl    three
            fsubl   minusTwo
            fstpl   fst0
            
            lea     fmtSub6, rdi
            call    printFP            
            
    
    
# fsubr st0, st1
 
            fldl    three
            fldl    minusTwo
            fsub    st0, st1         #Gas Bug, should be fsub
            fstpl   fst0
            fstpl   fst1
            
            lea     fmtSub7, rdi
            call    printFP            
            
# fsubr st1, st0
 
            fldl    three
            fldl    minusTwo
            fsubr   st1, st0
            fstpl   fst0
            fstpl   fst1
            
            lea     fmtSub8, rdi
            call    printFP            
 
# fsubrp st0, st1                                                       
                                                                        
            fldl    three                                               
            fldl    minusTwo                                            
            fsubp   st0, st1             #Gas Bug, should be fsubrp     
            fstpl   fst0                                                
                                                                        
            lea     fmtSub9, rdi                                        
            call    printFP                                             
            
# fsubr mem64
 
            fldl    three
            fsubrl  minusTwo
            fstpl   fst0
            
            lea     fmtSub10, rdi
            call    printFP            
            
            leave
            ret     #Returns to caller

