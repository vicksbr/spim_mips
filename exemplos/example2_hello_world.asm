# hello.asm
# Simple routine to demo MIPS output.
# Author: R.N. Ciminero
# See Patterson & Hennessy pg. A-46 for system services.

	.text
	.globl	main
main:
	li	$v0,4		# code for print_str
	la	$a0, msg	# point to string
	syscall
	li	$v0,10		# code for exit
	syscall

	.data
msg:	.asciiz	"Hello World!\n"
