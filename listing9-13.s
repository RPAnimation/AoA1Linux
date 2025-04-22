; Listing 9-13
;
; Exponent output helper function
;
; Cut and pasted from Listing 9-10

#***********************************************************
#                                                           
# eToStr-                                                   
#                                                           
# Converts a REAL10 floating-point number to the       
# corresponding string of digits.  Note that this           
# function always emits the string using scientific                  
# notation, use the r10ToStr routine for decimal notation.   
#                                                           
# On Entry:                                                 
#                                                           
#    e10-           Real10 value to convert.
#                   Passed in st0                     
#                                                           
#    width-         Field width for the number (note that this   
#                   is an *exact* field width, not a minimum     
#                   field width).
#                   Passed in RAX (LO 32 bits).                                
#                                                           
#    fill-          Padding character if the number is smaller   
#                   than the specified field width.
#                   Passed in RCX.                  
#                                                                            
#    buffer-        e10ToStr stores the resulting characters in  
#                   this buffer (passed in EDI).
#                   Passed in RDI (LO 32 bits).                 
#                                                           
#    expDigs-       Number of exponent digits (2 for real4,     
#                   3 for real8, and 4 for real10).
#                   Passed in RDX (LO 8 bits)             
#                                                                            
#
#    maxLength-     Maximum buffer size.
#                   Passed in R8.                                     
# On Exit:                                                  
#                                                           
#    Buffer contains the newly formatted string.  If the    
#    formatted value does not fit in the width specified,   
#    e10ToStr will store "#" characters into this string.   
#                                                           
#-----------------------------------------------------------
#                                                           
# Unlike the integer to string conversions, this routine    
# always right justifies the number in the specified        
# string.  Width must be a positive number, negative        
# values are illegal (actually, they are treated as         
# *really* big positive numbers which will always raise     
# a string overflow exception.                              
#                                                           
#***********************************************************

            .equ    fWidth,   -8        #RAX
            .equ    buffer,   -16       #RDI
            .equ    expDigs,  -24       #RDX
            .equ    rbxSave,  -32
            .equ    rcxSave,  -40
            .equ    rsiSave,  -48
            .equ    Exponent, -52
            .equ    MantSize, -56
            .equ    Sign,     -60
            .equ    Digits,   -128

e10ToStr:

            push    rbp                                                                     
            mov     rsp, rbp                                                
            sub     $128, rsp                                               
                                                                            
            cmp     r8d, eax                                                
            jae     strOvfl                                                 
            movb    $0, (rdi, rax)      # 0-terminate str                   
                                                                            
                                                                            
            mov     rdi, buffer(rbp)                                        
            mov     rsi, rsiSave(rbp)                                       
            mov     rcx, rcxSave(rbp)                                       
            mov     rbx, rbxSave(rbp)                                       
            mov     rax, fWidth(rbp)                                        
            mov     rdx, expDigs(rbp)                                       
                                                                            
# First, make sure the width isn't zero.                                    
                                                                            
            test    eax, eax                                                
            jz      voorb                                                   

# Just to be on the safe side, don't allow widths greater                   
# than 1024:                                                                

            cmp     $1024, eax                                              
            ja      badWidthb                                               

# Okay, do the conversion.                                                  

            lea     Digits(rbp), rdi    # Store result string here.         
            call    FPDigits            # Convert e80 to digit str.         
            mov     eax, Exponent(rbp)  # Save away exponent result.            
            mov     cl, Sign(rbp)       # Save mantissa sign char.
            
# Verify that there is sufficient room for the mantissa's sign,             
# the decimal point, two mantissa digits, the "E",                          
# and the exponent's sign.  Also add in the number of digits                
# required by the exponent (2 for real4, 3 for real8, 4 for                 
# real10).                                                                  
#                                                                           
# -1.2e+00    :real4                                                        
# -1.2e+000   :real8                                                        
# -1.2e+0000  :real10                                                       
                                                                            
                                                                            
            mov     $6, ecx             # Char posns for above chars.       .   
            add     expDigs(rbp), ecx   # Number of digits for the exp.     
            cmp     fWidth(rbp), ecx                                        
            jbe     goodWidth                                               
                                                                            
# Output a sequence of "#...#" chars (to the specified width)               
# if the width value is not large enough to hold the                        
# conversion:                                                               

            mov     fWidth(rbp), ecx                                        
            mov     $'#', al                                                
            mov     buffer(rbp), rdi                                        
fillPound2: mov     al, (rdi)                                               
            inc     rdi                                                     
            dec     ecx                                                     
            jnz     fillPound2                                              
            jmp     exit_eToBuf                                             


# Okay, the width is sufficient to hold the number, do the                  
# conversion and output the string here:                                    

goodWidth:                                                                          
                                                                            
            mov     fWidth(rbp), ebx    # Compute the # of mantissa         
            sub     ecx, ebx            # digits to display.                
            add     $2, ebx             # ECX allows for 2 mant digs.       
            mov     ebx, MantSize(rbp)                                      
                                                                            
                                                                            
# Round the number to the specified number of print positions.              
# (Note: since there are a maximum of 18 significant digits,                
#  don't bother with the rounding if the field width is greater             
#  than 18 digits.)                                                         
                                                                                        
                                                                            
            cmp     $18, ebx                                                    
            jae     noNeedToRound                                           
                                                                            
# To round the value to the number of significant digits,                   
# go to the digit just beyond the last one we are considering               
# (ebx currently contains the number of decimal positions)                  
# and add 5 to that digit.  Propagate any overflow into the                 
# remaining digit positions.                                                
                                                                            
            mov     Digits(rbp,rbx), al # Get least sig digit + 1.          
            add     $5, al              # Round (e.g., +0.5 ).              
            cmp     $'9', al                                                
            jbe     noNeedToRound                                           
            movb    $'9'+1, Digits(rbp,rbx)                                 
            jmp     whileDigitGT9Testb                                      
                                                                            
# Subtract out overflow and add the carry into the previous                 
# digit (unless we hit the first digit in the number).                      
                                                                            
whileDigitGT9b:                                                             
            subb    $10, Digits(rbp,rbx)                                    
            dec     ebx                                                     
            cmp     $0, ebx                                                 
            jl      firstDigitInNumber                                      
                                                                              
            incb    Digits(rbp,rbx)                                         
            jmp     whileDigitGT9Testb                                      
                                                                            
firstDigitInNumber:                                                         
                                                                            
# If we get to this point, then we've hit the first                         
# digit in the number.  So we've got to shift all                           
# the characters down one position in the string of                         
# bytes and put a "1" in the first character position.                      
                                                                            
            mov     $17, ebx                                                
repeatUntilEBXeq0b:                                                         
                                                                            
            mov     Digits(rbp,rbx), al                                     
            mov     al, Digits+1(rbp,rbx)                                   
            dec     ebx                                                     
            jnz     repeatUntilEBXeq0b                                      
                                                                            
            movb    $'1', Digits(rbp)                                       
            incl    Exponent(rbp)           # Because we added a digit.       
            jmp     noNeedToRound                                           
                                                                            
                                                                            
whileDigitGT9Testb:                                                         
            cmpb    $'9', Digits(rbp,rbx)   # Overflow if char > '9'.       
            ja      whileDigitGT9b                                          
                                                                            
noNeedToRound:                                                              
                                                                            
# Okay, emit the string at this point.  This is pretty easy                 
# since all we really need to do is copy data from the                      
# digits array and add an exponent (plus a few other simple chars).         s).
                                                                            
            xor     ecx, ecx    # Count output mantissa digits.             
            mov     buffer(rbp), rdi                                        
            xor     edx, edx    # Count output chars.                       
            mov     Sign(rbp), al                                           
            cmp     $'-', al                                                
            je      noMinus                                                 
                                                                            
            mov     $' ', al                                                
                                                                            
noMinus:    mov     al, (rdi)                                               
                                                                            
# Output the first character and a following decimal point                  
# if there are more than two mantissa digits to output.                     
                                                                            
            mov     Digits(rbp), al                                         
            mov     al, 1(rdi)                                              
            add     $2, rdi                                                 
            add     $2, edx                                                 
            inc     ecx                                                     
            cmp     MantSize(rbp), ecx                                      
            je      noDecPt                                                 
                                                                            
            mov     $'.', al                                                
            mov     al, (rdi)                                               
            inc     rdi                                                     
            inc     edx                                                     
                                                                            
noDecPt:                                                                    
                                                                            
# Output any remaining mantissa digits here.                                
# Note that if the caller requests the output of                            
# more than 18 digits, this routine will output zeros                       
# for the additional digits.                                                
                                                                            
            jmp     whileECXltMantSizeTest                                  
                                                                            
whileECXltMantSize:                                                         
                                                                            
            mov     $'0', al                                                
            cmp     $18, ecx                                                
            jae     justPut0                                                

            mov     Digits(rbp,rcx), al                                     
                                                                            
justPut0:                                                                   
            mov     al, (rdi)                                               
            inc     rdi                                                     
            inc     ecx                                                     
            inc     edx                                                     
                                                                            
whileECXltMantSizeTest:                                                     
            cmp     MantSize(rbp), ecx                                      
            jb      whileECXltMantSize                                      

# Output the exponent:                                                      
                                                                            
            movb    $'e', (rdi)                                             
            inc     rdi                                                     
            inc     edx                                                     
            mov     $'+', al                                                
            cmpl    $0, Exponent(rbp)                                       
            jge     noNegExp                                                
                                                                            
            mov     $'-', al                                                
            negl    Exponent(rbp)                                           
                                                                            
noNegExp:                                                                   
            mov     al, (rdi)                                               
            inc     rdi                                                     
            inc     edx                                                     
                                                                            
            mov     Exponent(rbp), eax                                      
            mov     expDigs(rbp), ecx                                       
            call    expToBuf                                                
            jc      errorb                                                  
                                                                            
exit_eToBuf:                                                                
            mov     rsiSave(rbp), rsi                                       
            mov     rcxSave(rbp), rcx                                       
            mov     rbxSave(rbp), rbx                                       
            mov     fWidth(rbp), rax                                        
            mov     expDigs(rbp), rdx                                       
            leave                                                           
            clc                                                             
            ret                                                             

strOvfl:    mov     $-3, rax                                                
            jmp     errorb                                                  

badWidthb:  mov     $-2, rax                                                
            jmp     errorb                                                  
                                                                            
voorb:      mov     $-1, rax                                                
errorb:     mov     rsi, rsiSave(rbp)                                       
            mov     rcx, rcxSave(rbp)                                       
            mov     rbx, rbxSave(rbp)                                       
            mov     rdx, expDigs(rbp)                                       
            leave                                                           
            stc                                                             
            ret                                                             
