# Listing 4-6
#
# Calling C Standard Libary string functions
#
# To compile/assemble this program and run it
# ("$" represents Linux command-line prompt):
#
#	$build listing4-6
#	$listing4-6
#
# or
#
#	$gcc -o listing4-6 -fno-pie -no-pie c.cpp listing4-6.s -lstdc++
#	$listing4-6


            .include    "regs.inc"      #Use Intel register names

            .equ    maxLen, 256

            .section    const, "a"
ttlStr:     .asciz      "Listing 4-6"
prompt:     .asciz      "Input a string: "
fmtStr1:    .asciz      "After strncpy, resultStr='%s'\n"
fmtStr2:    .asciz      "After strncat, resultStr='%s'\n"
fmtStr3:    .asciz      "After strcmp (3), eax=%d\n"
fmtStr4:    .asciz      "After strcmp (4), eax=%d\n"
fmtStr5:    .asciz      "After strcmp (5), eax=%d\n"
fmtStr6:    .asciz      "After strchr, rax='%s'\n"
fmtStr7:    .asciz      "After strstr, rax='%s'\n"
fmtStr8:    .asciz      "resultStr length is %d\n"

str1:       .asciz      "Hello, "
str2:       .asciz      "World!"
str3:       .asciz      "Hello, World!"
str4:       .asciz      "hello, world!"      
str5:       .asciz      "HELLO, WORLD!"      
        
            .data
strLength:  .int        0
resultStr:  .fill       maxLen

        
            .text
            .extern     readLine
            .extern     printf
            .extern     malloc
            .extern     free
        
# Some C standard library string functions:
#
# size_t strlen(char *str)
 
            .extern     strlen

# char *strncat(char *dest, const char *src, size_t n)
 
            .extern     strncat
        
# char *strchr(const char *str, int c)

            .extern     strchr
        
# int strcmp(const char *str1, const char *str2)

            .extern     strcmp

# char *strncpy(char *dest, const char *src, size_t n)

            .extern     strncpy
        
# char *strstr(const char *inStr, const char *search4)

            .extern     strstr
         
        

# Return program title to C++ program:

            .global getTitle
getTitle:
            lea ttlStr, rax
            ret


# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbx

# Demonstrate the strncpy function to copy a
# string from one location to another:

            lea     resultStr, rdi  # Destination string
            lea     str1, rsi       # Source string
            mov     $maxLen, rdx    # Max number of chars to copy
            call    strncpy
            
            lea     fmtStr1, rdi
            lea     resultStr, rsi
            mov     $0, al
            call    printf
        
# Demonstrate the strncat function to concatenate str2 to
# the end of resultStr:

            lea     resultStr, rdi
            lea     str2, rsi
            mov     $maxLen, rdx
            call    strncat
            
            lea     fmtStr2, rdi
            lea     resultStr, rsi
            mov     $0, al
            call    printf
        
# Demonstrate the strcmp function to compare resultStr
# with str3, str4, and str5:

            lea     resultStr, rdi
            lea     str3, rsi
            call    strcmp
            
            lea     fmtStr3, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf

            lea     resultStr, rdi
            lea     str4, rsi
            call    strcmp
            
            lea     fmtStr4, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf

            lea     resultStr, rdi
            lea     str5, rsi
            call    strcmp
            
            lea     fmtStr5, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf
        
# Demonstrate the strchr function to search for
# ',' in resultStr

            lea     resultStr, rdi
            mov     $',', rsi
            call    strchr
            
            lea     fmtStr6, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf
        
# Demonstrate the strstr function to search for
# str2 in resultStr

            lea     resultStr, rdi
            lea     str2, rsi
            call    strstr
            
            lea     fmtStr7, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf

# Demonstrate a call to the strlen function

            lea     resultStr, rdi
            call    strlen
            
            lea     fmtStr8, rdi
            mov     rax, rsi
            mov     $0, al
            call    printf
                     

            pop     rbx
            ret     #Returns to caller

