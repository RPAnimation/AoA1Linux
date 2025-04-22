# Listing 8-3
#
# 128-bit by 128-bit division
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing8-3
#   $listing8-3
#
# or
#
#   $gcc -o listing8-3 -fno-pie -no-pie c.cpp listing8-3.s -lstdc++
#   $listing8-3



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 8-3"
fmtStr1:    .ascii      "quotient  = "
            .asciz      "%08x_%08x_%08x_%08x\n"
            
fmtStr2:    .ascii      "remainder = "
            .asciz      "%08x_%08x_%08x_%08x\n"
            
fmtStr3:    .ascii      "quotient (2)  = "
            .asciz      "%08x_%08x_%08x_%08x\n"
            
            
             .data

# op1 is a 128-bit value. Initial values were chosen
# to make it easy to verify result.

op1:        .octa       0x2222eeeeccccaaaa8888666644440000            
op2:        .octa       2
op3:        .octa       0x11117777666655554444333322220000
result:     .octa       0
remain:     .octa       0

            .text
            .extern     printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



# div128-
#
# This procedure does a general 128/128 division operation 
# using the following algorithm (all variables are assumed 
# to be 128-bit objects):
#
# Quotient := Dividend#
# Remainder := 0#
# for i := 1 to NumberBits do
# 
#  Remainder:Quotient := Remainder:Quotient SHL 1#
#  if Remainder >= Divisor then
# 
#      Remainder := Remainder - Divisor#
#      Quotient := Quotient + 1#
# 
#  endif
# endfor
#
# Data passed:
#
# 128-bit dividend, by reference in RCX
# 128-bit divisor, by reference in RDX
#
# Data returned:
#
# Pointer to 128-bit quotient in R8
# Pointer to 128-bit remainder in R9 

            .equ    remainder, -16
            .equ    dividend, -32
            .equ    quotient, dividend      #Aliased to dividend
            .equ    divisor, -48

div128:

            push    rbp
            mov     rsp, rbp
            sub     $48, rsp
            
            push    rax
            push    rcx
            
            xor     rax, rax        #Initialize remainder to 0
            mov     rax, remainder(rbp)
            mov     rax, remainder+8(rbp)
            
# Copy the dividend to local storage

            mov     (rcx), rax
            mov     rax, dividend(rbp)
            mov     8(rcx), rax
            mov     rax, dividend+8(rbp)
            
# Copy the divisor to local storage

            mov     (rdx), rax
            mov     rax, divisor(rbp)
            mov     8(rdx), rax
            mov     rax, divisor+8(rbp)
            
            
            mov     $128, cl           #Count off bits in cl

# Compute Remainder:Quotient := Remainder:Quotient SHL 1:

repeatLp:   shlq    $1, dividend+0(rbp)  #256-bit extended
            rclq    $1, dividend+8(rbp)  # precision shift
            rclq    $1, remainder+0(rbp) # through remainder
            rclq    $1, remainder+8(rbp)       

# Do a 128-bit comparison to see if the remainder
# is greater than or equal to the divisor.

            mov     remainder+8(rbp), rax
            cmp     divisor+8(rbp), rax
            ja      isGE
            jb      notGE
            
            mov     remainder(rbp), rax
            cmp     divisor(rbp), rax
            ja      isGE
            jb      notGE
            
# Remainder := Remainder - Divisor

isGE:       mov     divisor(rbp), rax
            sub     rax, remainder(rbp)
            mov     divisor+8(rbp), rax
            sbb     rax, remainder+8(rbp)

# Quotient := Quotient + 1#


            add     $1, quotient(rbp)
            adc     $0, quotient+8(rbp)

notGE:      dec     cl
            jnz     repeatLp


# Okay, copy the quotient (left in the Dividend variable)
# and the remainder to their return locations.
    
            mov     quotient(rbp), rax
            mov     rax, (r8)
            mov     quotient+8(rbp), rax
            mov     rax, 8(r8)
            
            mov     remainder+0(rbp), rax
            mov     rax, (r9)
            mov     remainder+8(rbp), rax
            mov     rax, 8(r9)


            pop     rcx
            pop     rax
            leave
            ret
                        





            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp

            

# Test the div128 function:

            lea     op1, rcx
            lea     op2, rdx
            lea     result, r8
            lea     remain, r9
            call    div128
                        
# Print the results:

            lea     fmtStr1, rdi
            mov     result+12, esi
            mov     result+8, edx 
            mov     result+4, ecx 
            mov     result+0, r8d 
            mov     $0, al 
            call    printf
                

            lea     fmtStr2, rdi
            mov     remain+12, esi
            mov     remain+8, edx
            mov     remain+4, ecx
            mov     remain+0, r8d
            mov     $0, al
            call    printf
                
            
# Test the div128 function:

            lea     op1, rcx
            lea     op3, rdx
            lea     result, r8
            lea     remain, r9
            call    div128
                        
# Print the results:

            lea     fmtStr3, rdi
            mov     remain+12, esi
            mov     remain+8, edx
            mov     remain+4, ecx
            mov     remain+0, r8d
            mov     $0, al
            call    printf
                

            lea     fmtStr2, rdi
            mov     remain+12, esi
            mov     remain+8, edx
            mov     remain+4, ecx
            mov     remain+0, r8d
            mov     $0, al
            call    printf
            
            leave
            ret     #Returns to caller

