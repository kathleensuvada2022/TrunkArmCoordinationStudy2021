#include "stdafx.h"
#include "stdio.h"
#include "string.h"
#include "stdlib.h"

// HapticAPI
//extern "C"  __declspec(dllimport) void _stdcall Out32( short PortAddress, short value );

//typedef void _stdcall (*oupfuncPtr)(short portaddr, short datum);

void _stdcall Out32(short PortAddress, short data);

//extern __declspec(dllimport) void __stdcall Out32(short PortAddress, short data);
