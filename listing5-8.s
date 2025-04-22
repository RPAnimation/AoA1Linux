# Listing 5-8
#
# Demonstrate obtaining the address
# of a static variable using "$"
# operator.


            .include    "regs.inc"
            .data
staticVar:  .int    0

            .text
            .extern someFunc
            
getAddress:

            mov     $staticVar, rdi
            call    someFunc

            ret

