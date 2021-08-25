	.file	"Ass1.c"			# Name of source File
	.text			
	.section	.rodata			# Section defining Read only data
	.align 8					# Align with 8-byte boundary
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
	movq	%rsp, %rbp				# rbp <-- rsp, set new base pointer by assigning rsp to rbp
	.cfi_def_cfa_register 6			
	subq	$432, %rsp				# Create 432 bytes space for local variables and array 
	movq	%fs:40, %rax			# Segment addressing
	movq	%rax, -8(%rbp)			# M[rbp-8] <-- rax
	xorl	%eax, %eax				# Clear eax by xoring it with itself. In other words set it to 0.
	leaq	.LC0(%rip), %rdi		# rdi <-- string defined by .LC0,it uses rip relative addressing, rdi being the first argument of the function (here printf)
	call	puts@PLT				# Call puts for printing .LC0, equivalent to the code printf("Enter how many elements you want:\n");
	leaq	-432(%rbp), %rax		# rax <-- (rbp-432) i.e Load the address of variable n into rax
	movq	%rax, %rsi				# rsi <-- rax, set second parameter for calling scanf
	leaq	.LC1(%rip), %rdi		# rdi <-- string of .LC1, uses rip relative addressing, rdi is the first argument of the function (here scanf)
	movl	$0, %eax				# eax <-- 0 
	call	__isoc99_scanf@PLT		# Call scanf to scan the variable n
	movl	-432(%rbp), %eax		# eax <-- M[rbp-432] i.e set the value of eax equal to value of variable n.
	movl	%eax, %esi				# eax <-- esi ,i.e set the second parameter for function call of printf
	leaq	.LC2(%rip), %rdi		# rdi <-- string of .LC2, uses rip relative addressing, rdi is the first argument of the function (here printf)
	movl	$0, %eax				# Set eax <-- 0, corresponding to return 0
	call	printf@PLT				# Call printf to print the statement of .LC2
	movl	$0, -424(%rbp)			# Set M[rbp-424] <-- 0 (Assign variable i = 0)
	jmp	.L2							# Unconditional jump , i.e transfer program control to .L2
.L3:
	leaq	-416(%rbp), %rax		# Assign rax <-- (rbp-416) i.e base address of 'a' array is loaded into rax.
	movl	-424(%rbp), %edx		# Assign edx <-- M[rbp-424] i.e value of variable i is loaded into edx
	movslq	%edx, %rdx				# Sign Extension(32 to 64 bit) of value stored in edx to rdx. rdx <-- edx
	salq	$2, %rdx				# Left shift twice for rdx i.e it is doing rdx <-- 4*i
	addq	%rdx, %rax				# Add rdx to rax i.e. rax <-- rax + 4*i or a + 4*i i.e, rax stores the address of a[i] 
	movq	%rax, %rsi				# Assign rsi <-- rax (32 to 64 bit)
	leaq	.LC1(%rip), %rdi		# rdi <-- string of .LC1, uses rip relative addressing and rdi is the first argument of the function (here scanf)
	movl	$0, %eax				# Set eax <-- 0,corresponding to return 0
	call	__isoc99_scanf@PLT		# Call scanf to read i-th element of array 'a'. 
	addl	$1, -424(%rbp)			# Add 1 to M[rbp-424] , i.e add 1 to variable i (i++) .
.L2:
	movl	-432(%rbp), %eax		# assign eax <--M[rbp-432] i.e,Load the value of variable n.
	cmpl	%eax, -424(%rbp)		# Compare whether M[rbp-424] is less than M[eax] (i.e i < n condition is being checked)
	jl	.L3							# if the condition in the previous line satisfies, jump to .L3 (jl represents jump less than)
	movl	-432(%rbp), %edx		# Assign edx <-- M[rbp-432] i.e value of the variable n
	leaq	-416(%rbp), %rax		# Assign rax <-- (rbp-416) i.e base address of array a
	movl	%edx, %esi				# Assign esi <-- edx,  Assigning the second parameter for function call(variable n)
	movq	%rax, %rdi				# Assign rdi <-- rdx,  Assign the first parameter for function call(base address of array a)
	call	inst_sort				# Call the function inst_sort with two parameters as mentined in above 2 lines.
	leaq	.LC3(%rip), %rdi		# rdi <-- string of .LC3, uses rip relative addressing, rdi is the first argument of the function (here printf)
	call	puts@PLT				# call the puts function for printf operation.
	leaq	-428(%rbp), %rax		# Set rax <-- (rbp-428) i.e address of variable item
	movq	%rax, %rsi				# Set  rsi <-- rax i.e value stored at rax is loaded into rsi (i.e value of variable item)
	leaq	.LC1(%rip), %rdi		# rdi <-- string of .LC1, uses rip relative addressing, rdi is the first argument of the function (here scanf)
	movl	$0, %eax				# Set eax <-- 0,corresponds to return 0 
	call	__isoc99_scanf@PLT		# call scanf to take input of the variable item
	movl	-428(%rbp), %edx		# Set edx <-- M[rbp-428] i.e item
	movl	-432(%rbp), %ecx		# Set ecx <-- M[rbp-432] i.e n
	leaq	-416(%rbp), %rax		# Set rax <-- (rbp-416) i.e base address of array 'a'
	movl	%ecx, %esi				# Set esi <-- ecx i.e set the second parameter for calling function named bsearch
	movq	%rax, %rdi				# Set rdi <-- rax i.e set the first parameter for calling function named bsearch
	call	bsearch					# Call bsreach function, it will return eax
	movl	%eax, -420(%rbp)		# Set M[rbp-420] <-- eax i.e store returned value from bsearch to variable loc.
	movl	-420(%rbp), %eax		# Set eax <-- M[rbp-420] i.e value of variable loc 
	cltq							# Sign Extend (32bit to 64bit) eax to rax
	movl	-416(%rbp,%rax,4), %edx	# Assign edx <-- M[rbp -416 + 4*M[rax]] i.e edx = value stored at (a + 4*loc) or value of a[loc]
	movl	-428(%rbp), %eax		# Set eax <-- M[rbp-428] i.e value of variable item
	cmpl	%eax, %edx				# Compare eax and edx i.e value of item and value of a[loc] (Corresponds to C code loc == a[item])
	jne	.L4							# If the above condition is false, jump to L4 (jne is jump not equals to)
	movl	-420(%rbp), %eax		# Set eax <-- M[rbp-420] i.e value of variable loc
	leal	1(%rax), %edx			# Set edx <-- (M[rax] + 1) i.e value of variable a + 1
	movl	-428(%rbp), %eax		# Set eax <-- M[rbp-428] i.e value of item
	movl	%eax, %esi				# Set esi <-- eax,Assign the second parameter for function call of printf 
	leaq	.LC4(%rip), %rdi		# rdi <-- string of .LC4, uses rip relative addressing, rdi is the first argument of the function (here printf)
	movl	$0, %eax				# Set eax <-- 0, corresponds to return 0
	call	printf@PLT				# call printf function to print the string .LC4 
	jmp	.L5							# Jump unconditionally to .LC5
.L4:
	leaq	.LC5(%rip), %rdi		# rdi <-- string of .LC5, uses rip relative addressing, rdi is the first argument of the function (here printf)
	call	puts@PLT				# call printf to print the .LC5 string
.L5:	
	movl	$0, %eax				# Set eax <-- 0
	movq	-8(%rbp), %rcx			# Set rcx <-- M[rbp-8]
	xorq	%fs:40, %rcx			# Check if equal to the original value
	je	.L7							# if equal,jump to .L7
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
	.cfi_def_cfa_offset 16		 
	.cfi_offset 6, -16			
	movq	%rsp, %rbp			# Set rbp <-- rsp i.e set new base pointer by assigning rsp to rbp
	.cfi_def_cfa_register 6		
	movq	%rdi, -24(%rbp)		# set M[rbp-24] <-- rdi i.e stores base address of array num from register rdi
	movl	%esi, -28(%rbp)		# set M[rbp-28] <-- esi i.e value of n
	movl	$1, -8(%rbp)		# set M[rbp-8] <-- 1 i.e variable j = 1
	jmp	.L9						# Jump unconditionally to .L9
.L13:
	movl	-8(%rbp), %eax		# Set eax <-- M[rbp-8] i.e load value of j to eax
	cltq						# Sign Extension of eax to rax (32bit to 64bit)
	leaq	0(,%rax,4), %rdx	# set rdx <-- rax *4 i.e, j * 4
	movq	-24(%rbp), %rax		# set rax <-- M[rbp - 24] that is store base address of array num to rax
	addq	%rdx, %rax			# add rax <-- rax + rdx i.e num + 4*j which is the address of the element num[j] 
	movl	(%rax), %eax		# assign eax <-- M[rax]  i.e value of num[j]
	movl	%eax, -4(%rbp)		# Set M[rbp-4] <-- eax i.e set k = num[j]
	movl	-8(%rbp), %eax		# set eax <-- M[rbp-8] i.e load value of variable j into eax
	subl	$1, %eax			# Subtract 1 from eax i.e eax <-- eax - 1 ( j - 1)
	movl	%eax, -12(%rbp)		# set M[rbp-12] <-- eax i.e put j - 1 into varible i ( i = j - 1 )
	jmp	.L10					# Unconditionally jump to .L10
.L12:				
	movl	-12(%rbp), %eax		# Set eax <= M[rbp-12] i.e value of i
	cltq						# Signed Extension of eax to rax
	leaq	0(,%rax,4), %rdx	# set rdx <-- rax *4 i.e i * 4
	movq	-24(%rbp), %rax		# Set rax <-- M[rbp-24] i.e store base address of array num into rax
	addq	%rdx, %rax			# Add rdx to rax i.e rax <-- rax + rdx which is equivalent to a +  4*i
	movl	-12(%rbp), %edx		# Set edx <-- M[rbp-12] i.e value of i is stored into edx
	movslq	%edx, %rdx			# Sign Extension of value stored at of edx to rdx (32bit to 64bit)
	addq	$1, %rdx			# Add 1 to rdx i.e rdx <-- rdx + 1 , which means  (i + 1)
	leaq	0(,%rdx,4), %rcx	# set rcx <-- rdx * 4 i.e (i +1)* 4
	movq	-24(%rbp), %rdx		# Set rdx <-- M[rbp-24] i,e base address of array num is stored in rdx
	addq	%rcx, %rdx			# Add rcx to rdx i.e rdx <-- rdx + rcx i.e rdx = num + 4*(i+1)
	movl	(%rax), %eax		# Set eax <-- M[rax] i.e Load value of num[i] 
	movl	%eax, (%rdx)		# Set M[rdx] <-- eax i.e num[i+1] = num[i]
	subl	$1, -12(%rbp)		# Subtract 1 from M[rbp-12] i.e M[rbp-12] = M[rbp-12] - 1 i.e (i--) 
.L10:
	cmpl	$0, -12(%rbp)		# Compare  M[rbp-12] i.e value of i is less than 0 .
	js	.L11					# If the returned flag from above comparison is true , jump to .L11
	movl	-12(%rbp), %eax		# set eax <-- M[rbp-12] i.e assign eax to value of i
	cltq						# Sign Extension of eax to rax(32bit to 64bit)
	leaq	0(,%rax,4), %rdx	# set rdx <-- rax * 4 i.e  i * 4
	movq	-24(%rbp), %rax		# Set rax <-- M[rbp-24] i.e store base address of array num to rax
	addq	%rdx, %rax			# Add rdx to rax i.e rax <-- rax + rdx to get (num + i*4)
	movl	(%rax), %eax		# Set eax <-- M[rax] i.e assign value of num[i] to eax
	cmpl	%eax, -4(%rbp)		# Check that M[rbp-4] is less than eax i.e k<num[i] 
	jl	.L12					# If the returned flag from above condition is true jump to .L12 (jl means jump less than)
.L11:
	movl	-12(%rbp), %eax		# Set eax <= M[rbp-12] i.e value of i
	cltq						# Signed Extension of eax to rax (32bit to 64bit)
	addq	$1, %rax			# Add 1 to rax i.e rax <= rax + 1 which is (i + 1)
	leaq	0(,%rax,4), %rdx	# set rdx <-- rax * 4 i.e  (i+1) * 4
	movq	-24(%rbp), %rax		# Set rax<-- M[rbp-24] i.e base address of array num is stored into rax
	addq	%rax, %rdx			# Add rax to rdx i.e rdx <-- rax + rdx  i.e (num + 4*(i+1))
	movl	-4(%rbp), %eax		# Set eax <-- M[rbp-4] i.e value of k into eax
	movl	%eax, (%rdx)		# Set M[rdx] <-- eax. rdx has the address of num[i+1]. and it stores k (stored in eax) into that location i.e num[i+1] = k
	addl	$1, -8(%rbp)		# Add 1 to M[rbp-8] i.e j++ is being done.
.L9:
	movl	-8(%rbp), %eax		# set eax <-- M[rbp-8] i.e set eax to value of j
	cmpl	-28(%rbp), %eax		# Check if M[eax] < M[rbp-28] i.e whether j < n
	jl	.L13					# If above condition is true, jump (jl means jump less than)  to.L13
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
	movq	%rsp, %rbp			# Set rbp <-- rsp i.e set new base pointer by assigning rsp to rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)		# Set M[rbp-24] <-- rdi , which means base address of array 'a' is stored.
	movl	%esi, -28(%rbp)		# Set M[rbp-8] <-- esi i.e the value bottom is stored from register esi
	movl	%edx, -32(%rbp)		# Set M[rbp-32] <-- edx, i.e the value of the variable item is stored.
	movl	$1, -8(%rbp)		# Set M[rbp-8] <-- 1 i.e bottom = 1
	movl	-28(%rbp), %eax		# Set eax <-- M[rbp-28] i.e assign eax to value of n 
	movl	%eax, -12(%rbp)		# Set M[rbp-12] <-- eax i.e assign top = n
.L18:
	movl	-8(%rbp), %edx		# Set edx <-- M[rbp-8] i.e load value of bottom in edx
	movl	-12(%rbp), %eax		# Set eax <-- M[rbp-12] i.e load value of top in eax
	addl	%edx, %eax			# Add edx to eax i.e eax <-- eax + edx (so it is doing top + bottom)
	movl	%eax, %edx			# Set edx <-- eax
	shrl	$31, %edx			# Shift the bits in edx to the right 31 bits and store in edx
	addl	%edx, %eax			# Add edx to eax i.e eax <-- eax + edx
	sarl	%eax				# Shift the bits in eax to the right i.e (top+bottom)/2
	movl	%eax, -4(%rbp)		# Set M[rbp-4] <-- eax i.e mid = (top+bottom)/2
	movl	-4(%rbp), %eax		# Set eax <-- M[rbp-4] i.e value of mid is stored in eax
	cltq						# Sign Extension of eax to rax(32 to 64bit)
	leaq	0(,%rax,4), %rdx	# Set rdx <-- rax * 4  i.e value of 4*mid is stored in rdx
	movq	-24(%rbp), %rax		# Set rax <-- M[rbp-24] i.e base address of array 'a' is stored in rax
	addq	%rdx, %rax			# Add rdx to rax i.e rax <-- rax + rdx (i.e a + mid*4) 
	movl	(%rax), %eax		# Set eax <-- M[rax] i.e assign eax = a[mid]
	cmpl	%eax, -32(%rbp)		# Compare eax with M[rbp-32] i.e a[mid] with item by doing item - a[mid]
	jge	.L15					# if the above greater than equal condition (item-a[mid]>=0) is true, jump to .L15 (jge = jump greater than equals),
	movl	-4(%rbp), %eax		# Set eax <-- M[rbp-4] i.e, load value of variable mid to eax 
	subl	$1, %eax			# Subtract 1 from the value of eax i.e eax <-- eax - 1(equivalent to mid - 1)  
	movl	%eax, -12(%rbp)		# Set M[rbp-12] <-- eax i.e assigning top = mid - 1
	jmp	.L16					# Unconditionally jump to .L16
.L15:
	movl	-4(%rbp), %eax		# Set eax <-- M[rbp-4] i.e value of mid is loaded in eax
	cltq						# Sign Extend eax to rax(32 bit to 64 bit)
	leaq	0(,%rax,4), %rdx	# Set rdx <-- rax * 4 i.e 4*mid
	movq	-24(%rbp), %rax		# Set rax <-- M[rbp-24] i.e the base address of array 'a' is stored in rax
	addq	%rdx, %rax			# Add rdx to rax i.e rax <-- rax + rdx ( a + 4*mid ) i.e rax is storing the address of the element a[mid]
	movl	(%rax), %eax		# Set eax <-- M[rax] i.e assign eax to value of a[mid]
	cmpl	%eax, -32(%rbp)		# Compare eax with M[rbp] i.e item with a[mid] by doing item -a[mid]
	jle	.L16					# If item - a[mid] is less than equal to 0, jump to .L16 
	movl	-4(%rbp), %eax		# Set eax <-- M[rbp-4] i.e load value of variable 'mid' in eax
	addl	$1, %eax			# Add 1 to eax i.e value of mid + 1 is stored in eax 
	movl	%eax, -8(%rbp)		# Set M[rbp - 8] <-- eax i.e bottom is assigned mid - 1 (bottom = mid - 1) 
.L16:
	movl	-4(%rbp), %eax		# Set eax <-- M[rbp-4] i.e value of variable mid
	cltq						# Sign Extend eax to rax (32 bit to 64 bit)	
	leaq	0(,%rax,4), %rdx	# Set rdx <-- rax *4 i.e 4*mid
	movq	-24(%rbp), %rax		# Set rax <-- M[rbp-24] i.e the base address of array 'a'
	addq	%rdx, %rax			# Add rdx to rax i.e rax <-- rax + rdx i.e  (a + 4 * mid) which means rax is storing the address of a[mid]
	movl	(%rax), %eax		# Set eax <-- M[rax] i.e value of a[mid]
	cmpl	%eax, -32(%rbp)		# Compare eax with M[rbp-32] i.e item with a[mid]
	je	.L17					# If a[mid] is equal to item, then jump to .L17(je means jump equal to)
	movl	-8(%rbp), %eax		# Set eax <-- M[rbp-8] i.e value of bottom
	cmpl	-12(%rbp), %eax		# Compare eax with M[rbp-12] i.e compare top with bottom by doing bottom-top
	jle	.L18					# If (bottom-top) is less than equal to 0 , then jump to .L18 (jle means jump less than equal )
.L17:
	movl	-4(%rbp), %eax		# Set eax <-- M[rbp-4] i.e value of mid
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
