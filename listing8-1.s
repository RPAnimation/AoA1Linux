# Listing 8-1
#
# 128-bit multiplication
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing8-1
#   $listing8-1
#
# or
#
#   $gcc -o listing8-1 -fno-pie -no-pie c.cpp listing8-1.s -lstdc++
#   $listing8-1



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 8-1"
fmtStr1:    .asciz      "%d * %d = %lld (verify:%lld)\n"
            
            
             .data
op1:        .quad       123456789
op2:        .quad       234567890
product:    .octa       0           
product2:   .octa       0           

            .text
            .extern     printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



# mul64-
#
#  Multiplies two 64-bit values passed in rdx and rax by
# doing a 64x64-bit multiplication, producing a 128-bit result. 
# Algorithm is easily extended to 128x128 bits by switching the 
# 32-bit registers for 64-bit registers.
#
# Stores result to location pointed at by R8.

            .equ    mp, -8      #Multiplier
            .equ    mc, -16     #Multiplicand

mul64:

            push    rbp
            mov     rsp, rbp
            sub     $16, rsp
            
            push    rbx     #Preserve these register values
            push    rcx
            

# Save parameters passed in registers:

            mov     rax, mp(rbp)
            mov     rdx, mc(rbp)

# Multiply the LO dword of Multiplier times Multiplicand.
                                           
            mov     mp(rbp), eax
            mull    mc(rbp)         # Multiply LO dwords.
            mov     eax, (r8)       # Save LO dword of product.
            mov     edx, ecx        # Save HO dword of partial product result.

            mov     eax, mp(rbp)
            mull    mc+4(rbp)       # Multiply mp(LO) * mc(HO)
            add     ecx, eax        # Add to the partial product.
            adc     $0, edx         # Don't forget the carry!
            mov     eax, ebx        # Save partial product for now.
            mov     edx, ecx

# Multiply the HO word of Multiplier with Multiplicand.

            mov     mp+4(rbp), eax  # Get HO dword of Multiplier.
            mull    mc(rbp)         # Multiply by LO word of Multiplicand.
            add     ebx, eax        # Add to the partial product.
            mov     eax, 4(r8)      # Save the partial product.
            adc     edx, ecx        # Add in the carry!

            mov     mp+4(rbp), eax  # Multiply the two HO dwords together.
            mull    mc+4(rbp)
            add     ecx, eax        # Add in partial product.
            adc     $0, edx         # Don't forget the carry!
            
            mov     eax, 8(r8)      #Save HO qword of result
            mov     edx, 12(r8)
    
# EDX:EAX contains 64-bit result at this point

            pop     rcx     # Restore these registers
            pop     rbx
            leave
            ret    


            
            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp

            

# Test the mul64 function:

            mov     op1, rax
            mov     op2, rdx
            lea     product, r8
            call    mul64
            
# Use a 64-bit multiply to test the result

            mov     op1, rax
            mov     op2, rdx
            imul    rdx, rax
            mov     rax, product2
            
# Print the results:

            lea     fmtStr1, rdi
            mov     op1, rsi
            mov     op2, rdx
            mov     product, rcx
            mov     product2, r8
            mov     $0, al
            call    printf
                
            
            leave
            ret     #Returns to caller

