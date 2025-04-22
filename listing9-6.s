# Listing 9-6
#
# Fast signed integer to string function
# using fist/fbstp
#
#   $build listing9-6
#   $listing9-6
#
# or
#
#   $gcc -o listing9-6 -fno-pie -no-pie c.cpp listing9-6.s -lstdc++
#   $listing9-6



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 9-6"
fmtStr1:    .asciz      "utoStr: Value=%zd, string=%s\n"
            
            .data
buffer:     .fill       30, 1, 0
            
            .text
            .extern     printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



# utoStr-
#
#  Unsigned integer to string.
#
# Inputs:
#
#    RAX:   Unsigned integer to convert
#    RDI:   Location to hold string.
#
# Note: for 64-bit integers, resulting
# string could be as long as  21 bytes
# (including the zero-terminating byte).

bigNum:     .quad   1000000000000000000

utoStr:
            push    rcx
            push    rdx
            push    rdi
            push    rax
            sub     $16, rsp

# Quick test for zero to handle that special case:

            test    rax, rax
            jnz     not0
            movb    $'0', (rdi)
            jmp     allDone

# The FBSTP instruction only supports 18 digits.
# 64-bit integers can have up to 19 digits.
# Handle that 19th possible digit here:
            
not0:       cmp     bigNum, rax
            jb      lt19Digits

# The number has 19 digits (which can be 0-9).
# pull off the 19th digit:

            xor     edx, edx        #Zero extends!
            divq    bigNum          #19th digit in AL
            mov     rdx, 16(rsp)    #Remainder (RAX on stk)
            or      $'0', al
            mov     al, (rdi)
            inc     rdi
            
            

# The number to convert is non-zero.
# Use BCD load and store to convert
# the integer to BCD:

lt19Digits: fildq   16(rsp)         #RAX on stack
            fbstp   6(rsp)
            
            
# Begin by skipping over leading zeros in
# the BCD value (max 19 digits, so the most
# significant digit will be in the LO nibble
# of DH).

            mov     14(rsp), dx
            mov     6(rsp), rax
            mov     $20, ecx
            jmp     testFor0
            
Skip0s:     shld    $4, rax, rdx
            shl     $4, rax
testFor0:   dec     ecx         #Count digits we've processed
            test    $0xf, dh    #Because the number is not 0
            jz      Skip0s      #this always terminates
            
# At this point the code has encountered
# the first non-0 digit. Convert the remaining
# digits to a string:

cnvrtStr:   and     $0xf, dh
            or      $'0', dh 
            mov     dh, (rdi)
            inc     rdi
            mov     $0, dh
            shld    $4, rax, rdx
            shl     $4, rax
            dec     ecx
            jnz     cnvrtStr

# Zero-terminte the string and return:
            
allDone:    movb    $0, (rdi)
            add     $16, rsp
            pop     rax
            pop     rdi
            pop     rdx
            pop     rcx
            ret



# itoStr - Signed integer to string conversion
#
# Inputs:
#   RAX -   Signed integer to convert
#   RDI -   Destination buffer address

itoStr:
            push    rdi
            push    rax
            test    rax, rax
            jns     notNeg
            
# Number was negative, emit '-' and negate
# value.

            movb    $'-', (rdi) 
            inc     rdi
            neg     rax
            
# Call utoStr to convert non-negative number:

notNeg:     call    utoStr
            pop     rax
            pop     rdi
            ret



            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp
            
# Because all the (x)toStr functions preserve RDI,
# we only need to do the following once:
 
            lea     buffer, rdi
            mov     $-1123456789012345678, rax
            call    itoStr
            
            lea     fmtStr1, rdi
            mov     $-1123456789012345678, rsi
            lea     buffer, rdx
			mov		$0, al
            call    printf
                                
            leave
            ret     #Returns to caller

