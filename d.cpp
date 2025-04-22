#include <stdlib.h>
#include <stdio.h>

double rFunc( int i, float f, int j, double d, int k, double e, int l, double g, int m, double h)
{
	return i+f+j+d+k+e+l+g+m+h;
}

int main( void )
{					//From RBP:
	int i=1;		//-56
	float f=1.0;	//-52
	int j= 2;		//-48
	double d = 2.0;	//-32
	int k=3;		//-44
	double e=3.0;	//-24
	int l=4;		//-40
	double g=4.0;	//-16
	int m=5;		//-36
	double h=5.0;	//-8
	
	printf
	( 
		"Result=%7e\n",
		rFunc
		( 
			i,	// movl	-56(%rbp), %edi
			f,  // movss -52(%rbp), %xmm0	;Actually, a long sequence, but... 
			j,	// movl	-48(%rbp), %esi 
			d,  // movsd -32(%rbp), %xmm1 
			k,	// movl	-44(%rbp), %edx 
			e,	// movsd -24(%rbp), %xmm2 
			l,	// movl	-40(%rbp), %ecx 
			g,	// movsd -16(%rbp), %xmm3 
			m,	// movl	-36(%rbp), %r8d 
			h	// movsd -8(%rbp), %xmm4 
		)
	);
}
