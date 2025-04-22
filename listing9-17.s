# Listing 9-17
#
# 64-bit unsigned decimal string to numeric conversion
#
#   $build listing9-17
#   $listing9-17
#
# or
#
#   $gcc -o listing9-17 -fno-pie -no-pie c.cpp listing9-17.s -lstdc++
#   $listing9-17



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.
            
            .equ    false, 0
            .equ    true, 1
            
            .equ    tab, 9

            .section    const, "a"
ttlStr:     .asciz    	"Listing 9-17"
fmtStr1:    .asciz    	"strtou: String='%s' value=%Zu\n"
fmtStr2:    .asciz    	"strtou: error, rax=%d\n"
           
qStr:     	.asciz    	"12345678901234567"
ten:		.quad		10
            
            .text
            .extern		printf
            
# Return program title to C++ program:

            .global	getTitle
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

            
                    
            
# Here is the "asmMain" function.

        
            .global	asmMain
asmMain:
            push    rbp
            mov     rsp, rbp
            

# Test hexadecimal conversion:
            
            lea     qStr, rdi
            call    strtou
            jc      error
            
            lea     fmtStr1, rdi
            mov     rax, rdx
            lea     qStr, rsi
			mov		$0, al
            call    printf
            jmp     allDone
            
error:      lea     fmtStr2, rdi
            mov     rax, rsi
			mov		$0, al
            call    printf            
 

             
allDone:    leave
            ret     #Returns to caller

