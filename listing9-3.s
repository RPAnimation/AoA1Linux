# Listing 9-3
#
# Numeric to hex string functions
#
#   $build listing9-3
#   $listing9-3
#
# or
#
#   $gcc -o listing9-3 -fno-pie -no-pie c.cpp listing9-3.s -lstdc++
#   $listing9-3



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 9-3"
fmtStr1:    .asciz      "qtoStr: Value=%zx, string=%s\n"
            
            .data
buffer:     .fill       20, 1, 0
            
            .text
            .extern     printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret






# qtoStr-
#
#  Converts the qword in RAX to a string of hexadecimal
# characters and stores them at the buffer pointed at
# by RDI. Buffer must have room for at least 17 bytes.
# This function zero-terminates the string.

hexChar:    .ascii  "0123456789ABCDEF"

qtoStr:
            push    rdi
            push    rcx
            push    rdx
            push    rax             #Leaves LO dword at [rsp]
                            
            lea     hexChar, rcx

            xor     edx, edx        #Zero extends!
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl #Table lookup
            mov     dl, (rdi)
                            
# Emit bits 56-59:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 1(rdi)
                            
# Emit bits 52-55:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 2(rdi)
            
# Emit bits 48-51:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 3(rdi)
            
# Emit bits 44-47:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 4(rdi)
                            
# Emit bits 40-43:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 5(rdi)
            
# Emit bits 36-39:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 6(rdi)
            
# Emit bits 32-35:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 7(rdi)
            
# Emit bits 28-31:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 8(rdi)
            
# Emit bits 24-27:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 9(rdi)
            
# Emit bits 20-23:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 10(rdi)
            
# Emit bits 16-19:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 11(rdi)
            
# Emit bits 12-15:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 12(rdi)
            
# Emit bits 8-11:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 13(rdi)
            
# Emit bits 4-7:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 14(rdi)
            
# Emit bits 0-3:

            xor     edx, edx
            shld    $4, rax, rdx
            shl     $4, rax
            mov     (rcx,rdx,1), dl
            mov     dl, 15(rdi)
            
# Zero-terminate string:

            movb     $0, 16(rdi)
            


            pop     rax
            pop     rdx
            pop     rcx
            pop     rdi
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
            
            
# Demonstrate call to qtoStr:

            mov     $0xaa55FF0022334455, rax
            call    qtoStr
            
            mov     rdi, rdx
            lea     fmtStr1, rdi
            mov     rax, rsi
			mov		$0, al
            call    printf

            
            leave
            pop     rdi
            ret     #Returns to caller
        
