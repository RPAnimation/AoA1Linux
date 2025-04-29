# Listing 3-1
#
# Demonstrate address expressions
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#	$build listing3-1
#	$listing3-1
#
# or
#
#	$gcc -o listing3-1 -fno-pie -no-pie c.cpp listing3-1.s -lstdc++
#	$listing3-1
#
#
#	"Magic" directive that includes the "reg.inc"
#	source file at this point during assembly.
#
#	The "regs.inc" contains equates for all the
#	x86-64 register names that allow you to 
#	specify them without the leading "%" character.
#	(this reduces programming errors.)
#	See the listing3-0.s file for details on
#	these equates.



            .section	const, "a"
			
ttlStr:     .asciz		"Listing 3-1"
fmtStr1:	.asciz		"i[0]=%d\n"
fmtStr2:	.asciz		"i[1]=%d\n"
fmtStr3:	.asciz		"i[2]=%d\n"	
fmtStr4:	.asciz		"i[3]=%d\n"



        	.data
i:			.byte    0, 1, 2, 3



        	.text
        	.extern	printf

# Return program title to C++ program:

         .global	getTitle
getTitle:
         lea ttlStr(%rip), %rax
         ret



        
# Here is the "asmMain" function.

        
        .global	asmMain
asmMain:
		push	%rbx		#Preserve RBX and align stack
                           

# Sadly, Gas does not allow you to use syntax like "i[1]"
# or even "i(1)" to access elements of the array "i". Gas
# does allow address expressions, though, where you simply
# add the offset you want to the base variable using the
# syntax "i+1".

		lea		fmtStr1(%rip), %rdi
        lea     i(%rip), %rax
		movzbq	0(%rax), %rsi		#load i[0] into RSI 
		mov		$0, %al
		call	printf
		
        lea		fmtStr1(%rip), %rdi
        lea     i(%rip), %rax
		movzbq	1(%rax), %rsi		#load i[1] into RSI 
		mov		$0, %al
		call	printf
        
        lea		fmtStr1(%rip), %rdi
        lea     i(%rip), %rax
		movzbq	2(%rax), %rsi		#load i[2] into RSI 
		mov		$0, %al
		call	printf
        
        lea		fmtStr1(%rip), %rdi
        lea     i(%rip), %rax
		movzbq	3(%rax), %rsi		#load i[3] into RSI 
		mov		$0, %al
		call	printf

		pop		%rbx
        ret     #Returns to caller

