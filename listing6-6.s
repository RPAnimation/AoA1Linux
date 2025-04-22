# Listing 6-6
#
# Demonstration of fcomi and fcomip instructions
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing6-6
#   $listing6-6
#
# or
#
#   $gcc -o listing6-6 -fno-pie -no-pie c.cpp listing6-6.s -lstdc++
#   $listing6-6


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 6-6"
fcomiFmt:   .asciz      "fcomi %f < %f is %d\n"
fcomiFmt2:  .asciz      "fcomi(2) %f < %f is %d\n"
fcomipFmt:  .asciz      "fcomip %f < %f is %d\n"
fcomipFmt2: .asciz      "fcomip (2) %f < %f is %d\n"

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


# Test to see if 0 < 3
# Note: st(0) contains zero, st(2) contains three
        
            xor     eax, eax
            fldl    three
            fldl    zero
            fcomi   st1, st0
            setb    al
            fstpl   fst0
            fstpl   fst1
            lea     fcomiFmt, rdi
            call    printFP
            
# Test to see if 3 < 0
# Note: st(0) contains zero, st(2) contains three
        
            xor     eax, eax
            fldl    zero
            fldl    three
            fcomi   st1, st0
            setb    al
            fstpl   fst0
            fstpl   fst1
            lea     fcomiFmt2, rdi
            call    printFP
                        
# Test to see if 3 < 0
# Note: st(0) contains zero, st(2) contains three
        
            xor     eax, eax
            fldl    zero
            fldl    three
            fstl    fst0             #Because this gets popped
            fcomip  st1, st0
            setb    al
            fstpl   fst1
            lea     fcomipFmt, rdi
            call    printFP
                        
# Test to see if 0 < 3
# Note: st(0) contains zero, st(2) contains three
        
            xor     eax, eax
            fldl    three
            fldl    zero
            fstl    fst0             #Because this gets popped
            fcomip   st1, st0
            setb    al
            fstpl   fst1
            lea     fcomipFmt2, rdi
            call    printFP
                        
            leave
            ret     #Returns to caller
        

