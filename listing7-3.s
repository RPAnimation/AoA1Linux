# Listing 7-3
#
# Initializing qword values with the
# addresses of statement labels.
#
# Note that Gas doesn't support locally-scoped
# symbols (as does MASM). So all this sample
# procedure really demonstrates is taking the
# address of symbols in the program and
# putting those addresses in .quad statements.
#
# You can assemble this with
#
# $as -a=listing7-3.lst listing7-3.s


            .data
lblsInProc: .quad   globalLbl1, globalLbl2  #From procWLabels
        
            .text


#procWLabels-
# Just a procedure containing symbols. 
# This really isn't an executable procedure.
 
procWLabels:
privateLbl:			#Not really private in Gas.
            nop     #"No operation" just to consume space

globalLbl1: jmp     globalLbl2
globalLbl2: nop


privateLbl2:
            ret
dataInCode: .quad   privateLbl, globalLbl1
            .quad   globalLbl2, privateLbl2

