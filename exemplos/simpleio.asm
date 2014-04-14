# simpleio.asm
# Simple routine to demo SPIM input/output.
# Author: R.N. Ciminero
# Revision date: 10-05-93 Original def.
# See Patterson & Hennessy pg. A-46 for system services.

	.text
	.globl	main
main:
	li	$v0,4		# output msg1
	la	$a0, msg1
	syscall

	li	$v0,5		# input A and save
	syscall	

	move	$t0,$v0		
	li	$v0,4		# output msg2
	la	$a0, msg2
	syscall

	li	$v0,5		# input B and save
	syscall	

	move	$t1,$v0		
	add	$t0, $t0, $t1	# A = A + B
	li	$v0, 4		# output msg3
	la	$a0, msg3
	syscall

	li	$v0,1		# output sum
	move	$a0, $t0
	syscall

	li	$v0,4		# output lf
	la	$a0, cflf
	syscall

	li	$v0,10		# exit
	syscall
	.data

msg1:	.asciiz	"\nEnter A:   "
msg2:	.asciiz	"\nEnter B:   "
msg3:	.asciiz	"\nA + B =  "
cflf:   .asciiz	"\n"