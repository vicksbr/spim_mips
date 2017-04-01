.data

hash:  .space 64 #vetor da tabela hash que recebera os ponteiros pra cada lista
tam:   .word  16   #numero de posicoes
esp:   .asciiz " "
sep:   .asciiz "-"
pula:  .asciiz "\n"
.text
.globl main

main: 					
	
	la $a0,hash
	jal criaLista

	la $a0,hash
	li $a1,1
	jal adicionaNoComeco
	
	la $a0,hash
	li $a1,2
	jal adicionaNoComeco
	
	la $a0,hash
	li $a1,3
	jal adicionaNoComeco
	
	la $a0,hash
	li $a1,4
	jal adicionaNoComeco

	addi,$a0,$a0,4
	li $a1,5
	jal adicionaNoComeco
	
	
	li $a1,6
	jal adicionaNoComeco

	addi $a0,$a0,4
	li $a1,7
	jal adicionaNoComeco

	la $a0,hash
	jal imprimeHash

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
	addi $t7,$t7,0
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


adicionaNoComeco: 

	addi,$sp,$sp,-12 #reserva espaço de 2 palavras para salvar o argumento e o endereço de retorno
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	
	jal criaNo
	
	#$v0 endreco do novo nó
	
	sw $a1,4($v0)	#escreve o valor no novo nó
	
	lw $t5,0($a0)   #$t5 = mem[$a0]
	sw $t5,8($v0)   #salva para o novo ponteiro o rabo do ponteiro anterior
	sw $v0,0($t5) 
	sw $v0,($a0)    #aponta a cabeca para o novo vetor 
	
		
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
