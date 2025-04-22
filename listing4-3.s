# Listing 4-3
#
# Demonstration of calls
# to C standard library malloc
# and free functions.
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing4-3
#   $listing4-3
#
# or
#
#   $gcc -o listing4-3 -fno-pie -no-pie c.cpp listing4-3.s -lstdc++
#   $listing4-3


    .include    "regs.inc"      #Use Intel register names

            .section    const, "a"
ttlStr:     .asciz      "Listing 4-3"
fmtStr:     .asciz      "Addresses returned by malloc: %ph, %ph\n"
        
            .data
ptrVar:     .quad   0
ptrVar2:    .quad   0



            .text
            .extern printf
            .extern malloc
            .extern free


# Return program title to C++ program:

            .global getTitle
getTitle:
            lea ttlStr, rax
            ret


# Here is the "asmMain" function.

        
            .global asmMain
asmMain:

            push    rbx     #Align stack
                    
# C standard library malloc function
#
# ptr = malloc( byteCnt )#

            mov     $256, rdi       # Allocate 256 bytes
            call    malloc
            mov     rax, ptrVar         # Save pointer to buffer

            mov     $1024, rdi       # Allocate 1,024 bytes
            call    malloc
            mov     rax, ptrVar2     # Save pointer to buffer

            lea     fmtStr, rdi
            mov     ptrVar, rsi
            mov     rax, rdx         # Print addresses
            mov     $0, al  
            call    printf

# Free the storage by calling
# C standard library free function.
#
# free( ptrToFree )#

            mov     ptrVar, rdi
            call    free

            mov     ptrVar2, rdi
            call    free

            pop     rbx
            ret     #Returns to caller
        

