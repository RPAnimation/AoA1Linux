# Listing 1-4
# A simple demonstration of a user-defined procedure.

        .global _start
        .text

# A sample user-defined procedure that this program can call.

myProc:
        ret    # Immediately return to the caller


# Here is the "main" procedure.

_start:

# Call the user-define procedure

        call   myProc

        # exit(0)
        
        mov     $60, %rax               # system call 60 is exit
        xor     %rdi, %rdi              # we want return code 0
        syscall                         # invoke operating system to exit

