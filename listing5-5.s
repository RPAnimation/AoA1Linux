# Listing 5-5
#
# Popping a return address by mistake
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing5-5
#   $listing5-5
#
# or
#
#   $gcc -o listing5-5 -fno-pie -no-pie c.cpp listing5-5.s -lstdc++
#   $listing5-5


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 5-5"
calling:    .asciz      "Calling proc2\n"
call1:      .asciz      "Called proc1\n"
rtn1:       .asciz      "Returned from proc 1\n"
rtn2:       .asciz      "Returned from proc 2\n"
        
            .text
            .extern     printf

# Return program title to C++ program:

             .global    getTitle
getTitle:
             lea        ttlStr, rax
             ret



# proc1 - Gets called by proc2, but returns
#         back to the main program.

proc1:
              pop   rcx     #Pops return address off stack
              ret


# Normally, we would want to align the stack to
# 16 bytes before attempting a call to printf
# in the following procedure. However, that would
# mess up proc1 (and printf won't be called anyway),
# so no push instruction appears here.

proc2:
              call  proc1   #Will never return

# This code never executes because the call to proc1
# pops the return address off the stack and returns
# directly to asmMain.
            
              lea   rtn1, rdi
              mov   $0, al
              call  printf
              ret



# Here is the "asmMain" function.

              .global   asmMain
asmMain:
              push  rbp
              mov   rsp, rbp
              
              lea   calling, rdi
              mov   $0, al
              call  printf
              
              call  proc2
              lea   rtn2, rdi
              mov   $0, al
              call  printf 
              
              leave
              ret           #Returns to caller

