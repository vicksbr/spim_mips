	.text
	.globl main

	main:


		li $a0,10
		
		jal fib
		move $a0,$v0
		
		li $v0,1
		syscall


		li $v0,10
		syscall

		endMain:

	fib:

		addi $sp, $sp, -32
		sw   $ra, 28($sp)
		sw   $fp, 24($sp)
		addu $fp, $sp, 32

		move $t0,$a0   				#	pasando para $t0 o valor n passado 

		blt $t0, 2, fib_base_case	#	caso n < 2, ou seja n = 1,0

		sw $t0,20($sp)    			#	salva esse valor na pilha

		sub $a0, $t0, 1             #	a0 recebe $t0-1 e chama de novo a função							
		jal fib 					

		move $t1,$v0 				#	$t1 = fib(n-1)
		
		lw $t0,20($sp)				#	pop $t0

		sw $t0, 20($sp) 			#   push $t0 para calcular fib(n-2)
		sw $t1, 16($sp)

		sub $a0,$t0,2
		jal fib

		move $t2,$v0				#	$t2 = fib(n-2)

		lw $t0,20($sp)				#  restaura o valor n dando pop $t0
		lw $t1,16($sp)

		add $v0, $t1, $t2
		b fib_return


	fib_base_case:

		li $v0,1     				# return = 1


	fib_return:

		lw $ra, 28($sp)
		lw $fp, 24($sp)
		addi $sp, $sp, 32
		jr $ra












