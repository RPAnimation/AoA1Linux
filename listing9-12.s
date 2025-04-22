; Listing 9-12
;
; Exponent output helper function
;
; Cut and pasted from Listing 9-10

#*************************************************************
#
# expToBuf-
#
#  Unsigned integer to buffer.
# Used to output up to 4-digit exponents.
#
# Inputs:
#
#    EAX:   Unsigned integer to convert
#    ECX:   Print width 1-4
#    RDI:   Points at buffer.
#

            .equ    expWidth, +16
            .equ    exp, +8
            .equ    bcd, -16

expToBuf:

            push    rdx                                                 
            push    rcx     #At [RBP+16]                                
            push    rax     #At [RBP+8]                                 
            push    rbp                                                 
            mov     rsp, rbp                                            
            sub     $16, rsp
            

# Verify exponent digit count is in the range 1-4:                      

            cmp     $1, rcx                                             
            jb      badExp                                              
            cmp     $4, rcx                                             
            ja      badExp                                              
            mov     rcx, rdx                                            
                                                                        
# Verify the actual exponent will fit in the number of digits:          

            cmp     $2, rcx                                             
            jb      oneDigit                                            
            je      twoDigits                                           
            cmp     $3, rcx                                             
            ja      fillZeros       #4 digits, no error                 
            cmp     $1000, eax                                          
            jae     badExp                                              
            jmp     fillZeros                                           
                                                                        
oneDigit:   cmp     $10, eax                                            
            jae     badExp                                              
            jmp     fillZeros                                           
                                                                        
twoDigits:  cmp     $100, eax                                           
            jae     badExp                                              
                                                                        
                                                                        
# Fill in zeros for exponent:                                           

fillZeros:  movb    $'0', -1(rdi,rcx,1)                                 
            dec     ecx                                                 
            jnz     fillZeros                                           
                                                                        
# Point RDI at the end of the buffer:                                   

            lea     -1(rdi,rdx,1), rdi                                  
            movb    $0, 1(rdi)                                          
            push    rdi                 #Save pointer to end            

# Quick test for zero to handle that special case:                      

            test    eax, eax                                            
            jz      allDone                                             
                                                                        
# The number to convert is non-zero.                                    
# Use BCD load and store to convert                                     
# the integer to BCD:                                                   

            fildl   exp(rbp)            #Get integer value                          
            fbstp   bcd(rbp)            #Convert to BCD                             
                                                                        
# Begin by skipping over leading zeros in                               
# the BCD value (max 10 digits, so the most                             
# significant digit will be in the HO nibble                            
# of byte 4).                                                           

            mov     bcd(rbp), eax        #Get exponent digits               
            mov     expWidth(rbp), ecx   #Number of total digits                
                                                                        
OutputExp:  mov     al, dl                                              
            and     $0xf, dl                                            
            or      $'0', dl                                            
            mov     dl, (rdi)                                           
            dec     rdi                                                 
            shr     $4, ax                                              
            jnz     OutputExp                                           


# Zero-terminte the string and return:                                  
                                                                        
allDone:    pop     rdi                                                 
            leave                                                       
            pop     rax                                                 
            pop     rcx                                                 
            pop     rdx                                                 
            clc                                                         
            ret                                                         
                                                                        
badExp:     leave                                                       
            pop     rax                                                 
            pop     rcx                                                 
            pop     rdx                                                 
            stc                                                         
            ret                                                         

