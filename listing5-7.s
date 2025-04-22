# Listing 5-7
#
# Accessing local variables #2
#
#
# To assemble this program
# ("$" represents Linux command-line prompt):
#
#   $as listing5-7.s
#
# Note that this code is not executable.


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .text

# localVars - Demonstrates local variable access
#
# sdword a is at offset -4 from RBP
# sdword b is at offset -8 from RBP
#
# On entry, ECX and EDX contain values to store
# into the local variables a & b (respectively)

            .equ    a_localVars, -dword
            .equ    b_localVars, a_localVars-dword
            
        #Calculate storage used by the above and round it
        # up to the next multiple of 16:
        
            .equ    extra,(b_localVars % 16)    # Extra bytes beyond 16-byte alignment
            .equ    notZero, (extra != 0) & 1   # '1' if result is non-zero, 0 otherwise
            .equ    added, (16-extra)*notZero   # Add extra bytes if not a multiple of 16
            .equ    localsSize, b_localVars + added 
            

localVars:
            push    rbp
            mov     rsp, rbp
            sub     $localsSize, rsp  #Make room for a & b
              
            mov     edi, a_localVars(rbp)
            mov     esi, b_localVars(rbp)
              
    # Additional code here that uses a & b
              
            leave
            ret


# Comment:
#
# Why do all the extra work to calculate a value that is a multiple of 16
# for the size of the activation record? Why not just calculate this number
# manually (which isn't that hard) and save all the extra coding?
#
# This answer is simple: maintainability. You're likely to add additional
# local variables in the future (or remove some). By putting these
# calculations in the code, you don't have to recompute them every time
# you change the size of the activation record.
#
# This might seem like a lot of typing. Don't worry, when you learn about
# macros you'll see how to reduce this sequence to a single statement.
 