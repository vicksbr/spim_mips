
	.text
	.globl main

main:
	li $v0,4     #quatro é o código para a operação print string
	la $a0,msg   #a0 recebe o ponteiro para o começo da string(label) mensagem

	syscall     # executa a operação contida em $v0


	li $v0,10   #10 é a operação exit

	syscall


	.data

msg: .asciiz "Meu primeiro hello world nessa porra \n"

