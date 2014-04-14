.data

msg:    	.asciiz   "Teste\n"
msg2:		.asciiz   "Outro teste\n"
size:		.word	  16
list:   	.word     16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
auxlist:    .word     0,0,0,0,0,0,0,0,0,0
espaco: 	.asciiz   ", "
pulalinha:  .asciiz   "\n"

	.text
	.globl main



main:

	la $a0,list
	lw $a1, size

	#jal bubble

	#jal print_function

	jal merge

	jal print_function

	move $t0,$v0

	li $v0,4
	la $a0,pulalinha
	syscall

	la $a0,msg
	syscall

	li $v0,10
	syscall

	endMain:

bubble:

	addi $sp, $sp, -28		#	passa pra t1 o endereço de lista
	sw $ra,24($sp)
	sw $s0,20($sp)
	sw $s1,16($sp)
	sw $s3,12($sp)
	sw $t1,8($sp)
	sw $t2,4($sp)
	sw $t3,0($sp)

	#lw $t3,size
	move $t3, $a1
	la $t1,list

	#lw $s3,size
	move $s3, $a1
	add $s3,$s3,-1

	outer:

		bge $zero,$s3,outer_end
		li $s0,0  			   	#	contador do loop
		li $s1,0  				#	posicao dentro do array (i)

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

		lw 	$ra, 24($sp)
		lw	$s0, 20($sp)	# restore $s0 from the stack
		lw	$s1, 16($sp)	# restore $s1 from the stack
		lw	$s3, 12($sp)    # restore $s3 from the stack
    	lw  $t1, 8($sp)
		lw  $t2, 4($sp)
		lw  $t3, 0($sp)
		addi $sp, $sp, 28	# restore stack pointer
		jr	$ra

	endbubble:


print_function:

	addi $sp, $sp, -16
	sw   $ra, 12($sp)
	sw 	 $t1, 8($sp)
	sw   $t2, 4($sp)
	sw   $t3, 0($sp)

	move $t1, $a0	  	#	passa pra t1 o endereço de lista
	move $t3, $a1    	#	passa pra t1 o argumento com o tamanho da lista
	li $t2,0      		#	loop counter


	print_loop:

		beq $t2,$t3,print_loop_end
		lw $a0,($t1)
		li $v0,1
		syscall

		li $v0,4
		la $a0,espaco
		syscall

		addi $t2,$t2,1    #	incremento no para o loop
		addi $t1,$t1,4    #	avançando no array

		j 	print_loop


	print_loop_end:

		lw   $ra, 12($sp)
		lw 	 $t1, 8($sp)
		lw   $t2, 4($sp)
		lw   $t3, 0($sp)

		addi $sp, $sp, 16		# restore stack pointer
#        li $a0, 8
#        li $v0, 11
#        syscall


		jr $ra

#-------------------------------------------------------
#	merge function
#   ordena um vetor usando um merge recursivo
#
#	entradas:
#	$t0 é o endereço para o começo do vetor
#	t1 é o tamanho do vetor
#
#	saidas:
#
#-------------------------------------------------------

merge:


	addi $sp,$sp,-32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $a0, 20($sp)
	sw $a1, 16($sp)
	addi $fp, $sp, 32

    subu $t7, $a1, 4
    blt $a1, 5, bubble   #caso tamanho maior do que 4
    bltz $t7, merge_fim   #caso tamanho maior do que 4

    move $t0, $a1
    move $t1, $a0
    li $t7, 2
    divu $t2, $a1, $t7
    add $t3, $t1, $t2
    sub $t4, $t0, $t2

    move $a0, $t1
    move $a1, $t2
    jal merge

    lw $a0, 20($sp)
	lw $a1, 16($sp)
    move $t0, $a1
    move $t1, $a0
    li $t7, 2
    divu $t2, $a1, $t7
    add $t3, $t1, $t2
    sub $t4, $t0, $t2

    move $a0, $t3
    move $a1, $t4
    jal merge

    merge_fim:

	lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $a0, 20($sp)
	lw $a1, 16($sp)
	addu $sp, $sp, 32
	jr $ra
