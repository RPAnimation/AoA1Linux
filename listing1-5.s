# Listing 1-5
#
# A "Hello, World!" program using the C/C++ printf function to 
# provide the output.

        .data

# Remember, ".asciz" adds a zero byte to the
# end of the following ASCII string. Strings
# take the usual "C/C++" format; they must be
# surrounded by quotes and may contain C-style
# escape sequences. E.g., "\n" corresponds to
# a newline character.
 
fmtStr:  .asciz    "Hello, World!\n"


#Start of code section:

        .text

# External declaration so Gas knows about the C/C++ printf 
# function (technically, this is optional; all undefined
# symbols are external in Gas).

        .extern   printf

        
# Here is the "asmFunc" function.


        .global   asmFunc        
asmFunc:

# Just to align the stack on a 16-byte boundary:

        push    %rbx        

# Here's where will call the C printf function to print 
# "Hello, World!" Pass the address of the format string
# to printf in the RCX register. Use the LEA instruction 
# to get the address of fmtStr.
#
# Remember: printf parameters are:
#
#	al: must be zero.
#  rdi: format string
#  rsi: 1st argument (for format string)
#  rdx: 2nd argument
#  rcx: 3rd argument
#  r8:	4th argument
#  r9:	5th argument
#
# Don't forget: "$" precedes constant (immediate) operands.  

        
        mov     $0, %al			#No XMM/Float parameters
        lea     fmtStr(%rip), %rdi	#RDI = &fmtStr	
        call    printf
 
# Undoes the effect of the push, earlier
       
        pop     %rbx       
        
        ret     #Returns to caller
        

