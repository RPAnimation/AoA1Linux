# Listing 2-4
#
# Demonstrate packed data types
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing2-4
#   $listing2-4
#
# or
#
#   $gcc -o listing2-4 -fno-pie -no-pie c.cpp listing2-4.s -lstdc++
#   $listing2-4
#
#


			.equ	NULL, 0
			.equ	maxLen, 256


# New data declaration section.
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

				.section  const, "a"
ttlStr:			.asciz	  "Listing 2-4"
moPrompt:   	.asciz    "Enter current month: "
dayPrompt:  	.asciz    "Enter current day: "
yearPrompt: 	.ascii    "Enter current year "
            	.asciz    "(last 2 digits only): "

unpacked:		.asciz	  "Unpacked date is %02d/%02d/%02d\n"           
packed:     	.asciz    "Packed date is %04x\n"
theDate:    	.asciz    "The date is %02d/%02d/%02d\n"
 
# Note the use of ".ascii" and "asciz" together to
# allow a single string to be split across two lines
# in the source file.
          
badDayStr:  	.ascii    "Bad day value was entered "
            	.asciz    "(expected 1-31)\n"
           
badMonthStr:	.ascii    "Bad month value was entered "
            	.asciz    "(expected 1-12)\n"
				
badYearStr:  	.ascii    "Bad year value was entered "
            	.asciz    "(expected 00-99)\n"


# Read/write data area in memory:

            	.data
month:       	.byte    	0
day:         	.byte    	0
year:        	.byte    	0
date:        	.word    	0

input:       	.fill    	maxLen, 1, 0

            	.text
            	.extern 	printf
            	.extern 	readLine
            	.extern 	atoi

# Return program title to C++ program:

            	.global	getTitle
getTitle:
            	lea 	ttlStr(%rip), %rax
            	ret



# Here's a user-written function that reads a numeric value from the
# user
# 
# int readNum( char *prompt )#
# 
# A pointer to a string containing a prompt message is passed in the
# RDI register.
# 
# This procedure prints the prompt, reads an input string from the
# user, then converts the input string to an integer and returns the
# integer value in RAX.

readNum:

# Must set up stack properly (using this "magic" instruction) before
# we can call any C/C++ functions:

            push	%rbx
        
# Print the prompt message. Note that the prompt message was passed to
# this procedure in RDI, we're just passing it on to printf.
#
# Remember: printf parameters are:
#
#	al: must be zero.
#  rdi: format string
#  rsi: 1st argument (for format string)
#  rdx: 2nd argument
#  rcx: 3rd argument
#  r8:	4th argument
#  r9:	5th argument
#
# Don't forget: "$" precedes constant (immediate) operands.  

			mov		$0, %al
            call    printf

# Set up arguments for readLine and read a line of text from the user.
# Note that readLine returns NULL (0) in RAX if there was an error.

            lea     input(%rip), %rdi
            mov     $maxLen, %rsi
            call    readLine
        
# Test for a bad input string:

            cmp     $NULL, %rax
            je      badInput
        
# Okay, good input at this point, try converting the string to an
# integer by calling atoi. The atoi function returns zero if there was
# an error, but zero is a perfectly fine return result, so we ignore
# errors.

            lea     input(%rip), %rdi     #Ptr to string
            call    atoi            #Convert to integer
        
badInput:
            pop		%rbx	        #Undo stack setup
            ret

        
# Here is the "asmMain" function.

        
            .global	asmMain
asmMain:
            push	%rbx

# Read the date from the user. Begin by reading the month:

            lea     moPrompt(%rip), %rdi
            call    readNum
        
# Verify the month is in the range 1..12:
#
# Gas note: because Gas reverses the operands, the
# CMP instruction must be read as "compare second
# operand to first operand."
        
            cmp     $1, %rax
            jl      badMonth
            cmp     $12, %rax
            jg      badMonth
        
#Good month, save it for now
        
            mov     %al, month(%rip)		#1..12 fits in a byte
        
# Read the day:

            lea     dayPrompt(%rip), %rdi
            call    readNum
        
# We'll be lazy here and only verify that the day is in the range
# 1..31.
        
            cmp     $1, %rax
            jl      badDay
            cmp     $31, %rax
            jg      badDay
        
#Good day, save it for now
        
            mov     %al, day(%rip)		#1..31 fits in a byte
        
# Read the year

            lea     yearPrompt(%rip), %rdi
            call    readNum
        
# Verify that the year is in the range 0..99.
        
            cmp     $0, %rax
            jl      badYear
            cmp     $99, %rax
            jg      badYear
        
#Good day, save it for now
        
            mov     %al, year(%rip)		#0..99 fits in a byte

# Print the unpacked data (in decimal):			
			
			mov		$0, %al
			lea		unpacked(%rip), %rdi
			movzbq	month(%rip), %rsi
			movzbq	day(%rip), %rdx
			movzbq	year(%rip), %rcx
			call	printf
        
# Pack the data into the following bits:
#
#  15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
#   m  m  m  m  d  d  d  d  d  y  y  y  y  y  y  y
#
#
# In Gas, the movzx instruction is written as movz{ss}{ds}
# where {ss} is the source size (b/w/l) and {ds} is the
# destination size (w/l/q). Two rules, though: the source
# size must be less than the destination size, and there
# is no "movzdq" instruction ("mov s32, %e32" automatically
# zero-extends s32 into the HO 32 bits of %e32 register). 

            movzbw  month(%rip), %ax
            shl     $5, %ax
            or      day(%rip), %al
            shl     $7, %ax
            or      year(%rip), %al
            mov     %ax, date(%rip)
        
# Print the packed date:

			mov		$0, %al
            lea     packed(%rip), %rdi
            movzwq  date(%rip), %rsi
            call    printf
        
# Unpack the date and print it:

			mov		$0, %al
            movzwq  date(%rip), %rsi
            mov     %rsi, %rcx
            and     $0x7f, %rcx     #Keep LO 7 bits (year)
            shr     $7, %rsi        #Get day in position
            mov     %rsi, %rdx
            and     $0x1f, %rdx     #Keep LO 5 bits
            shr     $5, %rsi        #Get month in position
            lea     theDate(%rip), %rdi
			call    printf 
        
            jmp     allDone
                
# Come down here if a bad day was entered:

badDay:
			mov		$0, %al
            lea     badDayStr(%rip),  %rdi
            call    printf
            jmp     allDone
        

# Come down here if a bad month was entered:

badMonth:
			mov		$0, %al
            lea     badMonthStr(%rip), %rdi
            call    printf
            jmp     allDone

# Come here if a bad year was entered:

badYear:
			mov		$0, %al
            lea     badYearStr(%rip), %rdi
            call    printf  

allDone:       
            pop		%rbx
            ret     #Returns to caller

