# Listing 5-6
#
# Accessing local variables
#
#
# To assemble this program
# ("$" represents Linux command-line prompt):
#
#   $as listing5-6.s
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
# On entry, EDI and ESI contain values to store
# into the local variables a & b (respectively)

localVars:
              push rbp
              mov  rsp, rbp
              sub  $16, rsp         #Make room for a & b
              
              mov  edi, -4(rbp)     #a = edi
              mov  esi, -8(rbp)     #b = esi
              
    # Additional code here that uses a & b
              
              leave
              ret

