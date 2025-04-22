# Listing 9-14
#
# String to numeric conversion
#
#   $build listing9-14
#   $listing9-14
#
# or
#
#   $gcc -o listing9-14 -fno-pie -no-pie c.cpp listing9-14.s -lstdc++
#   $listing9-14



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.
            
            .equ    false, 0
            .equ    true, 1
            
            .equ    tab, 9

            .section    const, "a"
ttlStr:     .asciz      "Listing 9-14"
fmtStr1:    .ascii      "strtou: String='%s'\n"
            .asciz      "    value=%zu\n"
            
fmtStr2:    .ascii      "Overflow: String='%s'\n"
            .asciz      "    value=%zx\n"
            
fmtStr3:    .ascii      "strtoi: String='%s'\n"
            .asciz      "    value=%zi\n"
                    
unexError:  .asciz      "Unexpected error in program\n"
            
value1:     .asciz      "  1"
value2:     .asciz      "12 "
value3:     .asciz      " 123 "
value4:     .asciz      "1234"
value5:     .asciz      "1234567890123456789"
value6:     .asciz      "18446744073709551615"
OFvalue:    .asciz      "18446744073709551616"
OFvalue2:   .asciz      "999999999999999999999"
            
ivalue1:    .asciz      "  -1"
ivalue2:    .asciz      "-12 "
ivalue3:    .asciz      " -123 "
ivalue4:    .asciz      "-1234"
ivalue5:    .asciz      "-1234567890123456789"
ivalue6:    .asciz      "-9223372036854775807"
OFivalue:   .asciz      "-9223372036854775808"
OFivalue2:  .asciz      "-999999999999999999999"

ten:        .quad       10
tooBig:     .quad       0x7fffffffffffffff

            
            .data
buffer:     .fill       30, 1, 0
            
            .text
            .extern     printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret




# strtou-
#  Converts string data to a 64-bit unsigned integer.
#
# Input-
#   RDI-    Pointer to buffer containing string to convert
#
# Output-
#   RAX-    Contains converted string (if success), error code
#           if an error occurs.
#
#   RDI-    Points at first char beyond end of numeric string.
#           If error, RDI's value is restored to original value.
#           Caller can check character at [RDI] after a
#           successful result to see if the character following
#           the numeric digits is a legal numeric delimiter.
#
#   C       (carry flag) Set if error occurs, clear if
#           conversion was successful. On error, RAX will
#           contain 0 (illegal initial character) or
#           0ffffffffffffffffh (overflow).

strtou:                                                             
            push    rdi      #In case we have to restore RDI        
            push    rdx      #Munged by mul                         
            push    rcx      #Holds input char                      
                                                                    
            xor     edx, edx #Zero extends!                         
            xor     eax, eax #Zero extends!                         
                                                                    
# The following loop skips over any whitespace (spaces and          
# tabs) that appear at the beginning of the string.                 

            dec     rdi      #Because of inc below.                 
skipWS2:    inc     rdi                                             
            mov     (rdi), cl                                       
            cmp     $' ', cl                                        
            je      skipWS2                                         
            cmp     $tab, al                                        
            je      skipWS2                                         
                                                                    
# If we don't have a numeric digit at this point,                   
# return an error.                                                  

            cmp     $'0', cl    #Note: '0' < '1' < ... < '9'        
            jb      badNumber                                       
            cmp     $'9', cl                                        
            ja      badNumber                                       
                                                                    
# Okay, the first digit is good. Convert the string                 
# of digits to numeric form:                                        

convert:    and     $0xf, ecx   #Convert to numeric in RCX          
            mulq    ten         #Accumulator *= 10                  
            jc      overflow                                        
            add     rcx, rax    #Accumulator += digit               
            jc      overflow                                        
            inc     rdi         #Move on to next character          
            mov     (rdi), cl                                       
            cmp     $'0', cl                                        
            jb      endOfNum                                        
            cmp     $'9', cl                                        
            jbe     convert                                         

# If we get to this point, we've successfully converted             
# the string to numeric form:                                       

endOfNum:   pop     rcx                                             
            pop     rdx                                             
                                                                    
# Because the conversion was successful, this procedure             
# leaves RDI pointing at the first character beyond the             
# converted digits. As such, we don't restore RDI from              
# the stack. Just bump the stack pointer up by 8 .ascizs            
# to throw away RDI's saved value.                                  

            add     $8, rsp                                         
            clc              #Return success in carry flag          
            ret                                                     
                                                                    
# badNumber- Drop down here if the first character in               
#            the string was not a valid digit.                      

badNumber:  mov     $0, rax                                         
            pop     rcx                                             
            pop     rdx                                             
            pop     rdi                                             
            stc              #Return error in carry flag            
            ret                                                     
                                                                    
overflow:   mov     $-1, rax #0FFFFFFFFFFFFFFFFh                    
            pop     rcx                                             
            pop     rdx                                             
            pop     rdi                                             
            stc              #Return error in carry flag            
            ret                                                     
                    
                    



# strtoi-
#  Converts string data to a 64-bit signed integer.
#
# Input-
#   RDI-    Pointer to buffer containing string to convert
#
# Output-
#   RAX-    Contains converted string (if success), error code
#           if an error occurs.
#
#   RDI-    Points at first char beyond end of numeric string.
#           If error, RDI's value is restored to original value.
#           Caller can check character at [RDI] after a
#           successful result to see if the character following
#           the numeric digits is a legal numeric delimiter.
#
#   C       (carry flag) Set if error occurs, clear if
#           conversion was successful. On error, RAX will
#           contain 0 (illegal initial character) or
#           0ffffffffffffffffh (overflow).


strtoi:
            
            push    rdi      #In case we have to restore RDI
            sub     $8, rsp
                        
# Assume we have a non-negative number.

            movb    $false, (rsp)

            
# The following loop skips over any whitespace (spaces and
# tabs) that appear at the beginning of the string.

            dec     rdi      #Because of inc below.
skipWS:     inc     rdi
            mov     (rdi), al
            cmp     $' ', al
            je      skipWS
            cmp     $tab, al
            je      skipWS
            
# If the first character we've encountered is '-',
# then skip it, but remember that this is a negative
# number.

            cmp     $'-', al
            jne     notNeg
            movb    $true, (rsp)
            inc     rdi                 #Skip '-'
            
notNeg:     call    strtou              #Convert string to integer
            jc      hadError
            
# strtou returned success. Check the negative flag and
# negate the input if the flag contains true.

            cmpb    $true, (rsp)
            jne     itsPosOr0
            
            cmp     tooBig, rax         #number is too big
            ja      overflow2
            neg     rax
itsPosOr0:  add     $16, rsp            #Success, so don't restore RDI
            clc                         #Return success in carry flag
            ret

# If we have an error, we need to restore RDI from the stack

overflow2:  mov     $-1, rax            #Indicate overflow      
hadError:   add     $8, rsp             #Remove locals
            pop     rdi
            stc             #Return error in carry flag
            ret 
            

            
                    
            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rbp, rsp
            

# Test unsigned conversions:
            
            lea     value1, rdi
            call    strtou
            jc      UnexpectedError
            
            lea     fmtStr1, rdi
            lea     value1, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     value2, rdi
            call    strtou
            jc      UnexpectedError
            
            lea     fmtStr1, rdi
            lea     value2, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     value3, rdi
            call    strtou
            jc      UnexpectedError
            
            lea     fmtStr1, rdi
            lea     value3, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     value4, rdi
            call    strtou
            jc      UnexpectedError
            
            lea     fmtStr1, rdi
            lea     value4, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     value5, rdi
            call    strtou
            jc      UnexpectedError
            
            lea     fmtStr1, rdi
            lea     value5, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     value6, rdi
            call    strtou
            jc      UnexpectedError
            
            lea     fmtStr1, rdi
            lea     value6, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     OFvalue, rdi
            call    strtou
            jnc     UnexpectedError
            test    rax, rax            #Non-zero for overflow
            jz      UnexpectedError
            
            lea     fmtStr2, rdi
            lea     OFvalue, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     OFvalue2, rdi
            call    strtou
            jnc     UnexpectedError
            test    rax, rax            #Non-zero for overflow
            jz      UnexpectedError
            
            lea     fmtStr2, rdi
            lea     OFvalue2, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
# Test signed conversions:
            
            lea     ivalue1, rdi
            call    strtoi
            jc      UnexpectedError
            
            lea     fmtStr3, rdi
            lea     ivalue1, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     ivalue2, rdi
            call    strtoi
            jc      UnexpectedError
            
            lea     fmtStr3, rdi
            lea     ivalue2, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     ivalue3, rdi
            call    strtoi
            jc      UnexpectedError
            
            lea     fmtStr3, rdi
            lea     ivalue3, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     ivalue4, rdi
            call    strtoi
            jc      UnexpectedError
            
            lea     fmtStr3, rdi
            lea     ivalue4, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     ivalue5, rdi
            call    strtoi
            jc      UnexpectedError
            
            lea     fmtStr3, rdi
            lea     ivalue5, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     ivalue6, rdi
            call    strtoi
            jc      UnexpectedError
            
            lea     fmtStr3, rdi
            lea     ivalue6, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     OFivalue, rdi
            call    strtoi
            jnc     UnexpectedError
            test    rax, rax        #Non-zero for overflow
            jz      UnexpectedError
            
            lea     fmtStr2, rdi
            lea     OFivalue, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
 
            lea     OFivalue2, rdi
            call    strtoi
            jnc     UnexpectedError
            test    rax, rax        #Non-zero for overflow
            jz      UnexpectedError
            
            lea     fmtStr2, rdi
            lea     OFivalue2, rsi
            mov     rax, rdx
            mov     $0, al
            call    printf
            
            jmp     allDone

UnexpectedError:
            lea     unexError, rdi
            mov     $0, al
            call    printf

             
allDone:    leave
            ret     #Returns to caller

