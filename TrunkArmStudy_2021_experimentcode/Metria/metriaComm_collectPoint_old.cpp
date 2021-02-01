/*==========================================================
 * metriaComm_oldWay.cpp
 *
 * This .cpp file is a conversion from the new mex format to be compatible
 * with the old version of Mex in Matlab
 *
 * Communicates with Metria system to provide marker position and time data
 *
 * Usage : from MATLAB
 *         --> Input: port number to connect with
 *         --> Outputs: time and position data arrays for all markers
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

/*==========================================================
 * Nov 18, 2020 - Hendrik
 * - Outputted hostname[64] first before anything else in MetriaComm
 * - Changed all usages of the word "Tag" with "Marker" to avoid confusion
 * - Returned the Marker ID (i.e., jmarker counter value) as well in Metria Comm
 *========================================================*/
//TODO: Get rid of most if not all the xprintf lines
//TODO: The current format creates a structure with arrays for details of 256 possible markers and then iterates through the arrays to check whether they've been populated by the Metria itself. But AMA says that the Metria populates the structure such that the ID number is equal to its positition in the Array (i.e Array[4] is the Metria marker with 4 on it). In this case, it makes more sense to pass an array with the expected marker IDs and save us having to iterate across 256 things every time). Maybe replace numMarkers

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
//I believe Sabeen worked off of the V100 code shown in the Metria User Manual on page 36, or section
//6.6 in the Appendices.
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
        float brightness;  //V101 specific
        float focusMetric; //V101 specific
        float blurRadius;  //V101 specific
        float x, y, z;
        float qr, qx, qy, qz;
        int   flags;       //this was an unsigned int in V100
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
        
        //mexPrintf("Error %ld (%s) calling %s:\n  ", GetLastError(), temp, function);
        
        //if (GetLastError() == 10048)
            //mexPrintf("UDP port in use\n");
        //mexPrintf("Socket error\n");
    }
}

// static void metriaComm(int sockInput, int numMarkers, double *out,double *out2)
static void metriaComm(int sockInput, int numMarkers, double *out, double *out2)
{
    //Pass in the pointer to the UDP port --> don't need to have the InitUDP function in here
    
    int len;
    int _socket;
    
    _socket = sockInput;
    
    //mexPrintf("_socket: %d\n",_socket);
    
    WSADATA wsaData;
    WSAStartup(0x0202, &wsaData);
   
    ProcessSocketFunction(len = recv(_socket, (char *)&sPacket, sizeof(UDPPacketV101_t), 0), "recv");
    
    //Hendrik: I don't know the point/thrust of the following block of code, comments, mexPrints, w/e does ANYTHING
    //TODO: Try deleting from here
    //if (len == sizeof(UDPPacketV101_t) && sPacket.version == 101)
        //mexPrintf("Passed the first check:)\n");
    
//     mexPrintf("version:     %03d\n", sPacket.version);
//     mexPrintf("frameNumber: %08d\n", sPacket.frameNumber);
//     mexPrintf("frameTime    %010ld.%09d\n", sPacket.frameTime_sec, sPacket.frameTime_nsec);
//     mexPrintf("irqTime      %010ld.%09d\n", sPacket.irqTime_sec, sPacket.irqTime_nsec);
//     
//     
//     //Note: I don't need to return all of the details of the original packet, only the data that I can store in my own structure, rather than trying to create a
//     //structure in a structure that should be returned
//     
//     //Note2: I think that it makes sense to return a struct array for the timed data, and just a struct for single points
//     //Return structure format --> AMA wants this in separate arrays again instead:
//     //-int frameNumber;
//     //-int frameTime_sec, frameTime_nsec;
//     //-int irqSequenceNum;
//     //-int irqTime_sec, irqTime_nsec;
//     //-int markerSeriesNumber
//     //-float markerWidth;
//     //-float markerThickness;
//     //-float brightness;
//     //-float focusMetric;
//     //-float blurRadius;
//     //-float x,y,z;
//     //-float qr,qx,qy,qz;
//     
//     mwSize i,j,count=0,count2=0;
//     
//     double y[][14]{1.0,2.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0};
// //     double y2[][4]{4.0,5.0,6.0,7.0};
//     
// //     For loop iterates once because it's a one dimensional array with all of the marker values in it
// 
// //     for(j=0; j< (1+ (numMarkers*8)); j++){
// //         mexPrintf("j: %d\n",j);
// //         *(out+count) = 2* (*(y[0]+j));
// //         mexPrintf("out[i]: %f\n", *(out+count));
// //         count++;
// //     }
//     
//     mexPrintf("version:     %03d\n", sPacket.version);
//     mexPrintf("frameNumber: %08d\n", sPacket.frameNumber);
//     mexPrintf("frameTime    %010ld.%09d\n", sPacket.frameTime_sec, sPacket.frameTime_nsec);
//     mexPrintf("irqTime      %010ld.%09d\n", sPacket.irqTime_sec, sPacket.irqTime_nsec);
//     //TODO: To here and see if anything even happens. This code block looks useless is all
//     
    
    mwSize jCounter = 0;
    char firstRead[64];
    memset(firstRead, '\0', sizeof(firstRead));
    strncpy(firstRead,sPacket.hostname,10);
    firstRead[10] = 0; // null terminate destination
    //mexPrintf("Hostname:     %s\n", sPacket.hostname);
    for (int jMarker = 0; jMarker < 256; jMarker++){
        if (sPacket.aMarkers[jMarker].markerSeriesNumber > 0)
        {
            //TODO: Comment these Printf lines out once everything's working
            //mexPrintf("  Marker[%04d:%03d] ", sPacket.aMarkers[jMarker].markerSeriesNumber, jMarker);
            //mexPrintf("XYZ:[%+09.3f %+09.3f %+09.3f] ", sPacket.aMarkers[jMarker].x, sPacket.aMarkers[jMarker].y, sPacket.aMarkers[jMarker].z);
            //mexPrintf("Q:[%+08.5f %+08.5f %+08.5f %+08.5f]\n", sPacket.aMarkers[jMarker].qr, sPacket.aMarkers[jMarker].qx, sPacket.aMarkers[jMarker].qy, sPacket.aMarkers[jMarker].qz);
            //mexPrintf("\n");
            
            //mexPrintf("this is jCounter: %d\n",jCounter); //TODO: Comment this out once everything's working
            if (jCounter == 0)
            {
                *(out + jCounter + 0) = sPacket.frameNumber; //comment out later
                *(out + jCounter + 1) = sPacket.frameTime_sec; //comment out later
                *(out + jCounter + 2) = sPacket.frameTime_nsec; //comment out later
            }
            *(out+ ((jCounter*8)+3)) = jMarker;
//            *(out+ ((jCounter*8)+4)) = sPacket.aMarkers[jMarker].markerSeriesNumber; //comment out later
            *(out+ ((jCounter*8)+4)) = sPacket.aMarkers[jMarker].x;
            *(out+ ((jCounter*8)+5)) = sPacket.aMarkers[jMarker].y;
            *(out+ ((jCounter*8)+6)) = sPacket.aMarkers[jMarker].z;
            *(out+ ((jCounter*8)+7)) = sPacket.aMarkers[jMarker].qx;
            *(out+ ((jCounter*8)+8)) = sPacket.aMarkers[jMarker].qy;
            *(out+ ((jCounter*8)+9)) = sPacket.aMarkers[jMarker].qz;
            *(out+ ((jCounter*8)+10)) = sPacket.aMarkers[jMarker].qr;
            jCounter++;
            
            //TODO: Why is she using both jCounter and jMarker? Aren't they the same dang thing?
        }        
    }
    
    //TEMPTEMPTEMP
    bool newCamera = false;
    while (newCamera == false){
        ProcessSocketFunction(len = recv(_socket, (char *)&sPacket, sizeof(UDPPacketV101_t), 0), "recv");
        char newRead[64];
        memset(newRead, '\0', sizeof(newRead));
        strncpy(newRead,sPacket.hostname,10);
        newRead[10] = 0; // null terminate destination
        if (strcmp(firstRead,newRead)!=0) {   
          newCamera = true;
//          mexPrintf("FirstRead:     %s  newRead:  %s   They're different", firstRead, sPacket.hostname);
        }
//        mexPrintf("FirstRead:     %s  newRead:  %s", firstRead,newRead);
    }
    

    //if (len == sizeof(UDPPacketV101_t) && sPacket.version == 101)
        //mexPrintf("Passed the first check:)\n");
    
    jCounter=0;
    //mexPrintf("Hostname:     %s\n", sPacket.hostname);
    for (int jMarker = 0; jMarker < 256; jMarker++){
        if (sPacket.aMarkers[jMarker].markerSeriesNumber > 0)
        {
            //TODO: Comment these Printf lines out once everything's working
            //mexPrintf("  Marker[%04d:%03d] ", sPacket.aMarkers[jMarker].markerSeriesNumber, jMarker);
            //mexPrintf("XYZ:[%+09.3f %+09.3f %+09.3f] ", sPacket.aMarkers[jMarker].x, sPacket.aMarkers[jMarker].y, sPacket.aMarkers[jMarker].z);
            //mexPrintf("Q:[%+08.5f %+08.5f %+08.5f %+08.5f]\n", sPacket.aMarkers[jMarker].qr, sPacket.aMarkers[jMarker].qx, sPacket.aMarkers[jMarker].qy, sPacket.aMarkers[jMarker].qz);
            //mexPrintf("\n");
            
            //mexPrintf("this is jCounter: %d\n",jCounter); //TODO: Comment this out once everything's working
            if (jCounter == 0)
            {
                *(out2 + jCounter + 0) = sPacket.frameNumber; //comment out later
                *(out2 + jCounter + 1) = sPacket.frameTime_sec; //comment out later
                *(out2 + jCounter + 2) = sPacket.frameTime_nsec; //comment out later
            }
            *(out2+ ((jCounter*8)+3)) = jMarker;
//            *(out+ ((jCounter*8)+4)) = sPacket.aMarkers[jMarker].markerSeriesNumber; //comment out later
            *(out2+ ((jCounter*8)+4)) = sPacket.aMarkers[jMarker].x;
            *(out2+ ((jCounter*8)+5)) = sPacket.aMarkers[jMarker].y;
            *(out2+ ((jCounter*8)+6)) = sPacket.aMarkers[jMarker].z;
            *(out2+ ((jCounter*8)+7)) = sPacket.aMarkers[jMarker].qx;
            *(out2+ ((jCounter*8)+8)) = sPacket.aMarkers[jMarker].qy;
            *(out2+ ((jCounter*8)+9)) = sPacket.aMarkers[jMarker].qz;
            *(out2+ ((jCounter*8)+10)) = sPacket.aMarkers[jMarker].qr;
            jCounter++;
            
            //TODO: Why is she using both jCounter and jMarker? Aren't they the same dang thing?
        }        
    }
    //Temptemptemp
    
    //mexPrintf("end test :) \n"); //TODO: Comment this out once everything's working
    
//     closesocket(_socket);
    WSACleanup();
    
}

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *outMatrix, *outMatrix2;
    
    int sockInput = mxGetScalar(prhs[0]);
//     int sockInput = (int)*mxGetPr(prhs[0]);
    int numMarkers = (int)*mxGetPr(prhs[1]);
    
    int mrows = 1;
    int ncols = 3+ (numMarkers*8);
    int ncols2 = 4;
    
    //mexPrintf("input port: %d\n",sockInput);
//     mexPrintf("_socket: %i\n",_socket);
//     mexPrintf("_socket: %g\n",double(_socket));
//     mexPrintf("_socket: %g\n",sockInput);
    
    //mexPrintf("number of markers: %d\n",numMarkers);
    /* Check for proper number of arguments */
    
    if (nrhs != 2) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
                "MEXCPP requires two input arguments.");
    } else if (nlhs > 3) {
//     } else if (nlhs > 3) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargout",
                "MEXCPP has two output arguments.");
    }
    
    plhs[0] = mxCreateDoubleMatrix( (mwSize)mrows, (mwSize)ncols, mxREAL); //This works!
    plhs[1] = mxCreateDoubleMatrix( (mwSize)mrows, (mwSize)ncols, mxREAL); //This works!
    plhs[2] = mxCreateDoubleMatrix( (mwSize)mrows, (mwSize)ncols2, mxREAL); //This works!
    
    outMatrix = mxGetPr(plhs[0]);
    outMatrix2 = mxGetPr(plhs[1]);
    
    metriaComm(sockInput,numMarkers,outMatrix,outMatrix2);
   // metriaComm(sockInput,numMarkers,outMatrix);
    
    return;
}
