# Listing 6-5
#
# Demonstration of fcom instructions
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing6-5
#   $listing6-5
#
# or
#
#   $gcc -o listing6-5 -fno-pie -no-pie c.cpp listing6-5.s -lstdc++
#   $listing6-5


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 6-5"
fcomFmt:    .asciz      "fcom %f < %f is %d\n"
fcomFmt2:   .asciz      "fcom(2) %f < %f is %d\n"
fcomFmt3:   .asciz      "fcom st(1) %f < %f is %d\n"
fcomFmt4:   .asciz      "fcom st(1) (2) %f < %f is %d\n"
fcomFmt5:   .asciz      "fcom mem %f < %f is %d\n"
fcomFmt6:   .asciz      "fcom mem %f (2) < %f is %d\n"
fcompFmt:   .asciz      "fcomp %f < %f is %d\n"
fcompFmt2:  .asciz      "fcomp (2) %f < %f is %d\n"
fcompFmt3:  .asciz      "fcomp st(1) %f < %f is %d\n"
fcompFmt4:  .asciz      "fcomp st(1) (2) %f < %f is %d\n"
fcompFmt5:  .asciz      "fcomp mem %f < %f is %d\n"
fcompFmt6:  .asciz      "fcomp mem (2) %f < %f is %d\n"
fcomppFmt:  .asciz      "fcompp %f < %f is %d\n"
fcomppFmt2: .asciz      "fcompp (2) %f < %f is %d\n"

three:      .double     3.0
zero:       .double     0.0
minusTwo:   .double     -2.0
        
            .data
fst0:       .double     0
fst1:       .double     0
        
            .text
            .extern     printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



# printFP- Prints values of fst0 and (possibly) fst1.
#          Caller must pass in ptr to fmtStr in RDI and
#          Boolean value to print in AL.

printFP:
            push    rbp
            mov     rsp, rbp
            and     $-16, rsp
                        
            movsd   fst0, xmm0
            movsd   fst1, xmm1
            movzx   al, rsi
            mov     $2, al      #Two args in XMM regs
            call    printf
            leave
            ret

            
            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp


# fcom demo
        
            xor     eax, eax
            fldl    three
            fldl    zero
            fcom
            fstsw   ax
            sahf
            setb    al
            fstpl   fst0
            fstpl   fst1
            lea     fcomFmt, rdi
            call    printFP
            
# fcom demo 2
        
            xor     eax, eax
            fldl    zero
            fldl    three
            fcom
            fstsw   ax
            sahf
            setb    al
            fstpl   fst0
            fstpl   fst1
            lea     fcomFmt2, rdi
            call    printFP

# fcom st(i) demo
        
            xor     eax, eax
            fldl    three
            fldl    zero
            fcom    st1
            fstsw   ax
            sahf
            setb    al
            fstpl   fst0
            fstpl   fst1
            lea     fcomFmt3, rdi
            call    printFP
            
# fcom st(i) demo 2
        
            xor     eax, eax
            fldl    zero
            fldl    three
            fcom    st1
            fstsw   ax
            sahf
            setb    al
            fstpl   fst0
            fstpl   fst1
            lea     fcomFmt4, rdi
            call    printFP
            
# fcom mem64 demo                                            
                                                             
            xor     eax, eax                                 
            fldl    three           #Never on stack so       
            fstpl   fst1            # copy for output        
            fldl    zero                                     
            fcom    three                                    
            fstsw   ax                                       
            sahf                                             
            setb    al                                       
            fstpl   fst0                                     
            lea     fcomFmt5, rdi                            
            call    printFP                                  
                        
# fcom mem64 demo 2
        
            xor     eax, eax
            fldl    zero            #Never on stack so
            fstpl   fst1            # copy for output
            fldl    three
            fcom    zero
            fstsw   ax
            sahf
            setb    al
            fstpl   fst0
            lea     fcomFmt6, rdi
            call    printFP
                        
# fcomp demo
        
            xor     eax, eax
            fldl    zero
            fldl    three
            fstl    fst0            #Because this gets popped
            fcomp
            fstsw   ax
            sahf
            setb    al
            fstpl   fst1
            lea     fcompFmt, rdi
            call    printFP
                        
# fcomp demo 2
        
            xor     eax, eax
            fldl    three
            fldl    zero
            fstl    fst0            #Because this gets popped
            fcomp
            fstsw   ax
            sahf
            setb    al
            fstpl   fst1
            lea     fcompFmt2, rdi
            call    printFP
                        
# fcomp demo 3
        
            xor     eax, eax
            fldl    zero
            fldl    three
            fstl    fst0            #Because this gets popped
            fcomp   st1
            fstsw   ax
            sahf
            setb    al
            fstpl   fst1
            lea     fcompFmt3, rdi
            call    printFP
                        
# fcomp demo 4
        
            xor     eax, eax
            fldl    three
            fldl    zero
            fstl    fst0            #Because this gets popped
            fcomp   st1
            fstsw   ax
            sahf
            setb    al
            fstpl   fst1
            lea     fcompFmt4, rdi
            call    printFP
                        
# fcomp demo 5
        
            xor     eax, eax
            fldl    three
            fstpl   fst1
            fldl    zero
            fstl    fst0            #Because this gets popped
            fcompl  three
            fstsw   ax
            sahf
            setb    al
            lea     fcompFmt5, rdi
            call    printFP
                        
# fcomp demo 6
        
            xor     eax, eax
            fldl    zero
            fstpl   fst1
            fldl    three
            fstl    fst0             #Because this gets popped
            fcompl  zero
            fstsw   ax
            sahf
            setb    al
            lea     fcompFmt6, rdi
            call    printFP
                        
# fcompp demo
        
            xor     eax, eax
            fldl    zero
            fstl    fst1             #Because this gets popped
            fldl    three
            fstl    fst0             #Because this gets popped
            fcompp  
            fstsw   ax
            sahf
            setb    al
            lea     fcomppFmt, rdi
            call    printFP
                        
# fcompp demo 2
        
            xor     eax, eax
            fldl    three
            fstl    fst1             #Because this gets popped
            fldl    zero
            fstl    fst0             #Because this gets popped
            fcompp  
            fstsw   ax
            sahf
            setb    al
            lea     fcomppFmt2, rdi
            call    printFP
                        
            leave
            ret     #Returns to caller

