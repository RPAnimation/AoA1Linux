# Listing 5-10
#
# Demonstrate passing parameters in registers
#
#
# To assemble this program
# ("$" represents Linux command-line prompt):
#
#   $as listing5-10.s
#
# Note that this code is not executable.


            .include    "regs.inc"      #Use Intel register names

            .data
staticVar:  .int        0

            .text
            .extern     someFunc
            
# strfill-  Overwrites the data in a string with a character.
#
#     RDI-  Pointer to zero-terminated string 
#           (e.g., a C/C++ string)
#      AL-  Character to store into the string

strfill:
            push    rdi     # Preserve RDI because it changes
            
            
# While we haven't reached the end of the string

whlNot0:    cmpb    $0, (rdi)
            je      endOfStr

# Overwrite character in string with the character
# passed to this procedure in AL

            mov     al, (rdi)

# Move on to the next character in the string and
# repeat this process:

            inc     rdi
            jmp     whlNot0  
              
endOfStr:   pop     rdi
            ret

