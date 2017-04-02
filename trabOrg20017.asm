.data

hash:      .space 64 #vetor da tabela hash que recebera os ponteiros pra cada lista
tam:       .word  16 #numero de posicoes
esp:       .asciiz " "
sep:       .asciiz "-"
pula:      .asciiz "\n"
inicial:   .asciiz "Univerisade de São Paulo -Hash Table para Mips 2017\n"
menu:      .asciiz "Opções 1-inserir 2-buscar 3-remover 4-listar\n"
strinsere: .asciiz "Digite o numero: "
sucesso:   .asciiz "***No inserido com sucesso\n"
achado:    .asciiz "***O numero foi encontrado\n"
nachado:   .asciiz "***O numero nao foi encontrado\n"
.text
.globl main

main: 					
	
	la $a0,inicial
	li $v0,4
	syscall

	la $a0,hash
	jal criaLista


inicioprograma:

	li $v0,4
	la $a0,menu
	syscall
		
	li $v0,5
	syscall
	
	beq $v0,$zero,fimprograma
	
	li $t6,1
        beq $v0,$t6,funcaoHash
	
	li $t6,2
        beq $v0,$t6,buscarHash
	
	li $t6,3
        beq $v0,$t6,fimprograma
	
	li $t6,4
	la $a0,hash
    	beq $v0,$t6,imprimeHash #se a opcao digitada for 1
	j inicioprograma											
	
fimprograma:
	li $v0,10
	syscall

criaNo:

	addi,$sp,$sp,-8 #reserva espaço de 2 palavras para salvar o argumento e o endereço de retorno
	sw $ra,0($sp)
	sw $a0,4($sp)

	li $a0,12
	li $v0,9
	syscall		
	
	lw $ra,0($sp)
	lw $a0,4($sp)
	
	addi,$sp,$sp,8
	
	jr $ra	
	
	
criaLista:
	
	addi $t7,$t7,-1  #valor imicializador
	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $a0,4($sp)

	li $t0,0 # contador
	lw $t1,tam
	
loop:
	beq $t0,$t1,fimloop
	
	jal criaNo
	
        sw $t7,4($v0)	
	sw $v0,($a0)
	addi,$a0,$a0,4
	addi,$t0,$t0,1
	j loop
	

fimloop:
	lw $ra,0($sp)
	lw $a0,4($sp)
	addi $sp,$sp,8
	jr $ra
	
# 
# adicionaNo(posicaoNaHash,valor)
#	

# parametros entrada $a0 endereço da cabeça 
# adicionanumero 
#

adicionaNoComeco: 

	addi,$sp,$sp,-12 #reserva espaço de 2 palavras para salvar o argumento e o endereço de retorno
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	

	lw $t5,0($a0)
	lw $t9,4($t5)
	ble $t9,$zero,primeiro

	jal criaNo
	
	#$v0 endreco do novo nó
	
	sw $a1,4($v0)	#escreve o valor no novo nó
	
	lw $t5,0($a0)   #$t5 = mem[$a0]
	sw $t5,8($v0)   #salva para o novo ponteiro o rabo do ponteiro anterior
	sw $v0,0($t5) 
	sw $v0,($a0)    #aponta a cabeca para o novo vetor 
	la $a0,sucesso
	li $v0,4

	j fimadiciona
	
primeiro:
	
	sw $a1,4($t5)
	la $a0,sucesso
	li $v0,4
	syscall
fimadiciona:

	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)
	addi,$sp,$sp,12 
	jr $ra


imprimeHash:
	
	addi,$sp,$sp,-8 #reserva espaço de 2 palavras para salvar o argumento e o endereço de retorno
	sw $ra,0($sp)
	sw $a0,4($sp)
		
	li $t1,0 #contador
	lw $t7,tam
	la $t2,hash

imprimeLoop:
	beq $t1,$t7,fimImprime
	lw $a0,0($t2)
	jal imprimeListaUnica
	addi,$t1,$t1,1
	addi,$t2,$t2,4
	la $a0,pula          
        li $v0,4              
        syscall               
	j imprimeLoop

fimImprime:	
	lw $ra,0($sp)
	lw $a0,4($sp)
	addi,$sp,$sp,8

	jr $ra

imprimeListaUnica:

	addi,$sp,$sp,-8 #reserva espaço de 2 palavras para salvar o argumento e o endereço de retorno
	sw $ra,0($sp)
	sw $a0,4($sp)
	
	move $s0,$a0

looplista:

	beqz $s0,fimlooplista	
	lw $a0,4($s0)
	li $v0,1
	syscall
	
	lw $s0,8($s0)

	la $a0,sep
	li $v0,4
	syscall
	j looplista

fimlooplista:
	lw $ra,0($sp)
	lw $a0,4($sp)
	addi,$sp,$sp,8

	jr $ra


#
# 
#	          
funcaoHash: 

	addi $sp,$sp,-8
	sw $a0,0($sp)
	sw $ra,4($sp)
	
	move $t3,$a0
	
	la $a0,strinsere
	li $v0,4	
	syscall
	li $v0,5
	syscall
	move $t3,$v0	
	lw $t4,tam
	
	div $t3,$t4
	mfhi $t5 #resto da divisao, ou seja, em qual posição do vetor hash inserir o numero

	mul $t5,$t5,4
	la $a0,hash
	add $a0,$a0,$t5
	move $a1,$t3	
	jal adicionaNoComeco 
	
	lw $a0,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8
	
	jr $ra	


buscarHash:
	
	addi $sp,$sp,-8
	sw $a0,0($sp)
	sw $ra,4($sp)
	
	la $a0,strinsere
	li $v0,4	
	syscall
	li $v0,5
	syscall
	
	move $t3,$v0 # contem o numero a ser buscado
	lw   $t4,tam
	
	div  $t3,$t4
	mfhi $t5 #resto da divisao, ou seja, em qual posição do vetor hash inserir o numero

	mul $t5,$t5,4 #calcula a posicao certa dentro do vetor de ponteiros hash

	la $t6,hash
	add $t6,$t6,$t5 #aponta para a cabeça do ponteiro na posicao correta
	lw $s0,0($t6)
loopbusca:	
	
	beqz $s0,naoachou

	lw $a0,4($s0)
	beq $a0,$t3,achou
			
	lw $s0,8($s0)

	la $a0,sep
	li $v0,4
	syscall
	j loopbusca


achou:
	la $a0,achado
	li $v0,4
	syscall
	j fimbusca
naoachou:
	la $a0,nachado
	li $v0,4
	syscall
	j fimbusca

fimbusca:		
	lw $a0,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8
	
	jr $ra	

		
		
