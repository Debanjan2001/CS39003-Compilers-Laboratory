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
	pushq	%rbp				# Save old base pointer in stack frame.
	.cfi_def_cfa_offset 16		# 
	.cfi_offset 6, -16			#
	movq	%rsp, %rbp			# Set rbp <== rsp i.e set new base pointer by assigning rsp to rbp
	.cfi_def_cfa_register 6		#
	movq	%rdi, -24(%rbp)		# set rbp-24 <== rdi i.e base address of array num
	movl	%esi, -28(%rbp)		# set rbp-28 <== esi i.e value of n
	movl	$1, -8(%rbp)		# set rbp-8 <== 1 i.e variable j = 1
	jmp	.L9						# Jump unconditionally to .L9
.L13:
	movl	-8(%rbp), %eax		# Set eax <== M[rbp-8] i.e load value of j
	cltq						# # Sign Extend eax to rax
	leaq	0(,%rax,4), %rdx	# set rdx <== rax *4 i.e j * 4
	movq	-24(%rbp), %rax		# set rax <== M[rbp - 24] i.e array num
	addq	%rdx, %rax			# add rax <== rax + rdx i.e num + 4*j
	movl	(%rax), %eax		# assign eax <== M[rax]  i.e value of num[j]
	movl	%eax, -4(%rbp)		# Set M[rbp-4] <== eax i.e set k = num[j]
	movl	-8(%rbp), %eax		# set eax <== M[rbp-8] i.e variable j
	subl	$1, %eax			# Subtract 1 from eax i.e eax <== eax - 1 ( j - 1)
	movl	%eax, -12(%rbp)		# set M[rbp-12] <== eax i.e put it into varible i
	jmp	.L10					# Unconditionally jump to .L10
.L12:				
	movl	-12(%rbp), %eax		# Set eax <= M[rbp-12] i.e value of i
	cltq						# Signed Extension of eax to rax
	leaq	0(,%rax,4), %rdx	# set rdx <== rax *4 i.e i * 4
	movq	-24(%rbp), %rax		# Set rax <== M[rbp-24] i.e array num
	addq	%rdx, %rax			# Add rdx to rax i.e rax <== rax + rdx i.e  a +  4*i
	movl	-12(%rbp), %edx		# Set edx <== M[rbp-12] i.e value of i
	movslq	%edx, %rdx			# Sign Extension 
	addq	$1, %rdx			# Add 1 to rdx i.e rdx <= rdx + 1 , which means  (i + 1)
	leaq	0(,%rdx,4), %rcx	# set rcx <== rdx * 4 i.e (i +1)* 4
	movq	-24(%rbp), %rdx		# Set rdx = M[rbp-24] i,e array num
	addq	%rcx, %rdx			# Add rcx to rdx i.e rdx <== rdx + rcx i.e rdx = num + 4*(i+1)
	movl	(%rax), %eax		# Set eax <== M[rax] i.e Load num[i] 
	movl	%eax, (%rdx)		# Set M[rdx] = eax i.e num[i+1] = num[i]
	subl	$1, -12(%rbp)		# Subtract 1 from M[rbp-12] i.e M[rbp-12] = M[rbp-12] - 1 i.e (i--) 
.L10:
	cmpl	$0, -12(%rbp)		# Compare  M[rbp-12] i.e value of i is less than 0 .
	js	.L11					# If the flag is true , jump to .L11
	movl	-12(%rbp), %eax		# set eax <== M[rbp-12] i.e value of i
	cltq						# Sign Extension of eax to rax
	leaq	0(,%rax,4), %rdx	# set rdx <== rax * 4 i.e  i * 4
	movq	-24(%rbp), %rax		# Set rax <== M[rbp-24] i.e  array num
	addq	%rdx, %rax			# Add rdx to rax i.e rax <== rax + rdx to get (num + i*4)
	movl	(%rax), %eax		# Set eax <== M[rax] i.e assign num[i] to eax
	cmpl	%eax, -4(%rbp)		# Check that M[rbp-4] is less than eax i.e k<num[i] 
	jl	.L12					# If the flag is true jump to .L12
.L11:
	movl	-12(%rbp), %eax		# Set eax <= M[rbp-12] i.e value of i
	cltq						# Signed Extension of eax to rax
	addq	$1, %rax			# Add 1 to rax i.e rax <= rax + 1 (i + 1)
	leaq	0(,%rax,4), %rdx	# set rdx <== rax * 4 i.e  (i+1) * 4
	movq	-24(%rbp), %rax		# Set rax<== M[rbp-24] i.e array num
	addq	%rax, %rdx			# Add rax to rdx i.e rdx <== rax + rdx  i.e (num + 4*(i+1))
	movl	-4(%rbp), %eax		# Set eax <== M[rbp-4] i.e value of k
	movl	%eax, (%rdx)		# Set M[rdx] <== eax i.e num[i+1] = k
	addl	$1, -8(%rbp)		# Add 1 to M[rbp-8] i.e j++
.L9:
	movl	-8(%rbp), %eax		# set eax <== M[rbp-8] i.e value of j
	cmpl	-28(%rbp), %eax		# Check if M[eax] < M[rbp-28] i.e j<n or not
	jl	.L13					# If above condition is true, jump (jump less than ~ jl)  to.L13
	nop							# Do nothing
	nop							# Do nothing
	popq	%rbp				# Pop rbp
	.cfi_def_cfa 7, 8				
	ret							# pop return address from stack and transfer control back to the return address
	.cfi_endproc
.LFE1:
	.size	inst_sort, .-inst_sort
	.globl	bsearch
	.type	bsearch, @function
bsearch:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp				# Save old base pointer in stack frame.
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp			# Set rbp <== rsp i.e set new base pointer by assigning rsp to rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)		# Set M[rbp-24] <== rdi 
	movl	%esi, -28(%rbp)		# Set M[rbp-8] <== esi i.e bottom
	movl	%edx, -32(%rbp)		# Set M[rbp-32] <== edx
	movl	$1, -8(%rbp)		# Set M[rbp-8] <== 1 i.e bottom = 1
	movl	-28(%rbp), %eax		# Set eax <== M[rbp-28] i.e fetch value of n 
	movl	%eax, -12(%rbp)		# Set M[rbp-12] <== eax i.e top = n
.L18:
	movl	-8(%rbp), %edx		# Set edx <== M[rbp-8] i.e load value of bottom
	movl	-12(%rbp), %eax		# Set eax <== M[rbp-12] i.e value of top
	addl	%edx, %eax			# Add edx to eax i.e eax <== eax + edx ( top + bottom)
	movl	%eax, %edx			# Set edx <== eax
	shrl	$31, %edx			# Shift the bits in edx to the right 31 bits and store in edx  ?????
	addl	%edx, %eax			# Add edx to eax i.e eax <== eax + edx
	sarl	%eax				# Shift the bits in eax to the right i.e (top+bottom)/2
	movl	%eax, -4(%rbp)		# Set M[rbp-4] <== eax i.e mid = (top+bottom)/2
	movl	-4(%rbp), %eax		# Set eax <== M[rbp-4] i.e value of mid
	cltq						# Sign Extend eax to rax
	leaq	0(,%rax,4), %rdx	# Set rdx <== M[rax * 4]  i.e 4*mid
	movq	-24(%rbp), %rax		# Set rax <== M[rbp-24] i.e array 'a'
	addq	%rdx, %rax			# Add rdx to rax i.e rax <== rax + rdx (i.e a + mid*4) 
	movl	(%rax), %eax		# Set eax <== M[rax] i.e a[mid]
	cmpl	%eax, -32(%rbp)		# Compare eax with M[rbp-32] i.e a[mid] with item by doing item - a[mid]
	jge	.L15					# if the above greater than equal condition is true, jump to .L15
	movl	-4(%rbp), %eax			
	subl	$1, %eax
	movl	%eax, -12(%rbp)
	jmp	.L16
.L15:
	movl	-4(%rbp), %eax		# Set eax <== M[rbp-4] i.e mid
	cltq						# Sign Extend eax to rax
	leaq	0(,%rax,4), %rdx	# Set rdx <== M[rax * 4] i.e 4*mid
	movq	-24(%rbp), %rax		# Set rax <== M[rbp-24] i.e the array 'a'
	addq	%rdx, %rax			# Add rdx to rax i.e rax <== rax + rdx ( a + 4*mid )
	movl	(%rax), %eax		# Set eax <== M[rax] i.e value of a[mid]
	cmpl	%eax, -32(%rbp)		# Compare eax with M[rbp] i.e item with a[mid] by doing item -a[mid]
	jle	.L16					# If it is less than equal, jump to .L16 
	movl	-4(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -8(%rbp)
.L16:
	movl	-4(%rbp), %eax		# Set eax <== M[rbp-4] i.e mid
	cltq						# Sign Extend eax to rax	
	leaq	0(,%rax,4), %rdx	# Set rdx <== rax *4 i.e 4*mid
	movq	-24(%rbp), %rax		# Set rax <== M[rbp-24] i.e array 'a'
	addq	%rdx, %rax			# Add rdx to rax i.e rax <== rax + rdx i.e  a + 4* mid
	movl	(%rax), %eax		# Set eax <== M[rax] i.e value of a[mid]
	cmpl	%eax, -32(%rbp)		# Compare eax with M[rbp-32] i.e item with a[mid]
	je	.L17					# If the above compares them as equal then jump equal to .L17
	movl	-8(%rbp), %eax		# Set eax <== M[rbp-8] i.e value of bottom
	cmpl	-12(%rbp), %eax		# Compare eax with M[rbp-12] i.e top with bottom by doing bottom-top
	jle	.L18					# If bottom-top less than equals 0 , then jump less than equal to .L18
.L17:
	movl	-4(%rbp), %eax		# Set eax <== M[rbp-4] i.e value of mid
	popq	%rbp				# Pop base pointer
	.cfi_def_cfa 7, 8
	ret							# pop return address from stack and transfer control back to the return address
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
