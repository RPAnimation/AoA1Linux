# Listing 5-3
#
# Preserving registers (failure) example
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing5-3
#   $listing5-3
#
# or
#
#   $gcc -o listing5-3 -fno-pie -no-pie c.cpp listing5-3.s -lstdc++
#   $listing5-3


			.include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

			.section	const, "a"
ttlStr:     .asciz		"Listing 5-3"
space:      .asciz		" "
asterisk:   .asciz		"*, %d\n"
        
            .text
	      	.exter		printf

# Return program title to C++ program:

             .global	getTitle
getTitle:
             lea 		ttlStr, rax
             ret




# print40Spaces-
# 
#  Prints out a sequence of 40 spaces
# to the console display.

print40Spaces:
			push	rbp			#Just to align stack
	      	mov  	$40, ebx
printLoop:  lea  	space, rcx
			mov		$0, al
 	      	call 	printf
	      	dec  	ebx
	      	jnz  	printLoop #Until ebx==0
			pop		rbp
            ret



# Here is the "asmMain" function.

              public  asmMain
asmMain       proc
              push    rbx
		
              mov     $20, rbx
astLp:        call    print40Spaces
              lea     asterisk, rdi
	      	  mov     rbx, rsi			#Always prints zero
			  mov	  $0, al			# because of print40spaces
	      	  call    printf
              dec     rbx
	          jnz     astLp

	      	  pop     rbx
              ret     #Returns to caller
