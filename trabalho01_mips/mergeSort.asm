	.text
	.globl main

main:

	jal bubble

	la $a0, list
	lw $a1, size
	
	jal print_function	

	li $v0,4
	la $a0,pulalinha
	syscall
	
	li $v0,4
	la $a0,msg
	syscall

	li $v0,10
	syscall

	endMain:

bubble:

	addi $sp, $sp, -24
	sw $s0,0($sp)
	sw $s1,4($sp)
	sw $s3,8($sp)
	sw $t1,12($sp)
	sw $t2,16($sp)
	sw $t3,20($sp)

	lw $t3,size
	la $t1,list	  #passa pra t1 o endereço de lista	

	lw $s3,size
	add $s3,$s3,-1

	outer:

		bge $zero,$s3,outer_end
		li $s0,0  #contador do loop
		li $s1,0  #posicao dentro do array (i)

		inner:

			bge $s0,$s3,inner_end
			lw $t7,list($s1)
			lw $t8,list + 4($s1)

			ble $t7,$t8,no_swap
			sw 	$t8,list($s1)
			sw  $t7,list + 4($s1)

	no_swap:

		addi $s1,$s1,4
		addi $s0,$s0,1
		j inner

		inner_end:

		addi $s3,$s3,-1
		j outer

	outer_end:

		lw	$s0, 0($sp)	   # restore $s0 from the stack
		lw	$s1, 4($sp)	   # restore $s1 from the stack
		lw	$s3, 8($sp)    # restore $s3 from the stack
    	lw  $t1, 12($sp)
		lw  $t2, 16($sp)
		lw  $t3, 20($sp)
		addi $sp, $sp, 24  # restore stack pointer


	endbubble:

		jr	$ra
	 
	
print_function:
	
	addi $sp, $sp, -12
	sw 	 $t1, 0($sp)
	sw   $t2, 4($sp)
	sw   $t3, 8($sp)

	move $t1, $a0	  #passa pra t1 o endereço de lista
	move $t3, $a1    #passa pra t1 o argumento com o tamanho da lista
	li $t2,0      #loop counter	
	

	print_loop:
	
		beq $t2,$t3,print_loop_end
		lw $a0,($t1)
		li $v0,1
		syscall

		li $v0,4
		la $a0,espaco
		syscall

		addi $t2,$t2,1    #incremento no para o loop
		addi $t1,$t1,4    #avançando no array 

		j 	print_loop


	print_loop_end:

		lw  $t1, 0($sp)
		lw  $t2, 4($sp)
		lw  $t3, 8($sp)
		addi $sp, $sp, 12		# restore stack pointer

		jr $ra

	.data


merge:

	
	#$t0 é o endereço para o começo do vetor
	#$t1 é o tamanho do vetor 

	addi $sp,$sp,-32
	sw $t0,	0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $t6, 24($sp)
	sw $t7, 28($sp)





endmerge:













msg:    .asciiz   "Teste\n"
size:	.word	  10
list:   .word     13,23,2,17,5,11,19,3,29,1
espaco: .asciiz   " "
pulalinha: .asciiz   "\n"
