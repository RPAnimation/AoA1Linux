; Listing 9-11
;
; 
; This was cut and pasted from Listing 9-10


#***********************************************************
#                                                           
# r10ToStr-                                                 
#                                                           
# Converts a REAL10 floating-point number to the       
# corresponding string of digits.  Note that this           
# function always emits the string using decimal            
# notation.  For scientific notation, use the e10ToBuf      
# routine.                                                  
#                                                           
# On Entry:                                                 
#                                                           
# r10-              Real10 value to convert.
#                   Passed in st0.                       
#                                                           
# fWidth-           Field width for the number (note that this   
#                   is an *exact* field width, not a minimum         
#                   field width).
#                   Passed in EAX (RAX).                                    
#                                                           
# decimalpts-       # of digits to display after the decimal pt.
#                   Passed in EDX (RDX). 
#                                                           
# fill-             Padding character if the number is smaller   
#                   than the specified field width.
#                   Passed in CL (RCX).                  
#                                                                            
# buffer-           r10ToStr stores the resulting characters in  
#                   this string.
#                   Address passed in RDI.
#
# maxLength-        Maximum string length.
#                   Passed in R8d (R8).                                     
#                                                                            
# On Exit:                                                  
#                                                           
# Buffer contains the newly formatted string.  If the       
# formatted value does not fit in the width specified,      
# r10ToStr will store "#" characters into this string.      
#                                                           
# Carry-    Clear if success, set if an exception occurs.                                                         
#           If width is larger than the maximum length of          
#           the string specified by buffer, this routine        
#           will return with the carry set and RAX=-1.                                             
#                                                           
#***********************************************************


r10ToStr:


# Local variables:

            .equ    fWidth, -8      #RAX: uns32
            .equ    decDigits, -16  #RDX: uns32
            .equ    fill, -24       #CL: char
            .equ    bufPtr, -32     #RDI: pointer
            .equ    exponent, -40   #uns32
            .equ    sign, -48       #char
            .equ    digits, -128    #char[80]

            push    rdi
            push    rbx
            push    rcx
            push    rdx
            push    rsi
            push    rax
            push    rbp
            mov     rsp, rbp
            sub     $128, rsp       #128 bytes of local vars


# First, make sure the number will fit into the 
# specified string.
            
            cmp     r8d, eax                             
            jae     strOverflow                          
            
            test    eax, eax                             
            jz      voor                                 

            mov     rdi, bufPtr(rbp)                     
            mov     rdx, decDigits(rbp)      
            mov     rcx, fill(rbp)                       
            mov     rax, fWidth(rbp)                 
           
#  If the width is zero, raise an exception:

            test    eax, eax
            jz      voor
            
# If the width is too big, raise an exception:

            cmp     fWidth(rbp), eax
            ja      badWidth        

# Okay, do the conversion. 
# Begin by processing the mantissa digits:
                    
            lea     digits(rbp), rdi        # Store result here.
            call    FPDigits                # Convert r80 to string.
            mov     eax, exponent(rbp)      # Save away exp result.
            mov     cl, sign(rbp)           # Save mantissa sign char.
            
# Round the string of digits to the number of significant 
# digits we want to display for this number:

            cmp     $17, eax
            jl      dontForceWidthZero

            xor     rax, rax                # If the exp is negative, or
                                            # too large, set width to 0.
dontForceWidthZero:
            mov     rax, rbx                # Really just 8 bits.
            add     decDigits(rbp), ebx     # Compute rounding position.
            cmp     $17, ebx
            jge     dontRound               # Don't bother if a big #.


# To round the value to the number of significant digits,
# go to the digit just beyond the last one we are considering
# (eax currently contains the number of decimal positions)
# and add 5 to that digit.  Propagate any overflow into the
# remaining digit positions.
                    
                    
            inc     ebx                     # Index+1 of last sig digit.
            mov     digits(rbp,rbx), al     # Get that digit.
            add     $5, al                  # Round (e.g., +0.5 ).
            cmp     $'9', al 
            jbe     dontRound

            movb    $'0'+10, digits(rbp,rbx) # Force to zero
whileDigitGT9:                               # (see sub 10 below).
            sub     $10, digits(rbp,rbx)    # Sub out overflow, 
            dec     ebx                     # carry, into prev
            js      hitFirstDigit           # digit (until 1st
                                            #  digit in the #).
            incb    digits(rbp,rbx)
            cmpb    $'9', digits(rbp,rbx)   # Overflow if > '9'.
            ja      whileDigitGT9
            jmp     dontRound
            
                                    
hitFirstDigit:
                                            
# If we get to this point, then we've hit the first
# digit in the number.  So we've got to shift all
# the characters down one position in the string of
# bytes and put a "1" in the first character position.
            
            mov     $17, ebx
repeatUntilEBXeq0:
            
            mov     digits(rbp,rbx), al
            mov     digits+1(rbp,rbx), al
            dec     ebx     
            jnz     repeatUntilEBXeq0
                    
            movb    $'1', digits(rbp) 
            incl    exponent(rbp)           # Because we added a digit.
                    
dontRound: 
                    
            
# Handle positive and negative exponents separately.

            mov     bufPtr(rbp), rdi        # Store the output here.
            cmp     $0, exponent(rbp)
            jge     positiveExponent

# Negative exponents:
# Handle values between 0 & 1.0 here (negative exponents
# imply negative powers of ten).
#
# Compute the number's width.  Since this value is between
# 0 & 1, the width calculation is easy: it's just the
# number of decimal positions they've specified plus three
# (since we need to allow room for a leading "-0.").
                    
            
            mov     decDigits(rbp), ecx
            add     $3, ecx 
            cmp     $4, ecx 
            jae     minimumWidthIs4

            mov     $4, ecx                 # Minimum possible width is four.

minimumWidthIs4:
            cmp     ecx, fWidth(rbp)
            ja      widthTooBig 
            
# This number will fit in the specified field width,
# so output any necessary leading pad characters.
            
            mov     fill(rbp), al
            mov     fWidth(rbp), edx
            sub     ecx, edx
            jmp     testWhileECXltWidth
            
            
whileECXltWidth:
            mov     al, (rdi)
            inc     rdi
            inc     ecx
testWhileECXltWidth:
            cmp     fWidth(rbp), ecx
            jb      whileECXltWidth
                            
# Output " 0." or "-0.", depending on the sign of the number.
            
            mov     sign(rbp), al
            cmp     $'-', al
            je      isMinus
                    
            mov     $' ', al
            
isMinus:    mov     al, (rdi)
            inc     rdi
            inc     edx
                    
            movw    $0x2e30, (rdi)      #".0"
            add     $2, rdi
            add     $2, edx
            
# Now output the digits after the decimal point:

            xor     ecx, ecx            # Count the digits in ecx.
            lea     digits(rbp), rbx    # Pointer to data to output.
                                    
# If the exponent is currently negative, or if
# we've output more than 18 significant digits,
# just output a zero character.
            
repeatUntilEDXgeWidth: 
            mov     $'0', al
            incl    exponent(rbp)
            js      noMoreOutput
            
            cmp     $18, ecx
            jge     noMoreOutput
            
            mov     (rbx), al
            inc     ebx
                    
noMoreOutput:
            mov     al, (rdi)
            inc     rdi
            inc     ecx
            inc     edx
            cmp     fWidth(rbp), edx
            jb      repeatUntilEDXgeWidth
            jmp     r10BufDone


# If the number's actual width was bigger than the width
# specified by the caller, emit a sequence of '#' characters
# to denote the error.
                            
widthTooBig:
            

# The number won't fit in the specified field width,
# so fill the string with the "#" character to indicate
# an error.
                    
                    
            mov     fWidth(rbp), ecx
            mov     $'#', al
fillPound:  mov     al, (rdi)
            inc     rdi
            dec     ecx
            jnz     fillPound
            jmp     r10BufDone

            
# Handle numbers with a positive exponent here.

positiveExponent:
            
# Compute # of digits to the left of the ".".
# This is given by:
#
#                   Exponent     # # of digits to left of "."
#           +       2            # Allow for sign and there
#                                # is always 1 digit left of "."
#           +       decimalpts   # Add in digits right of "."
#           +       1            # If there is a decimal point.
            

            mov     exponent(rbp), edx  # Digits to left of "."
            add     $2, edx             # 1 digit + sign posn.
            cmp     $0, decDigits(rbp)
            je      decPtsIs0

            add     decDigits(rbp), edx # Digits to right of "."
            inc     edx                 # Make room for the "."
            
decPtsIs0:
            
# Make sure the result will fit in the
# specified field width.
            
            cmp     fWidth(rbp), edx
            ja      widthTooBig
            
                    
# If the actual number of print positions
# is less than the specified field width,
# output leading pad characters here.
            
            cmp     fWidth(rbp), edx
            jae     noFillChars
            
            mov     fWidth(rbp), ecx
            sub     edx, ecx
            jz      noFillChars
            mov     fill(rbp), al
fillChars:  mov     al, (rdi)
            inc     rdi
            dec     ecx
            jnz     fillChars
                    
noFillChars:
            
            
# Output the sign character.
            
            mov     sign(rbp), al
            cmp     $'-', al
            je      outputMinus#
            
            mov     $' ', al
                    
outputMinus:
            mov     al, (rdi)
            inc     rdi
                    
# Okay, output the digits for the number here.
            
            
            xor     ecx, ecx            # Counts  # of output chars.
            lea     digits(rbp), rbx    # Ptr to digits to output.
            
            
# Calculate the number of digits to output
# before and after the decimal point.
            
            
            mov     decDigits(rbp), edx # Chars after "."
            add     exponent(rbp), edx  # # chars before "."
            inc     edx                 # Always one digit before "."
            
                    
# If we've output fewer than 18 digits, go ahead
# and output the next digit.  Beyond 18 digits,
# output zeros.
            
repeatUntilEDXeq0:
            mov     $'0', al
            cmp     $18, ecx
            jnb     putChar
            
            mov     (rbx), al
            inc     rbx

putChar:    mov     al, (rdi)
            inc     rdi     
            
# If the exponent decrements down to zero,
# then output a decimal point.
            
            cmp     $0, exponent(rbp)
            jne     noDecimalPt
            cmp     $0, decDigits(rbp)
            je      noDecimalPt
            
            mov     $'.', al
            mov     al, (rdi)
            inc     rdi
                    
noDecimalPt:
            decl    exponent(rbp)       # Count down to "." output.
            inc     ecx                 # # of digits thus far.
            dec     edx                 # Total # of digits to output.
            jnz     repeatUntilEDXeq0
                    

# Zero-terminate string and leave:
            
r10BufDone: movb    $0, (rdi)
            leave
            clc                         #No error
            jmp     popRet

badWidth:   mov     $-2, rax            #Illegal character
            jmp     ErrorExit
            
strOverflow:
            mov     $-3, rax            #String overflow
            jmp     ErrorExit

voor:       or      $-1, rax            #Range error
ErrorExit:  leave
            stc                         #Error
            mov     rax, (rsp)          #Change RAX on return
            
popRet:     pop     rax
            pop     rsi
            pop     rdx
            pop     rcx
            pop     rbx
            pop     rdi
            ret



