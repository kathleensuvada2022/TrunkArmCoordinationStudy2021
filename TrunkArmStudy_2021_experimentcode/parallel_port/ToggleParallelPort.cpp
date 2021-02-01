/*
Send a value to pin 1 on the parallel port

You can compile this file using "mex ToggleParallelPort.cpp inpout32.lib"
*/

#include "mex.h"
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <conio.h>

#define PPORT_BASE ((short) 0x3030)

typedef short (_stdcall *inpfuncPtr)(short portaddr);
typedef void (_stdcall *oupfuncPtr)(short portaddr, short datum);

// After successful initialization, these 2 variables will contain function pointers.
inpfuncPtr inp32fp;
oupfuncPtr oup32fp;

// Wrapper functions for the function pointers - call these functions to perform I/O.
short  Inp32 (short portaddr)
{
    return (inp32fp)(portaddr);
}
     
void  Out32 (short portaddr, short datum)
{
    (oup32fp)(portaddr,datum);
}


void ToggleParallelPort( short value )
{
    HINSTANCE hLib;

     // Load the library 
     hLib = LoadLibrary("inpout32.dll");
     if (hLib == NULL) {
          fprintf(stderr,"LoadLibrary Failed.\n");
          return;
     }

     // get the address of the function(s)

     oup32fp = (oupfuncPtr) GetProcAddress(hLib, "Out32");
     if (oup32fp == NULL) {
          fprintf(stderr,"GetProcAddress for Oup32 Failed.\n");
          return;
     }
     
     /*
     //TESTING: for input 
     inp32fp = (inpfuncPtr) GetProcAddress(hLib, "Inp32");
     if (inp32fp == NULL) {
          fprintf(stderr,"GetProcAddress for Inp32 Failed.\n");
          return;
     }
     */
     
     //  Write the data register 
     short i;
     i=PPORT_BASE;
     Out32(i,value);

     //printf("Port write to 0x%X, datum=0x%X\n" ,i ,value);

     // TESTING: for input
     // And read back to verify 
     //value = Inp32(i);
     //printf("Port read (%04X)= %04X\n",i,value);
     
     // finished - unload library and exit
     FreeLibrary(hLib);
}


void mexFunction(int nlhs, mxArray *plhs[ ],int nrhs, const mxArray *prhs[ ]) 
{
	short value; 
    
    // check: two input and one output arguments
	if ( nrhs !=1 ) { mexErrMsgTxt( "Must have one input argument" );	}
	if ( nlhs !=0 ) { mexErrMsgTxt( "Must have no output arguments" );	}
	
	// store inputs
	value = mxGetScalar( prhs[0] );
	
    //call routine
	ToggleParallelPort(value);
}
