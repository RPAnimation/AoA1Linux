# Listing 9-8
#
# Extended-precision signed integer 
# to string function
#
#   $build listing9-8
#   $listing9-8
#
# or
#
#   $gcc -o listing9-8 -fno-pie -no-pie c.cpp listing9-8.s -lstdc++
#   $listing9-8



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 9-8"
fmtStr1:    .asciz      "otoStr(0): string=%s\n"
fmtStr2:    .asciz      "otoStr(-1): string=%s\n"
fmtStr3:    .asciz      "otoStr(-2147483648): string=%s\n"
fmtStr4:    .asciz      "otoStr(-4294967296): string=%s\n"
fmtStr5:    .asciz      "otoStr(FFF...FFFF): string=%s\n"
            
            .data
buffer:     .fill       40, 1, 0

b0:         .octa       0
b1:         .octa       -1
b2:         .octa       -2147483648
b3:         .octa       -4294967296
    
# Largest oword value (unsigned)
# (decimal=170,141,183,460,469,231,731,687,303,715,884,105,727):
    
b4:         .octa       0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            
            .text
            .extern printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret




# DivideBy10-
#
#  Divides "divisor" by 10 using fast
#  extended-precision division algorithm
#  that employs the div instruction.
#
#  Returns quotient in "quotient".
#  Returns remainder in rax.
#  Trashes rdx.
#
# RCX - points at oword dividend and location to
#       receive quotient

ten:        .quad   10


DivideBy10:
            xor     edx, edx
            mov     8(rcx), rax
            divq    ten
            mov     rax, 8(rcx)
            
            mov     (rcx), rax
            divq    ten
            mov     rax, (rcx)
            mov     edx, eax        #Remainder (always 0..9!)
            ret    



# Recursive version of otoStr.
# A separate "shell" procedure calls this so that
# this code does not have to preserve all the registers
# it uses (and DivideBy10 uses) on each recursive call.
#
# On entry:
#    Stack contains oword in/out parameter (dividend in/quotient out)
#    RDI- contains location to place output string
#
# Note: this function must clean up stack (parameters)
#       on return.

           .equ     value, +16
           .equ     remainder, -8

rcrsvOtoStr:
            push    rbp
            mov     rsp, rbp
            sub     $8, rsp
            lea     value(rbp), rcx
            call    DivideBy10
            mov     al, remainder(rbp)
            
# If the quotient (left in value) is not 0, recursively
# call this routine to output the HO digits.

            mov     value(rbp), rax
            or      value+8(rbp), rax
            jz      allDone2
            
            mov     value+8(rbp), rax
            push    rax
            mov     value(rbp), rax
            push    rax
            call    rcrsvOtoStr

allDone2:   mov     remainder(rbp), al
            or      $'0', al
            mov     al, (rdi)
            inc     rdi
            leave
            ret     $16      #Remove parms from stack
            


# Nonrecursive shell to the above routine so we don't bother
# saving all the registers on each recursive call.
#
# On entry:
#
#   RDX:RAX- contains oword to print
#   RDI-     buffer to hold string (at least 40 bytes)

otostr:

            push    rax
            push    rcx
            push    rdx
            push    rdi

# Special-case zero:

            test    rax, rax
            jnz     not0
            test    rdx, rdx
            jnz     not0
            movb    $'0', (rdi)
            inc     rdi
            jmp     allDone
            
not0:       push    rdx
            push    rax
            call    rcrsvOtoStr
            
# Zero-terminate string before leaving

allDone:    movb    $0, (rdi)

            pop     rdi
            pop     rdx
            pop     rcx
            pop     rax
            ret
 
 
 
# i128toStr-
#   Converts a 128-bit signed integer to a string
#
# Inputs#
#    RDX:RAX- signed integer to convert
#    RDI-     pointer to buffer to receive string

i128toStr:
            push    rax
            push    rdx
            push    rdi
            
            test    rdx, rdx  #Is number negative?
            jns     notNeg
            
            movb    $'-', (rdi) 
            inc     rdi
            neg     rdx     #128-bit negation
            neg     rax
            sbb     $0, rdx
            
notNeg:     call    otostr
            pop     rdi
            pop     rdx
            pop     rax
            ret

           
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rdi
            push    rbp
            mov     rsp, rbp
            and     $-16, rsp
            
# Because all the (x)toStr functions preserve RDI,
# we only need to do the following once:
 
            lea     buffer, rdi

# Convert b0 to a string and print the result:
            
            mov     b0, rax
            mov     b0+8, rdx
            call    i128toStr

            lea     fmtStr1, rdi
            lea     buffer, rsi
            mov     $0, al
            call    printf
            
# Convert b1 to a string and print the result:
            
            lea     buffer, rdi
            mov     b1, rax
            mov     b1+8, rdx
            call    i128toStr

            lea     fmtStr2, rdi
            lea     buffer, rsi
            mov     $0, al
            call    printf
            
# Convert b2 to a string and print the result:
            
            lea     buffer, rdi
            mov     b2, rax
            mov     b2+8, rdx
            call    i128toStr

            lea     fmtStr3, rdi
            lea     buffer, rsi
            mov     $0, al
            call    printf
            
# Convert b3 to a string and print the result:
            
            lea     buffer, rdi
            mov     b3, rax
            mov     b3+8, rdx
            call    i128toStr

            lea     fmtStr4, rdi
            lea     buffer, rsi
            mov     $0, al
            call    printf
            
# Convert b4 to a string and print the result:
            
            lea     buffer, rdi
            mov     b4, rax
            mov     b4+8, rdx
            call    i128toStr

            lea     fmtStr5, rdi
            lea     buffer, rsi
            mov     $0, al
            call    printf
            
            leave
            pop     rdi
            ret     #Returns to caller
        
