	
	.data

msg:    	.asciiz   "Teste\n"
msg2:		.asciiz   "Outro teste\n"
size:		.word	  16
list:   	.word     13,23,2,17,5,11,19,3,29,1,15,98,89,37,77,68
origlist:   .word     13,23,2,17,5,11,19,3,29,1,15,98,89,37,77,68
espaco: 	.asciiz   " "
pulalinha:  .asciiz   "\n"

	.text
	.globl main



main:

	la $a0, origlist
	lw $a1, size		
	jal print_function		
	
	li $v0,4
	la $a0,pulalinha
	syscall
	
	jal bubble	

	la $a0, list
	lw $a1, size	
	
	jal print_function		

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

	lw $t3,size
	la $t1,list	  			

	lw $s3,size
	add $s3,$s3,-1

	outer: #    loop externo

		bge $zero,$s3,outer_end	
		li $s0,0  			   	#	contador do loop		   
		li $s1,0  				#	posicao dentro do array (i)

		inner:

			bge $s0,$s3,inner_end   #loop intero 
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
		lw	$s0, 20($sp)	# restaura os valores da pilha	
		lw	$s1, 16($sp)		
		lw	$s3, 12($sp)    	
    	lw  $t1, 8($sp)
		lw  $t2, 4($sp)
		lw  $t3, 0($sp)
		addi $sp, $sp, 28				
		jr	$ra

	endbubble:		
	 
	
print_function:         #funcao simples que printa um array contido em $a0 de tamanho $a1
	
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
	addi $fp, $sp, 32
	
	move $t0,$a0
	blt $t0,1,caso_basico

	sw $t0,20($sp)

	sub $a0, $t0, 1
	jal merge

	move $t1,$v0  #passa o resultado de merge(n)
	lw $t0,20($sp)

	add $v0, $t0, $t1
	b endmerge

caso_basico:
	li $v0,1	

endmerge:
	lw $ra, 28($sp)
	lw $fp, 24($sp)
	addu $sp, $sp, 32
	jr $ra

	

