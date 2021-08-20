	.file	"Ass1.c"
	.text
	.section	.rodata
	.align 8
.LC0:												# Label of f-string 1st printf
	.string	"Enter how many elements you want:"		
.LC1:												# Label of f-string scanf
	.string	"%d"
.LC2:												# Label of f-string 2nd printf
	.string	"Enter the %d elements:\n"
.LC3:												# Label of f-string 3rd printf
	.string	"\nEnter the item to search"
.LC4:												# Label of f-string 4th printf
	.string	"\n%d found in position: %d\n"
	.align 8										# Align with 8-byte boundary 
.LC5:												# Label of f-string 5th printf
	.string	"\nItem is not present in the list."
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp					# Save old base pointer in stack frame.
	.cfi_def_cfa_offset 16			
	.cfi_offset 6, -16
	movq	%rsp, %rbp				# rbp <== rsp, set new base pointer by assigning rsp to rbp
	.cfi_def_cfa_register 6			
	subq	$432, %rsp				# Create 432 bytes space for local variables and array 
	movq	%fs:40, %rax			# Segment addressing
	movq	%rax, -8(%rbp)			# M[rbp-8] <== rax
	xorl	%eax, %eax				# Clear eax by xoring it with itself.
	leaq	.LC0(%rip), %rdi		# rdi <== string (string of .LC0), uses rip relative addressing, rdi is the first argument of the function (here printf)
	call	puts@PLT				# calls printf (with rdi and rsi as arguments) via Procedure Linkage Table (used to call external procedures or functions whose address isn't known at the time of linking), # equivalent to the code printf("Enter how many elements you want:\n");
	leaq	-432(%rbp), %rax		# rax <== M[rbp-432]
	movq	%rax, %rsi				# rsi <== rax
	leaq	.LC1(%rip), %rdi		# rdi <== string (string of .LC1), uses rip relative addressing, rdi is the first argument of the function (here scanf)
	movl	$0, %eax				# printf is a variable argument function, %al is expected to hold the number of vector register, since here printf has integer argument so eax = 0 (al is the first 8 bits of eax)
	call	__isoc99_scanf@PLT		# Call scanf to scan the variable n
	movl	-432(%rbp), %eax		# eax <== M[rbp-432] i.e value of n
	movl	%eax, %esi				# eax <== esi 
	leaq	.LC2(%rip), %rdi		# rdi <== string (string of .LC2), uses rip relative addressing, rdi is the first argument of the function (here printf)
	movl	$0, %eax				# Set eax <== 0, corresponds to return 0
	call	printf@PLT				# Call printf to print the statement of .LC2
	movl	$0, -424(%rbp)			# Set M[rbp-424] = 0 (Assign i = 0)
	jmp	.L2							# Unconditional jump , i.e transfer program control to .L2
.L3:
	leaq	-416(%rbp), %rax		# Assign rax <== M[rbp-416] i.e address of 'a' array
	movl	-424(%rbp), %edx		# Assign edx <== M[rbp-424] i.e address of i
	movslq	%edx, %rdx				# Sign Extend value stored in edx to rdx. rdx <== edx
	salq	$2, %rdx				# Left shift twice for rdx i.e doing rdx = 4*i
	addq	%rdx, %rax				# Add rdx to rax i.e rax <== rdx + 4*i
	movq	%rax, %rsi				# Assign rsi <== rax (32 to 64 bit)
	leaq	.LC1(%rip), %rdi		# rdi <== string (string of .LC1), uses rip relative addressing, rdi is the first argument of the function (here scanf)
	movl	$0, %eax				# Set eax <== 0,corresponds to return 0
	call	__isoc99_scanf@PLT		# Call scanf to read i-th array entry of array 'a'. 
	addl	$1, -424(%rbp)			# Add 1 to M[rbp-424] , i.e add 1 to variable i.
.L2:
	movl	-432(%rbp), %eax		# Load the value of n, assign eax <==M[rbp-432]  (i.e value of variable n)
	cmpl	%eax, -424(%rbp)		# Compare whether M[rbp-424] is less than M[eax] (i.e i < n condition is being checked)
	jl	.L3							# Jump less than (if the condition in the previous line satisfies) , jump to .L3
	movl	-432(%rbp), %edx		# Assign edx <== M[rbp-432] i.e n
	leaq	-416(%rbp), %rax		# Assign rax <== M[rbp-416] i.e base address of array a
	movl	%edx, %esi				# Assign esi <== edx
	movq	%rax, %rdi				# Assign rdi <== rdx
	call	inst_sort				# Call the function inst_sort
	leaq	.LC3(%rip), %rdi		# rdi <== string (string of .LC3), uses rip relative addressing, rdi is the first argument of the function (here printf)
	call	puts@PLT				# call the printf function
	leaq	-428(%rbp), %rax		# Set rax <== M[rbp-428] i.e address of variable item
	movq	%rax, %rsi				# Set  rsi <== rax
	leaq	.LC1(%rip), %rdi		# rdi <== string (string of .LC1), uses rip relative addressing, rdi is the first argument of the function (here scanf)
	movl	$0, %eax				# Set eax <== 0,corresponds to return 0 
	call	__isoc99_scanf@PLT		# call scanf to take input of the variable item
	movl	-428(%rbp), %edx		# Set edx <== M[rbp-428] i.e item
	movl	-432(%rbp), %ecx		# Set ecx <== M[rbp-432] i.e n
	leaq	-416(%rbp), %rax		# Set rax <== M[rbp-416] i.e array 'a'
	movl	%ecx, %esi				# Set esi <== ecx
	movq	%rax, %rdi				# Set rdi <== rax
	call	bsearch					# Call bsreach function, it will return eax
	movl	%eax, -420(%rbp)		# Set M[rbp-420] <== eax i.e store value of bsearch to variable loc
	movl	-420(%rbp), %eax		# Set eax <= M[rbp-420] i.e value of loc for a[loc]
	cltq							# Sign Extend eax to rax
	movl	-416(%rbp,%rax,4), %edx	# Assign edx <== M[rbp-416 + 4*M[rax]] i.e edx = a + 4*loc
	movl	-428(%rbp), %eax		# Set eax <== M[rbp-428] i.e item
	cmpl	%eax, %edx				# Compare eax and edx i.e value of item and value of a[loc]
	jne	.L4							# If the above condition is false, jump to L4 ( jump not equals to)
	movl	-420(%rbp), %eax		# Set eax <== M[rbp-420] i.e loc
	leal	1(%rax), %edx			# Set edx <== M[rax] + 1 i.e loc + 1
	movl	-428(%rbp), %eax		# Set eax <== M[rbp-428] i.e value of item
	movl	%eax, %esi				# Set esi <== eax
	leaq	.LC4(%rip), %rdi		# rdi <== string (string of .LC4), uses rip relative addressing, rdi is the first argument of the function (here printf)
	movl	$0, %eax				# Set eax <== 0, i.e return 0
	call	printf@PLT				# call printf function to print the string .LC4 
	jmp	.L5							# Jump unconditionally to .LC5
.L4:
	leaq	.LC5(%rip), %rdi		# rdi <== string (string of .LC5), uses rip relative addressing, rdi is the first argument of the function (here printf)
	call	puts@PLT				# call puts to print the .LC5 string
.L5:	
	movl	$0, %eax				# Set eax <== 0
	movq	-8(%rbp), %rcx			# Set rcx <== M[rbp-8]
	xorq	%fs:40, %rcx			# Check if equal to the original value
	je	.L7							# If equal, jump to .L7
	call	__stack_chk_fail@PLT	# Check Stack (__stack_chk_fail is noreturn)
.L7:
	leave							# Set rsp to rbp, and pop top of stack into rbp
	.cfi_def_cfa 7, 8
	ret								# pop return address from stack and transfer control back to the return address
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	inst_sort
	.type	inst_sort, @function
inst_sort:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	$1, -8(%rbp)
	jmp	.L9
.L13:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
	movl	-8(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -12(%rbp)
	jmp	.L10
.L12:
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	addq	$1, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	subl	$1, -12(%rbp)
.L10:
	cmpl	$0, -12(%rbp)
	js	.L11
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L12
.L11:
	movl	-12(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	movl	%eax, (%rdx)
	addl	$1, -8(%rbp)
.L9:
	movl	-8(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L13
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	inst_sort, .-inst_sort
	.globl	bsearch
	.type	bsearch, @function
bsearch:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movl	$1, -8(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -12(%rbp)
.L18:
	movl	-8(%rbp), %edx
	movl	-12(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -32(%rbp)
	jge	.L15
	movl	-4(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -12(%rbp)
	jmp	.L16
.L15:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -32(%rbp)
	jle	.L16
	movl	-4(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -8(%rbp)
.L16:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -32(%rbp)
	je	.L17
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jle	.L18
.L17:
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	bsearch, .-bsearch
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
