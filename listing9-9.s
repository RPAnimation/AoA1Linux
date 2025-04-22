# Listing 9-9
#
# Formatted string output:
#
#   $build listing9-9
#   $listing9-9
#
# or
#
#   $gcc -o listing9-9 -fno-pie -no-pie c.cpp listing9-9.s -lstdc++
#   $listing9-9



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.
            
            
            .equ    tab, 9

            .section    const, "a"
ttlStr:     .asciz      "Listing 9-9"
fmtStr1:    .asciz      "fmtOut: value=%19zd, string='%s'\n"
    
            
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
            jmp     allDone3

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
            
allDone3:   movb    $0, (rdi)
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

# uSize-
#  Determines how many character positions it will take
# to hold a 64-bit numeric-to-string conversion.
# VERY brute-force algorithm. Just compares the value
# in RAX against 18 powers of 10 to determine if there
# are 1-19 digits in the number. 
#
# Input
#   RAX-    Number to check
#
# Returns-
#   RAX-    Number of character positions required.

dig2:       .quad   10
dig3:       .quad   100
dig4:       .quad   1000
dig5:       .quad   10000
dig6:       .quad   100000
dig7:       .quad   1000000
dig8:       .quad   10000000
dig9:       .quad   100000000
dig10:      .quad   1000000000
dig11:      .quad   10000000000
dig12:      .quad   100000000000
dig13:      .quad   1000000000000
dig14:      .quad   10000000000000
dig15:      .quad   100000000000000
dig16:      .quad   1000000000000000
dig17:      .quad   10000000000000000
dig18:      .quad   100000000000000000
dig19:      .quad   1000000000000000000
dig20:      .quad   10000000000000000000

uSize:
            push    rdx
            cmp     dig10, rax
            jae     ge10
            cmp     dig5, rax
            jae     ge5
            mov     $4, edx
            cmp     dig4, rax
            jae     allDone
            dec     edx
            cmp     dig3, rax
            jae     allDone
            dec     edx
            cmp     dig2, rax
            jae     allDone
            dec     edx
            jmp     allDone
            
ge5:        mov     $9, edx
            cmp     dig9, rax
            jae     allDone
            dec     edx
            cmp     dig8, rax
            jae     allDone
            dec     edx
            cmp     dig7, rax
            jae     allDone
            dec     edx
            cmp     dig6, rax
            jae     allDone
            dec     edx         #Must be 5
            jmp     allDone
            
            
ge10:       cmp     dig14, rax
            jae     ge14
            mov     $13, edx
            cmp     dig13, rax
            jae     allDone
            dec     edx
            cmp     dig12, rax
            jae     allDone
            dec     edx
            cmp     dig11, rax
            jae     allDone
            dec     edx         #Must be 10
            jmp     allDone
            
ge14:       mov     $20, edx
            cmp     dig20, rax
            jae     allDone
            dec     edx
            cmp     dig19, rax
            jae     allDone
            dec     edx
            cmp     dig18, rax
            jae     allDone
            dec     edx
            cmp     dig17, rax
            jae     allDone
            dec     edx
            cmp     dig16, rax
            jae     allDone
            dec     edx
            cmp     dig15, rax
            jae     allDone
            dec     edx     #Must be 14             


allDone:    mov     rdx, rax        #Return digit count
            pop     rdx
            ret



# iSize-
#  Determines the number of print positions required by
# a 64-bit signed integer.

iSize:
            test    rax, rax
            js      isNeg

            jmp     uSize   # Effectively a call and ret

# If the number is negative, negate it, call uSize,
# and then bump the size up by 1 (for the '-' character)
            
isNeg:      neg     rax
            call    uSize
            inc     rax
            ret



# utoStrSize-
#   Converts an unsigned integer to a formatted string
# having at least "minDigits" character positions.
# If the actual number of digits is smaller than
# "minDigits" then this procedure inserts encough
# "pad" characters to extend the size of the string.
#
# Inputs:
#   RAX -   Number to convert to string
#   CL-     minDigits (minimum print positions)
#   CH-     Padding character
#   RDI -   Buffer pointer for output string

utoStrSize:
            push    rcx
            push    rdi
            push    rax
            
            call    uSize       #Get actual number of digits
            sub     al, cl      #>= the minimum size?
            jbe     justConvert
            
            
# If the minimum size is greater than the number of actual
# digits, we need to emit padding characters here.
#
# Note that this code used "sub" rather than "cmp" above.
# As a result, CL now contains the number of padding
# characters to emit to the string (CL is always positive
# at this point, as negative and zero results would have
# branched to justConvert).

padLoop:    mov     ch, (rdi)
            inc     rdi
            dec     cl
            jne     padLoop

# Okay, any necessary padding characters have already been
# added to the string. Call utostr to convert the number
# to a string and append to the buffer:

justConvert:
            mov     (rsp), rax      #Retrieve original value
            call    utoStr
            
            pop     rax
            pop     rdi
            pop     rcx
            ret


# itoStrSize-
#   Converts a signed integer to a formatted string
# having at least "minDigits" character positions.
# If the actual number of digits is smaller than
# "minDigits" then this procedure inserts encough
# "pad" characters to extend the size of the string.
#
# Inputs:
#   RAX -   Number to convert to string
#   CL-     minDigits (minimum print positions)
#   CH-     Padding character
#   RDI -   Buffer pointer for output string

itoStrSize:
            push    rcx
            push    rdi
            push    rax
            
            call    iSize   #Get actual number of digits
            sub     al, cl  #>= the minimum size?
            jbe     justConvert2
            
# If the minimum size is greater than the number of actual
# digits, we need to emit padding characters here.
#
# Note that this code used "sub" rather than "cmp" above.
# As a result, CL now contains the number of padding
# characters to emit to the string (CL is always positive
# at this point, as negative and zero results would have
# branched to justConvert).

padLoop2:   mov     ch, (rdi)
            inc     rdi
            dec     cl
            jne     padLoop2

# Okay, any necessary padding characters have already been
# added to the string. Call utostr to convert the number
# to a string and append to the buffer:

justConvert2:
            mov     (rsp), rax      #Retrieve original value
            call    itoStr
            
            pop     rax
            pop     rdi
            pop     rcx
            ret

            
# Here is the "asmMain" function.

        
            .global asmMain                             
asmMain:
            push    rbp
            mov     rsp, rbp

            
# Because the functions all preserve RDI, we only need
# to do this once:

            lea     buffer, rdi
            
            mov     $1, rax
            mov     $19, cl
            mov     $'0', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $1, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $12, rax
            mov     $19, cl
            mov     $'.', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $12, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $123, rax
            mov     $19, cl
            mov     $'+', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $123, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $1234, rax
            mov     $19, cl
            mov     $'*', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $1234, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $12345, rax
            mov     $19, cl
            mov     $'$', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $12345, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $123456, rax
            mov     $19, cl
            mov     $'_', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $123456, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $1234567, rax
            mov     $19, cl
            mov     $'-', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $1234567, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $12345678, rax
            mov     $19, cl
            mov     $'@', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $12345678, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $123456789, rax
            mov     $19, cl
            mov     $' ', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $123456789, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $1234567890, rax
            mov     $19, cl
            mov     $' ', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $1234567890, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $12345678901, rax
            mov     $19, cl
            mov     $' ', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $12345678901, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $123456789012, rax
            mov     $19, cl
            mov     $' ', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $123456789012, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $1234567890123, rax
            mov     $19, cl
            mov     $' ', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $1234567890123, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $12345678901234, rax
            mov     $19, cl
            mov     $' ', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $12345678901234, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $123456789012345, rax
            mov     $19, cl
            mov     $' ', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $123456789012345, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $1234567890123456, rax
            mov     $19, cl
            mov     $' ', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $1234567890123456, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $12345678901234567, rax
            mov     $19, cl
            mov     $' ', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $12345678901234567, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $123456789012345678, rax
            mov     $19, cl
            mov     $' ', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $123456789012345678, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
            
            lea     buffer, rdi
            mov     $1234567890123456789, rax
            mov     $19, cl
            mov     $' ', ch
            call    utoStrSize
            
            lea     fmtStr1, rdi
            mov     $1234567890123456789, rsi
            lea     buffer, rdx
            mov     $0, al
            call    printf
                     
            leave
            ret     #Returns to caller

