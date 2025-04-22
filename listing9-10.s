# Listing 9-10
#
# Floating-point to string conversion
#
#   $build listing9-10
#   $listing9-10
#
# or
#
#   $gcc -o listing9-10 -fno-pie -no-pie c.cpp listing9-10.s -lstdc++
#   $listing9-10



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.
            
            
            .equ    tab, 9

            .section    const, "a"
ttlStr:     .asciz      "Listing 9-10"
fmtStr1:    .asciz      "f10ToStr: value='%s'\n"
fmtStr2:    .asciz      "fpError: code=%zd\n"
fmtStr3:    .asciz      "e10ToStr: value='%s'\n"

# Gas, for whatever reason, does not support REAL10 constants.
# I had to convert these values to hexadecimal and output them
# as bytes:

# r10_1     real10      1.2345678901234567

r10_1:      .byte       0x58,0xd8,0xcf,0x62,0x14,0x52,0x06,0x9e,0xff,0x3f

# r10_2     real10      0.0000000000000001

r10_2:      .byte       0x5b,0xe1,0x4d,0xc4,0xbe,0x94,0x95,0xe6,0xc9,0x3f
    
# r10_3     real10      12345678901234567.0

r10_3:      .byte       0x00,0x1c,0x2e,0xad,0x75,0x51,0x71,0xaf,0x34,0x40
    
# r10_4     real10      1234567890.1234567

r10_4:      .byte       0x72,0xb7,0x35,0x3f,0xa4,0x05,0x2c,0x93,0x1d,0x40

# r10_5     real10      994999999999999999.0

r10_5:      .byte       0xf0,0xff,0x37,0xf8,0xa6,0x33,0xef,0xdc,0x3a,0x40



# e10_1     real10      1.2345678901234567e123

e10_1:      .byte       0xc3,0xb1,0x47,0x2b,0x7f,0x83,0x0c,0xef,0x97,0x41

# e10_2     real10      1.2345678901234567e-123

e10_2:      .byte       0x8f,0xf9,0xa6,0xa9,0xe5,0x23,0xed,0xd0,0x66,0x3e

# e10_3     real10      1.2345678901234567e1

e10_3:      .byte       0x6e,0xce,0x83,0x7b,0x99,0xe6,0x87,0xc5,0x02,0x40


# e10_4     real10      1.2345678901234567e-1

e10_4:      .byte       0xc0,0xf3,0xb2,0x37,0xba,0xe9,0xd6,0xfc,0xfb,0x3f


# e10_5     real10      1.2345678901234567e10

e10_5:      .byte       0x4e,0x25,0x03,0x4f,0x0d,0x07,0xf7,0xb7,0x20,0x40


# e10_6     real10      1.2345678901234567e-10

e10_6:      .byte       0xa6,0x55,0x9c,0x12,0x2f,0xff,0xbd,0x87,0xde,0x3f


# e10_7     real10      1.2345678901234567e100

e10_7:      .byte       0x41,0x19,0x8c,0xef,0x44,0xc7,0x9e,0xb4,0x4b,0x41

# e10_8     real10      1.2345678901234567e-100

e10_8:      .byte       0x93,0x8f,0x2e,0x06,0x31,0x7f,0x41,0x8a,0xb3,0x3e


# e10_9     real10      1.2345678901234567e1000

e10_9:      .byte       0x89,0x2b,0x7d,0x2a,0x41,0x77,0x57,0x96,0xf9,0x4c


# e10_0     real10      1.2345678901234567e-1000

e10_0:      .byte       0xe2,0xe0,0x49,0xb5,0x69,0xb0,0x19,0xa6,0x05,0x33



            .data
r10str_1:   .fill       32, 1, 0

           
            .balign     8

# TenTo17 - Holds the value 1.0e+17. Used to get a floating 
#           point number to the range x.xxxxxxxxxxxxe+17

                #real10 1.0e+17
TenTo17:    .byte   0x00,0x00,0x00,0xc5,0x2e,0xbc,0xa2,0xb1,0x37,0x40
                        
# PotTblN- Hold powers of ten raised to negative powers of two.
            
#PotTblN     real10  1.0,
#                    1.0e-1,
#                    1.0e-2,
#                    1.0e-4,
#                    1.0e-8,
#                    1.0e-16,
#                    1.0e-32,
#                    1.0e-64,
#                    1.0e-128,
#                    1.0e-256,
#                    1.0e-512,
#                    1.0e-1024,
#                    1.0e-2048,
#                    1.0e-4096                               

            .balign     8
PotTblN:    .byte       0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xff,0x3f    
            .byte       0xcd,0xcc,0xcc,0xcc,0xcc,0xcc,0xcc,0xcc,0xfb,0x3f    
            .byte       0x0a,0xd7,0xa3,0x70,0x3d,0x0a,0xd7,0xa3,0xf8,0x3f    
            .byte       0x2c,0x65,0x19,0xe2,0x58,0x17,0xb7,0xd1,0xf1,0x3f    
            .byte       0xfd,0xce,0x61,0x84,0x11,0x77,0xcc,0xab,0xe4,0x3f
            .byte       0x5b,0xe1,0x4d,0xc4,0xbe,0x94,0x95,0xe6,0xc9,0x3f    
            .byte       0xba,0x94,0x39,0x45,0xad,0x1e,0xb1,0xcf,0x94,0x3f    
            .byte       0xa5,0xe9,0x39,0xa5,0x27,0xea,0x7f,0xa8,0x2a,0x3f    
            .byte       0xa1,0xe4,0xbc,0x64,0x7c,0x46,0xd0,0xdd,0x55,0x3e    
            .byte       0x3a,0x19,0x7a,0x63,0x25,0x43,0x31,0xc0,0xac,0x3c    
            .byte       0x1c,0xd2,0x23,0xdb,0x32,0xee,0x49,0x90,0x5a,0x39    
            .byte       0xbe,0xc0,0x57,0xda,0xa5,0x82,0xa6,0xa2,0xb5,0x32    
            .byte       0xe4,0x2d,0x36,0x34,0x4f,0x53,0xae,0xce,0x6b,0x25    
            .byte       0xde,0x9f,0xce,0xd2,0xc8,0x04,0xdd,0xa6,0xd8,0x0a    
            .equ        sizeofPotTblN, (14*10)
                                        
# PotTblP- Hold powers of ten raised to positive powers of two.
            
#PotTblP     real10  1.0,
#                    1.0e+1,
#                    1.0e+2,
#                    1.0e+4,
#                    1.0e+8,
#                    1.0e+16,
#                    1.0e+32,
#                    1.0e+64,
#                    1.0e+128,
#                    1.0e+256,
#                    1.0e+512,
#                    1.0e+1024,
#                    1.0e+2048,
#                    1.0e+4096

            .balign 8
PotTblP:    .byte   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xff,0x3f   
            .byte   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xa0,0x02,0x40   
            .byte   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xc8,0x05,0x40   
            .byte   0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x9c,0x0c,0x40   
            .byte   0x00,0x00,0x00,0x00,0x00,0x20,0xbc,0xbe,0x19,0x40   
            .byte   0x00,0x00,0x00,0x04,0xbf,0xc9,0x1b,0x8e,0x34,0x40   
            .byte   0x9e,0xb5,0x70,0x2b,0xa8,0xad,0xc5,0x9d,0x69,0x40   
            .byte   0xd5,0xa6,0xcf,0xff,0x49,0x1f,0x78,0xc2,0xd3,0x40   
            .byte   0xe0,0x8c,0xe9,0x80,0xc9,0x47,0xba,0x93,0xa8,0x41   
            .byte   0x8e,0xde,0xf9,0x9d,0xfb,0xeb,0x7e,0xaa,0x51,0x43   
            .byte   0xc7,0x91,0x0e,0xa6,0xae,0xa0,0x19,0xe3,0xa3,0x46   
            .byte   0x17,0x0c,0x75,0x81,0x86,0x75,0x76,0xc9,0x48,0x4d   
            .byte   0xe5,0x5d,0x3d,0xc5,0x5d,0x3b,0x8b,0x9e,0x92,0x5a   
            .byte   0x9b,0x97,0x20,0x8a,0x02,0x52,0x60,0xc4,0x25,0x75   
            .equ    sizeofPotTblP, (14*10)
                                    
# ExpTbl- Integer equivalents to the powers in the tables 
#         above.
            
            .balign 4
ExpTab:     .int    0
            .int    1
            .int    2
            .int    4
            .int    8
            .int    16
            .int    32
            .int    64
            .int    128
            .int    256
            .int    512
            .int    1024
            .int    2048
            .int    4096
            .equ    sizeofExpTab, (14*4)
            
            
            .text
            .extern printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret




print:
            push    rax
            push    rcx
            push    rdx
            push    rdi
            push    rsi
            push    r8
            push    r9
            push    r10
            push    r11
            
            push    rbp
            mov     rsp, rbp
            sub     $40, rsp
            and     $-16, rsp
            
            mov     80(rbp), rdi   #Return address
            mov     $0, al
            call    printf
            
            mov     80(rbp), rdi
            dec     rdi
skipTo0:    inc     rdi
            cmpb    $0, 80(rbp)
            jne     skipTo0
            inc     rdi
            mov     rdi, 80(rbp)
            
            leave
            pop     r11
            pop     r10
            pop     r9
            pop     r8
            pop     rsi
            pop     rdi
            pop     rdx
            pop     rdi
            pop     rax
            ret

            


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
            



#*************************************************************
#                                                                  
# FPDigits-                                                        
#                                                                  
# Used to convert a floating point number on the FPU 
# stack (ST(0)) to a string of digits.                                           
#                                                                  
# Entry Conditions:                                                
#                                                                  
# ST(0)-    80-bit number to convert.                              
# RDI-      Points at array of at least 18 bytes where FPDigits    
#           stores the output string.                      
#                                                                  
# Exit Conditions:                                                 
#                                                                  
# RDI-      Converted digits are found here.                       
# RAX-      Contains exponent of the number.                       
# CL-       Contains the sign of the mantissa (" " or "-").
#                                                                  
#*************************************************************


FPDigits:                                                                                       
            push    rbx                                                     
            push    rdx                                                     
            push    rsi                                                     
            push    r8                                                      
            push    r9                                                      
            push    r10                                                     

# Special case if the number is zero.                                       

                                                                            
            ftst                                                            
            fstsw   ax                                                      
            sahf                                                            
            jnz     fpdNotZero                                              

# The number is zero, output it as a special case.                          

            fstpt   (rdi)  #Pop value off FPU stack.                        
            mov     $0x3030303030303030, rax                                
            mov     rax, (rdi)                                              
            mov     rax, 8(rdi)                                             
            mov     ax, 16(rdi)                                             
            add     $18, rdi                                                
            xor     edx, edx         # Return an exponent of 0.             
            mov     $' ', bl         # Sign is positive.                    
            jmp     fpdDone                                                 
                                                                            
fpdNotZero:                                                                 
                                                                            
# If the number is not zero, then fix the sign of the value.                
                                                                            
            mov     $' ', bl        # Assume it's positive.                 
            jnc     WasPositive     # Flags set from sahf above.            
                                                                            
            fabs                    # Deal only with positive numbers.      
            mov     $'-', bl        # Set the sign return result.           
                                                                            
WasPositive:                                                                

# Get the number between one and ten so we can figure out                   
# what the exponent is.  Begin by checking to see if we have                
# a positive or negative exponent.                                          
                                                                            
                                                                            
            xor     edx, edx        # Initialize exponent to 0.             
            fld1                                                            
            fcomip  st1, st0                                                
            jbe     PosExp                                                  

# We've got a value between zero and one, exclusive,                        
# at this point.  That means this number has a negative                     
# exponent.  Multiply the number by an appropriate power                    
# of ten until we get it in the range 1..10.                                
                                                                            
            mov     $sizeofPotTblN, esi # After last element.               
            mov     $sizeofExpTab, ecx  # Ditto.                            
            lea     PotTblN, r8                                             
            lea     PotTblP, r9                                             
            lea     ExpTab, r10                                             

CmpNegExp:                                                                  
            sub     $10, esi            # Move to previous element.         
            sub     $4, ecx             # Zeros HO bytes                    
            jz      test1                                                   

            fldt    (r8,rsi)            # Get current power of 10.          
            fcomip  st1, st0            # Compare against NOS.              
            jbe     CmpNegExp           #While Table >= value.              

            mov     (r10,rcx), eax                                          
            test    eax, eax                                                
            jz      didAllDigits                                            

            sub     eax, edx                                                
            fldt    (r9,rsi)                                                
            fmulp                                                           
            jmp     CmpNegExp                                               

# If the remainder is *exactly* 1.0, then we can branch                     
# on to InRange1_10, otherwise, we still have to multiply                   
# by 10.0 because we've overshot the mark a bit.                            

test1:                                                                      
            fld1                                                            
            fcomip  st1, st0                                                
            je      InRange1_10                                             

didAllDigits:                                                               
                                                                            
# If we get to this point, then we've indexed through                       
# all the elements in the PotTblN and it's time to stop.                    

            fldt    10(r9)              # 10.0                              
            fmulp                                                           
            dec     edx 
            
            jmp     InRange1_10                                             
                                                                            
                                                                            
                                                                            
                                                                            
#  At this point, we've got a number that is one or greater.                
#  Once again, our task is to get the value between 1 and 10.               
                                                                            
PosExp:                                                                     
                                                                            
            mov     $sizeofPotTblP, esi # After last element.               
            mov     $sizeofExpTab, ecx  # Ditto.                            
            lea     PotTblP, r9                                             
            lea     ExpTab, r10                                             

CmpPosExp:                                                                  
            sub     $10, esi            # Move back 1 element in            
            sub     $4, ecx             #  PotTblP and ExpTbl.              
            fldt    (r9,rsi)                                                
            fcomip  st1, st0                                                
            ja      CmpPosExp                                               
            mov     (r10, rcx), eax                                         
            test    eax, eax                                                
            jz      InRange1_10                                             
                                                                            
            add     eax, edx                                                
            fldt    (r9, rsi)                                               
            fdivrp                                                          
            jmp     CmpPosExp                                               
                                                                            

                                                                            
InRange1_10:                                                                

# Okay, at this point the number is in the range 1 <= x < 10,               
# Let's multiply it by 1e+18 to put the most significant digit              
# into the 18th print position.  Then convert the result to                 
# a BCD value and store away in memory.                                     

                                                                            
            sub     $24, rsp            # Make room for BCD result.         
            fldt    TenTo17                                                 
            fmulp                                                           
                                                                            
# We need to check the floating-point result to make sure it                
# is not outside the range we can legally convert to a BCD                  
# value.                                                                    
#                                                                           
# Illegal values will be in the range:                                      
#                                                                           
#  >999,999,999,999,999,999 ..<1,000,000,000,000,000,000                    
#      $403a_de0b_6b3a_763f_ff01..$403a_de0b_6b3a_763f_ffff                 
#                                                                           
# Should one of these values appear, round the result up to                 
#                                                                           
#           $403a_de0b_6b3a_7640_0000                                       
                                                                            
            fstpt   (rsp)                                                   
            cmpw    $0x403a, 8(rsp)                                         
            jne     noRounding                                              
                                                                            
            cmpl    $0xde0b6b3a, 4(rsp)                                     
            jne     noRounding                                              
                                                                            
            mov     (rsp), eax                                              
            cmp     $0x763fff01, eax                                        
            jb      noRounding                                              
            cmp     $0x76400000, eax                                        
            jae     TooBig                                                  
                                                                            
            fldt    TenTo17                                                 
            inc     edx     #Inc exp as this is really 10^18.               
            jmp     didRound                                                
                                                                            
# If we get down here, there was some problems getting the                  
# value in the range 1 <= x <= 10 above and we've got a value               
# that is 10e+18 or slightly larger. We need to compensate for              
# that here.                                                                

TooBig:                                                                     
            lea     PotTblP, r9                                             
            fldt    (rsp)                                                   
            fldt    10(r9)          # /10                                   
            fdivrp                                                          
            inc     edx             # Adjust exp due to fdiv.               
            jmp     didRound                                                
                                                                            
                                                                            
noRounding:                                                                 
            fldt    (rsp)                                                   
didRound:                                                                   
            fbstp   (rsp)                                                   

                                                                            
                                                                            
# The data on the stack contains 18 BCD digits.  Convert these              
# to ASCII characters and store them at the destination location            
# pointed at by edi.                                                        
                                                                            
            mov     $8, ecx                                                 
repeatLp:                                                                   
            mov     (rsp, rcx), al                                          
            shr     $4, al                  #Always in the                  
            or      $'0', al                # range 0..9                    
            mov     al, (rdi)                                               
            inc     rdi                                                     
                                                                            
            mov     (rsp, rcx), al                                          
            and     $0xf, al                                                
            or      $'0', al                                                
            mov     al, (rdi)                                               
            inc     rdi                                                     
                                                                            
            dec     ecx                                                     
            jns     repeatLp                                                

            add     $24, rsp                # Remove BCD data from stack.   

fpdDone:                                                                    

            mov     edx, eax                # Return exponent in EAX.       
            mov     bl, cl                  # Return sign in CL             
            pop     r10                                                     
            pop     r9                                                      
            pop     r8                                                      
            pop     rsi                                                     
            pop     rdx                                                     
            pop     rbx                                                     
            ret                                                             
                    
                    
      
      
      
      
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
            subb    $10, digits(rbp,rbx)    # Sub out overflow, 
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
            cmpl    $0, exponent(rbp)
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
            cmpb    $0, decDigits(rbp)
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
            
            cmpl    $0, exponent(rbp)
            jne     noDecimalPt
            cmpb    $0, decDigits(rbp)
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


    
    
  
 
                
            
                   
            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbx
            push    rsi
            push    rdi
            push    rbp
            mov     rsp, rbp
            sub     $64, rsp
            and     $-16, rsp
      
            
# F output

            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $16, edx         #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $15, edx         #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $14, edx         #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $13, edx         #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $12, edx         #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $11, edx         #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $10, edx         #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $9, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $8, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $7, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $6, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $5, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $4, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $3, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $2, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $1, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    r10_1
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $0, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            


            fldt    r10_2
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $16, edx         #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            

            fldt    r10_3
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $1, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            

            fldt    r10_4
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $6, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            

            fldt    r10_5
            lea     r10str_1, rdi
            mov     $30, eax         #fWidth
            mov     $1, edx          #decimalPts
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    r10ToStr
            jc      fpError
            
            lea     fmtStr1, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
# E output

            fldt    e10_1
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $3, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf


            fldt    e10_2
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $3, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf


            fldt    e10_3
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $3, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf


            fldt    e10_4
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $3, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf


            fldt    e10_5
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $3, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf


            fldt    e10_6
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $3, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi

            fldt    e10_7
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $3, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf


            fldt    e10_8
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $3, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf


            fldt    e10_9
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $4, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf


            fldt    e10_0
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $4, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            

            fldt    e10_3
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $1, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    e10_3
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $2, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            fldt    e10_3
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $3, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            fldt    e10_3
            lea     r10str_1, rdi
            mov     $26, eax         #fWidth
            mov     $4, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf



            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            fldt    e10_3
            lea     r10str_1, rdi
            mov     $25, eax         #fWidth
            mov     $1, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            fldt    e10_3
            lea     r10str_1, rdi
            mov     $20, eax         #fWidth
            mov     $1, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    e10_3
            lea     r10str_1, rdi
            mov     $15, eax         #fWidth
            mov     $1, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    e10_3
            lea     r10str_1, rdi
            mov     $10, eax         #fWidth
            mov     $1, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    e10_3
            lea     r10str_1, rdi
            mov     $9, eax          #fWidth
            mov     $1, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    e10_3
            lea     r10str_1, rdi
            mov     $8, eax          #fWidth
            mov     $1, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    e10_3
            lea     r10str_1, rdi
            mov     $7, eax          #fWidth
            mov     $1, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            fldt    e10_3
            lea     r10str_1, rdi
            mov     $6, eax          #fWidth
            mov     $1, edx          #expDigits
            mov     $'*', ecx        #Fill
            mov     $32, r8d         #maxLength
            call    e10ToStr
            jc      fpError
            
            lea     fmtStr3, rdi
            lea     r10str_1, rsi
            mov     $0, al
            call    printf

            
            
            
            jmp     allDone4
            
fpError:    lea     fmtStr2, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf
 
            
 

             
allDone4:   leave
            pop     rdi
            pop     rsi
            pop     rbx
            ret     #Returns to caller

