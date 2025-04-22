# Listing 8-0
#
# Preliminary information concerning Ao64A-Chapter 8

                .include    "regs.inc"      #Use Intel register names
                
				.equ		reg32, eax		#Represents any 32-bit GPR
				.equ		reg64, rax		#Represents any 64-bit GPR
				.equ		constant, 1

                .section    const, "a"
ttlStr:         .asciz      "Listing 5-0"

                .data
bVar:           .byte       0
wVar:           .word       0
dVar:           .int        0
qVar:           .quad       0

# Gas uses .octa to define 128-bit variables:

oVar:			.octa		0


# Gas (at least latest versions) don't seem to support 10-byte
# variable declarations (e.g., REAL80 and TBYTE in MASM).
# There are some scattered mentions of a ".bcd" directive on
# the internet, but the latest version of Gas doesn't recognize
# that. AFAIK, the only way to declare 10-byte objects in
# Gas is with:

ten_bytes:		.fill	10, 1, 0


# To rub salt into the wound, the .fill directive doesn't allow the size operand
# to be larger than 8 (generates a warning and sets it to 8 if a larger value
# is specified. If you want to create an array of REAL10/TBYTE variables,
# do this:

				.equ	numElements, 16
				.fill	10*numElements, 1, 0


				.data


#
# Extended-precision shift left and right instructions:
#
				.text
				shldl	$constant, reg32, dVar
				shldl	cl, reg32, dVar
				shldl	$constant, reg32, reg32
				shldl	cl, reg32, reg32
				
				shldq	$constant, reg64, dVar
				shldq	cl, reg64, qVar
				shldq	$constant, reg64, reg64
				shldq	cl, reg64, reg64
				
				shrdl	$constant, reg32, dVar
				shrdl	cl, reg32, dVar
				shrdl	$constant, reg32, reg32
				shrdl	cl, reg32, reg32
				
				shrdq	$constant, reg64, dVar
				shrdq	cl, reg64, qVar
				shrdq	$constant, reg64, reg64
				shrdq	cl, reg64, reg64
				
				
                
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

