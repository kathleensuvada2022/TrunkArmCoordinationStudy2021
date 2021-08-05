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

// static void metriaComm(int sockInput, int numTags, double *out,double *out2)
static void metriaComm(int sockInput, int numTags, double *out)
{
    //Pass in the pointer to the UDP port --> don't need to have the InitUDP function in here
    
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
    
    
    //Note: I don't need to return all of the details of the original packet, only the data that I can store in my own structure, rather than trying to create a
    //structure in a structure that should be returned
    
    //Note2: I think that it makes sense to return a struct array for the timed data, and just a struct for single points
    //Return structure format --> AMA wants this in separate arrays again instead:
    //-int frameNumber;
    //-int frameTime_sec, frameTime_nsec;
    //-int irqSequenceNum;
    //-int irqTime_sec, irqTime_nsec;
    //-int markerSeriesNumber
    //-float markerWidth;
    //-float markerThickness;
    //-float brightness;
    //-float focusMetric;
    //-float blurRadius;
    //-float x,y,z;
    //-float qr,qx,qy,qz;
    
    mwSize i,j,count=0,count2=0;
    
    double y[][14]{1.0,2.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0};
//     double y2[][4]{4.0,5.0,6.0,7.0};
    
//     For loop iterates once because it's a one dimensional array with all of the tag values in it

//     for(j=0; j< (1+ (numTags*8)); j++){
//         mexPrintf("j: %d\n",j);
//         *(out+count) = 2* (*(y[0]+j));
//         mexPrintf("out[i]: %f\n", *(out+count));
//         count++;
//     }
    
    mexPrintf("version:     %03d\n", sPacket.version);
    mexPrintf("frameNumber: %08d\n", sPacket.frameNumber);
    mexPrintf("frameTime    %010ld.%09d\n", sPacket.frameTime_sec, sPacket.frameTime_nsec);
    mexPrintf("irqTime      %010ld.%09d\n", sPacket.irqTime_sec, sPacket.irqTime_nsec);

    mwSize jCounter = 0;

    for (int jMarker = 0; jMarker < 256; jMarker++){
        if (sPacket.aMarkers[jMarker].markerSeriesNumber > 0)
        {
            mexPrintf("  Marker[%04d:%03d] ", sPacket.aMarkers[jMarker].markerSeriesNumber, jMarker);
            mexPrintf("XYZ:[%+09.3f %+09.3f %+09.3f] ", sPacket.aMarkers[jMarker].x, sPacket.aMarkers[jMarker].y, sPacket.aMarkers[jMarker].z);
            mexPrintf("Q:[%+08.5f %+08.5f %+08.5f %+08.5f]\n", sPacket.aMarkers[jMarker].qr, sPacket.aMarkers[jMarker].qx, sPacket.aMarkers[jMarker].qy, sPacket.aMarkers[jMarker].qz);
            mexPrintf("\n");
            
            if (sPacket.aMarkers[jMarker].markerSeriesNumber == 1024)
            {
                mexPrintf("Found the pointer tool: %d\n",sPacket.aMarkers[jMarker].markerSeriesNumber);
                if (jCounter == 0)
                {
                    *(out + jCounter) = sPacket.frameNumber;
                    *(out + jCounter + 1) = sPacket.frameTime_sec;
                    *(out + jCounter + 2) = sPacket.frameTime_nsec;
                }
                
                *(out+ ((jCounter*8)+3)) = sPacket.aMarkers[jMarker].markerSeriesNumber;
                *(out+ ((jCounter*8)+4)) = sPacket.aMarkers[jMarker].x;
                *(out+ ((jCounter*8)+5)) = sPacket.aMarkers[jMarker].y;
                *(out+ ((jCounter*8)+6)) = sPacket.aMarkers[jMarker].z;
                *(out+ ((jCounter*8)+7)) = sPacket.aMarkers[jMarker].qx;
                *(out+ ((jCounter*8)+8)) = sPacket.aMarkers[jMarker].qy;
                *(out+ ((jCounter*8)+9)) = sPacket.aMarkers[jMarker].qz;
                *(out+ ((jCounter*8)+10)) = sPacket.aMarkers[jMarker].qr;
                
                jCounter++;
                mexPrintf("this is jCounter: %d\n",jCounter);
            }        
        }
    }
    
    mexPrintf("end test :) \n");
    
//     closesocket(_socket);
    WSACleanup();
    
}

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *outMatrix, *outMatrix2;
    
    int sockInput = mxGetScalar(prhs[0]);
//     int sockInput = (int)*mxGetPr(prhs[0]);
    int numTags = (int)*mxGetPr(prhs[1]);
    
    int mrows = 1;
    int ncols = 11; //Number of tags is 1, which means 8 columns of data plus 3 for the header
    int ncols2 = 4;
    
    mexPrintf("input port: %d\n",sockInput);
//     mexPrintf("_socket: %i\n",_socket);
//     mexPrintf("_socket: %g\n",double(_socket));
//     mexPrintf("_socket: %g\n",sockInput);
    
    mexPrintf("number of tags: %d\n",numTags);
    /* Check for proper number of arguments */
    
    if (nrhs != 2) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
                "MEXCPP requires two input arguments.");
    } else if (nlhs > 2) {
//     } else if (nlhs > 3) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargout",
                "MEXCPP has one output arguments.");
    }
    
    plhs[0] = mxCreateDoubleMatrix( (mwSize)mrows, (mwSize)ncols, mxREAL); //This works!
    plhs[1] = mxCreateDoubleMatrix( (mwSize)mrows, (mwSize)ncols2, mxREAL); //This works!
    
    outMatrix = mxGetPr(plhs[0]);
//     outMatrix2 = mxGetPr(plhs[1]);
    
//     metriaComm(sockInput,numTags,outMatrix,outMatrix2);
    metriaComm(sockInput,numTags,outMatrix);
    
    return;
}