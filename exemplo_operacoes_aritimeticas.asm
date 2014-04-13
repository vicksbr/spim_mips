
	.text
	.globl main


main:

	li $v0,4  
	la $a0,msg1   #passando ponteiro da onde começa a mensagem
	syscall 
	
	li $v0,5     #passando para v0 a função que recebe input do usuario
	syscall

	move $t0,$v0 #passando para t0(proposito geral) o valor de v0

	li,$v0,4
	la $a0,msg2
	syscall	

	li,$v0,5
	syscall

	move $t1,$v0
	add $t0,$t0,$t1
	
	li	$v0, 4   # output msg3
	la	$a0, msg3
	syscall
	
	li $v0,1    	# passando para v0 a função que imprime um inteiro contido em a0
	move $a0,$t0    # passando para a0 o valor contido em t0
	syscall

	li $v0,10		# passando para v0 a função que chama exit
	syscall 

	.data

msg1: .asciiz "Digite o primeiro numero:\t"
msg2: .asciiz "Digite o segundo numero:\t"
msg3: .asciiz "O numero digitado foi: "
