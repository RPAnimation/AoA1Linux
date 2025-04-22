# Listing 5-14
#
# Passing a large object by reference
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing5-14
#   $listing5-14
#
# or
#
#   $gcc -o listing5-14 -fno-pie -no-pie c.cpp listing5-14.s -lstdc++
#   $listing5-14


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

# Define an array of structures:

            .equ        NumElements, 24

#  Pt          struct
#  x           byte    ?
#  y           byte    ?
#  Pt          ends

            .equ    .x, 0               #x is at offset 0 in struct
            .equ    .y, .x+byte         #y is one byte beyond x.
            .equ    PtSize, .y+byte     #size of structure.



            .section    const, "a"

ttlStr:     .asciz      "Listing 5-14"
fmtStr1:    .asciz      "RefArrayParm[%d].x=%d "
fmtStr2:    .asciz      "RefArrayParm[%d].y=%d\n"
        
            .data
index:      .int        0
Pts:        .fill       NumElements, PtSize #Array of Pt structs
        
            .text
            .extern printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret


# Stack on entry
#
# RBP
# +16:  ptArray (pointer)
# +8:   return address
# +0:   saved RBP

            .equ    ptArray, 16             #Array pointer at 16(RBP)
             
RefAryParm:
            push    rbp
            mov     rsp, rbp
            
            mov     ptArray(rbp), rdi
            xor     rsi, rsi                #RSI = 0
            
# while esi < NumElements, initialize each
# array element. x = esi/8, y=esi % 8

ForEachEl:  cmp     $NumElements, esi
            jnl     LoopDone
            
            mov     sil, al
            shr     $3, al                  #AL = esi / 8
            mov     al, .x(rdi, rsi, 2)     #Pt.x = al
            
            mov     sil, al
            and     $0b111, al              #AL = esi % 8
            mov     al, .y(rdi, rsi, 2)     #Pt.y = al
            inc     esi
            jmp     ForEachEl
                        
LoopDone:   leave
            ret


# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp
            sub     $16, rsp                #Make room for parameter
                                            # but keep stk 16-byte aligned
        
# Initialize the array of points:

            lea     Pts, rax
            mov     rax, (rsp)              #Store address on stack
            call    RefAryParm

# Display the array:
            
            movl    $0, index
dispLp:     cmp     $NumElements, index
            jnl     dispDone
            
            lea     fmtStr1, rdi
            mov     index, esi              #zero extends!
            lea     Pts, rdx                #Get array base
            movzx   .x(rdx, rsi, 2), rdx    #Get x field
            mov     $0, al
            call    printf
            
            lea     fmtStr2, rdi
            mov     index, esi              #zero extends!
            lea     Pts, rdx                #Get array base
            movzx   .y(rdx, rsi, 2), rdx    #Get x field
            mov     $0, al
            call    printf
            
            incl    index
            jmp     dispLp
            
            
# Clean up stack:

dispDone:
            leave
            ret     #Returns to caller
        
