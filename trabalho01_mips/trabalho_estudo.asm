####
### la load-adress
### li load-imediate (valor)
### lw load-word


	.data

msg_ordenado:	.asciiz "Vetor ordenado: "
msg_n_ordenado: .asciiz "Vetor nao ordenado: "
pula_linha:		.asciiz "\n"
espaco: 		.asciiz " "

tam_vetor: 		.word 	8
lista:			.word 	13,23,2,17,5,11,19,3
lista_original: .word 	13,23,2,17,5,11,19,3,29,1,15,98,89,37,77,68,12

vet_temp:		.space 	8


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
	

	la $a0, vet_temp
	lw $a1, tam_vetor
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

	addi $sp, $sp,-20
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)

	move $t0, $a0
	move $t1, $a1
	
	li $t4,1
    sub $t4, $a1, $t4			#	Se o tamanho do vetor < 4, então chama o bubble 	
	blez,$t4,bubble_merge       

	li $t1, 2
	div $t1,$a1,$t1 	   #$t1 = tamanho/2 (var mid)
	
	li $t9, 4
	mul $t9, $t9, $t1 	   #$t9 = tamanho do vetor em bytes 
	
	add $t2, $t0, $t9      #$t2 = endereço da segunda metade do vetor
	sub $t3, $a1,$t1	   #$t3 tamanho da segunda parte do vetor
	
	move $a0, $t0
	move $a1, $t1
	jal mergeSort

	move $a0, $t2
	move $a1, $t3
	jal mergeSort

	move $a0, $t0 			    #	setando os parametros e chamando merge(t0,t1,t2,t3)
 	move $a1, $t1
    move $a2, $t2
    move $a3, $t3
    
    jal merge
	
    #imprime parcialmente
	la $a0, vet_temp
	lw $a1, tam_vetor
	jal print_vetor
	
	la $a0,pula_linha
	li $v0, 4
	syscall	

    
    b end_mergeSort

	bubble_merge:

		#jal bubble_sort

	end_mergeSort:

		lw $ra, 0($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		addi $sp, $sp, 20
		jr $ra

merge:

	addi $sp, $sp, -32
	sw $ra,28($sp)
	sw $t0,24($sp)
	sw $t1,20($sp)
	sw $t2,16($sp)
	sw $t3,12($sp)		#	$t3 sera nosso vetor auxiliar
	sw $t4,8($sp)		
	sw $t5,4($sp)		
	sw $a0,0($sp)	
	
	la $t3,vet_temp

	li $t4,0 		  #i = 0
	move $t5,$a1 	  #meio = tamanho
	move $t6,$t5 	  #j = meio
	add $t7,$a1,$a3   #total
	
	
	merge_loop:	

		lw $t1,($a0)		# 	carrega para $t1 o valor em vet1[posicao]
		lw $t2,($a2)        #   careega para $t2 o valor em vet2[posicao]

		#while(i < meio && j < tamanho )
		bge  $t4, $t5, fim_while   # cond1: branch if ! ( i >= meio ) 
    	bge  $t6, $t7, fim_while   # cond2: branch if ! ( j >= tamanho ) 
      
		sub $t0, $t1, $t2               
		bgtz $t0, v2maior				#	compara se vet1[a0] > vet2[a2]	    

		sw   $t1, ($t3)					# 	copia de vet1 para vetAux 			
		addi $a0, $a0,4					#   incrementa uma posição(word) em $a0 
		addi $t3, $t3,4					#   incrementa uma posição(word) em $t3 
		addi $t4, $t4,1 #i++
	
		b merge_loop

      	v2maior:						#	quando vet2[a2] > vet1				

			sw 	 $t2, ($t3)				#	carrega de vet2 para vetAux			
			addi $a2, $a2, 4			#   incrementa uma posição(word) em $a2 
			addi $t3, $t3, 4			#   incrementa uma posição(word) em $t3 
			addi $t6, $t6, 1 #j++
	
			b merge_loop	  

    
    fim_while:
	  	
	preenche:
	
	#if i == meio, preenche com j, else preenche com i
	bne $t4,$t5,preenche_p2

	sw $t2,($t3)
	addi $a2, $a2, 4
    addi $t3, $t3, 4
	addi $t6, $t6, 1 #j++
	beq $t6, $t7, merge_fim
	lw $t2,($a2)
	b preenche
	
	#else
	preenche_p2:
		sw $t1,($t3)
		addi $a0, $a0, 4
		addi $t3, $t3, 4
		addi $t4, $t4,1 #i++
		beq $t4, $t5, merge_fim	
		lw $t1,($a0)
		b preenche_p2

	merge_fim:

		lw $ra,28($sp)
		lw $t0,24($sp)
		lw $t1,20($sp)
		lw $t2,16($sp)
		lw $t3,12($sp)
		lw $t4,8($sp)
		lw $t5,4($sp)
		lw $a0, 0($sp)	
		addi $sp, $sp, 32

		jr $ra


