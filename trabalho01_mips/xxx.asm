####
### la load-adress
### li load-imediate (valor)
### lw load-word


	.data

msg_ordenado:	.asciiz "Vetor ordenado: "
msg_n_ordenado: .asciiz "Vetor nao ordenado: "
pula_linha:		.asciiz "\n"
espaco: 		.asciiz " "

tam_vetor: 		.word 	16
lista:			.word 	13,23,2,17,5,11,19,3,29,1,15,98,89,37,77,68
lista_original:  .word 	13,23,2,17,5,11,19,3,29,1,15,98,89,37,77,68

vet_temp:		.space   16


	.text
	.globl main


main:
	
	#li $v0, 4
	#la $a0, msg_n_ordenado
	#syscall

	#la $a0, lista
	#lw $a1, tam_vetor
	#jal print_vetor 
	
	
	#la $a0,pula_linha
	#syscall	

	#la $a0,msg_ordenado
	#syscall

	#la $a0, vet_temp
	#la $a1, lista_original
	#lw $a2, tam_vetor
	
	#jal copia_vetor 

	la $a0, lista
	lw $a1, tam_vetor
	
	jal mergeSort

	jal print_vetor

	li $v0,10
	syscall

endmain:


print_vetor:         
	
	addi $sp, $sp, -16
	sw   $ra, 12($sp)	
	sw 	 $t1, 8($sp)
	sw   $t2, 4($sp)
	sw   $t3, 0($sp)

	move $t1, $a0	  				#	passa pra t1 o endereço de lista				
	move $t3, $a1    				#	passa pra t1 o argumento com o tamanho da lista 
	li $t2,0      					#	loop counter									
	

	print_loop:
	
		beq $t2,$t3,print_loop_end  #	condição para o fim do loop
		lw $a0,($t1)				#	carrega o parametro para escrever
		
		li $v0,1         		  	#	printa o numero
		syscall

		li $v0,4					
		la $a0,espaco
		syscall

		addi $t2,$t2,1    			
		addi $t1,$t1,4    			

		j print_loop


	print_loop_end:

		lw $ra, 12($sp)
		lw $t1, 8($sp)
		lw $t2, 4($sp)
		lw $t3, 0($sp)

		addi $sp, $sp, 16		

		jr $ra


###	função copia_vetor
### @$a0 endereço de destino
### @$a1 endereço para o vetor de origem
### @$a2 tamanho do vetor!


#lw destino,origen
#sw origem,destino


copia_vetor:
	
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $t0, 4($sp)

	li $t4, 0

	copia_vetor_loop:

		lw $t0, 0($a1) #carrega em $t0 vet_original[i]
		sw $t0, 0($a0) #copia em vet_destino[i] $t0

		addi $a0, $a0, 4 #anda 4 bits em $a0 (uma palavra)
		addi $a1, $a1, 4 #anda 4 bits em $a1 (uma palavra)	
		addi $a2, $a2, -1

		bne $t4, $a2, copia_vetor_loop

	lw $ra, 0($sp)
	lw $t0, 4($sp)
	addi $sp, $sp,-8
	jr $ra

end_copia_vetor:



bubble_sort:

	# @$a0 endereço do vetor 
	# @$a1 tamanho
	
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $t0, 4($sp)  #endereço do vetor
	sw $t1, 8($sp)  #tamanho do vetor
	sw $t2, 12($sp)	#contador do loop interno
	sw $t3, 16($sp) #contador do loop externo
	
	move $t0, $a0
	move $t1, $a1
	addi $t1, $t1, -1
	li $t3, 0


	loop_externo:

		beq $t3, $t1, fim_loop_externo
		li $t2, 0
		
		loop_interno:

			
			beq $t2,$t1, fim_loop_interno

			lw $t5,0($t0)
			lw $t6,4($t0)
			bgt $t5, $t6, troca
			addi $t2, $t2, 1
			addi $t0, $t0, 4

			j loop_interno

			troca:
				
				sw 	$t6,0($t0)
				sw  $t5,4($t0)
				j loop_interno

			
		fim_loop_interno:

			addi $t3,$t3,1
			move $t0, $a0
			j loop_externo

	fim_loop_externo:

		lw $ra, 0($sp)
		lw $t0, 4($sp)  #endereço do vetor
		lw $t1, 8($sp)  #tamanho do vetor
		lw $t2, 12($sp)	#contador do loop interno
		lw $t3, 16($sp) #contador do loop externo
		addi $sp, $sp, 20
		jr $ra

end_bubble_sort:

######
# @$t0 = endereço do vetor
# @$t1 = tamanho do vetor
# @$t2 = endereço do segundo vetor	
# @$t3 = tamanho do segundo vetor
#
######

mergeSort:

	addi $sp,$sp, -28
	sw $a0, 24($sp)
	sw $ra, 20($sp)
	sw $t0, 16($sp)
	sw $t1, 12($sp)
	sw $t2, 8($sp)
	sw $t3, 4($sp)
	sw $t4, 0($sp)   			#	$t4 sera um registrador auxiliar					

	li $t4,1
	sub $t4, $a1, $t4			#	Se o tamanho do vetor < 4, então chama o bubble 	
	blez,$t4,endmergeSort       
	
	move $t0,$a0  				#	$t0 recebe endereço do inicio do primeiro vetor 	
	li $t1,2
	div $t1,$a1,$t1 			#	$t1 = $a1/2  (t1 recebe metade do tamanho do vetor)

	li $t4,4
	mul $t4,$t4,$t1             #	$t4 = tamanho do vetor em bytes		
	add $t2,$t0,$t4				#	t2 recebe a posição do começo do segundo vetor      

	sub $t3,$a1,$t1				# 	$t3 = $a1 - $t1 (tamanho do segundo vetor)

	move $a0,$t0				#	setando os parametros e chamando mergeSort(0..mid-1)
	move $a1,$t1
	jal mergeSort

	move $a0,$t2 				#	setando os parametros e chamando mergeSort(mid..fim)
	move $a1,$t3
	jal mergeSort

	b endmergeSort

		
	endmergeSort:
	
		lw $ra, 20($sp)
		lw $t0, 16($sp)
		lw $t1, 12($sp)
		lw $t2, 8($sp)
		lw $t3, 4($sp)
		lw $t4, 0($sp)
		addi $sp, $sp, 24
		jr $ra