# Listing 9-18
#
# 128-bit unsigned decimal string to numeric conversion
#
#   $build listing9-18
#   $listing9-18
#
# or
#
#   $gcc -o listing9-18 -fno-pie -no-pie c.cpp listing9-18.s -lstdc++
#   $listing9-18



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.
            
            .equ    false, 0
            .equ    true, 1
            
            .equ    tab, 9

            .section    const, "a"
ttlStr:     .asciz      "Listing 9-18"
fmtStr1:    .asciz      "strtou128: String='%s' value=%zx%zx\n"
           
oStr:       .asciz      "340282366920938463463374607431768211455"

ten:        .quad       10
            
            .text
            .extern     printf:proc
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret





# strtou128-
#  Converts string data to a 128-bit unsigned integer.
#
# Input-
#   RDI-    Pointer to buffer containing string to convert
#
# Output-
#   RDX:RAX-Contains converted string (if success), error code
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


            .equ    accumulator, -16
            .equ    partial, -24

strtou128:
            push    rcx         #Holds input char                           
            push    rdi         #In case we have to restore RDI             
            push    rbp                                                     
            mov     rsp, rbp                                                
            sub     $24, rsp    #Accumulate result here                     
                                                                            
            xor     edx, edx    #Zero extends!                              
            mov     rdx, accumulator(rbp)                                   
            mov     rdx, accumulator+8(rbp)                                 
                                                                            
# The following loop skips over any whitespace (spaces and                  
# tabs) that appear at the beginning of the string.                         

            dec     rdi         #Because of inc below.                      
skipWS:     inc     rdi                                                     
            mov     (rdi), cl                                               
            cmp     $' ', cl                                                
            je      skipWS                                                  
            cmp     $tab, al                                                
            je      skipWS                                                  
                                                                            
# If we don't have a numeric digit at this point,                           
# return an error.                                                          

            cmp     $'0', cl    #Note: '0' < '1' < ... < '9'                
            jb      badNumber                                               
            cmp     $'9', cl                                                
            ja      badNumber                                               
                                                                            
# Okay, the first digit is good. Convert the string                         
# of digits to numeric form:                                                

convert:    and     $0xf, ecx #Convert to numeric in RCX                    

# Multiple 128-bit accumulator by 10                                        

            mov     accumulator(rbp), rax                           
            mulq    ten                                             
            mov     rax, accumulator(rbp)                           
            mov     rdx, partial(rbp)       #Save partial product   
            mov     accumulator+8(rbp), rax                         
            mulq    ten                                             
            jc      overflow1                                       
            add     partial(rbp), rax                               
            mov     rax, accumulator+8(rbp)                         
            jc      overflow1                                       

# Add in the current character to the 128-bit accumulator           
                                                                    
            mov     accumulator(rbp), rax                           
            add     rcx, rax                                        
            mov     rax, accumulator(rbp)                           
            mov     accumulator+8(rbp), rax                         
            adc     $0, rax                                         
            mov     rax, accumulator+8(rbp)                         
            jc      overflow2                                       
                                                                    
#Move on to next character                                          

            inc     rdi                                             
            mov     (rdi), cl                                       
            cmp     $'0', cl                                        
            jb      endOfNum                                        
            cmp     $'9', cl                                        
            jbe     convert                                         

# If we get to this point, we've successfully converted                     
# the string to numeric form:                                               

endOfNum:                                                                   
                                                                            
# Because the conversion was successful, this procedure                     
# leaves RDI pointing at the first character beyond the                     
# converted digits. As such, we don't restore RDI from                      
# the stack. Just bump the stack pointer up by 8 bytes                      
# to throw away RDI's saved value# must also remove                         

            mov     accumulator(rbp), rax                                   
            mov     accumulator+8(rbp), rdx                                 
            leave                                                           
            add     $8, rsp  #Remove original RDI value                     
            pop     rcx      #Restore RCX                                   
            clc              #Return success in carry flag                  
            ret                                                             
                                                                            
# badNumber- Drop down here if the first character in                       
#            the string was not a valid digit.                              

badNumber:  xor     rax, rax                                                
            xor     rdx, rdx                                                
            jmp     errorExit                                               

overflow1:  mov     $-1, rax
            cqo                                             
            jmp     errorExit                                               
                                                                            
overflow2:  mov     $-2, rax  #0FFFFFFFFFFFFFFFEh                           
            cqo              #Just to be consistent.                        
errorExit:  leave            #Remove accumulator from stack                 
            pop     rdi                                                     
            pop     rcx                                                     
            stc              #Return error in carry flag                    
            ret                                                             
                    


            
                    
            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp
            

# Test hexadecimal conversion:
            
            lea     oStr, rdi
            call    strtou128
            jc      badConversion    
                 
            lea     fmtStr1, rdi
            lea     oStr, rsi
            mov     rax, rcx
            mov     $0, al
            call    printf
            jmp     allDone

fmtStr2:    .asciz  "Bad Conversion %zd\n"

badConversion:
            lea fmtStr2, rdi
            mov rax, rsi
            mov $0, al
            call    printf            
 

             
allDone:    leave
            ret     #Returns to caller

