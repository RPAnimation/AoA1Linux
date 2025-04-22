# Listing 7-4
#
# Demonstration of register indirect jumps
#
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#   $build listing7-4
#   $listing7-4
#
# or
#
#   $gcc -o listing7-4 -fno-pie -no-pie c.cpp listing7-4.s -lstdc++
#   $listing7-4



            .equ    maxLen, 256
            .equ    EINVAL, 22          #"Magic" C stdlib constant, invalid argument
            .equ    ERANGE, 34          #Value out of range

            .include    "regs.inc"      #Use Intel register names
            .include    "types.inc"     #Sizes for bytes, words, etc.

            .section    const, "a"
ttlStr:     .asciz      "Listing 7-4"
fmtStr1:    .ascii      "Enter an integer value between "
            .asciz      "1 and 10 (0 to quit): "
            
badInpStr:  .ascii      "There was an error in readLine "
            .asciz      "(ctrl-Z pressed?)\n"
            
invalidStr: .asciz      "The input string was not a proper number\n"
            
rangeStr:   .ascii      "The input value was outside the "
            .asciz      "range 1-10\n"
            
unknownStr: .ascii      "The was a problem with strToInt "
            .asciz      "(unknown error)\n"
            
goodStr:    .asciz      "The input value was %d\n"

fmtStr:     .asciz      "result:%d, errno:%d\n"

            .data

endStr:     .quad       0
inputValue: .quad       0
errno:      .int        0
buffer:     .fill       maxLen, 1, 0

        
            .text
            .extern     readLine
            .extern     strtol
            .extern     printf
            .extern     getErrno
            
# Return program title to C++ program:

            .global getTitle
getTitle:
            lea     ttlStr, rax
            ret



# strToInt-
#
#  Converts a string to an integer, checking for errors.
#
# Argument:
#    RDI-   Pointer to string containing (only) decimal 
#           digits to convert to an integer.
#
# Returns:
#    RAX-   Integer value if conversion was successful.
#    RCX-   Conversion state. One of the following:
#           0- Conversion successful
#           1- Illegal characters at the beginning of the 
#                   string (or empty string).
#           2- Illegal characters at the end of the string
#           3- Value too large for 32-bit signed integer.

            .equ    endPtr, -8      #Save ptr to end of str.
            .equ    strToConv, -16  #Save RCX here
 
strToInt:
            push    rbp
            mov     rsp, rbp
            sub     $16, rsp        #Locals + 16-byte alignment
            
            mov     rdi, strToConv(rbp) #Save, so we can test later.
            
            #RDI already contains string parameter for strtol
            
            lea     endPtr(rbp), rsi     #Ptr to end of string goes here.
            mov     $10, rdx             #Decimal conversion
            call    strtol
            
            push    rax                  #Save result for a moment
            call    getErrno             #Get errno value from C
            mov     eax, errno           #Save in local variable
            pop     rax                  #Restore strtol return value.
            
    
            
# On return:
#
#    RAX-   Contains converted value, if successful.
#    endPtr-Pointer to 1 position beyond last char in string.
#
# If strtol returns with endPtr == strToConv, then there were no
# legal digits at the beginning of the string.

            mov     $1, ecx          #Assume bad conversion
            mov     endPtr(rbp), rdi
            cmp     strToConv(rbp), rdi
            je      returnValue
            
# If endPtr is not pointing at a zero byte, then we've got
# junk at the end of the string.

            mov     $2, ecx          #Assume junk at end
            cmpb    $0, (rdi)
            jne     returnValue
            
# If the return result is 7fff_ffffh or 8000_0000h (max long and
# min long, respectively), and the C global errno variable 
# contains ERANGE, then we've got a range error.

            mov     $0, ecx         #Assume good input
            cmpl    $ERANGE, errno
            jne     returnValue
            mov     $3, ecx         #Assume out of range
            cmp     $0x7fffFFFF, eax
            je      returnValue
            cmp     $0x80000000, eax
            je      returnValue
            
# If we get to this point, it's a good number

            mov     $0, ecx
            
returnValue:
            leave
            ret

            
            
# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbx                     #Preserve RBX
            push    rbp
            mov     rsp, rbp

            
            # Prompt the user to enter a value
            # between 1 and 10:
            
repeatPgm:  lea     fmtStr1, rdi
            mov     $0, al
            call    printf
            
            # Get user input:
            
            lea     buffer, rdi
            mov     $maxLen, esi    #Zero extends!
            call    readLine
            lea     badInput, rbx   #Initialize state machine
            test    rax, rax        #RAX is -1 on bad input
            js      hadError        #(only neg value readLine returns)
            
            #Call strtoint to convert string to an integer and
            #check for errors:
            
            lea     buffer, rdi     #Ptr to string to convert
            call    strToInt
            
            
            lea     invalid, rbx
            cmp     $1, ecx
            je      hadError
            cmp     $2, ecx
            je      hadError
            
            lea     range, rbx
            cmp     $3, ecx
            je      hadError
            
            lea     unknown, rbx
            cmp     $0, ecx
            jne     hadError
            
            
# At this point, input is valid and is sitting in EAX.
#
# First, check to see if the user entered 0 (to quit
# the program).

            test    eax, eax        #Test for zero
            je      allDone
            
# However, we need to verify that the number is in the
# range 1-10. 

            lea     range, rbx
            cmp     $1, eax
            jl      hadError
            cmp     $10, eax
            jg      hadError
            
# Pretend a bunch of work happens here dealing with the
# input number.

            lea     goodInput, rbx
            mov     eax, inputValue

# The different code streams all merge together here to
# execute some common code (we'll pretend that happens,
# for brevity, no such code exists here).

hadError:

# At the end of the common code (which doesn't mess with
# RBX), separate into five different code streams based
# on the pointer value in RBX:

            jmp     *rbx
            
# Transfer here if readLine returned an error:

badInput:   lea     badInpStr, rdi
            mov     $0, al
            call    printf
            jmp     repeatPgm
            
# Transfer here if there was a non-digit character:
# in the string:
 
invalid:    lea     invalidStr, rdi
            mov     $0, al
            call    printf
            jmp     repeatPgm

# Transfer here if the input value was out of range:
                    
range:      lea     rangeStr, rdi
            mov     $0, al
            call    printf
            jmp     repeatPgm

# Shouldn't ever get here. Happens if strToInt returns
# a value outside the range 0-3.
            
unknown:    lea     unknownStr, rdi
            mov     $0, al
            call    printf
            jmp     repeatPgm

# Transfer down here on a good user input.
            
goodInput:  lea     goodStr, rdi
            mov     inputValue, esi #Zero extends!
            mov     $0, al
            call    printf
            jmp     repeatPgm

# Branch here when the user selects "quit program" by
# entering the value zero:

allDone:    leave
            pop     rbx     #Restore RBX
            ret             #Returns to caller
        
