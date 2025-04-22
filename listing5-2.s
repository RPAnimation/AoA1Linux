# Listing 5-2
#
# A procedure without a RET instruction
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing5-2
#   $listing5-2
#
# or
#
#   $gcc -o listing5-2 -fno-pie -no-pie c.cpp listing5-2.s -lstdc++
#   $listing5-2


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 5-2"
fpMsg:      .asciz      "followingProc was called\n"
        
            .text
            .extern     printf

# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret




# noRet-
# 
#  Demonstrates what happens when a procedure
# does not have a return instruction.

noRet:

followingProc:
              push  rbp         #Standard entry sequence
              mov   rsp, rbp
              
              lea   fpMsg, rdi
              call  printf
              
              leave             #Standard exit sequence
              ret



# Here is the "asmMain" function.

              .global   asmMain
asmMain:
              push      rbp
              mov       rsp, rbp
                
              call      noRet
              
              leave
              ret     #Returns to caller

