#----------------------------------------------------
#
# Magic use of the ".equ" directive: renaming registers
#
# The Gas syntax for registers on the x86-64 is painful.
# Having to type "%" in front of all the register names
# *does* allow you to use names like RAX and AX as
# variable names. However, doing that would be incredibly
# bad programming style because it would confuse anyone
# reading your code. 
#
# If you accidentally leave a "%" off a register name,
# Gas thinks it's a variable name and you'll have to
# fix this issue. Wouldn't it be convenient if you could
# just use real Intel register names just like every
# other x86-64 assembler on the planet? Guess what, you
# can. You can use the ".equ" directive to rename the
# register as follows:

            .equ    al, %al
            .equ    ah, %ah
            .equ    bl, %bl
            .equ    bh, %bh
            .equ    cl, %cl
            .equ    ch, %ch
            .equ    dl, %dl
            .equ    dh, %dh
            
            .equ    sil, %sil
            .equ    dil, %dil
            .equ    spl, %spl
            .equ    bpl, %bpl
            
            .equ    r8b,  %r8b
            .equ    r9b,  %r9b
            .equ    r10b, %r10b
            .equ    r11b, %r11b
            .equ    r12b, %r12b
            .equ    r13b, %r13b
            .equ    r14b, %r14b
            .equ    r15b, %r15b
            
            .equ    ax, %ax
            .equ    bx, %bx
            .equ    cx, %cx
            .equ    dx, %dx
            .equ    si, %si
            .equ    di, %di
            .equ    sp, %sp
            .equ    bp, %bp
            
            .equ    r8w,  %r8w
            .equ    r9w,  %r9w
            .equ    r10w, %r10w
            .equ    r11w, %r11w
            .equ    r12w, %r12w
            .equ    r13w, %r13w
            .equ    r14w, %r14w
            .equ    r15w, %r15w
            
            .equ    eax, %eax
            .equ    ebx, %ebx
            .equ    ecx, %ecx
            .equ    edx, %edx
            .equ    esi, %esi
            .equ    edi, %edi
            .equ    esp, %esp
            .equ    ebp, %ebp
            
            .equ    r8d,  %r8d
            .equ    r9d,  %r9d
            .equ    r10d, %r10d
            .equ    r11d, %r11d
            .equ    r12d, %r12d
            .equ    r13d, %r13d
            .equ    r14d, %r14d
            .equ    r15d, %r15d
            
            .equ    rax, %rax
            .equ    rbx, %rbx
            .equ    rcx, %rcx
            .equ    rdx, %rdx
            .equ    rsi, %rsi
            .equ    rdi, %rdi
            .equ    rsp, %rsp
            .equ    rbp, %rbp
            
            .equ    r8,  %r8
            .equ    r9,  %r9
            .equ    r10, %r10
            .equ    r11, %r11
            .equ    r12, %r12
            .equ    r13, %r13
            .equ    r14, %r14
            .equ    r15, %r15
	
	.equ	rip, %rip
	
	.equ	xmm0, %xmm0
	.equ	xmm1, %xmm1
	.equ	xmm2, %xmm2
	.equ	xmm3, %xmm3
	.equ	xmm4, %xmm4
	.equ	xmm5, %xmm5
	.equ	xmm6, %xmm6
	.equ	xmm7, %xmm7
	.equ	xmm8, %xmm8
	.equ	xmm9, %xmm9
	.equ	xmm10, %xmm10
	.equ	xmm11, %xmm11
	.equ	xmm12, %xmm12
	.equ	xmm13, %xmm13
	.equ	xmm14, %xmm14
	.equ	xmm15, %xmm15
	
	.equ	ymm0, %ymm0
	.equ	ymm1, %ymm1
	.equ	ymm2, %ymm2
	.equ	ymm3, %ymm3
	.equ	ymm4, %ymm4
	.equ	ymm5, %ymm5
	.equ	ymm6, %ymm6
	.equ	ymm7, %ymm7
	.equ	ymm8, %ymm8
	.equ	ymm9, %ymm9
	.equ	ymm10, %ymm10
	.equ	ymm11, %ymm11
	.equ	ymm12, %ymm12
	.equ	ymm13, %ymm13
	.equ	ymm14, %ymm14
	.equ	ymm15, %ymm15
	
	.equ	st0, %st(0)
	.equ	st1, %st(1)
	.equ	st2, %st(2)
	.equ	st3, %st(3)
	.equ	st4, %st(4)
	.equ	st5, %st(5)
	.equ	st6, %st(6)
	.equ	st7, %st(7)
	
