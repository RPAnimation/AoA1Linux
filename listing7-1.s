# Listing 7-1
#
# Demonstration of local symbols.
# Note that this program will not
# execute properly.
#
# You can assemble this file with the command:
#
#   as -a=listing7-1.lst listing7-1.s
#
#
#
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

        
            .text

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



# Here is the "asmMain" function.

            .global asmMain       
asmMain:
1:
            jmp 1b          #Infinite loop! Don't execute.

