# Listing 2-2
# 
# Demonstrate AND, OR, XOR, and NOT logical instructions.
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing2-2
#   $listing2-2
#
# or
#
#   $gcc -o listing2-2 -fno-pie -no-pie c.cpp listing2-2.s -lstdc++
#   $listing2-2
#
#

              .data
byteVar:      .byte     0
wordVar:      .word     0
dwordVar:     .int      0
qwordVar:     .quad     0

leftOp:       .int      0xf0f0f0f
rightOp1:     .int      0xf0f0f0f0
rightOp2:     .int      0x12345678

titleStr:     .asciz "Listing 2-2"

fmtStr1:      .asciz    "%08lx AND %08lx = %08lx\n"
fmtStr2:      .asciz    "%08lx OR  %08lx = %08lx\n"
fmtStr3:      .asciz    "%08lx XOR %08lx = %08lx\n"
fmtStr4:      .asciz    "NOT %08lx = %08lx\n"

             .text
             .extern    printf

# Return program title to C++ program:

             .global    getTitle
getTitle:

#  Load address of "titleStr" into the RAX register (RAX holds the
#  function return result) and return back to the caller:
# 
            lea     titleStr(%rip), %rax
            ret


        
# Here is the "asmMain" function.

        
            .global     asmMain
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
#
# Demonstrate Gas syntax for const/memory operations:

            andb    $-1, byteVar(%rip)
            andw    $-1, wordVar(%rip)
            andl    $-1, dwordVar(%rip)
            andq    $-1, qwordVar(%rip)
            
            orb     $0, byteVar(%rip)
            orw     $0, wordVar(%rip)
            orl     $0, dwordVar(%rip)
            orl     $0, qwordVar(%rip)
            
            xorb    $0, byteVar(%rip)
            xorw    $0, wordVar(%rip)
            xorl    $0, dwordVar(%rip)
            xorq    $0, qwordVar(%rip)
            
            notb    byteVar(%rip)
            notw    wordVar(%rip)
            notl    dwordVar(%rip)
            notq    qwordVar(%rip)
                   
#           
################################################################


# Demonstrate the AND instruction

            mov     $0, %al
            lea     fmtStr1(%rip), %rdi
            mov     leftOp(%rip), %esi
            mov     rightOp1(%rip), %edx
            mov     %esi, %ecx      # Compute leftOp 
            and     %edx, %ecx      #   AND rightOp1
            call    printf

            mov     $0, %al
            lea     fmtStr1(%rip), %rdi
            mov     leftOp(%rip), %rsi
            mov     rightOp2(%rip), %rdx
            mov     %rsi, %rcx
            and     %rdx, %rcx
            call    printf

# Demonstrate the OR instruction

            mov     $0, %al
            lea     fmtStr2(%rip), %rdi
            mov     leftOp(%rip), %esi
            mov     rightOp1(%rip), %edx
            mov     %esi, %ecx      # Compute leftOp 
            or      %edx, %ecx      #   OR rightOp1
            call    printf

            mov     $0, %al
            lea     fmtStr2(%rip), %rdi
            mov     leftOp(%rip), %esi
            mov     rightOp2(%rip), %edx
            mov     %esi, %ecx      # Compute leftOp 
            or      %edx, %ecx      #   OR rightOp2
            call    printf

# Demonstrate the XOR instruction

            mov     $0, %al
            lea     fmtStr3(%rip), %rdi
            mov     leftOp(%rip), %esi
            mov     rightOp1(%rip), %edx
            mov     %esi, %ecx      # Compute leftOp 
            xor     %edx, %ecx      #   XOR rightOp1
            call    printf

            mov     $0, %al
            lea     fmtStr3(%rip), %rdi
            mov     leftOp(%rip), %esi
            mov     rightOp2(%rip), %edx
            mov     %esi, %ecx      # Compute leftOp 
            xor     %edx, %ecx      #   XOR rightOp1
            call    printf

# Demonstrate the NOT instruction

            mov     $0, %al
            lea     fmtStr4(%rip), %rdi
            mov     leftOp(%rip), %esi
            mov     %esi, %edx  # Compute not leftOp 
            not     %edx
            call    printf

            mov     $0, %al
            lea     fmtStr4(%rip), %rdi
            mov     rightOp1(%rip), %esi
            mov     %esi, %edx  # Compute not rightOp1 
            not     %edx
            call    printf

            mov     $0, %al
            lea     fmtStr4(%rip), %rdi
            mov     rightOp2(%rip), %esi
            mov     %esi, %edx  # Compute not rightOp2 
            not     %edx
            call    printf


# Another "magic" instruction that undoes the effect of the previous
# one before this procedure returns to its caller.
       
            pop     %rbx
        
        
            ret     #Returns to caller
        
