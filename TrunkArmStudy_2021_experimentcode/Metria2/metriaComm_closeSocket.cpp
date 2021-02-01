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

//Define the packet structure that will have to be interpreted when we receive data from the Metria
typedef struct UDPPacketV101_s {
    int  version;
    char hostname[64];
    int  frameNumber;
    int  frameTime_sec, frameTime_nsec;
    int  irqSequenceNum;
    int  irqTime_sec, irqTime_nsec;
    
    struct {
        int   markerSeriesNumber;
        float markerWidth;
        float markerThickness;
        float brightness;
        float focusMetric;
        float blurRadius;
        float x, y, z;
        float qr, qx, qy, qz;
        int   flags;
    } aMarkers[256];
    
    double aVoltages[16];
} UDPPacketV101_t;

sockaddr_in     server_addr;
UDPPacketV101_t sPacket;
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

static void metriaComm(int sockInput, int *out)
{
    int len;
    int _socket;
    
    _socket = sockInput;
    
    mexPrintf("_socket: %d\n",_socket);
    
    WSADATA wsaData;
    WSAStartup(0x0202, &wsaData);
    
    ProcessSocketFunction(len = recv(_socket, (char *)&sPacket, sizeof(UDPPacketV101_t), 0), "recv");
    
    if (len == sizeof(UDPPacketV101_t) && sPacket.version == 101)
        mexPrintf("Passed the first check:)\n");
    
    mexPrintf("version:     %03d\n", sPacket.version);
    mexPrintf("frameNumber: %08d\n", sPacket.frameNumber);
    mexPrintf("frameTime    %010ld.%09d\n", sPacket.frameTime_sec, sPacket.frameTime_nsec);
    mexPrintf("irqTime      %010ld.%09d\n", sPacket.irqTime_sec, sPacket.irqTime_nsec);


    mexPrintf("end test :) \n");    
    closesocket(_socket);
    WSACleanup(); 
}

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *outMatrix, *outMatrix2;
    int sockInput = mxGetScalar(prhs[0]);    
    int *outVal;
//     int port = (int)*mxGetPr(prhs[0]);
    int mrows = 1;
    int ncols = 1;
    
    mexPrintf("input port: %d\n",sockInput);

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
    
    metriaComm(sockInput,outVal);
    
    mexPrintf("resulting port value: %d\n",*outVal);

    return;
}
