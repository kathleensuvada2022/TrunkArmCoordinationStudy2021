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

/****************************/
// Commenting out the MyData portion for now because it seems like this is 
// an unnecessary structure to follow in the example
// class MyData {
//     // Pointer to MATLAB engine to call fprintf
//     std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();
//     ArrayFactory factory;
//     
//     // Create an output stream
//     std::ostringstream stream;
//     
// public:
//   void display();
//   void set_data(double v1, double v2);
//   MyData(double v1 = 0, double v2 = 0);
//   ~MyData() { }
// private:
//   double val1, val2;
// };
// 
// MyData::MyData(double v1, double v2)
// {
//   val1 = v1;
//   val2 = v2;
// }
// 
// void MyData::display()
// {
// #ifdef _WIN32
// 	mexPrintf("Value1 = %g\n", val1);
// 	mexPrintf("Value2 = %g\n\n", val2);
// #else
//   cout << "Value1 = " << val1 << "\n";
//   cout << "Value2 = " << val2 << "\n\n";
// #endif
// }
// 
// void MyData::set_data(double v1, double v2) { val1 = v1; val2 = v2; }

/*********************/

void ProcessSocketFunction(int result, const char *function) {
    char temp[256];

    if (result == SOCKET_ERROR) {
        FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, GetLastError(), 0, temp, 256, NULL);

        mexPrintf("Error %ld (%s) calling %s:\n  ", GetLastError(), temp, function);
//         stream << "Error in process socket function! " << std::endl;
//         displayOnMATLAB(stream);

        if (GetLastError() == 10048)
//             stream << "UDP port in use!" << std::endl;
//             displayOnMATLAB(stream);
            mexPrintf("UDP port in use\n");

//         stream << "Socket error: " << std::endl;
//         displayOnMATLAB(stream);
            mexPrintf("Socket error\n");
//             exit(0);
    }
}

static void metriaComm(int port2, int choice)
{
    mexPrintf("port2 is: %d\n",port2);
    mexPrintf("choice is: %d\n",choice);

    //InitUDP BEGINS
    sockaddr_in server_addr;
    char hostname[NI_MAXHOST];
    char servInfo[NI_MAXSERV];
    u_short port =  6111;
    DWORD errorVal;
    WSADATA wsaData;
    WSAStartup(0x0202, &wsaData);
        
    ProcessSocketFunction(_socket = socket(AF_INET, SOCK_DGRAM, 0), "socket");

    // Bind the socket to the supplied port number
    memset(&server_addr, 0, sizeof(struct sockaddr_in));
    server_addr.sin_family = AF_INET; //this was for inetpton now for getnameinfo
    server_addr.sin_port = htons(port2); //this was for inetpton now for getnameinfo
//     server_addr.sin_addr.s_addr = inet_addr(INADDR_ANY);
//     server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");  // look for traffic on a specific interface and see if it still works --> it does!
    server_addr.sin_addr.s_addr = inet_addr("192.168.2.30");  // look for traffic on a specific interface and see if it still works --> it does!
    errorVal = getnameinfo((struct sockaddr *) &server_addr,sizeof(struct sockaddr),hostname,NI_MAXHOST,servInfo,NI_MAXSERV, NI_NUMERICSERV);

    if (errorVal != 0) {
        mexPrintf("getnameinfo failed with error: %ld \n  ", GetLastError());
//         stream << "getnameinfo failed with error: " << WSAGetLastError() << std::endl;
//         displayOnMATLAB(stream);
    } else {
        mexPrintf("getnameinfo returned hostname =: %s \n  ", hostname);
//         stream << "getnameinfo returned hostname = " << hostname << std::endl;
//         displayOnMATLAB(stream);
    }

    ProcessSocketFunction(bind(_socket, (struct sockaddr *) &server_addr, sizeof(struct sockaddr)), "bind");
    mexPrintf("After processsocketfunction\n  ");
//     stream << "After processsocketfunction" << std::endl;
//     displayOnMATLAB(stream);
    //InitUDP ENDS
    
    int len;

    ProcessSocketFunction(len = recv(_socket, (char *)&sPacket, sizeof(UDPPacketV101_t), 0), "recv");

    if (len == sizeof(UDPPacketV101_t) && sPacket.version == 101)
        mexPrintf("Passed the first check:)\n");
//         stream << "Passed the first check :)" << std::endl;
//         displayOnMATLAB(stream);

//     stream << "version: " << sPacket.version << std::endl;
//     displayOnMATLAB(stream);
//     stream << "frameNumber: " << sPacket.frameNumber << std::endl;
//     displayOnMATLAB(stream);
//     stream << "frameTime: " << sPacket.frameTime_sec << std::endl;
//     displayOnMATLAB(stream);
//     stream << "irqTime: " << sPacket.irqTime_sec << std::endl;
//     displayOnMATLAB(stream);

    mexPrintf("version:     %03d\n", sPacket.version);
    mexPrintf("frameNumber: %08d\n", sPacket.frameNumber);
    mexPrintf("frameTime    %010ld.%09d\n", sPacket.frameTime_sec, sPacket.frameTime_nsec);
    mexPrintf("irqTime      %010ld.%09d\n", sPacket.irqTime_sec, sPacket.irqTime_nsec);

    for (int jMarker = 0; jMarker < 256; jMarker++){
//             stream << "entered the for statement! marker series number is: " << sPacket.aMarkers[jMarker].markerSeriesNumber << std::endl;
//             displayOnMATLAB(stream);            
    if (sPacket.aMarkers[jMarker].markerSeriesNumber > 0)
        {
            mexPrintf("  Marker[%04d:%03d] ", sPacket.aMarkers[jMarker].markerSeriesNumber, jMarker);
            mexPrintf("XYZ:[%+09.3f %+09.3f %+09.3f] ", sPacket.aMarkers[jMarker].x, sPacket.aMarkers[jMarker].y, sPacket.aMarkers[jMarker].z);
            mexPrintf("Q:[%+08.5f %+08.5f %+08.5f %+08.5f]\n", sPacket.aMarkers[jMarker].qr, sPacket.aMarkers[jMarker].qx, sPacket.aMarkers[jMarker].qy, sPacket.aMarkers[jMarker].qz);
            mexPrintf("\n");
        }
    }
    
    mexPrintf("end test :) \n");        

    closesocket(_socket); 
    WSACleanup();

//  I don't think I need the below for my code
//   MyData *d = new MyData; // Create a  MyData object
//   d->display();           // It should be initialized to
//                           // zeros
//   d->set_data(num1,num2); // Set data members to incoming
//                           // values
// #ifdef _WIN32
//   mexPrintf("After setting the object's data to your input:\n");
// #else
//   cout << "After setting the object's data to your input:\n";
// #endif
//   d->display();           // Make sure the set_data() worked
//   delete(d);
//   flush(cout);
//   return;
}

// void InitUDP(int port) {
//     WSADATA wsaData;
//     WSAStartup(0x0202, &wsaData);
// 
//     printf("UDP Port: %05d\n", port);
// 
//     // Open the socket
//     ProcessSocketFunction(_socket = socket(AF_INET, SOCK_DGRAM, 0), "socket");
// 
//     // Bind to the port
//     memset(&server_addr, 0, sizeof(struct sockaddr_in));
//     server_addr.sin_family      = AF_INET;
//     server_addr.sin_port        = htons(port);
//     server_addr.sin_addr.s_addr = INADDR_ANY; // look for traffic on any interface
// 
//     if (bind(_socket, (struct sockaddr *) &server_addr, sizeof(struct sockaddr)) == -1) {
//         stream << "Error calling bind: " << errno << std::endl;
//         displayOnMATLAB(stream);
// //             printf("Error %d (%s) calling bind\n", errno, strerror(errno));
// //             exit(1);
//     }
// }
//     

    
void mexFunction(
		 int          nlhs,
		 mxArray      *[],
		 int          nrhs,
		 const mxArray *prhs[]
		 )
{
//   int      *port;
//   int      *choice;

  /* Check for proper number of arguments */

  if (nrhs != 2) {
    mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin", 
            "MEXCPP requires two input arguments.");
  } else if (nlhs >= 2) {
    mexErrMsgIdAndTxt("MATLAB:mexcpp:nargout",
            "MEXCPP requires no output arguments.");
  }

  int port = (int)*mxGetPr(prhs[0]);
  int choice = (int)*mxGetPr(prhs[1]);  
//   port = (int *) mxGetPr(prhs[0]);
//   choice = (int *) mxGetPr(prhs[1]);
//   vin2 = (double *) mxGetPr(prhs[1]);

  metriaComm(port,choice);
  return;
}