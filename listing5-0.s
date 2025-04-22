# Listing 5-0
#
# Preliminary information concerning Ao64A-Chapter 5

                .include    "regs.inc"      #Use Intel register names
                

                .section    const, "a"
ttlStr:         .asciz      "Listing 5-0"


                .data
bVar:           .byte       0
wVar:           .word       0
dVar:           .int        0
qVar:           .quad       0


                
#---------------------------------------------------------
#
# Procedures in Gas don't have any special syntax. They
# simply consist of a label (the procedure name) followed
# by a sequence of statements that (ultimately) execute
# a RET instruction to return to the caller:

                .text
procName:
            # Procedure body
            
            ret
            
#end procName
            
# Note that no special Gas statement ends a procedure's 
# body. It might not be a bad idea to include a comment
# marking the end of the procedure body, as done above.
#
#
#   To call a procedure, use the CALL instruction:

anotherProc:
                call    procName
                ret

#end anotherProc
#
#
#---------------------------------------------------------
#
#
# Passing parameters:
#
# In the System V ABI (used by Linux), the first six
# parameters get passed in the following registers (GPRs):
#
#   RDI, RSI, RDX, RCX, R8, R9
#
# assuming the parameters are not floating-point values.
# Floating-point valids get passed in the XMM registers:
#
# XMM0, XMM1, ..., XMM7.
#
# Integer/non-real parameters fill up the GPRs in the
# reverse order they appear in the parameter list,
# reals (single and double) fill up the XMM registers
# in the order they appear. Consider the following
# C code and the (unoptimized) assembly language
# GCC produces:
#
#
#  #include <stdlib.h>
#  #include <stdio.h>
#  
#  double rFunc( int i, float f, int j, double d, int k, double e, int l, double g, int m, double h)
#  {
#   return i+f+j+d+k+e+l+g+m+h;
#  }
#  
#  int main( void )
#  {                //From RBP:
#   int i=1;        //-56
#   float f=1.0;    //-52
#   int j= 2;       //-48
#   double d = 2.0; //-32
#   int k=3;        //-44
#   double e=3.0;   //-24
#   int l=4;        //-40
#   double g=4.0;   //-16
#   int m=5;        //-36
#   double h=5.0;   //-8
#   
#   printf
#   ( 
#       "Result=%7e\n",
#       rFunc
#       ( 
#           i,  // movl -56(%rbp), %edi
#           f,  // movss -52(%rbp), %xmm0   ;Actually, a long sequence, but... 
#           j,  // movl -48(%rbp), %esi 
#           d,  // movsd -32(%rbp), %xmm1 
#           k,  // movl -44(%rbp), %edx 
#           e,  // movsd -24(%rbp), %xmm2 
#           l,  // movl -40(%rbp), %ecx 
#           g,  // movsd -16(%rbp), %xmm3 
#           m,  // movl -36(%rbp), %r8d 
#           h   // movsd -8(%rbp), %xmm4 
#       )
#   );
#  }
#
# Note that the code to load f into %xmm0 is actually not this straight-forward
# because f is not aligned on a 16-bit boundary; but ignoring that the effect
# is the same as the code above.
#
# As you can see from the GCC code generation, the compiler filled up the GPRs
# with the integer arguments in the order:
#
# i->EDI
# j->ESI
# k->EDX
# l->ECX
# m->R8
#
# from the System V parameter sequence: RDI, RSI, RDX, RCX, R8, R9
#
# The real arguments filled up XMM0..XMM4 as follows:
#
# f->XMM0
# d->XMM1
# e->XMM2
# g->XMM3
# h->XMM4
#
# All parameters were assigned in the order of their appearance in the
# parameter list.
#
# When passing floating-point parameters to a variadic
# function (a function with a variable number of
# parameters), the function must pass the number of
# parameters to the function (even if 0) in the AL
# register.
#
#---------------------------------------------------------
#
# Preserving registers across procedure calls.
#
# In the System V ABI, the following registers are
# non-volatile and must be preserved within a procedure:
#
#   RBX, RSP, RBP, and R12 through R15
#
# All other general=purpose registers and all XMM/YMM
# registers are volatile. They may be freely used within
# a procedure without preserving their values.
#
# On the other hand, if a procedure calls some other
# procedures, it cannot expect the volatile registers
# to be preserved across a call. It must explicitly save
# those (volatile) registers if it still requires their
# original values across some procedure call.
#
#
#---------------------------------------------------------
#
# Local (automatic) variables with Gas
#
# Gas does not provide any facilities for declaring and
# using local (automatic allocation) variables. You will
# have to use equates to declare the offsets into the
# activation record and then use those equates with the
# (RBP) addressing mode to reference the locals. You will
# also have to manually build the activation record upon
# entry into the procedure.
#
#
# Example:
#
#   Define local variable offsets:
#
#   int i;      // Assume ints are 32 bits  
#   int j;
#   char c;
#   double d;
#   short s;

            .equ    byte, 1     # define some sizes for various types
            .equ    word, 2
            .equ    dword, 4
            .equ    qword, 8
            .equ    single, 4
            .equ    double, 8

# Note: convention is use use local variable name with an underscore
# followed by the procedure name (because symbols are not local in
# scope to a procedure).
#
# To "declare" a local, subtract the size of an object from the
# offset of the previous declared local (the offset of the first
# local variable is just the negation of its size).

            .equ    i_proc, -dword          #Base is 0, subtract size           
            .equ    j_proc, i_proc-dword    #Subtract size from offset
            .equ    c_proc, j_proc-byte     # of previous local variable            
            .equ    d_proc, c_proc-double
            .equ    s_proc, d_proc-word
            .equ    locals_proc, -s_proc    #Size of locals in procedure

            # Sneakly calculations that will bump the allocation
            # size so that it is a multiple of 16 bytes (to
            # maintain 16-byte alignment on the stack):
            
            .equ    extra,(locals_proc % 16)    # Extra bytes beyond 16-byte alignment
            .equ    notZero, (extra != 0) & 1   # '1' if result is non-zero, 0 otherwise
            .equ    added, (16-extra)*notZero   # Add extra bytes if not a multiple of 16
            .equ    allocSize_proc, locals_proc + added 
            
# Although the above set of equates might seem messy, they allow you to
# automatically allocate a sufficient amount of storage on the stack
# to keep it 16-byte aligned without any extra instructions (they do
# assume that the stack was 16-byte-aligned PLUS EIGHT BYTES) upon
# entry into the procedure; the "push rbp" instruction int the standard
# entry sequence will align it on a 16-byte boundary. Then subtracting
# "allocSize_proc" from RSP will keep it aligned on a 16-byte boundary.
            
            
# procedure proc

proc:
            push    rbp                             #Standard entry sequence
            mov     rsp, rbp
            sub     $allocSize_proc, rbp            #Make room for locals
                                                    # and keep aligned on
                                                    # 16-byte boundary.
                                                        
# To access local variables, just use its offset along with the
# indirect-RBP addressing mode:
        
            movl    $0, i_proc(rbp)         #i = 0
            movl    $5, j_proc(rbp)         #j = 5
            movb    $'a', c_proc(rbp)       #c = 'a'
            movw    $6, s_proc(rbp)
            
            leave                           #Standard exit sequence
            ret 
            
#
#---------------------------------------------------------
#
# Function results:
#
# System V ABI states that function results (up to 64 bits)
# come back in RAX. If 128 bits are needed, use RDX:RAX
# (with RDX containing the HO 64 bits).
#
# The getTitle function is a good example that returns
# 64 bits in RAX:


# Return program title to C++ program:

                .text
                .global getTitle
getTitle:
                lea     ttlStr, rax
                ret
#end getTitle

#
# Note that for *very* large objects (greater than 128 bits)
# the System V ABI states that the caller should pass a
# pointer to the space to hold the result as the first
# argument (RDI) and the function should store the return
# data in that allocated space. On return, the function
# should return a pointer to this same space in RAX.
# 
#---------------------------------------------------------
#
# To take the address of a static (.data) variable,
# just specify the variable's name after a "$" using
# the immediate (constant) addressing mode:

				mov	$ttlStr, rax	#Like LEA, but larger...

# Note that the LEA instruction typically uses less memory
# because the immediate operand encodes the full eight bytes
# of the address (whereas LEA only encodes a 4-byte PC-relative
# offset to the variable).
# 
#---------------------------------------------------------
#


# Here is the "asmMain" function.

        
            .global asmMain
asmMain:
            push    rbx


allDone:       
            pop     rbx
            ret     #Returns to caller

#end asmMain

