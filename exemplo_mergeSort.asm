# Programmer:  Mark Fienup
# Solution to homework #4 Merge Sort
# Implementation of Merge Sort

	.data
array:	.word	8, 2, 7, 1, 5, 6, 3, 4, 9, 0
n:	.word	10

	.text
	.globl main
main:
	lw $t0, n		# $t0 contains n
	la $a0, array	# $a0 contains address of array
	li $a1, 0		# $a1 contains starting index to sort (low)
	addi $a2,$t0,-1 	# $a2 contains ending index to sort (high)
	jal	mergeSort	

	li	$v0, 10		# system code for exit
	syscall
endMain:


	.text
	.globl	mergeSort

# $a0 contains address of array to sort
# $a1 contains low (starting index of array to sort)
# $a2 contains high (ending index of array to sort)
# $s0 contains address of array to sort
# $s1 contains low (starting index of array to sort)
# $s2 contains high (ending index of array to sort)
# $s3 contains mid


mergeSort:

	addi	$sp, $sp, -20		# make room on stack for 5 registers
	sw	$s0, 4($sp)		# save $s0 on stack
	sw	$s1, 8($sp)		# save $s1 on stack
	sw	$s2, 12($sp)		# save $s2 on stack
	sw	$s3, 16($sp)		# save $s3 on stack
	sw	$ra, 20($sp)		# save $ra on stack

	move	$s0, $a0		# copy param. $a0 into $s0 (addr array)
	move 	$s1, $a1		# copy param. $a1 into $s1 (low)
	move 	$s2, $a2		# copy param. $a2 into $s2 (high)

if:
	blt	$s1, $s2, then		# if low < high
	j	endIf
then:
	li	$t0, 2
	add	$s3, $s1, $s2		# mid = (low + high) / div
	div	$s3, $s3, $t0

	move 	$a0, $s0
	move 	$a1, $s1
	move 	$a2, $s3
	jal	mergeSort

	move 	$a0, $s0
	addi	$a1, $s3, 1
	move	$a2, $s2
	jal	mergeSort

	move 	$a0, $s0
	move 	$a1, $s1
	move 	$a2, $s3
	move	$a3, $s2
	jal	merge

endIf:

	lw	$s0, 4($sp)		# restore $s0 from the stack
	lw	$s1, 8($sp)		# restore $s1 from the stack
	lw	$s2, 12($sp)		# restore $s2 from the stack
	lw	$s3, 16($sp)		# restore $s3 from the stack
	lw	$ra, 20($sp)		# restore $ra from the stack
	addi	$sp, $sp, 20		# restore stack pointer

	jr	$ra			# return to calling routine
endMergeSort:


	.text
	.globl merge

# $a0 contains address of array to sort
# $a1 contains low (starting index of array to sort)
# $a2 contains mid (middle index of array to sort)
# $a3 contains high (ending index of array to sort)
# $t0 contains i (or m)
# $t1 contains j (or m)
# $t2 contains k
# $t3 contains address of array[i] (or array[m])
# $t4 contains address of array[j] (or array[m])
# $t5 contains address of temp[k]
# $t6 contains constant 4
# $t7 contains value of array[i]
# $t8 contains value of array[j]
# $t9 contains value of temp[k]

merge:

# Since NO this subprogram does NOT call any other subprogram or use any $s 
# registers, no registers needs to be saved on the run-time stack.

# initialize registers containing constants
li	$t6, 4

# Make room for temp array with (high-low+1) elements on the stack 
sub	$t0, $a3, $a1
addi	$t0, $t0, 1
mul	$t0, $t0, $t6
sub	$sp, $sp, $t0 

# initialize i, j, and k
move 	$t0, $a1
addi 	$t1, $a2, 1
li	$t2, 0

while:
	ble	$t0, $a2, andTest
	j	endWhile
andTest:
	ble	$t1, $a3, whileBody
	j	endWhile
whileBody:
	
if2:
	mul	$t3, $t0, $t6
	add	$t3, $t3, $a0
	lw	$t7, 0($t3)

	mul	$t4, $t1, $t6
	add	$t4, $t4, $a0
	lw	$t8, 0($t4)

	blt	$t7, $t8, then2
	j	else2
then2:
	mul	$t5, $t2, $t6
	add	$t5, $t5, $sp
	addi	$t5, $t5, 4
	sw	$t7, 0($t5)
	
	addi	$t0, $t0, 1
	j	endIf2
else2:
	mul	$t5, $t2, $t6
	add	$t5, $t5, $sp
	addi	$t5, $t5, 4
	sw	$t8, 0($t5)
	
	addi	$t1, $t1, 1
endIf2:

	addi	$t2, $t2, 1

	j	while

.globl endWhile
endWhile:

if3:
	bgt	$t0, $a2, then3
	j	else3
then3:
	
for:
	move 	$t0, $t1		# reuse $t0 for m
forLoop:
	ble	$t0, $a3, forBody
	j	endFor
forBody:
	mul	$t3, $t0, $t6
	add	$t3, $t3, $a0
	lw	$t7, 0($t3)

	mul	$t5, $t2, $t6
	add	$t5, $t5, $sp
	addi	$t5, $t5, 4
	sw	$t7, 0($t5)
	
	addi 	$t2, $t2, 1

	addi	$t0, $t0, 1
	j	forLoop
endFor:

	j	endIf3
.globl else3
else3:

for2:
	move 	$t1, $t0		# reuse $t1 for m
forLoop2:
	ble	$t1, $a2, forBody2
	j	endFor2
forBody2:
	mul	$t4, $t1, $t6
	add	$t4, $t4, $a0
	lw	$t8, 0($t4)

	mul	$t5, $t2, $t6
	add	$t5, $t5, $sp
	addi	$t5, $t5, 4
	sw	$t8, 0($t5)
	
	addi 	$t2, $t2, 1

	addi	$t1, $t1, 1
	j	forLoop2
endFor2:

endIf3:	

	li	$t2, 0
for3:
	move 	$t1, $a1		# reuse $t1 for m
forLoop3:
	ble	$t1, $a3, forBody3
	j	endFor3
forBody3:
	mul	$t5, $t2, $t6
	add	$t5, $t5, $sp
	addi	$t5, $t5, 4
	lw	$t9, 0($t5)
	
	mul	$t4, $t1, $t6
	add	$t4, $t4, $a0
	sw	$t9, 0($t4)

	addi 	$t2, $t2, 1

	addi	$t1, $t1, 1
	j	forLoop3
endFor3:

# Remove temp array with (high-low+1) elements from the stack 
sub	$t0, $a3, $a1
addi	$t0, $t0, 1
mul	$t0, $t0, $t6
add	$sp, $sp, $t0 

jr	$ra

endMerge:

