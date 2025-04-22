# Listing 3-0
#
# Preliminary information concerning Ao64A-Chapter 3
#
# Note that each operating system orders segments in
# its own way. If you want to control the loading
# of segments (sections) in memory, please see the
# documentation for the GNU "ld" program; it has options
# to control the position of sections in memory.
#

			.equ	maxLen, 256

#----------------------------------------------------
#
# Concerning Windows' "LARGEADDRESSAWARE:NO" option
#
# Assembly programs under Linux produced by GCC are
# generally "position independent." This allows the
# program loader to relocation sections of the program
# anywhere it sees fit in memory. This is done for
# security purposes, so "bad actor" code can't easily
# find the data associated with the program code.
#
# While this is good for security, it is bad for
# code generation. "Anywhere it sees fit in memory"
# includes doing things like placing the ".data"
# section (or any other section) farther than 2GB
# away from the code (.text) section. This means that
# the code cannot directly access variables in the
# .data (or other) section using the direct (PC-relative)
# addressing mode. Instead, the program has to set up
# a pointer to the data section (in a 64-bit general-
# purpose register) and index to that variable off the
# register. This is inefficient (and very painful in
# assembly language). Assembly programmers generally
# have to turn this security scheme off in order to
# use the normal addressing modes on the x86-64. This
# is done with the following two gcc command-line
# options:
#
#  -fno-pie -no-pie
#
# (which you may have see in the "build" shell
# script from the previous chapters).
#
# These options tell gcc (and the linker) not to
# expect position independent code. Without these
# options, you're likely to see errors such as
#
# """
# /usr/bin/ld: /tmp/ccrtmHfV.o: relocation R_X86_64_32S 
# against `.data' can not be used when making a PIE object; 
# recompile with -fPIC
# """
#
# when compiling/assembling your projects.
#
# One drawback to this scheme is that your program must
# live within the lower 2GB of the Linux address space.
# Generally, this is not a problem for most programs,
# but keep in mind this limitation. On the plus side,
# this does open up the use of various addressing mode
# forms mentioned in Ao64A with respect to the
# Window's "LARGEADDRESSAWARE:NO" option.
			
			
#----------------------------------------------------
#
# Magic use of the ".equ" directive: renaming registers
#
# The Gas syntax for registers on the x86-64 is painful.
# Having to type "%" in front of all the register names
# *does* allow you to use names like RAX and AX as
# variable names. However, doing that would be incredibly
# bad programming style because it would confuse anyone
# reading your code. 
#
# If you accidentally leave a "%" off a register name,
# Gas thinks it's a variable name and you'll have to
# fix this issue. Wouldn't it be convenient if you could
# just use real Intel register names just like every
# other x86-64 assembler on the planet? Guess what, you
# can. You can use the ".equ" directive to rename the
# register as follows:

			.equ	al, %al
			.equ	ah, %ah
			.equ	bl, %bl
			.equ	bh, %bh
			.equ	cl, %cl
			.equ	ch, %ch
			.equ	dl, %dl
			.equ	dh, %dh
			
			.equ	sil, %sil
			.equ	dil, %dil
			.equ	spl, %spl
			.equ	bpl, %bpl
			
			.equ	r8b,  %r8b
			.equ	r9b,  %r9b
			.equ	r10b, %r10b
			.equ	r11b, %r11b
			.equ	r12b, %r12b
			.equ	r13b, %r13b
			.equ	r14b, %r14b
			.equ	r15b, %r15b
			
			.equ	ax, %ax
			.equ	bx, %bx
			.equ	cx, %cx
			.equ	dx, %dx
			.equ	si, %si
			.equ	di, %di
			.equ	sp, %sp
			.equ	bp, %bp
			
			.equ	r8w,  %r8w
			.equ	r9w,  %r9w
			.equ	r10w, %r10w
			.equ	r11w, %r11w
			.equ	r12w, %r12w
			.equ	r13w, %r13w
			.equ	r14w, %r14w
			.equ	r15w, %r15w
			
			.equ	eax, %eax
			.equ	ebx, %ebx
			.equ	ecx, %ecx
			.equ	edx, %edx
			.equ	esi, %esi
			.equ	edi, %edi
			.equ	esp, %esp
			.equ	ebp, %ebp
			
			.equ	r8d,  %r8d
			.equ	r9d,  %r9d
			.equ	r10d, %r10d
			.equ	r11d, %r11d
			.equ	r12d, %r12d
			.equ	r13d, %r13d
			.equ	r14d, %r14d
			.equ	r15d, %r15d
			
			.equ	rax, %rax
			.equ	rbx, %rbx
			.equ	rcx, %rcx
			.equ	rdx, %rdx
			.equ	rsi, %rsi
			.equ	rdi, %rdi
			.equ	rsp, %rsp
			.equ	rbp, %rbp
			
			.equ	r8,  %r8
			.equ	r9,  %r9
			.equ	r10, %r10
			.equ	r11, %r11
			.equ	r12, %r12
			.equ	r13, %r13
			.equ	r14, %r14
			.equ	r15, %r15
			
			.equ	rip, %rip
			
			
			
			
			.text
			
			mov	$0, al
			mov $0, ah
			mov	$0, bl
			mov $0, bh
			mov	$0, cl
			mov $0, ch
			mov	$0, dl
			mov $0, dh

			mov	$0, dil
			mov	$0, sil
			mov	$0, spl
			mov	$0, bpl
			
			mov	$0, r8b
			mov	$0, r9b
			mov	$0, r10b
			mov	$0, r11b
			mov	$0, r12b
			mov	$0, r13b
			mov	$0, r14b
			mov	$0, r15b
			
			mov	$0, ax
			mov $0, bx
			mov	$0, cx
			mov	$0, dx
			mov	$0, di
			mov	$0, si
			mov	$0, sp
			mov	$0, bp
			
			mov	$0, r8w
			mov	$0, r9w
			mov	$0, r10w
			mov	$0, r11w
			mov	$0, r12w
			mov	$0, r13w
			mov	$0, r14w
			mov	$0, r15w
			
			mov	$0, eax
			mov $0, ebx
			mov	$0, ecx
			mov	$0, edx
			mov	$0, edi
			mov	$0, esi
			mov	$0, esp
			mov	$0, ebp
			
			mov	$0, r8d
			mov	$0, r9d
			mov	$0, r10d
			mov	$0, r11d
			mov	$0, r12d
			mov	$0, r13d
			mov	$0, r14d
			mov	$0, r15d
			
			mov	$0, rax
			mov $0, rbx
			mov	$0, rcx
			mov	$0, rdx
			mov	$0, rdi
			mov	$0, rsi
			mov	$0, rsp
			mov	$0, rbp
			
			mov	$0, r8
			mov	$0, r9
			mov	$0, r10
			mov	$0, r11
			mov	$0, r12
			mov	$0, r13
			mov	$0, r14
			mov	$0, r15

#----------------------------------------------------
#
# Variable allocation within a section.
#
# Just like MASM, Gas will allocate variables within
# a section in the order you declare them in the
# section. If there are multiple sections with the
# same name in a source file, Gas will *probably*
# allocate the variables in the second section
# immediately after the first. However, you should
# never depend on this. If you need to ensure the
# ordering of symbols with respect to one another,
# be sure to declare them in the exact same section.
#
#----------------------------------------------------


# Gas doesn't have a .const section for holding
# constants (like MASM). However, you can create
# an equivalent section (also named "const") using
# the Gas ".section" directive.
#
# .section lets you specify a new memory section
# by name. The second argument is a string
# containing various alphabetic characters that
# specify flags (permissions) for the section.
# Typical flags would be "w" (for writeable),
# "x" (for executable) and "a" for allocatable. 
# By default, sections are always readable. 
# However, sections must be allocated in memory
# (hence the "a" flag below). A section with
# only the "a" flag is a read-only section
# in memory. 

				.section  	const, "a"
ttlStr:			.asciz		"Listing 3-0"

# At this point in the source file, you can put all your
# read-only declarations, e.g.,

byteConst:		.byte	123		#Cannot be changed

#----------------------------------------------------



# Gas doesn't have a ".data?" segment like MASM. However,
# it has an equivalent section named ".bss"

				.bss
notInitialized:	.byte	0	#Only zero values
niWord:			.word	0	# are allowed as
niDWord:		.int	0	# operands within
niQWord:		.int	0	# the .bss section.
niArray:		.fill	maxLen, 1, 0	#<-- Last field must be zero

# Note that it doesn't make any sense to put
# an .ascii or .asciz directive in the .bss
# section, as those directives must contain
# initialized data (use .fill if you want to create
# storage to hold a string of characters). 			

#----------------------------------------------------
#
# The Gas ".align" directive.
#
# The Gas ".balign" directive allows you to align
# the next address in a section on a bounary that
# is some power of two. The single ".balign" operand
# is a number that Gas uses as the alignment. It must
# be a power of two (0, 1, 2, 4, 8, ...).
#
# Examples:
#
#		.balign	0	#Disables alignment (ignored)
#		.balign	1	#Align to a byte boundary
#		.balign	2	#Align to a word boundary
#		.balign	4	#Align to a dword boundary
#		.balign	8	#Align to a qword boundary
#		.balign	16	#Align to a 16-bit boundary
#
# Coding examples

				.data
				.balign	0
byteVar:		.byte	0

				.balign	2
wordVar:		.word	0	#Sits at an even address
				.byte	0	#Force location counter odd
				
				.balign	4	#Align on 4-byte address
dwordVar:		.int	0
				.byte	0	#Mess up alignment
				
				.balign	8	#Align on 8-byte address
qwordVar:		.quad	0

# Note: the .balign allows an additional pair of
# operands that let you specify the fill value and
# a maximum number of bytes to fill. See the GNU AS
# documentation for details.
#
# There is also a .p2align directive that lets you
# specify the alignment using powers of two (e.g.,
# 0=byte, 1=word, 2=dword, etc.). See the GNU AS
# manual for more details.
				

#----------------------------------------------------
#
# Labels in a Gas program have an address associated
# with them. This address is an offset into the
# section in which they were declared (this offset is
# often known as the "location counter."
#
# Unlike MASM, there is no type (size) information
# associated with a label. As such, Gas does not
# have a "label" directive like MASM's (which is used
# to attach a type to a symbol).
#
#----------------------------------------------------


#----------------------------------------------------
#
# x86-64 memory addressing modes in Gas:
#
# Gas, for the most part, uses a radically different
# syntax for addressing memory than other x86 assemblers
# (such as MASM). Here are the MASM (Intel-syntax)
# addressing modes and their Gas equivalents.
# Note: "r64" represents any x86-64 general-purpose
# 64-bit register; i64 represents any x86-64 GPR except
# (%)RSP. "Scale" is the constant 1, 2, 4, or 8.
#
# ---Intel------		  ---Gas------				---Description---
#	Direct					Direct					Access simple variable in memory
#													(PC-relative addressing mode)
#
#							Direct(%rip)			Alternate form
#							Direct(rip)				Using equates given earlier
#
#	[r64]					(r64)					Register indirect
#	
#	[r64+const]				const(r64)				Indirect plus offset
#	
#	[r64+i64*scale+const]	const(r64, i64, scale)  Scaled-indexed addressing mode
#	[r64+i64+const]			const(r64, i64) 		Scale assumed to be 1. 
#
#	const[i64*scale]		const(,i64, scale)		Assumes "const" is an RIP-relative
#													address in memory.
#	const[i64]				const(,i64)				Scaled assumed to be 1.


				mov		bVar, al
				mov		bVar(rip), al
				
				mov		(rax), al
				mov		5(rax), al
				mov		500(rax), al
				mov		bVar(rax), al
				
				mov		(rax, rbx), al
				mov		(rax, rbx, 1), al
				
				mov		5(rax, rax), al
				mov		5(rax, rax, 1), al
				
				mov		bVar(,rax), al
				mov		bVar(,rax,1), al
				mov		wVar(,rax,2), ax
				mov		dVar(,rax,4), eax
				mov		qVar(,rax,8), rax
				
				
#--------------------------------------------------------------
#
# Pushing and popping memory locations.
#
# Just like the NOT and NEG instructions (that operate directly
# on memory operands), the PUSH and POP instructions can also
# push and pop memory variables, though the instructions are
# limited to words (16-bit) and quadwords (64-bit). Because
# the stack needs to be kept aligned on a 16-byte boundary
# for calls to C standard library functions (and other system
# calls), you rarely see assembly language programs pushing
# words; though if you really want, you could push four
# words to keep the stack aligned.
#
# Like the NOT and NEG instructions, you must attach a size
# suffix to the push/pop instructions when working with
# memory variables:

				pushw	wVar
				popw	wVar
				pushq	qVar
				popq	qVar
				
				pushfq			#Push flags onto stack; usually quadword
				popfq			#Pop flags from stack; also quadword
				
#				
#--------------------------------------------------------------


				.text



# Return program title to C++ program:

            	.global	getTitle
getTitle:
            	lea 	ttlStr, rax
            	ret



# Here is the "asmMain" function.

        
            .global	asmMain
asmMain:

# The following push instruction has been used in all the
# sample programs to date in order to force stack alignment
# to 16 bytes. Upon entry into this program, the stack is
# aligned on an eight-byte boundary that is not also a
# 16-byte boundary (just because of how the Gcc main
# function calls this assembly module). Pushing eight
# bytes on the stack (RBX=eight bytes) properly aligns
# the stack on a 16-byte boundary. The choice of register
# has been irrelevant: just adding eight bytes on the
# stack has always been the goal. Because RBX is a
# non-volatile register, pushing and poping it within
# the main program makes RBX available for use in this
# assembly code (which is why this particular push/pop
# was chosen).
#
# Note that if you really don't need to preserve RBX,
# you could also use the following instructions to
# align and clean up the stack:
# 
#
#            sub	$8, rsp
#			  .
#			  .
#			  .
#
#allDone:       
#            add	 $8, rsp
#            ret     #Returns to caller
 

            push	rbx


allDone:       
            pop		rbx
            ret     #Returns to caller

