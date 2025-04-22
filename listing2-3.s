# Listing 2-3
# 
# Demonstrate two's complement operation and input of numeric values.
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing2-3
#   $listing2-3
#
# or
#
#   $gcc -o listing2-3 -fno-pie -no-pie c.cpp listing2-3.s -lstdc++
#   $listing2-3
#
#


            .equ        maxLen, 256

            .data
titleStr:   .asciz      "Listing 2-3"

prompt1:    .asciz      "Enter an integer between 0 and 127:"
fmtStr1:    .asciz      "Value in hexadecimal: %x\n"
fmtStr2:    .asciz      "Invert all the bits (hexadecimal): %x\n"
fmtStr3:    .asciz      "Add 1 (hexadecimal): %x\n"
fmtStr4:    .asciz      "Output as signed integer: %d\n"
fmtStr5:    .asciz      "Using neg instruction: %d\n"

intValue:   .quad       0
input:      .fill       maxLen, 1, 0    # Array of 256 bytes filled with zeros
            
byteVar:    .byte       0
wordVar:    .word       0
dwordVar:   .int        0
qwordVar:   .quad       0            
            
            .text
            .extern     printf
            .extern     atoi
            .extern     readLine

# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     titleStr(%rip), %rax
            ret

        
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
                           
# "Magic" instruction offered without explanation at this point:

            push    %rbx
            
################################################################
#
# Syntax Demonstration
#           
# Before doing anything else, demonstrate Gas syntax for
# immediate (constant), memory instructions. Because there
# is no explicit size associated with memory objects (Gas
# doesn't keep track of .byte, .word, .int, and .quad during
# assembly), you must explicitly state the instruction size
# when using instructions that don't involve any registers.
# Such instructions are generally instructions involving
# a constant (immediate) operand and a memory operand. Here
# is the Gas syntax for the logical operations introduced in
# this source file:

            andb    $0, byteVar(%rip)
            andw    $0, wordVar(%rip)
            andl    $0, dwordVar(%rip)
            andq    $0, qwordVar(%rip)

            orb     $0, byteVar(%rip)
            orw     $0, wordVar(%rip)
            orl     $0, dwordVar(%rip)
            orq     $0, qwordVar(%rip)

            xorb    $0, byteVar(%rip)
            xorw    $0, wordVar(%rip)
            xorl    $0, dwordVar(%rip)
            xorq    $0, qwordVar(%rip)
            
# NOT and NEG operate directly on memory with no immediate
# operands, however the same size issue exists with the
# single memory operand:

            notb    byteVar(%rip)
            notw    wordVar(%rip)
            notl    dwordVar(%rip)
            notq    qwordVar(%rip)

            negb    byteVar(%rip)
            negw    wordVar(%rip)
            negl    dwordVar(%rip)
            negq    qwordVar(%rip)

#           
################################################################
                        

                
# Read an unsigned integer from the user: This code will blindly
# assume that the user's input was correct. The atoi function returns
# zero if there was some sort of error on the user input. Later
# chapters in Ao64A will describe how to check for errors from the
# user.
#
# Remember: printf parameters are:
#
#   al: must be zero.
#  rdi: format string
#  rsi: 1st argument (for format string)
#  rdx: 2nd argument
#  rcx: 3rd argument
#  r8:  4th argument
#  r9:  5th argument
#
# Don't forget: "$" precedes constant (immediate) operands.  

            mov     $0, %al
            lea     prompt1(%rip), %rdi
            call    printf
        
            lea     input(%rip), %rdi     #Parm 1: Address of input string
            mov     $maxLen, %rsi   #Parm 2: Max string size
            call    readLine
        
# Call C stdlib atoi function.
#
# i = atoi( str )
        
            lea     input(%rip), %rdi     #Parm: Pointer to string
            call    atoi
            and     $0xff, %rax     #Only keep L.O. eight bits
            mov     %rax, intValue(%rip) # and save away in memory
        
# Print the input value (in decimal) as a hexadecimal number:

            mov     %rax, %rsi        
            mov     $0, %al
            lea     fmtStr1(%rip), %rdi
            call    printf
        
# Perform the two's complement operation on the input number. 
# Begin by inverting all the bits (just work with a byte here).
        
            mov     $0, %al
            mov     intValue(%rip), %rsi
            not     %sil            #Only work with 8-bit values!
            lea     fmtStr2(%rip), %rdi
            call    printf
        
# Invert all the bits and add 1 (still working with just a byte)
        
            mov     $0, %al
            mov     intValue(%rip), %rsi
            not     %rsi
            add     $1, %rsi
            and     $0xff, %rsi      # Only keep L.O. eight bits
            lea     fmtStr3(%rip), %rdi
            call    printf
        
# Negate the value and print as a signed integer (work with a full
# integer here, because C++ %d format specifier expects a 32-bit
# integer. H.O. 32 bits of RDI get ignored by C++.
        
            mov     $0, %al
            mov     intValue(%rip), %rsi
            not     %rsi
            add     $1, %rsi
            lea     fmtStr4(%rip), %rdi
            call    printf
        
# Negate the value using the neg instruction.
        
            mov     $0, %al
            mov     intValue(%rip), %rsi
            neg     %rsi
            lea     fmtStr5(%rip), %rdi
            call    printf

# Another "magic" instruction that undoes the effect of the previous
# one before this procedure returns to its caller.
       
            pop     %rbx
            ret     #Returns to caller

