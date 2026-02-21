#include <stdio.h>
#include <stdlib.h>

#define	NES_HEADER_SIZE		16

//-----------------------------------------------------------------------------
void
usage( char * sProgName)
{
	printf( "\n%s ver 1.0 / Extract GAME0-3 from the Family Basic V3 ROM.\n\n", sProgName ) ;
	printf ( " usege:\n" ) ;
	printf( "\t%s filename \n\n", sProgName ) ;

	return ;
}

//-----------------------------------------------------------------------------
int
main( int argv, char **argc )
{
	FILE		*fpr, *fpw  ;
	int		i, j ;
	unsigned char	d[0x10000], *inFileName ;
	char		*bs = "BS" ;
	size_t		rCnt ;

	//----------------------------------------------------------------------
	if ( 2 != argv ) {
		usage( argc[0] ) ;

		return 0 ;
	}

	//----------------------------------------------------------------------
	inFileName = argc[1] ;
	fpr = fopen( inFileName, "r" ) ;
	if (NULL != fpr) {
		rCnt = fread( d, 1, sizeof(d), fpr ) ;
		printf ( "File:%s: $%4X bytes readed\n", inFileName, rCnt ) ;
	} else {
		printf ( "\"%s\n cannot open\n", inFileName ) ;
		return 1 ;
	}
	fclose ( fpr ) ;

	//----------------------------------------------------------------------
	unsigned short	usEnd[3], usAddr[3] ;
	int	iBufPtr ;
	char	sOutFileName[10] ;
	unsigned char	ucHeader[6] = { 'B', 'S', 0x06, 0x60, 0, 0 };
	unsigned char	ucData ;
	for ( i = 0 ; i < 4 ; i ++ ) {
		iBufPtr = NES_HEADER_SIZE + 3 + i*2 ; 
		usEnd[i] = d[iBufPtr] + (d[iBufPtr+1] * 256) ;
		ucHeader[4] = d[iBufPtr] ;
		ucHeader[5] = d[iBufPtr+1] ;

		usAddr[i] = d[iBufPtr + 8] + (d[iBufPtr + 9] * 256) ;
		sprintf( sOutFileName, "GAME%02dBAS.prg", i ) ;
		printf ( "%s: %04X,%04X", sOutFileName, usAddr[i], usEnd[i] - 0x6000 ) ;
		fpw = fopen( sOutFileName, "w" ) ;
		if ( NULL == fpw )
			return 1 ;

		//--- File header ---------------------------------------------
		fwrite( ucHeader, 1, sizeof(ucHeader), fpw ) ;

		//--- internal BASIC program ----------------------------------
		for ( j = 0 ; j < usEnd[i] - 0x6000 ; j++ )
		{
			ucData = d[usAddr[i] - 0x8000 + NES_HEADER_SIZE + j] ; 
			fwrite( &ucData, 1, 1, fpw ) ;
			//if ( !(j % 16) )
				//printf ( "\n%04X:", usAddr[i] + j) ;
			//printf ( "%02X ", ucData ) ; 
		}
		//printf ( "\n" ) ;

		//--- padding -------------------------------------------------
		printf ( ",%04x\n", 0x1000 - (usEnd[i] - 0x6000) - 6 ) ;
		for ( j = 0 ; j < 0x1000 - (usEnd[i] - 0x6000) - 6 ; j++ )
			fputc ( 0 ,fpw ) ;

		fclose ( fpw ) ;
	}

	return	0;
}
