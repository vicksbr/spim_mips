
	.text
	.globl main


main:

	#somaAateB($a0,$a1)
	

	li $a0,2
	li $a1,4
	jal somaAateB
	move $t7,$v0

	#fibonnaci($a0)
	
	li $a0,6
	jal fibonacci
	move $t6,$v0


	li $v0,4
	la $a0,msg
	syscall

	li $v0,10
	syscall





	#	int somaAateB(int a, int b) {   
	#								 	
	#	if (a == b)						
	#		returk b 					
	#	return a + somaAateB(int a+1,k) 
	#}


	somaAateB:

		bne $a0,$a1,recursao_AateB
		move $v0,$a1 
		jr $ra

		recursao_AateB:

			addi $sp,$sp,-8
			sw $ra,0($sp)
			sw $a0,4($sp)
			add $a0,$a0,1
			
			jal somaAateB

			lw  $a0, 4($sp)
			add $v0, $v0, $a0			
			lw  $ra, 0($sp)
			addi $sp, $sp, 8
			jr $ra

	
	# int fibonacci(int n) {
	#						
	# 	if (n <= 1)			
	#		return n 		
	#	else			 	
	#		return fibonacci(n -1) + fibonacci(n-2)
	#}


	# entrada:
	# $a0 = n


	fibonacci:

		bgt $a0,1,recursao_fib
		move $v0,$a0
		jr $ra

		
		recursao_fib:

			addi $sp,$sp, -12
			sw 	 $ra, 0($sp)
			sw 	 $s0, 4($sp)
			sw 	 $s1, 8($sp)

			move $s0,$a0
			addi $a0,$a0,-1
			jal  fibonacci   	#chamando fib(n-1)

			move $s1, $v0    	#$s1 recebe fib(n-1)
			add  $a0, $s0, -2
			jal  fibonacci   	#chamadno fib(n-2)

			add $v0,$v0,$s1     #$v0 recebe $v0 + fib(n-1)

			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $ra, 0($sp)
			add $sp, $sp, 12

			jr $ra


	.data

msg:	 .asciiz  "teste \n"









	 

