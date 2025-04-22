# Listing1-1.s
#
#	"Shell" assembly language program for Linux
#
#
# Comments consist of all text from a "#" character or "//" sequence 
# to the end of the line.
#
#
#
# The ".global _start" statement tells Linux the name of the
# main program in this source file:

        .global _start

// The ".text" directive tells MASM that the statements following 
// this directive go in the section of memory reserved for machine
// instructions (code).

        .text

// Here is the "main" function. (This example assumes that the
// assembly language program is a stand-alone program with its 
// own main function.)

_start:

// << Machine Instructions go here >>
        
		
// This is the magic sequence of instructions that return
// control to the Linux operating system.

        # exit(0)
		
        mov     $60, %rax               # system call 60 is exit
        xor     %rdi, %rdi              # we want return code 0
        syscall                         # invoke operating system to exit
        

