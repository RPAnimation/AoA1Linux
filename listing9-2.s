# Listing 9-2
#
# Numeric to hex string functions
#
#   $build listing9-2
#   $listing9-2
#
# or
#
#   $gcc -o listing9-2 -fno-pie -no-pie c.cpp listing9-2.s -lstdc++
#   $listing9-2



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 8-5"
fmtStr1:    .asciz      "btoStr: Value=%zx, string=%s\n"
fmtStr2:    .asciz      "wtoStr: Value=%zx, string=%s\n"
fmtStr3:    .asciz      "dtoStr: Value=%zx, string=%s\n"
fmtStr4:    .asciz      "qtoStr: Value=%zx, string=%s\n"
            
            .data
buffer:     .fill       20, 1, 0
            
            .text
            .extern printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



# btoh-
#
# This procedure converts the binary value
# in the AL register to 2 hexadecimal
# characters and returns those characters
# in the AH (HO hibble) and AL (LO nibble)
# registers. 

btoh:

            mov     al, ah     #Do HO nibble first
            shr     $4, ah     #Move HO nibble to LO
            or      $'0', ah   #Convert to char
            cmp     $'9'+1, ah #Is it 'A'..'F'?
            jb      AHisGood
            
# Convert 3ah..3fh to 'A'..'F'

            add     $7, ah

# Process the LO nibble here
            
AHisGood:   and     $0xf, al        #Strip away HO nibble
            or      $'0', al    #Convert to char
            cmp     $'9'+1, al  #Is it 'A'..'F'?
            jb      ALisGood
            
# Convert 3ah..3fh to 'A'..'F'

            add     $7, al   
ALisGood:   ret



# btoStr-
#
#  Converts the byte in AL to a string of hexadecimal
# characters and stores them at the buffer pointed at
# by RDI. Buffer must have room for at least 3 bytes.
# This function zero-terminates the string.

btoStr:
            push    rax
            call    btoh            #Do conversion here
            
# Create a zero-terminated string at [RDI] from the
# two characters we converted to hex format:

            mov     ah, (rdi)
            mov     al, 1(rdi)
            movb    $0, 2(rdi)
            pop     rax
            ret




# wtoStr-
#
#  Converts the word in AX to a string of hexadecimal
# characters and stores them at the buffer pointed at
# by RDI. Buffer must have room for at least 5 bytes.
# This function zero-terminates the string.

wtoStr:
            push    rdi
            push    rax     #Note: leaves LO byte at (rsp)
            
# Use btoStr to convert HO byte to a string:

            mov     ah, al
            call    btoStr

            mov     (rsp), al       #Get LO byte
            add     $2, rdi         #Skip HO chars
            call    btoStr
            
            pop     rax
            pop     rdi
            ret



# dtoStr-
#
#  Converts the dword in EAX to a string of hexadecimal
# characters and stores them at the buffer pointed at
# by RDI. Buffer must have room for at least 9 bytes.
# This function zero-terminates the string.

dtoStr:
            push    rdi
            push    rax     #Note: leaves LO word at (rsp)
            
# Use wtoStr to convert HO word to a string:

            shr     $16, eax
            call    wtoStr

            mov     (rsp), ax       #Get LO word
            add     $4, rdi         #Skip HO chars
            call    wtoStr
            
            pop     rax
            pop     rdi
            ret



# qtoStr-
#
#  Converts the qword in RAX to a string of hexadecimal
# characters and stores them at the buffer pointed at
# by RDI. Buffer must have room for at least 17 bytes.
# This function zero-terminates the string.

qtoStr:
            push    rdi
            push    rax     #Note: leaves LO dword at (rsp)
            
# Use dtoStr to convert HO dword to a string:

            shr     $32, rax
            call    dtoStr

            mov     (rsp), eax      #Get LO dword
            add     $8, rdi         #Skip HO chars
            call    dtoStr
            
            pop     rax
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
            
# Demonstrate call to btoStr:

            mov     $0xaa, al
            call    btoStr
            
            mov     rdi, rdx
            lea     fmtStr1, rdi
            mov     eax, esi
			mov		$0, al
            call    printf

# Demonstrate call to wtoStr:

            lea     buffer, rdi
            mov     $0xa55a, ax
            call    wtoStr
            
            mov     rdi, rdx
            lea     fmtStr2, rdi
            mov     eax, esi
			mov		$0, al
            call    printf
            
# Demonstrate call to dtoStr:

            lea     buffer, rdi
            mov     $0xaa55FF00, eax
            call    dtoStr
            
            mov     rdi, rdx
            lea     fmtStr3, rdi
            mov     eax, esi
			mov		$0, al
            call    printf
            
# Demonstrate call to qtoStr:

            lea     buffer, rdi
            mov     $0x1234567890abcdef, rax
            call    qtoStr
            
            mov     rdi, rdx
            lea     fmtStr4, rdi
            mov     rax, rsi
			mov		$0, al
            call    printf

            
alldone:
            leave
            pop     rdi
            ret     #Returns to caller
        
