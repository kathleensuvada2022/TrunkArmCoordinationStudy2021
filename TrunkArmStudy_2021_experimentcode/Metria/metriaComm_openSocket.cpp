/*==========================================================
 * metriaComm_oldWay.cpp
 *
 * This .cpp file is a conversion from the new mex format to be compatible
 * with the old version of Mex in Matlab
 *
 * Communicates with Metria system to provide tag position and time data
 *
 * Usage : from MATLAB
 *         --> Input: port number to connect with
 *         --> Outputs: time and position data arrays for all tags
 *         >> outMatrix = metriaComm(portNumber)
 * Steps for the 1st function:
 *  -Open a port using the port number
 *
 * Steps for the 2nd function:
 *  -Use the open port to grab a data point from the Metria everytime the system is called
 *  -Function should call the ProcessSocketFunction, which takes in:
 *      -The socket handle
 *      -The packet handle
 *      -The number of bytes of the struct
 *      -The receive command
 *
 *========================================================*/

//Mex api .h files
#include "mex.h"
#include "matrix.h"
// #include "mexAdapter.hpp"
//.h files needed for my C++ code
#include <errno.h>
//#include <stdio.h>
//#include <stdlib.h>
#include <string.h>
#include <io.h>
//#include "stdafx.h"
#include <winsock2.h>
#include <WS2tcpip.h>

using namespace std;

void _main();

sockaddr_in     server_addr;
int _socket;

void ProcessSocketFunction(int result, const char *function) {
    char temp[256];
    
    if (result == SOCKET_ERROR) {
        FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, GetLastError(), 0, temp, 256, NULL);
        
        mexPrintf("Error %ld (%s) calling %s:\n  ", GetLastError(), temp, function);
        
        if (GetLastError() == 10048)
            mexPrintf("UDP port in use\n");
            mexPrintf("Socket error\n");
    }
}

static void metriaComm(int port, int *out)
{
    //InitUDP BEGINS
    sockaddr_in server_addr;
    char hostname[NI_MAXHOST];
    char servInfo[NI_MAXSERV]; //Added to work with 2014 Matlab
    DWORD errorVal;
    WSADATA wsaData;
    WSAStartup(0x0202, &wsaData);
    
    ProcessSocketFunction(_socket = socket(AF_INET, SOCK_DGRAM, 0), "socket");
    
    // Bind the socket to the supplied port number
    memset(&server_addr, 0, sizeof(struct sockaddr_in));
    server_addr.sin_family = AF_INET; //this was for inetpton now for getnameinfo
    server_addr.sin_port = htons(port); //this was for inetpton now for getnameinfo
    server_addr.sin_addr.s_addr = inet_addr("192.168.2.30");  // look for traffic on a specific interface and see if it still works --> it does!
    
    errorVal = getnameinfo((struct sockaddr *) &server_addr,sizeof(struct sockaddr),hostname,NI_MAXHOST,servInfo,NI_MAXSERV, NI_NUMERICSERV);

    if (errorVal != 0) {
        mexPrintf("getnameinfo failed with error: %ld \n  ", GetLastError());
    } else {
        mexPrintf("getnameinfo returned hostname =: %s \n  ", hostname);
    }
    
    ProcessSocketFunction(bind(_socket, (struct sockaddr *) &server_addr, sizeof(struct sockaddr)), "bind");
    mexPrintf("After processsocketfunction\n  ");
    
    //InitUDP ENDS   

    *out = _socket;

    mexPrintf("resulting port value _socket: %d\n",_socket);    
    mexPrintf("resulting port value out: %d\n",out);

    mexPrintf("end test :) \n");    
//     closesocket(_socket);
//     WSACleanup();
    
}

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *outMatrix, *outMatrix2;
    int *outVal;
    int port = (int)*mxGetPr(prhs[0]);
    int mrows = 1;
    int ncols = 1;
    
    /* Check for proper number of arguments */
    
    if (nrhs != 1) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
                "MEXCPP requires one input argument.");
    } else if (nlhs > 1) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargout",
                "MEXCPP has one output arguments.");
    }
    
    plhs[0] = mxCreateNumericMatrix( (mwSize)mrows, (mwSize)ncols, mxINT16_CLASS,mxREAL); //This works!

    outVal = (int*)mxGetPr(plhs[0]);
    
    metriaComm(port,outVal);
    
    mexPrintf("resulting port value: %d\n",*outVal);

    return;
}
