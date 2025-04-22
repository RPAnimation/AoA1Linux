# Listing 9-4
#
# Numeric unsigned integer to string function
#
#   $build listing9-4
#   $listing9-4
#
# or
#
#   $gcc -o listing9-4 -fno-pie -no-pie c.cpp listing9-4.s -lstdc++
#   $listing9-4



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 9-4"
fmtStr1:    .asciz      "utoStr: Value=%zu, string=%s\n"
            
            .data
buffer:     .fill   24, 1, 0
            
            .text
            .extern printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



# utoStr-
#
#  Unsigned integer to string.
#
# Inputs:
#
#    RAX:   Unsigned integer to convert
#    RDI:   Location to hold string.
#
# Note: for 64-bit integers, resulting
# string could be as long as  20 bytes
# (including the zero-terminating byte).

utoStr:
            push    rax
            push    rdx
            push    rdi

# Handle zero specially:
            
            test    rax, rax
            jnz     doConvert
            
            movb    $'0', (rdi) 
            inc     rdi
            jmp     allDone 
            

doConvert:  call    rcrsvUtoStr

# Zero-terminte the string and return:
            
allDone:    movb    $0, (rdi)
            pop     rdi
            pop     rdx
            pop     rax
            ret


ten:        .quad   10

# Here's the recursive code that does the
# actual conversion:

rcrsvUtoStr:

            xor     rdx, rdx #Zero-extend RAX->RDX
            divq    ten
            push    rdx      #Save output value
            test    eax, eax #Quit when RAX is 0
            jz      allDone2 
            
# Recursive call to handle value % 10:

            call    rcrsvUtoStr

allDone2:   pop     rax                #Retrieve char to print
            and     $0xf, al           #Convert to '0'..'9'
            or      $'0', al 
            mov     al, (rdi)          #Save in buffer
            inc     rdi                #Next char position
            ret



            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rdi
            push    rbp
            mov     rsp, rbp
            and     $-16, rsp
                        
# Because all the (x)toStr functions preserve RDI,
# we only need to do the following once:
 
            lea     buffer, rdi
            mov     $1234567890, rax
            call    utoStr
            
# Print the result

            mov     rdi, rdx
            lea     fmtStr1, rdi
            mov     rax, rsi
			mov		$0, al
            call    printf
            
            leave
            pop     rdi
            ret     #Returns to caller
        
