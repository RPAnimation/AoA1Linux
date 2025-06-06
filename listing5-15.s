# Listing 5-15
#
# Recursive quicksort
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing5-15
#   $listing5-15
#
# or
#
#   $gcc -o listing5-15 -fno-pie -no-pie c.cpp listing5-15.s -lstdc++
#   $listing5-15


            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.


            .section    const, "a"
ttlStr:     .asciz      "Listing 5-15"
fmtStr1:    .asciz      "Data before sorting: \n"
fmtStr2:    .ascii      "%d"        #Use nl and 0 from fmtStr3
fmtStr3:    .asciz      "\n"
fmtStr4:    .asciz      "Data after sorting: \n"

        
            .data
theArray:   .int   1,10,2,9,3,8,4,7,5,6
            .equ    numElements, (. - theArray)/dword
        
            .text
            .extern printf
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



# quicksort-
#
#  Sorts an array using the quicksort algorithm.
#
# Here's the algorithm in C, so you can follow along:
#
# void quicksort(int a[], int low, int high)
# {
#     int i,j,Middle;
#     if( low < high)
#     {
#         Middle = a[(low+high)/2];
#         i = low;
#         j = high;
#         do
#         {
#             while(a[i] <= Middle) i++;
#             while(a[j] > Middle) j--;
#             if( i <= j)
#             {
#                 swap(a[i],a[j]);
#                 i++;
#                 j--;
#             }
#         } while( i <= j );
#  
#         // recursively sort the two sub arrays
#
#         if( low < j ) quicksort(a,low,j-1);
#         if( i < high) quicksort(a,j+1,high);
#     }
# }
#
# Args:
#    RCX (_a):      Pointer to array to sort
#    RDX (_lowBnd): Index to low bound of array to sort
#    R8 (_highBnd): Index to high bound of array to sort    

            .equ    _a, 16              #Ptr to array
            .equ    _lowBnd, _a+8       #Low bounds of array
            .equ    _highBnd, _lowBnd+8 #High bounds of array

# Local variables (register save area)

            .equ    saveR9, -8
            .equ    saveRDI, saveR9-8
            .equ    saveRSI, saveRDI-8
            .equ    saveRBX, saveRSI-8
            .equ    saveRAX, saveRBX-8
            .equ    lclSize, (-saveRAX)
                        

# Within the procedure body, these registers
# have the following meaning:
#
# RCX: Pointer to base address of array to sort
# EDX: Lower bound of array (32-bit index).
# r8d: Higher bound of array (32-bit index).
#
# edi: index (i) into array.
# esi: index (j) into array.
# r9d: Middle element to compare against

quicksort:
            push    rbp
            mov     rsp, rbp
            sub     $lclSize, rsp
            and     $-16, rsp               #Keep stack aligned.
                
# This code doesn't mess with RCX. No
# need to save it. When it does  mess
# with RDX and R8, it saves those registers
# at that point.

# Preserve other registers we use:

            mov     rax, saveRAX(rbp)
            mov     rbx, saveRBX(rbp)
            mov     rsi, saveRSI(rbp)
            mov     rdi, saveRDI(rbp)
            mov     r9,  saveR9(rbp)  
            
            mov     edx, edi        #i=low
            mov     r8d, esi        #j=high

# Compute a pivotal element by selecting the
# physical middle element of the array.
        
            lea     (rsi, rdi, 1), rax  #RAX=i+j
            shr     $1, rax             #(i+j)/2
            mov     (rcx, rax, 4), r9d  #Middle = ary[(i+j)/2]
                    

# Repeat until the edi and esi indexes cross one
# another (edi works from the start towards the end
# of the array, esi works from the end towards the
# start of the array).

rptUntil:
        
# Scan from the start of the array forward
# looking for the first element greater or equal
# to the middle element).
            
            dec     edi     #to counteract inc, below
while1:     inc     edi     #i = i + 1
            cmp     (rcx, rdi, 4), r9d  #While middle > ary[i]
            jg      while1

# Scan from the end of the array backwards looking
# for the first element that is less than or equal
# to the middle element.

            inc     esi     #To counteract dec, below
while2:     dec     esi     #j = j - 1
            cmp     (rcx, rsi, 4), r9d  #while Middle < ary[j]
            jl      while2            
            
            
# If we've stopped before the two pointers have
# passed over one another, then we've got two
# elements that are out of order with respect
# to the middle element, so swap these two elements.
            
            cmp     esi, edi            #If i <= j
            jnle    endif1            
           
            mov     (rcx, rdi, 4), eax  #Swap ary[i] and ary[j]
            mov     (rcx, rsi, 4), r9d
            mov     eax, (rcx, rsi, 4)
            mov     r9d, (rcx, rdi, 4)
            
            inc     edi                 #i = i + 1
            dec     esi                 #j = j - 1
                
endif1:     cmp     esi, edi            #Until i > j
            jng     rptUntil
        
# We have just placed all elements in the array in
# their correct positions with respect to the middle
# element of the array. So all elements at indexes
# greater than the middle element are also numerically
# greater than this element. Likewise, elements at
# indexes less than the middle (pivotal) element are
# now less than that element. Unfortunately, the
# two halves of the array on either side of the pivotal
# element are not yet sorted. Call quicksort recursively
# to sort these two halves if they have more than one
# element in them (if they have zero or one elements, then
# they are already sorted).
        
             cmp     esi, edx           #if lowBnd < j
             jnl     endif2
 
             # Note: a is still in RCX,
             # Low is still in RDX
             # Need to preserve R8 (High)
             # Note: quicksort doesn't require stack alignment
                 
             push    r8
             mov     esi, r8d    
             call    quicksort          #( a, Low, j )
             pop     r8
             
 endif2:     cmp     r8d, edi           #if i < High
             jnl     endif3

            # Note: a is still in RCX,
            # High is still in R8d
            # Need to preserve RDX (low)
            # Note: quicksort doesn't require stack alignment
              
            push    rdx
            mov     edi, edx  
            call    quicksort           #( a, i, High )
            pop     rdx

# Restore registers and leave:
            
endif3:
            mov     saveRAX(rbp), rax
            mov     saveRBX(rbp), rbx
            mov     saveRSI(rbp), rsi
            mov     saveRDI(rbp), rdi
            mov     saveR9(rbp),  r9  
            leave
            ret  
    


# Little utility to print the array elements:

printArray:
            push    r15
            push    rbp
            mov     rsp, rbp
            and     $-16, rsp       #Align stack
                        
            xor     r15d, r15d      #R15=0 (zero extends!)
whileLT10:  cmp     $numElements, r15d 
            jge     endwhile1
            
            lea     theArray, r9
            lea     fmtStr2, rdi
            mov     (r9, r15, 4), esi
            mov     $0, al
            call    printf
            
            inc     r15d
            jmp     whileLT10

endwhile1:  lea     fmtStr3, rdi
            mov     $0, al
            call    printf
            
            leave
            pop     r15
            ret


# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbp
            mov     rsp, rbp
        
# Display unsorted array:

            lea     fmtStr1, rdi
            mov     $0, al
            call    printf
            call    printArray
            

# Sort the array

            lea     theArray, rcx
            xor     rdx, rdx                #low = 0
            mov     $numElements-1, r8d     #high= 9
            call    quicksort               #(theArray, 0, 9)
            
# Display sorted results:

            lea     fmtStr4, rdi
            mov     $0, al
            call    printf
            call    printArray   
            
            leave
            ret     #Returns to caller
        

