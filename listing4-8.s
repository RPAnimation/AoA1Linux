# Listing 4-8
#
# Sample struct initialization example.
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing4-8
#   $listing4-8
#
# or
#
#   $gcc -o listing4-8 -fno-pie -no-pie c.cpp listing4-8.s -lstdc++
#   $listing4-8


            .include    "regs.inc"      #Use Intel register names


            .section    const, "a"
ttlStr:     .asciz      "Listing 4-8"
fmtStr:     .asciz      "aString: maxLen:%d, len:%d, string data:'%s'\n"

 
# Define a struct for a string descriptor:
       

            .equ    .maxLen, 0
            .equ    .len, .maxLen+4
            .equ    .strPtr, .len+4
            .equ    strDescSize, .strPtr+8

            .data

# Here's the string data we will initialize the
# string descriptor with:

charData:   .asciz   "Initial String Data"
            .equ    len, .-charData  #Includes zero byte

# Create a string descriptor initialized with
# the charData string value:

aString:    .int    len, len
            .quad   charData
               
        
            .text
            .extern printf

# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret


# Here is the "asmMain" function.

            .global asmMain
asmMain:

            push    rbx         #align stack
            
# Display the fields of the string descriptor.

        lea     fmtStr, rdi
        mov     aString+.maxLen, esi    #Zero extends!
        mov     aString+.len, edx    #Zero extends!
        mov     aString+.strPtr, rcx
        mov     $0, al
        call    printf

        pop     rbx     #Restore RSP
        ret             #Returns to caller

