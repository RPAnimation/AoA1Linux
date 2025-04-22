# Listing 4-5
#
# Demonstration of lack of type
# checking in assembly language
# pointer access
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#	$build listing4-5
#	$listing4-5
#
# or
#
#	$gcc -o listing4-5 -fno-pie -no-pie c.cpp listing4-5.s -lstdc++
#	$listing4-5

            .include    "regs.inc"      #Use Intel register names

            .equ        maxLen, 256

            .section    const, "a"
ttlStr:     .asciz      "Listing 4-5"
prompt:     .asciz      "Input a string: "
fmtStr:     .asciz      "%d: Hex value of char read: %x\n"
        
            .data       
bytesRead:  .quad       0
bufPtr:     .quad       0
buffer:     .fill       256
        
            .text
            .extern     readLine
            .extern     printf
            .extern     malloc
            .extern     free


# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret


# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbx     #Preserve RBX


# C standard library malloc function
# Allocate sufficient characters
# to hold a line of text input
# by the user:

            mov     $maxLen, rdi    # Allocate 256 bytes
            call    malloc
            mov     rax, bufPtr     # Save pointer to buffer

# Read a line of text from the user and place in
# the newly allocated buffer:

            mov     $0, al
            lea     prompt, rdi     # Prompt user to input
            call    printf          #  a line of text.

            mov     bufPtr, rdi     # Pointer to input buffer
            mov     $maxLen, rsi    # Maximum input buffer length
            call    readLine        # Read text from user

            cmp     $-1, rax         # Skip output if error
            je      allDone
            mov     rax, bytesRead   #Save number of chars read
            
            
        
# Display the data input by the user:

            xor     rbx, rbx        #Set index to zero
dispLp:     mov     bufPtr, rdx     #Pointer to buffer
            mov     rbx, rsi        #Display index into buffer
            mov     (rdx,rbx,1), rdx #Read dword rather than byte!
            lea     fmtStr, rdi
            mov     $0, al
            call    printf
        
            inc     rbx             #Repeat for each char in buffer
            cmp     bytesRead, rbx
            jb      dispLp

# Free the storage by calling
# C standard library free function.
#
# free( bufPtr )#

allDone:
            mov     bufPtr, rdi
            call    free


            pop     rbx     #Restore RBX
            ret     #Returns to caller

