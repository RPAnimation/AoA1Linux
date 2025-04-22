# Listing 9-19
#
# Real string to floating-point conversion
#
#   $build listing9-19
#   $listing9-19
#
# or
#
#   $gcc -o listing9-19 -fno-pie -no-pie c.cpp listing9-19.s -lstdc++
#   $listing9-19



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.
            
            .equ    false, 0
            .equ    true, 1
            
            .equ    tab, 9

            .section    const, "a"
ttlStr:      .asciz     "Listing 9-19"
fmtStr1:    .asciz      "strToR10: str='%s', value=%e\n"
           
fStr1a:     .asciz      "1.234e56"
fStr1b:     .asciz      "-1.234e56"
fStr1c:     .asciz      "1.234e-56"
fStr1d:     .asciz      "-1.234e-56"
fStr2a:     .asciz      "1.23"
fStr2b:     .asciz      "-1.23"
fStr3a:     .asciz      "1"
fStr3b:     .asciz      "-1"
fStr4a:     .asciz      "0.1"
fStr4b:     .asciz      "-0.1"
fStr4c:     .asciz      "0000000.1"
fStr4d:     .asciz      "-0000000.1"
fStr4e:     .asciz      "0.1000000"
fStr4f:     .asciz      "-0.1000000"
fStr4g:     .asciz      "0.0000001"
fStr4h:     .asciz      "-0.0000001"
fStr4i:     .asciz      ".1"
fStr4j:     .asciz      "-.1"

values:     .quad   fStr1a 
            .quad   fStr1b, fStr1c, fStr1d
            .quad   fStr2a, fStr2b
            .quad   fStr3a, fStr3b
            .quad   fStr4a, fStr4b, fStr4c, fStr4d
            .quad   fStr4e, fStr4f, fStr4g, fStr4h
            .quad   fStr4i, fStr4j
            .quad   0, 0




                                                                        
#PotTbl      real10  1.0e+4096,                                         
#                    1.0e+2048,                                         
#                    1.0e+1024,                                         
#                    1.0e+512,                                          
#                    1.0e+256,                                          
#                    1.0e+128,                                          
#                    1.0e+64,                                           
#                    1.0e+32,                                           
#                    1.0e+16,                                           
#                    1.0e+8,                                            
#                    1.0e+4,                                            
#                    1.0e+2,                                            
#                    1.0e+1,                                            
#                    1.0e+0
                    

            .balign 8
PotTbl:     .byte   0x9b,0x97,0x20,0x8a,0x02,0x52,0x60,0xc4,0x25,0x75   
            .byte   0xe5,0x5d,0x3d,0xc5,0x5d,0x3b,0x8b,0x9e,0x92,0x5a   
            .byte   0x17,0x0c,0x75,0x81,0x86,0x75,0x76,0xc9,0x48,0x4d   
            .byte   0xc7,0x91,0x0e,0xa6,0xae,0xa0,0x19,0xe3,0xa3,0x46   
            .byte   0x8e,0xde,0xf9,0x9d,0xfb,0xeb,0x7e,0xaa,0x51,0x43   
            .byte   0xe0,0x8c,0xe9,0x80,0xc9,0x47,0xba,0x93,0xa8,0x41   
            .byte   0xd5,0xa6,0xcf,0xff,0x49,0x1f,0x78,0xc2,0xd3,0x40   
            .byte   0x9e,0xb5,0x70,0x2b,0xa8,0xad,0xc5,0x9d,0x69,0x40   
            .byte   0x00,0x00,0x00,0x04,0xbf,0xc9,0x1b,0x8e,0x34,0x40   
            .byte   0x00,0x00,0x00,0x00,0x00,0x20,0xbc,0xbe,0x19,0x40   
            .byte   0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x9c,0x0c,0x40   
            .byte   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xc8,0x05,0x40   
            .byte   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xa0,0x02,0x40   
            .byte   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xff,0x3f   
            .equ    sizeofPotTblP, (14*10)
                    

            .data
r8Val:      .double 0.0
rTemp:      .double 0.0
            
            .text
            .extern printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



# Used for debugging:

print:
            push    rdi
            push    rsi
            push    rdx
            push    rcx
            push    r8
            push    r9
            push    r10
            push    r11
            push    rax
            push    rbp
            mov     rsp, rbp
            and     $-16, rsp       
            
# Get the pointer to the string immediately following the
# call instruction and scan for the zero-terminating byte.
            
            mov     80(rbp), rdi     #Return address is here
            lea     -1(rdi), rsi     #rsi = return address - 1
search4_0:  inc     rsi              #Move on to next char
            cmpb    $0, (rsi)        #At end of string?
            jne     search4_0
            
# Fix return address and compute length of string:

            inc     rsi               #Point at new return address
            mov     rsi, 80(rbp)      #Save return address
            
# Call Write to print the string to the console

            mov     64(rbp), rsi
            mov     56(rbp), rdx
            mov     48(rbp), rcx
            mov     40(rbp), r8
            mov     32(rbp), r9
            mov     8(rbp), al
            call    printf
    
xit:            leave
            pop     rax
            pop     r11
            pop     r10
            pop     r9
            pop     r8
            pop     rcx
            pop     rdx
            pop     rsi
            pop     rdi                     
            ret



#*********************************************************
#                                                         
# strToR10-                                                   
#                                                         
# RSI points at a string of characters that represent a   
# floating point value.  This routine converts that string
# to the corresponding FP value and leaves the result on  
# the top of the FPU stack.  On return, ESI points at the 
# first character this routine couldn't convert.          
#                                                         
# Like the other ATOx routines, this routine raises an    
# exception if there is a conversion error or if ESI      
# contains NULL.                                          
#                                                         
#*********************************************************



            .equ    DigitStr, -24
            .equ    BCDValue, -34
            .equ    rsiSave, -44


strToR10:
            push    rbp                                                 
            mov     rsp, rbp                                            
            sub     $44, rsp                                            
            and     $-16, rsp                                           
            push    rbx                                                 
            push    rcx                                                 
            push    rdx                                                 
            push    r8                                                  
            push    rax                                                 
                                                                        
                                                                        
# Verify that RSI is not NULL.                                          
                                                                        
            test    rsi, rsi                                            
            jz      refNULL                                             
                                                                        
# Zero out the DigitStr and BCDValue arrays.                            
                                                                        
            xor     rax, rax                                            
            mov     rax, DigitStr(rbp)                                  
            mov     rax, DigitStr+8(rbp)                                
            mov     rax, DigitStr+16(rbp)                               
                                                                        
            mov     rax, BCDValue(rbp)                                  
            mov     ax, BCDValue+8(rbp)                                 
                                                                        
# Skip over any leading space or tab characters in the sequence.        
                                                                        
            dec     rsi                                                 
whileDelimLoop:                                                         
            inc     rsi                                                 
            mov     (rsi), al                                           
            cmp     $' ', al                                            
            je      whileDelimLoop                                      
            cmp     $tab, al                                            
            je      whileDelimLoop                                      
                                                                        
                                                                        
                                                                        
# Check for + or -                                                      
                                                                        
            cmp     $'-', al                                            
            sete    cl                                                  
            je      doNextChar                                          
            cmp     $'+', al                                            
            jne     notPlus                                             
doNextChar: inc     rsi             # Skip the '+' or '-'               
            mov     (rsi), al
                                                                        
notPlus:                                                                
                                                                        
# Initialize edx with -18 since we have to account                      
# for BCD conversion (which generates a number *10^18 by                
# default). EDX holds the value's decimal exponent.                     
                                                                        
            mov     $-18, rdx                                           
                                                                        
# Initialize ebx with 18, the number of significant                     
# digits left to process and also the index into the                    
# DigitStr array.                                                       
                                                                        
            mov     $18, ebx         #Zero extends!                     
                                                                        
# At this point we're beyond any leading sign character.                
# Therefore, the next character must be a decimal digit                 
# or a decimal point.
                                                                        
            mov     rsi, rsiSave(rbp)    # Save to look ahead 1 digit.  
            cmp     $'.', al                                            
            jne     notPeriod
                                                                        
# If the first character is a decimal point, then the                   
# second character needs to be a decimal digit.                         
                                                                        
            inc     rsi                                                 
            mov     (rsi), al                                           
                                                                        
notPeriod:                                                              
            cmp     $'0', al                                            
            jb      convError                                           
            cmp     $'9', al                                            
            ja      convError                                           
            mov     rsiSave(rbp), rsi    # Go back to orig char         
            mov     (rsi), al                                           
            jmp     testWhlAL0
                                                                        
# Eliminate any leading zeros (they do not affect the value or          
# the number of significant digits).                                    
                                                                        
                                                                        
whileAL0:   inc     rsi                                                 
            mov     (rsi), al                                           
testWhlAL0: cmp     $'0', al                                            
            je      whileAL0                                            
                                                                        
# If we're looking at a decimal point, we need to get rid of the        
# zeros immediately after the decimal point since they don't            
# count as significant digits.  Unlike zeros before the decimal         
# point, however, these zeros do affect the number's value as           
# we must decrement the current exponent for each such zero.            
                                                                        
            cmp     $'.', al                                            
            jne     testDigit                                           
                                                                        
            inc     edx     #Counteract dec below                       
repeatUntilALnot0:                                                      
            dec     edx                                                 
            inc     rsi                                                 
            mov     (rsi), al                                           
            cmp     $'0', al                                            
            je      repeatUntilALnot0                                   
            jmp     testDigit2                                          
                                                                        
                                                                        
# If we didn't encounter a decimal point after removing leading         
# zeros, then we've got a sequence of digits before a decimal           
# point.  Process those digits here.                                    
#                                                                       
# Each digit to the left of the decimal point increases                 
# the number by an additional power of ten.  Deal with                  
# that here.                                                            
                                                                        
whileADigit:                                                            
            inc     edx     
                                                                        
# Save all the significant digits, but ignore any digits                
# beyond the 18th digit.                                                
                                                                        
            test    ebx, ebx                                            
            jz      Beyond18                                            
                                                                        
            mov     al, DigitStr(rbp,rbx)                               
            dec     ebx                                                 
                                                                        
Beyond18:   inc     rsi                                                 
            mov     (rsi), al                                           
                                                                        
testDigit:                                                              
            sub     $'0', al                                            
            cmp     $10, al                                             
            jb      whileADigit
                                                                        
            cmp     $'.'-'0', al                                        
            jne     testDigit2
                                                                        
            inc     rsi             # Skip over decimal point.          
            mov     (rsi), al                                           
            jmp     testDigit2                                          
                                                                        
# Okay, process any digits to the right of the decimal point.           
                                                                        
                                                                        
whileDigit2:                                                            
            test    ebx, ebx                                            
            jz      Beyond18_2                                          
                                                                        
            mov     al, DigitStr(rbp,rbx)                               
            dec     ebx                                                 
                                                                        
Beyond18_2: inc     rsi                                                 
            mov     (rsi), al                                           
                                                                        
testDigit2: sub     $'0', al                                            
            cmp     $10, al                                             
            jb      whileDigit2 
            

# At this point, we've finished processing the mantissa.                
# Now see if there is an exponent we need to deal with.
                                                                        
            mov     (rsi), al                                           
            cmp     $'E', al                                            
            je      hasExponent                                         
            cmp     $'e', al                                            
            jne     noExponent                                          
                                                                        
hasExponent:                                                            
            inc     rsi                                                 
            mov     (rsi), al       # Skip the "E".                     
            cmp     $'-', al                                            
            sete    ch                                                  
            je      doNextChar_2                                        
            cmp     $'+', al                                            
            jne     getExponent                                         
                                                                        
doNextChar_2:                                                           
            inc     rsi             #Skip '+' or '-'                    
            mov     (rsi), al                                           
                                                                        
                                                                        
# Okay, we're past the "E" and the optional sign at this                
# point.  We must have at least one decimal digit.                      
                                                                        
getExponent:                                                            
            sub     $'0', al                                            
            cmp     $10, al                                             
            jae     convError                                           
                                                                        
            xor     ebx, ebx        # Compute exponent value in ebx.    
ExpLoop:    movzbl  (rsi), eax      #Zero extends to rax!               
            sub     $'0', al                                            
            cmp     $10, al                                             
            jae     ExpDone                                             
                                                                        
            imull   $10, ebx                                            
            add     eax, ebx                                            
            inc     rsi                                                 
            jmp     ExpLoop                                             
                                                                        
                                                                        
# If the exponent was negative, negate our computed result.             
                                                                        
ExpDone:                                                                
            cmp     $false, ch                                          
            je      noNegExp                                            
                                                                        
            neg     ebx                                                 
                                                                        
noNegExp:
                                                                        
# Add in the BCD adjustment (remember, values in DigitStr, when         
# loaded into the FPU, are multiplied by 10^18 by default.              
# The value in edx adjusts for this).                                   
                                                                        
            add     ebx, edx                                            
                                                                        
noExponent:                                                             
                                                                        
# verify that the exponent is between -4930..+4930 (which               
# is the maximum dynamic range for an 80-bit FP value).
                                                                        
            cmp     $4930, edx                                          
            jg      voor            # Value out of range                
            cmp     $-4930, edx                                         
            jl      voor                                                
                                                                        
                                                                        
# Now convert the DigitStr variable (unpacked BCD) to a packed          
# BCD value.
                                                                        
            mov     $8, r8                                              
for8:       mov     DigitStr+2(rbp,r8,2), al                            
            shl     $4, al                                              
            or      DigitStr+1(rbp,r8,2), al                            
            mov     al, BCDValue(rbp,r8)
            
            dec     r8                                                  
            jns     for8
                                                                        
            fbld    BCDValue(rbp)
                                                                                    
                                        
                                                                        
                                                                        
# Okay, we've got the mantissa into the FPU.  Now multiply the          
# Mantissa by 10 raised to the value of the computed exponent           
# (currently in edx).                                                   
#                                                                       
# This code uses power of 10 tables to help make the                    
# computation a little more accurate.                                   
#                                                                       
# We want to determine which power of ten is just less than the         
# value of our exponent.  The powers of ten we are checking are         
# 10**4096, 10**2048, 10**1024, 10**512, etc.  A slick way to           
# do this check is by shifting the bits in the exponent                 
# to the left.  Bit #12 is the 4096 bit.  So if this bit is set,        
# our exponent is >= 10**4096.  If not, check the next bit down         
# to see if our exponent >= 10**2048, etc.
                                                                        
            mov     $-10, ebx   # Initial index into power of ten table.
            test    edx, edx                                            
            jns     positiveExponent                                    
                                                                        
# Handle negative exponents here.                                       
                                                                        
            neg     edx                                                 
            shl     $19, edx    # Bits 0..12 -> 19..31                  
            lea     PotTbl, r8                                          
whileEDXne0:                                                            
            add     $10, ebx                                            
            shl     $1, edx                                             
            jnc     testEDX0                                            
                                                                        
            fldt    (r8, rbx)                                           
            fdivrp                                                      
                                                                        
testEDX0:   test    edx, edx                                            
            jnz     whileEDXne0                                         
            jmp     doMantissaSign

                                                                        
# Handle positive exponents here.                                       
                                                                        
positiveExponent:                                                       
            lea     PotTbl, r8                                          
            shl     $19, edx    # Bits 0..12 -> 19..31.                 
            jmp     testEDX0_2
                                                                        
whileEDXne0_2:                                                          
            add     $10, ebx                                            
            shl     $1, edx                                             
            jnc     testEDX0_2                                          
                                                                        
            fldt    (r8, rbx)                                           
            fmulp
                                                                                    
testEDX0_2:
            test    edx, edx                                            
            jnz     whileEDXne0_2

                                                                        
# If the mantissa was negative, negate the result down here.
                                                                        
doMantissaSign:                                                         
            cmp     $false, cl                                          
            je      mantNotNegative                                     
                                                                        
            fchs                                                        
                                                                        
mantNotNegative:                                                        
            clc             #Indicate Success                           
            jmp     Exit    
                                                                        
refNULL:    mov     $-3, rax                                            
            jmp     ErrorExit
                                                                        
convError:  mov     $-2, rax                                            
            jmp     ErrorExit
                                                                        
voor:       mov     $-1, rax #Value out of range                        
            jmp     ErrorExit
                                                                        
illChar:    mov     $-4, rax
                                                                        
ErrorExit:  stc                     #Indicate failure                   
            mov     rax, (rsp)      #Save error code                    
Exit:       pop     rax                                                 
            pop     r8                                                  
            pop     rdx                                                 
            pop     rcx                                                 
            pop     rbx                                                 
            leave                                                       
            ret

            
                    
            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbx
            push    rsi
            push    rbp
            mov     rsp, rbp
            

# Test floating-point conversion:
            
            lea     values, rbx
ValuesLp:   cmpq    $0, (rbx)
            je      allDone
            

            
            mov     (rbx), rsi
            call    strToR10
            fstpl   r8Val
            
            lea     fmtStr1, rdi
            mov     (rbx), rsi
            movsd   r8Val, xmm0
            mov     $1, al
            call    printf

            add     $8, rbx
            jmp     ValuesLp            
 

             
allDone:    leave
            pop     rsi
            pop     rbx
            ret     #Returns to caller


