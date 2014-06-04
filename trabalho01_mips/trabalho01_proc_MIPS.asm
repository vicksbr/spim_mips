#----------------------------------------------------------------------
#	Merge Sort em assembly MIPS					  					   
#												  					   
# 	download disponivel no github				  				       
#	https://github.com/vicksbr/spim_mips/tree/master/trabalho01_mips   
#																	   
#																	   


#------------------------------------------
# LABELS     								
#-------------------------------------------

	.data

ord_msg:    .asciiz  "Vetor ordenado: "
nord_msg:	.asciiz  "Vetor desordenado: "
espaco: 	.asciiz   " "
pulalinha:  .asciiz   "\n"

	.align 2
size:		.word	  8
list:   	.word     13,23,2,17,5,11,19,3
list_old:   .word     13,23,2,17,5,11,19,3,29,1,15,98,89,37,77,68,12
vetor_tmp:  .word     1


	.text
	.globl main


#-------------------------------------------
# Main     									
#-------------------------------------------


main:

	#passando os parametros e chamando printando o vetor desordenado

	la $a0,nord_msg
	syscall
	
	la $a0, list_old
	lw $a1, size		
	jal print_function		

	li $v0,4
	la $a0,pulalinha
	syscall
	

	#alocação de espaço para o vetor temporario

	li $v0, 9
    lw $a0, size
    li $t7, 4
    mul $a0, $a0, $t7
    syscall         

    sw $v0,vetor_tmp     

	#passando os parametros e chamando merge

	la $a0, list
	lw $a1, size	
	jal mergeSort
	
	#passando os parametros e chamando printando o vetor ordenado

	li $v0,4
	la $a0,ord_msg
	syscall

	la $a0, list
	lw $a1, size
	jal print_function		

	li $v0,10
	syscall

	endMain:

#-------------------------------------------
# FUNCOES									
#-------------------------------------------


#-------------------------------------------
#	bubble(*a0,a1)						 	
#	aplica o bubble sort no vetor passado	
#											
#	entradas								
#	$a0 endereço para o começo do vetor     
#   $a1 tamanho do vetor 					
#-------------------------------------------

	.text
	.globl bubble


bubble:

	addi $sp, $sp, -32		
	sw $ra,28($sp)
	sw $s0,24($sp)					#	$s0 sera o contador do loop inner   
	sw $s1,20($sp)					#	$s1 recebera o começo do vetor      
	sw $s2,16($sp)					#   $s2 sera o contador do loop outer   
	sw $s3,12($sp)					# 	$s3 recebera o tamanho				
	
	move $s3,$a1					#   copia para $s3 o tamanho do vetor       
	add $s3,$s3,-1                 #	decrementa o tamanho pois fara i-1 vezes

	li $s2, 0						#   setando o contador j para 0
	outer: 							#   loop externo

		bge  $s2,$s3,outer_end	
		li   $s0,0  			   	#	$s0 contador do loop interno	   					
		move $s1, $a0				#	$s1 recebe o endereço do começo do vetor			

		inner:

			bge $s0,$s3,inner_end   #	loop interno										
			lw $t7,($s1)			# 	coloca em t7 e t8 as palavras v[i] e v[i+]			
			lw $t8,4($s1)

			ble $t7,$t8,no_swap 	#	caso nao entrar no "no_swap" realizar a troca  		
			sw 	$t8,($s1)
			sw  $t7,4($s1)

	no_swap:

		addi $s1,$s1,4				#	incrementa 4 bytes p/ passar para prox posicao no vetor
		addi $s0,$s0,1 				#	incrementa o contador do loop interno (j)
		j inner

		inner_end:

		add $s2, $s2, 1             #	incrementa o contador do loop externo (i)
		j outer

	outer_end:

		lw 	$ra, 28($sp)
		lw 	$s0, 24($sp)
		lw	$s1, 20($sp)			
		lw	$s2, 16($sp)		
		lw	$s3, 12($sp)    	
    	addi $sp, $sp, 32				
		jr	$ra


#-------------------------------------------------
#	Printa um array contido em $a0 de tamanho $a1 
#												  
#	entradas: 									  
#	$a0	 endereço para o começo da lista 		  
#   $a1  tamanho								  
#------------------------------------------------ 

	.text
	.globl print_function

print_function:         
	
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

		li $v0,4					#	printa um espaço
		la $a0,espaco
		syscall

		addi $t2,$t2,1    			#	incremento no para o loop	
		addi $t1,$t1,4    			#	avançando no array		 	

		j 	print_loop


	print_loop_end:

		lw   $ra, 12($sp)
		lw 	 $t1, 8($sp)
		lw   $t2, 4($sp)
		lw   $t3, 0($sp)

		addi $sp, $sp, 16		

		jr $ra


#-----------------------------------------------
#	copia_vetor_loop(*a0,*a1,a2) ->	$v0		    
#	copia um vetor byte a byte para outro vetor 
#												
#   entradas:									
#   $a0 endereço para o vetor de destino		
#	$a1 endereço para o vetor de origem			
#   $a2 tamanho do vetor 						
#												
#	saida:										
#	$v0 contem o endereço para o destino		
#-----------------------------------------------

	.text
	.globl copia_vetor


copia_vetor:

	addi $sp, $sp, -32
	sw $ra, 28($sp)
	sw $t0, 24($sp)

	copia_vetor_loop:
	
		lw $t0, 0($a1)					#	carregando em t0 a palavra em vet2[i]  		   
		sw $t0, 0($a0)					#	copiando em  vet1[i] o valor de vet2[i]		   
		addi $a0, $a0, 4				#   incrementando a posição em vet1 em 1 palavra   
		addi $a1, $a1, 4				#   incrementando a posição em vet2 em 1 palavra   
		addi $a2, $a2, -1 				#   decrementando o contador					   
		bnez $a2, copia_vetor_loop		#   se contador > 0 então continua o loop

	lw $ra,28($sp)
	lw $t0,24($sp)
	addi $sp, $sp,32
	jr  $ra


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

	.text
	.globl mergeSort

mergeSort:

	addi $sp,$sp, -24
	sw $ra, 20($sp)
	sw $t0, 16($sp)
	sw $t1, 12($sp)
	sw $t2, 8($sp)
	sw $t3, 4($sp)
	sw $t4, 0($sp)   			#	$t4 sera um registrador auxiliar					

	li $t4,1
    sub $t4, $a1, $t4			#	Se o tamanho do vetor < 4, então chama o bubble 	
	blez,$t4,bubble_merge       
	
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

 	move $a0, $t0 			    #	setando os parametros e chamando merge(t0,t1,t2,t3)
 	move $a1, $t1
    move $a2, $t2
    move $a3, $t3
    
    jal merge

	la $a0, list
	lw $a1, size		
	jal print_function		

	li $v0,4
	la $a0,pulalinha
	syscall


	b endmergeSort

		bubble_merge:			#   entra aqui quando o vetor for menor que 4

			#jal bubble

	endmergeSort:
	
		lw $ra, 20($sp)
		lw $t0, 16($sp)
		lw $t1, 12($sp)
		lw $t2, 8($sp)
		lw $t3, 4($sp)
		lw $t4, 0($sp)
		addi $sp, $sp, 24
		jr $ra


#-------------------------------------------------------
#	merge(a0,a1,a2,a3) 								    
#   faz a ordenação entre 2 vetores e retorna em um 	
#   vetor só											
#														
#	entradas:											
#	$a0 é o endereço para o começo do vetor				
#	$a1 é o tamanho do primeiro vetor					
#   $a2 é o endereço para o começo da segunda parte do vetor		
#   $a3 é o tamanho da segunda parte do vetor 					
#-------------------------------------------------------

	.text
	.globl merge


merge:

	addi $sp, $sp, -32
	sw $ra,28($sp)
	sw $t0,24($sp)
	sw $t1,20($sp)
	sw $t2,16($sp)
	sw $t3,12($sp)		#	$t3 sera nosso vetor auxiliar
	sw $t4,8($sp)		# 	$t4 variavel auxiliar
	sw $t5,4($sp)		#	$t5 guarda o tamanho total (vet1 + vet2)
	sw $a0,0($sp)	
	
	add $t5, $a1, $a3 	#	$t5 recebe a soma dos tamanhos de vet1 e vet2
	
	li $t0,4            # 	fator multiplicativo p/ palavra(word)
	
	mul $a1, $a1, $t0   #	$a1 recebe o tamanho em bytes(palavras)      
	add $a1, $a0, $a1   #	$a1 recebe o endereço do meio 

	mul $a3, $a3, $t0   
	add $a3, $a3, $a2   #	$a3 recebe o endereço do fim

	lw $t3, vetor_tmp	
	
	lw $t1,($a0)		# 	carrega para $t1 o valor em vet1[posicao]
	lw $t2,($a2)        #   careega para $t2 o valor em vet2[posicao]

	merge_loop:	

		beq $a0, $a1,preenche_temp_v1	#	se o vet1 chegou ao fim
		beq $a2, $a3,preenche_temp_v2   #	se o vet2 chegou ao fim

		sub $t0, $t1, $t2               
		bgtz $t0, v2maior				#	compara se vet1[a0] > vet2[a2]	    

		sw   $t1, ($t3)					# 	copia de vet1 para vetAux 			
		addi $a0, $a0,4					#   incrementa uma posição(word) em $a0 
		addi $t3, $t3,4					#   incrementa uma posição(word) em $t3 
		lw 	 $t1, ($a0)					#   pega o novo valor de vet1			
		b merge_loop
		
		v2maior:						#	quando vet2[a2] > vet1				

			sw 	 $t2, ($t3)				#	carrega de vet2 para vetAux			
			addi $a2, $a2, 4			#   incrementa uma posição(word) em $a2 
			addi $t3, $t3, 4			#   incrementa uma posição(word) em $t3 
			lw   $t2, ($a2)				#   pega o novo valor em vet2
			b merge_loop

		preenche_temp_v1:				#	quando não há mais nada no vet1 	
										#   preenche com o vet2					
			sw $t2,($t3)
			addi $a2, $a2, 4
	        addi $t3, $t3, 4
			beq $a2, $a3,merge_fim
			lw $t2,($a2)
			b preenche_temp_v1
		
		preenche_temp_v2:				#	quando não há mais nada no vet2 	
										#	preenche com o vet1			    	
			sw $t1,($t3)
			addi $a0, $a0, 4
			addi $t3, $t3, 4
			beq $a0, $a1, merge_fim	
			lw $t1,($a0)
			b preenche_temp_v2


		merge_fim:

			lw $a0, 0($sp)				#	copia do vetor auxiliar para o nosso vetor original
			lw $a1, vetor_tmp
			move $a2, $t5

			jal copia_vetor_loop	   

			lw $ra,28($sp)
			lw $t0,24($sp)
			lw $t1,20($sp)
			lw $t2,16($sp)
			lw $t3,12($sp)
			lw $t4,8($sp)
			lw $t5,4($sp)
			addi $sp, $sp, 32

			jr $ra


	

