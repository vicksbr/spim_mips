.data

hash:      .space 64 #vetor da tabela hash que recebera os ponteiros pra cada lista
tam:       .word  16 #numero de posicoes da tabela hash
esp:       .asciiz " "
sep:       .asciiz "-"
pula:      .asciiz "\n"
inicial:   .asciiz "Univerisade de São Paulo -Hash Table para Mips 2017\n"
menu:      .asciiz "Opções 1-inserir 2-buscar 3-remover 4-listar: "
strinsere: .asciiz "Digite o numero: "
sucesso:   .asciiz "***No inserido com sucesso\n"
fracasso:  .asciiz "***O no inserido ja existe ou negativo\n"
achado:    .asciiz "***O numero foi encontrado\n"
nachado:   .asciiz "***O numero nao foi encontrado\n"
negativo:  .asciiz "Numero negativo invalido\n"


.text
.globl main

main: 					
	
	la $a0,inicial  #imprime um menu inicial
	li $v0,4
	syscall

	la  $a0,hash   # popula o vetor hash[15..0] com os nós cabeças das listas
	jal criaLista


inicioprograma:

	li $v0,4
	la $a0,menu    # imprime menu de opções
	syscall
		
	li $v0,5       # pega o valor digitado do usuario e retorna em $v0
	syscall
	
	beq $v0,$zero,fimprograma   
	
	li  $t6,1
	beq $v0,$t6,funcaoHash
	
	li  $t6,2
	beq $v0,$t6,buscarHash
	
	li  $t6,3        
	beq $v0,$t6,removeHash	
	
	li  $t6,4
	la  $a0,hash    
	beq $v0,$t6,imprimeHash 

	j inicioprograma											
	
fimprograma:
	
	li $v0,10
	syscall


##############################################################################################
####### criaNo:  entrada: nenhuma 
#######          retorno: $v0 com o endereço do nó criado na heap    		  		
#######
####### retorna o endereço em $v0 para um novo nó de 12 bytes
#############################################################################################

criaNo:

	addi $sp,$sp,-8 #reserva espaço de 2 palavras para salvar o argumento e o endereço de retorno
	sw   $ra,0($sp)
	sw   $a0,4($sp)

	li   $a0,12     #cria uma nó com 12 bytes (ptrAnterior,value,ptrProximo) e devolve o endereço em $v0
	li   $v0,9
	syscall		
	
	lw   $ra,0($sp)
	lw   $a0,4($sp)
	
	addi $sp,$sp,8
	
	jr $ra	

	
##############################################################################################
######## criaLista  entrada: $a0 endereço da tabela hash
########            retorno: hash é populado com nós cabeças das listas dupl encadeadas
#######
####### Inicializa todas as posições da hash com um novo nó cabeça com o valor -1
#############################################################################################

criaLista:	
	
	addi $sp,$sp,-8
	sw   $ra,0($sp)
	sw   $a0,4($sp)

	addi $t7,$t7,-1  # valor inicializador do nó
	li   $t0,0 		 # contador // var i 
	lw   $t1,tam     # tamanho da tabela hash = 16
	
loop:
	
	beq  $t0,$t1,fimloop  # se contador = tamanho fim
	
	jal criaNo  		  # cria um nó e retorna o endereço do novo nó em $v0         
	
    sw   $t7,4($v0) 	  # inicializa o nó com o valor -1 na posição 2 do nó
	sw   $v0,($a0)  	  # hash[i] = endereço do no criado
	addi $a0,$a0,4        #  *hash++
	addi $t0,$t0,1        # i = i + 1
	j loop
	
fimloop:
	
	lw   $ra,0($sp)       # desempilha
	lw   $a0,4($sp)
	addi $sp,$sp,8
	jr   $ra
	

##############################################################################################
####### adicionaNoFim   entrada: $a0 é o endereço do cabeca da lista com a posição ja calculada
#######				 	         $a1 contem o numero a ser inserido 
#######					retorna: sem retorno 
#######              		  	
#######
####### Adiciona um nó no fim da lista. O $a0 ja vem calculado da função que o chamou 
####### anteriomente para saber qual posição da hash é a cabeça que precisamos
#############################################################################################


adicionaNoFim: 

	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	
	
	lw $t5,0($a0)   #$t5 recebe o endereço do nó cabeça
	lw $t9,4($t5)   #$t9 recebe o valor do nó que esta na posição 2

    # Como por decisão de projeto a lista é iniciada com -1 e como pela especificação do programa não tratamos numeros
	# negativos, comparamos o valor do nó com -1 para sabermos se ele é o primeiro da lista

	li $t8,-1
	beq $t9,$t8,adicionaPrimeiro

	#caso o nó cabeça ja exista, cria um nó, percorre até o fim da lista até o fim da lista e faz as ligações necessárias

loopbusca: 
    move $t7,$t5   			    # guarda a posicao do nó
	lw   $t5,8($t5)  		    # carrega em $t5 o valor da proximo no da lista
	beqz $t5,insereNo     # quando achar o nó que aponta pro nulo sabe que é o fim e insere	
	j    loopbusca


insereNo: 
	jal criaNo 					# $v0 contem o endereço do novo nó criado 
	sw $a1,4($v0) 				# insere o valor escolhido no novo nó
	
	# $v0 contem o endereço do novo nó
	# $t7 contem o endereço do ultimo nó 
	
	sw $v0,8($t7)  # seta o proximo do ultimo nó na cauda do novo nó
	sw $t7,0($v0)  # seta a cauda do novo nó para o começo do ultimo
	j fimAdicionaPrimeiro


adicionaPrimeiro:

	# não precisamos criar outro nó e então apenas mudamos o valor contido no nó cabeça
	
	sw $a1,4($t5)
	la $a0,sucesso
	li $v0,4
	syscall
	j fimAdicionaPrimeiro

fimAdicionaPrimeiro:

	lw   $ra,0($sp)
	lw   $a0,4($sp)
	lw   $a1,8($sp)
	addi $sp,$sp,12 
	jr   $ra
	
	

##############################################################################################
####### adicionaNoComeco   entrada: $a0 é o endereço do cabeca da lista com a posição ja calculada
#######				 	         $a1 contem o numero a ser inserido 
#######					   retorna: sem retorno 
#######
####### Adiciona um nó no começo da lista, ficando assim como o cabeça da lista
#############################################################################################


adicionaNoComeco: 
	addi $sp,$sp,-12 #reserva espaço de 2 palavras para salvar o argumento e o endereço de retorno
	sw   $ra,0($sp)
	sw   $a0,4($sp)
	sw   $a1,8($sp)

	lw   $t5,0($a0)
	lw   $t9,4($t5)  
	
	li   $t8,-1
	beq  $t8,$t9,primeiro

	jal  criaNo
	
	#$v0 endereço do novo nó
	
	sw $a1,4($v0)	#escreve o valor no novo nó
	
	lw $t5,0($a0)   #$t5 = mem[$a0]
	sw $t5,8($v0)   #salva para o novo ponteiro o rabo do ponteiro anterior
	sw $v0,0($t5) 
	sw $v0,($a0)    #aponta a cabeca para o novo vetor 
	la $a0,sucesso
	li $v0,4
	syscall
	j fimadiciona
	
primeiro:
	
	sw $a1,4($t5)
	la $a0,sucesso
	li $v0,4
	syscall

fimadiciona:

	lw   $ra,0($sp)
	lw   $a0,4($sp)
	lw   $a1,8($sp)
	addi $sp,$sp,12 
	jr   $ra
	

##############################################################################################
####### imprimeHash	  entrada: nenhuma
####### 			  retorno: nenhum
#######
####### Imprime toda a lista de hash na tela
#############################################################################################

imprimeHash:
	
	addi $sp,$sp,-8 #reserva espaço de 2 palavras para salvar o argumento e o endereço de retorno
	sw   $ra,0($sp)
	sw   $a0,4($sp)
		
	li   $t1,0 #contador
	lw   $t7,tam
	la   $t2,hash

imprimeLoop:
	beq  $t1,$t7,fimImprime
	lw   $a0,0($t2)
	jal  imprimeListaUnica
	addi $t1,$t1,1
	addi $t2,$t2,4
	la   $a0,pula          
	li   $v0,4              
    syscall               
	j imprimeLoop

fimImprime:	

	lw   $ra,0($sp)
	lw   $a0,4($sp)
	addi $sp,$sp,8

	jr $ra


##############################################################################################
####### imprimeListaUnica	  entrada: $a0 é a cabeça da lista
####### 			  		  retorno: nenhum
#######
####### Imprime apenas a linha do nó cabeça passado
#############################################################################################

imprimeListaUnica:

	addi $sp,$sp,-8		# reserva espaço de 2 palavras para salvar o argumento e o endereço de retorno
	sw   $ra,0($sp)
	sw   $a0,4($sp)
	
	move $s0,$a0

looplista:

	beqz $s0,fimlooplista	
	lw   $a0,4($s0)
	li   $v0,1
	syscall
	
	lw $s0,8($s0)
	la $a0,sep
	li $v0,4
	syscall
	j looplista

fimlooplista:
	
	lw   $ra,0($sp)
	lw   $a0,4($sp)
	addi $sp,$sp,8
	jr   $ra
 

##############################################################################################
####### funcaoHash	  @entrada: nenhum
####### 			  @retorno: nenhum
#######
#######  Essa função é a responsavel por calcular e adicionar um numero na tabela hash
#######  Utiliza da funcao buscarHash para pedir o valor ao usuario e verificar 
######   se o nó ja existe. Caso não exista executa o procedimento para inserir o nó 
#############################################################################################

funcaoHash: 

	addi $sp,$sp,-8
	sw   $a0,0($sp)
	sw   $ra,4($sp)
	
	jal  buscarHash
	
	# $v0 contem o retorno de buscarHash (1, 0 ou -1) 
	# $v1 contem o endereço do nó caso ele já existir
	

	# Esse trecho do código compara $t0 com o valor do retorno $v0 para saber se o numero
	# é ja existe ou é negativo. Caso o numero não exista ele começa o procedimento de 
	# inserir no
	
	li   $t0,1
	beq  $v0,$t0,jaexiste 
	
	li   $t0,-1
	beq  $v0,$t0,jaexiste
			
	div  $t3,$t4             
	mfhi $t5 				 #resto da divisao, ou seja, em qual posição do vetor hash inserir o numero

	mul  $t5,$t5,4
	la   $a0,hash
	add  $a0,$a0,$t5
	move $a1,$t3	         # $a1 contem o nuemro a ser inserido
	jal  adicionaNoFim
	j    fimuncaohash
		
jaexiste:

	la  $a0,fracasso
	li  $v0,4
	syscall
	jal fimuncaohash

fimuncaohash:	

	lw   $a0,0($sp)
	lw   $ra,4($sp)
	addi $sp,$sp,8
	
	jr $ra	

#########################################################################################
####### buscarHash   entrada:
#######				 retorna: $v0 igual 1 caso achou e 0 ao contrario 
#######              		  $v1 contém o endereço do nó que foi achado caso achou
#######
####### Essa função sempre é chamada na hora de inserir remover e buscar
####### Ela é que fica encarregada de perguntar o numero (decisao de projeto)
#########################################################################################

buscarHash:
	
	addi $sp,$sp,-8
	sw   $a0,0($sp)
	sw   $ra,4($sp)

	la   $a0,strinsere  #imprime a pergunta pelo numero a ser inserido
	li   $v0,4	
	syscall

	li $v0,5            # recebe o numero digitado pelo usuario e coloca em $v0
	syscall
	
	blt  $v0,$zero,nr_negativo  # se o nr digitado < 0 
		
						
	# o trecho a seguir do codigo pega o numero digitado(não negativo) e faz a conta para descobrir em qual posição ta tabela 
	# ele deve entrar. Depois multiplica por 4(tamanho da word) para calcular a posição dentro da hash. Em $t6 fica endereço
	# para o primeiro elemento ($t6) e em $s0 
	
	
	move $t3,$v0     # $t3 = $v0 contem o numero a ser buscado
	lw   $t4,tam     # $t4 = 16 (tamanho da tabela) 
	
	div  $t3,$t4     # divide o nr escolhido por 16 p/ o calculo da posição na tabela
	mfhi $t5         # resto da divisao, ou seja, em qual posição do vetor hash inserir o numero
	mul  $t5,$t5,4   # calcula a posicao certa dentro do vetor de ponteiros hash    hash=[$t5 * 4] 
	
	la   $t6,hash     # carrega em $t6 o endereço da tabela hash
	add  $t6,$t6,$t5  # aponta para a cabeça do ponteiro na posicao correta. $t6 é a cabeça
	lw   $s0,0($t6)   # carrega em $s0 a primeira endereço do primeiro elemento (cabeça)  $s0 = hash[$t6]

loopbuscaInsere:	

	# $t3 tem o numero escolhido
	# $s0 nunca vai ser nulo da primeira vez pois sempre existe o primeiro elemento criado com -1
	# o loop termina quando $s0 = null 

	beqz $s0,naoachou 
	lw   $a0,4($s0)   	# carrega em $a0 o valor do nó 
	beq  $a0,$t3,achou  # se o numero for igual ao valor previamente carregado em t3. o endereço do noh achado esta em $s0
	lw   $s0,8($s0)     # $s0 recebe o endereço do proximo nó da lista  ptr = ptr->proximo
	la   $a0,sep        
	li   $v0,4          # imprime o tracinho
	syscall
	j loopbuscaInsere

achou:
	 # $s0 contem o valor do endereço do nó que foi achado
	
	la $a0,achado   # imprime a string que achou o numero
	li $v0,4
	syscall
	li   $v0,1 		# setando o retorno $v0 = 1 (achou)
	move $v1,$s0    # setando o retorno $v1 = $s0 (endereço do nó achado)
	j fimbusca

naoachou:

	la $a0,nachado  # imprime que não achou o numero
	li $v0,4
	syscall
	li $v0,0        # setando o retorno $v0 = 0 (nao achou)
	j fimbusca

nr_negativo:

	la $a0,negativo # imprime que o numero é negativo
	li $v0,4
	syscall
	li $v0,-1       # seta o retorno de $v0 = -1 (numero negativo)
    j fimbusca

fimbusca:		
	
	# desempilha e retorna

	lw   $a0,0($sp)
	lw   $ra,4($sp)
	addi $sp,$sp,8
	jr   $ra	

		
	

##############################################################################################
####### removeHash:  entrada: nenhum 
#######          	 retorno: nenhum    		  		
#######
####### remove um nó da tabela hash
#############################################################################################


removeHash:	

	addi $sp,$sp,-8
	sw   $a0,0($sp)
	sw   $ra,4($sp)	
	
	jal buscarHash
	
	li $t7,-1
	beq $v0,$t7,nr_negativo_encontrado
	li $t7,0
	beq $v0,$zero,nr_nao_encontrado

	move $t0,$v1 #endereço do nó a ser deletado
	move $t1,$t6 #ponteiro da cabeça do vetor do nó a ser deletado calculado na funcao buscarHash (!! design)
	
	lw $t2,0($t6) # $t2 contem o endereço apontado pela cabeça do nó para compararar com $t0 (nó a ser deletado)
	
	beq $t0,$t2,noehcabeca
	
	#se nao for cabeca
	
	lw $t4,8($t0) #carrega em $t4 o endereço do proximo do no a ser delatado
	beq $t4,$zero,ehcauda
	
	#se nao for cauda e nem cabeça, ou seja do meio
	
	lw $t4,0($t0)
	lw $t5,8($t0)
	
	sw $t5,8($t4)
	sw $t4,0($t5)
	
	j fimremoveHash 

ehcauda:
	
	lw $t9,0($t0)
	sw $zero,8($t9)
	j fimremoveHash
		
	
noehcabeca:

	lw $t4,8($t0) 			   # endereço do proximo do nó a ser deletado

	beq $t4,$zero,cabecaeunico # branch caso ele for cabeça e o unico nó da lista	
	
	sw $t4,0($t6)
	sw $zero,0($t4)
	j fimremoveHash

cabecaeunico:
	li $t8,-1
 	sw $t8,4($t0) 			   # coloca o valor -1 de volta
 	j fimremoveHash
 	
nr_nao_encontrado:

	li $v0,4
	la $a0,nachado
	syscall
	j fimremoveHash

nr_negativo_encontrado:
	j fimremoveHash

fimremoveHash:	

	lw $a0,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8		
	jr $ra
