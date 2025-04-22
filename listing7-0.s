# Listing 7-0
#
# Preliminary information concerning Ao64A-Chapter 7

                .include    "regs.inc"      #Use Intel register names
                

                .section    const, "a"
ttlStr:         .asciz      "Listing 5-0"

                .data
bVar:           .byte       0
wVar:           .word       0
dVar:           .int        0
qVar:           .quad       0



# Note: Gas does not support locally-scoped
# symbols as MASM does. Instead, local symbols
# consist of a single decimal digit followed
# by a ":". A subroutine references local symbols
# using "nF" or "nB" (where "n" is the corresponding
# single digit). "nF" mean reference the symbol
# in the forward direction (towards the end of the
# source file). "nB" means reference the forward
# symbol in the backward direction (towards the
# beginning of the source file). Note that
# multiple symbols with the same digit may appear
# in the source file (procedure). Ambiguity is
# resolved by having "nF" reference the *next*
# symbol in the source file with the digit "n"
# and "nB" referencing the immediately previous
# symbol with the digit "n" in the source file.

        
# To store the address of a label in a memory location,
# simply specify that label as the operand in a 
# .quad directive:

			.data
someLabel	.quad	someLabel		#Address of someLabel stored here.




# Gas "jmp" instruction:
#
#	jmp label		-Transfers control directly to target "label"
#	jmp *qVar		-qVar holds a 64-bit pointer. Transfer control to address held in qVar
#	jmp	*reg64		-reg64 is a 64-bit general-purpose register. Transfer control
#					- to the address held in the register.

            .text
			jmp		hasLocalLbl		#Direct jump
			jmp		*qVar			#Indirect (mem64) jump
			jmp		*rdx			#Indirect (reg64) jmp
			

hasLocalLbl:
            jmp 1f  #jump to symbol a
1:  #symbol a
            jmp 1b  #jmp to symbol a
            jmp 1f  #jmp to symbol b
1:  #symbol b
            jmp 1b  #jmp to symbol b
            jmp 1f  #jmp to symbol c
1:  #symbol c

            ret

                
# Return program title to C++ program:

                .text
                .global getTitle
getTitle:
                lea     ttlStr, rax
                ret
#end getTitle


# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbx


allDone:       
            pop     rbx
            ret     #Returns to caller

#end asmMain

