#include <stdio.h>
#include <stdlib.h>


void exemplo1(int num) { 

	if (num < 5) { 

		printf("%d ",num);
		exemplo1(num +1);
	}
}

void exemplo2(int num) { 

	if (num < 5) { 

		exemplo2(num +1);
		printf("%d ",num);
	}
}

int soma(int n)
{
   if (n > 0)
      return n + soma(n - 1);
   else
      return 0;
}


int main () { 

	exemplo1(0);
	printf("\n");
    exemplo2(0);
	
    int x = 0;

    x = soma(5);
    printf("\n%d\n",x);

	return 0;

}
