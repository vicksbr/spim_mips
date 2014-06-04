#include <stdio.h>
#include <stdlib.h>

void print_array(int *array,int tam) {

	int i = 0;
	while (i < tam) 
		printf("%d ",array[i++]);

	printf("\n");
}


void merge(int *vetor,int tamanho) { 

	int temp[tamanho];

	int contador=0;
	int i = 0;
	int meio = tamanho/2;
	int j = meio; 


	while (i < meio && j < tamanho) { 

		if (vetor[i] <= vetor[j]) {

			temp[contador] = vetor[i];
			i++;
		}
		
		else {  

			temp[contador] = vetor[j];
			j++;
		}
		
		contador++;
		
	}	

	if (i == meio) { 

		while(j < tamanho)
			temp[contador++] = vetor[j++];

	}

	else { 
		while(i < meio)
			temp[contador++] = vetor[i++];

	} 

	for (i = 0; i < tamanho; i++)
		vetor[i] = temp[i];
}


void mergeSort(int vetor[], int tamanho) {
  
  int meio;
 
  if (tamanho > 1) {
	  meio = tamanho / 2;
	  mergeSort(vetor, meio);
	  mergeSort(vetor + meio, tamanho - meio);
	  merge(vetor, tamanho);
 	  print_array(vetor,tamanho);
  	  printf("\n");
  }
}

int main () { 

	int vetor[8] = { 13, 23, 2, 17, 5, 11, 19, 3 };
	mergeSort(vetor,8);
	print_array(vetor,8);	
	return 0;

}