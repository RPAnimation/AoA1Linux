# Listing 10-1
#
# Real string to floating-point conversion
#
#   $build listing9-19
#   $listing9-19
#
# or
#
#   $gcc -o listing9-19 -fno-pie -no-pie c.cpp listing9-19.s -lstdc++
#   $listing9-19



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.
            
            .equ    false, 0
            .equ    true, 1
            
            .equ    tab, 9

            .section    const, "a"
ttlStr:     .asciz    	"Listing 10-1"
fmtStr1:    .asciz    	"strToR10: str='%s', value=%e\n"
           
table:		.byte	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'

            .data
r8Val:      .double	0

            
            .text
            .extern	printf
            
# Return program title to C++ program:

            .global	getTitle
getTitle:
            lea     ttlStr, rax
            ret



# Used for debugging:

print:
            push    rdi
            push    rsi
            push    rdx
            push    rcx
            push    r8
            push    r9
            push    r10
            push    r11
            push    rax
            push    rbp
            mov     rsp, rbp
            and     $-16, rsp       
            
# Get the pointer to the string immediately following the
# call instruction and scan for the zero-terminating byte.
            
            mov     80(rbp), rdi     #Return address is here
            lea     -1(rdi), rsi     #rsi = return address - 1
search4_0:  inc     rsi              #Move on to next char
            cmpb    $0, (rsi)        #At end of string?
            jne     search4_0
            
# Fix return address and compute length of string:

            inc     rsi               #Point at new return address
            mov     rsi, 80(rbp)      #Save return address
            
# Call Write to print the string to the console

            mov     64(rbp), rsi
            mov     56(rbp), rdx
            mov     48(rbp), rcx
            mov     40(rbp), r8
            mov     32(rbp), r9
            mov     8(rbp), al
            call    printf
    
xit:            leave
            pop     rax
            pop     r11
            pop     r10
            pop     r9
            pop     r8
            pop     rcx
            pop     rdx
            pop     rsi
            pop     rdi                     
            ret



            
                    
            
# Here is the "asmMain" function.

        
            .global	asmMain
asmMain:
            push    rbx
            push    rbp
            mov     rsp, rbp
			and		$-16, rsp
			            
			lea		table, rbx
			xor		rax, rax
			xlat
			mov		eax, esi
			call	print
			.asciz	"a=%c\n"
 

             
allDone:    leave
            pop     rbx
            ret     #Returns to caller
