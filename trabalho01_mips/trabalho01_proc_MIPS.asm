	.data

msg:    	.asciiz   "Teste\n"
msg2:		.asciiz   "Outro teste\n"
espaco: 	.asciiz   " "
pulalinha:  .asciiz   "\n"

	.align 2
size:		.word	  16
list:   	.word     13,23,2,17,5,11,19,3,29,1,15,98,89,37,77,68
vetor_tmp:  .word     1
list_ord:   .word     1


	.text
	.globl main

main:

	#la $a0, origlist
	#lw $a1, size		
	#jal print_function		

	#li $v0,4
	#la $a0,pulalinha
	#syscall
	
	li $v0, 9
    lw $a0, size
    li $t7, 4
    mul $a0, $a0, $t7
    syscall     #alloca "tam" bytes e retorna o ponteiro pro primeiro em v0
    sw $v0,vetor_tmp     #vetor_aux passa a apontar para o início do vetor alocado na linha acima

	la $a0, list
	lw $a1, size	
	jal merge
	
	la $a0, list
	lw $a1, size
	jal print_function		

	li $v0,10
	syscall

	endMain:

bubble:

	addi $sp, $sp, -32		#	passa pra t1 o endereço de lista	
	sw $ra,28($sp)
	sw $s0,24($sp)
	sw $s1,20($sp)
	sw $s2,16($sp)
	sw $s3,12($sp)
	sw $t1,8($sp)
	sw $t2,4($sp)
	sw $t3,0($sp)

	move $s3,$a1
	add $s3,$s3,-1

	li $s2, 0
	outer: #    loop externo

		bge $s2,$s3,outer_end	
		li $s0,0  			   	#	contador do loop interno	   
		move $s1, $a0			#	posicao dentro do array (i)						

		inner:

			bge $s0,$s3,inner_end   #loop intero 
			lw $t7,($s1)
			lw $t8,4($s1)

			ble $t7,$t8,no_swap
			sw 	$t8,($s1)
			sw  $t7,4($s1)

	no_swap:

		addi $s1,$s1,4
		addi $s0,$s0,1
		j inner

		inner_end:

		add $s2, $s2, 1
		j outer

	outer_end:

		lw 	$ra, 28($sp)
		lw 	$s0, 24($sp)
		lw	$s1, 20($sp)	# restaura os valores da pilha	
		lw	$s2, 16($sp)		
		lw	$s3, 12($sp)    	
    	lw  $t1, 8($sp)
		lw  $t2, 4($sp)
		lw  $t3, 0($sp)
		addi $sp, $sp, 32				
		jr	$ra


	 
	
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


copy_vector:  #copia n pisições de um vetor para outro vetor
#parametros
#a0 -   ponteiro para o vetor destino
#a1 -   ponteiro para o vetor origem
#a2 -   tamanho do vetor (n)
#retorno
#v0 -   ponteiro para o vetor destino

  #empilha os registradores utilizados
  addi $sp, $sp, -8   #"reserva" 2 bytes na pilha
	sw $ra, 0($sp)
	sw $t0, 4($sp)

    copy_vector_loop:
        lw $t0, 0($a1)  #carrega o numero da posição $a1 do vetor de origem para $t0
        sw $t0, 0($a0)  #atribui o valor de $t0 para a posição $a0 do vetor destino
        addi $a0, $a0, 4  #incrementa 4 pois é o tamanho de um inteiro
        addi $a1, $a1, 4  #incrementa 4 pois é o tamanho de um inteiro
        addi $a2, $a2, -1
        bnez $a2, copy_vector_loop     #enquanto o vetor não for totalmente percorrido, ele continua copiando de $a1 para $a0

	  #desempilha os registradores utilizados
    lw $ra, 0($sp)
    lw $t0, 4($sp)
    addi $sp, $sp, 8   #"libera" 2 bytes na pilha
    move $v0, $a0
    jr $ra  #retorno


#-------------------------------------------------------------------------------

merge:

	addi $sp,$sp, -24
	sw $ra, 20($sp)
	sw $t0, 16($sp)
	sw $t1, 12($sp)
	sw $t2, 8($sp)
	sw $t3, 4($sp)
	sw $t4, 0($sp)

	li $t4,4
	sub $t4, $a1, $t4
	blez,$t4,bubble_merge  

	move $t0,$a0  #endereço do inicio do primeiro vetor
	
	li $t1,2
	div $t1,$a1,$t1 #t1 recebendo o tamanho do primeiro vetor 

	li $t4,4
	mul $t4,$t4,$t1
	add $t2,$t0,$t4	#endereço do inicio do segundo vetor

	sub $t3,$a1,$t1		

	move $a0,$t0
	move $a1,$t1
	jal merge

	move $a0,$t2
	move $a1,$t3
	jal merge

 	move $a0, $t0
 	move $a1, $t1
    move $a2, $t2
    move $a3, $t3

    jal mergeSort

	b endmerge

		bubble_merge:

			jal bubble

	endmerge:
	
		lw $ra, 20($sp)
		lw $t0, 16($sp)
		lw $t1, 12($sp)
		lw $t2, 8($sp)
		lw $t3, 4($sp)
		lw $t4, 0($sp)
		addi $sp, $sp, 24
		jr $ra


#-------------------------------------------------------
#	mergeSort(a0,a1,a2,a3) 								
#   faz a ordenação entre 2 vetores e retorna em um 	
#   vetor só											
#														
#	entradas:											
#	$a0 é o endereço para o começo do vetor				
#	$a1 é o tamanho do primeiro vetor					
#   $a2 é o endereço para o começo do segundo vetor		
#   $a3 é o tamanho do segundo vetor 					
#	saidas:												
#														
#-------------------------------------------------------


mergeSort:

	addi $sp, $sp, -32
	sw $ra,28($sp)
	sw $t0,24($sp)
	sw $t1,20($sp)
	sw $t2,16($sp)
	sw $t3,12($sp)
	sw $t4,8($sp)
	sw $t5,4($sp)
	sw $a0,0($sp)	
	
	add $t5, $a1, $a3
	
	li $t0,4

	mul $a1, $a1, $t0
	add $a1, $a0, $a1

	mul $a3, $a3, $t0
	add $a3, $a2, $a3

	lw $t3, vetor_tmp
	
	lw $t1,($a0)
	lw $t2,($a2)

	mergeSort_loop:	

		beq $a0, $a1,preenche_temp_v1
		beq $a2, $a3,preenche_temp_v2

		sub $t0, $t1, $t2
		bgtz $t0, v2maior

		sw   $t1, ($t3)
		addi $a0, $a0,4
		addi $t3, $t3,4
		lw 	 $t1, ($a0)
		b mergeSort_loop
		
		v2maior:

			sw 	 $t2, ($t3)
			addi $a2, $a2, 4
			addi $t3, $t3, 4
			lw   $t2, ($a2)
			b mergeSort_loop

		preenche_temp_v1:

			sw $t2,($t3)
			addi $a2, $a2, 4
	        addi $t3, $t3, 4
			beq $a2, $a3,mergeSort_fim
			lw $t2,($a2)
			b preenche_temp_v1
		
		preenche_temp_v2:

			sw $t1,($t3)
			addi $a0, $a0, 4
			addi $t3, $t3, 4
			beq $a0, $a1, mergeSort_fim	
			lw $t1,($a0)
			b preenche_temp_v2


		mergeSort_fim:

			lw $a0, 0($sp)
			lw $a1, vetor_tmp
			move $a2, $t5

			jal copy_vector

			lw $ra,28($sp)
			lw $t0,24($sp)
			lw $t1,20($sp)
			lw $t2,16($sp)
			lw $t3,12($sp)
			lw $t4,8($sp)
			lw $t5,4($sp)
			addi $sp, $sp, 32

			jr $ra


	

