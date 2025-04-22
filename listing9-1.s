# Listing 9-1
#
# Convert a byte value to 2 hexadecimal digits
#
#   $build listing9-1
#   $listing9-1
#
# or
#
#   $gcc -o listing9-1 -fno-pie -no-pie c.cpp listing9-1.s -lstdc++
#   $listing9-1



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 9-1"
fmtStr1:    .asciz      "Value=%x, as hex=%c%c\n"
            

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
                        





            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp
            
            mov     $0xaa, al
            call    btoh

            lea     fmtStr1, rdi
            mov     $0xaa, rsi
            movzx   ah, edx          #Can't move ah into r8b!
            mov     al, cl
			mov		$0, al
            call    printf                
            
            leave
            ret     #Returns to caller
        
