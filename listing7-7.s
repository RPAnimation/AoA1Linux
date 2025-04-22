# Listing 7-7
#
# An indirect jump state machine example
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing7-7
#   $listing7-7
#
# or
#
#   $gcc -o listing7-7 -fno-pie -no-pie c.cpp listing7-7.s -lstdc++
#   $listing7-7



            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz     "Listing 7-7"
fmtStr0:    .ascii      "Calling StateMachine, "
            .asciz      "state=0, EAX=5, ECX=6\n"
            
fmtStr0b:   .ascii      "Calling StateMachine, "
            .asciz      "state=0, EAX=1, ECX=2\n"
            
fmtStrx:    .ascii      "Back from StateMachine, "
            .asciz      "EAX=%d\n"
            
fmtStr1:    .ascii      "Calling StateMachine, "
            .asciz      "state=1, EAX=50, ECX=60\n"
            
fmtStr2:    .ascii      "Calling StateMachine, "
            .asciz      "state=2, EAX=10, ECX=20\n"
            
fmtStr3:    .ascii      "Calling StateMachine, "
            .asciz      "state=3, EAX=50, ECX=5\n"
            
            
             .data
state:       .quad      state0
           

            .text
            .extern     printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



# StateMachine version 2.0- using an indirect jump.

StateMachine:
             
             jmp    *state
             
             
# State 0: Add ecx to eax and switch to State 1:

state0:      add    ecx, eax
             lea    state1, rcx
             mov    rcx, state
             ret

# State 1: Subtract ecx from eax and switch to state 2:

state1:      sub    ecx, eax
             lea    state2, rcx
             mov    rcx, state
             ret


# If this is State 2, multiply ecx by eax and switch to state 3:

state2:      imul   ecx, eax
             lea    state3, rcx
             mov    rcx, state
             ret

state3:      push   rdx          # Preserve this 'cause it gets whacked by div.
             xor    edx, edx     # Zero extend eax into edx.
             div    ecx
             pop    rdx          # Restore edx's value preserved above.
             lea    state0, rcx
             mov    rcx, state
             ret
            
            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp
            
            lea     state0, rcx
            mov     rcx, state        #Just to be safe
            
# Demonstrate state 0:

            lea     fmtStr0, rdi
            mov     $0, al
            call    printf
            
            mov     $5, eax
            mov     $6, ecx
            call    StateMachine
            
            lea     fmtStrx, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf
            
# Demonstrate state 1:

            lea     fmtStr1, rdi
            mov     $0, al
            call    printf
            
            mov     $50, eax
            mov     $60, ecx
            call    StateMachine
            
            lea     fmtStrx, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf
            
# Demonstrate state 2:

            lea     fmtStr2, rdi
            mov     $0, al
            call    printf
            
            mov     $10, eax 
            mov     $20, ecx 
            call    StateMachine
            
            lea     fmtStrx, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf
            
# Demonstrate state 3:

            lea     fmtStr3, rdi
            mov     $0, al
            call    printf
            
            mov     $50, eax 
            mov     $5, ecx 
            call    StateMachine
            
            lea     fmtStrx, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf
            
# Demonstrate back in state 0:

            lea     fmtStr0b, rdi
            mov     $0, al
            call    printf
            
            mov     $1, eax
            mov     $2, ecx
            call    StateMachine
            
            lea     fmtStrx, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf
            
            leave
            ret     #Returns to caller

