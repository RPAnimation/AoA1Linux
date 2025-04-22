# Listing 9-15
#
# Hexadecimal string to numeric conversion
#
#   $build listing9-15
#   $listing9-15
#
# or
#
#   $gcc -o listing9-15 -fno-pie -no-pie c.cpp listing9-15.s -lstdc++
#   $listing9-15



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.
            
            .equ    false, 0
            .equ    true, 1
            
            .equ    tab, 9

            .section    const, "a"
ttlStr:     .asciz      "Listing 9-15"
fmtStr1:    .ascii      "strtoh: String='%s' "
            .asciz      "value=%zx\n"
           
fmtStr2:    .asciz      "Error, RAX=%zx, str='%s'\n" 
fmtStr3:    .ascii      "Error, expected overflow: RAX=%zx, "
            .asciz      "str='%s'\n"
             
fmtStr4:    .ascii      "Error, expected bad char: RAX=%zx, "
            .asciz      "str='%s'\n" 

hexStr:     .asciz      "1234567890abcdef"
hexStrOVFL: .asciz      "1234567890abcdef0"
hexStrBAD:  .asciz      "x123"

            
            .text
            .extern     printf
            
# Return program title to C++ program:

            .global     getTitle
getTitle:
            lea     ttlStr, rax
            ret





# strtoh-
#  Converts string data to a 64-bit unsigned integer.
#
# Input-
#   RDI-    Pointer to buffer containing string to convert
#
# Output-
#   RAX-    Contains converted string (if success), error code
#           if an error occurs.
#
#   RDI-    Points at first char beyond end of hexadecimal string.
#           If error, RDI's value is restored to original value.
#           Caller can check character at [RDI] after a
#           successful result to see if the character following
#           the numeric digits is a legal numeric delimiter.
#
#   C       (carry flag) Set if error occurs, clear if
#           conversion was successful. On error, RAX will
#           contain 0 (illegal initial character) or
#           0ffffffffffffffffh (overflow).

strtoh:
            push    rcx      #Holds input char
            push    rdx      #Special mask value
            push    rdi      #In case we have to restore RDI

# This code will use the value in RDX to test and see if overflow
# will occur in RAX when shifting to the left 4 bits:
            
            mov     $0xF000000000000000, rdx
            xor     eax, eax #Zero out accumulator.
                        
# The following loop skips over any whitespace (spaces and
# tabs) that appear at the beginning of the string.

            dec     rdi      #Because of inc below.
skipWS:     inc     rdi
            mov     (rdi), cl
            cmp     $' ', cl
            je      skipWS
            cmp     $tab, al
            je      skipWS
            
# If we don't have a hexadecimal digit at this point,
# return an error.

            cmpb    $'0', cl          #Note: '0' < '1' < ... < '9'
            jb      badNumber
            cmp     $'9', cl
            jbe     convert
            and     $0x5f, cl       #Cheesy LC->UC conversion
            cmp     $'A', cl
            jb      badNumber
            cmp     $'F', cl
            ja      badNumber
            sub     $7, cl          #Maps 41h..46h->3ah..3fh
            
# Okay, the first digit is good. Convert the string
# of digits to numeric form:

convert:    test    rax, rdx        #See if adding in the current
            jnz     overflow        # digit will cause an overflow
            
            and     $0xf, ecx       #Convert to numeric in RCX


# Multiple 64-bit accumulator by 16 and add in new digit:

            shl     $4, rax
            add     cl, al  #Never overflows outside LO 4 bits
                        
#Move on to next character

            inc     rdi      
            mov     (rdi), cl
            cmp     $'0', cl
            jb      endOfNum
            cmp     $'9', cl
            jbe     convert
            
            and     $0x5f, cl       #Cheesy LC->UC conversion
            cmp     $'A', cl
            jb      endOfNum
            cmp     $'F', cl
            ja      endOfNum
            sub     $7, cl          #Maps 41h..46h->3ah..3fh
            jmp     convert
            

# If we get to this point, we've successfully converted
# the string to numeric form:

endOfNum:
            
# Because the conversion was successful, this procedure
# leaves RDI pointing at the first character beyond the
# converted digits. As such, we don't restore RDI from
# the stack. Just bump the stack pointer up by 8 bytes
# to throw away RDI's saved value# must also remove

            add     $8, rsp  #Remove original RDI value
            pop     rdx      #Restore RDX
            pop     rcx      #Restore RCX
            clc              #Return success in carry flag
            ret
            
# badNumber- Drop down here if the first character in
#            the string was not a valid digit.

badNumber:  xor     rax, rax
            jmp     errorExit     

overflow:   or      $-1, rax #Return -1 as error on overflow
errorExit:  pop     rdi      #Restore RDI if an error occurs
            pop     rdx
            pop     rcx
            stc              #Return error in carry flag
            ret
                    



            
                    
            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp
                                

# Test hexadecimal conversion:
            
            lea     hexStr, rdi
            call    strtoh
            jc      error
            
            lea     fmtStr1, rdi
            lea     hexStr, rsi
            mov     rax, rdx
            call    printf
            
# Test overflow conversion:
            
            lea     hexStrOVFL, rdi
            call    strtoh
            jnc     unexpected
            
            lea     fmtStr2, rdi
            mov     rax, rsi
            lea     hexStrOVFL, rdx
            call    printf
            
# Test bad character:
            
            lea     hexStrBAD, rdi
            call    strtoh
            jnc     unexp2
            
            lea     fmtStr2, rdi
            mov     rax, rsi
            lea     hexStrBAD, rdx
            call    printf
            jmp     allDone
            
unexpected: lea     fmtStr3, rdi
            mov     rax, rsi
            lea     hexStrOVFL, rdx
            call    printf
            jmp     allDone
            
unexp2:     mov     rdi, rdx
            lea     fmtStr4, rdi
            mov     rax, rsi
            jmp     allDone
            
error:      mov     rdi, rdx
            lea     fmtStr2, rdi
            mov     rax, rsi
            call    printf
            
 

             
allDone:    leave
            ret     #Returns to caller

