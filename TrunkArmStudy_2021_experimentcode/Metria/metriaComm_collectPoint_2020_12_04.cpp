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
 * - Outputted hostname[64], as it tells us what camera we're looking at
 * - Changed all usages of the word "Tag" with "Marker" to avoid confusion
 * - Returned the Marker ID (i.e., jmarker counter value) as well in Metria Comm
 * - Continued to pull from the metria until we definitely had both cameras
 *========================================================*/
/*==========================================================
* Nov 23, 2020 - Hendrik
* - Changed input/outputs so that we get passed the IDs we're expecting
* - Passed the camera info to check for the cameras we're supposed to see
*========================================================*/
/*==========================================================
* Dec 2, 2020 - Hendrik
* - Adjusted the loops to avoid all 256 and instead just look directly for the markers we need
* - Merged info from both cameras and returned them together (prioritizing by order in passed array)
*========================================================*/

//TODO: Always make sure to comment out all the xprintf lines when editing is done

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
//I believe Sabeen worked off of the V100 code shown in the Metria User Manual on page 36 (section 6.6 of the Appendice)
//This structure is populated somehow by the metria and is the format we have to work with
typedef struct UDPPacketV101_s {
    int  version;
    char hostname[64]; //Camera name, formated as Series2sXX where the XX are the serial number (24 or 25)
    int  frameNumber;
    int  frameTime_sec, frameTime_nsec;
    int  irqSequenceNum;
    int  irqTime_sec, irqTime_nsec;
    
    struct {
        int   markerSeriesNumber; //This indicates what size electrode, but it's shared by all of that size
        float markerWidth;
        float markerThickness;
        float brightness;  //V101 specific
        float focusMetric; //V101 specific
        float blurRadius;  //V101 specific
        float x, y, z;
        float qr, qx, qy, qz;
        int   flags;       //'flags' was an unsigned int in V100
    } aMarkers[256];
    
    double aVoltages[16];
} UDPPacketV101_t;

sockaddr_in     server_addr;
UDPPacketV101_t sPacket;

int _socket;

void ProcessSocketFunction(int result, const char *function) { //TODO: Figure out where int result comes from; how would it know that there's a SOCKET_ERROR and could this explain/fix the issue where the matlab crashes if another matlab script is still open and trying to contact the Metria?
    char temp[256];
    
    if (result == SOCKET_ERROR) {
        FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, GetLastError(), 0, temp, 256, NULL);
        
        mexPrintf("Error %ld (%s) calling %s:\n  ", GetLastError(), temp, function);
        
        if (GetLastError() == 10048)
            mexPrintf("UDP port in use\n");
        mexPrintf("Socket error\n");
    }
}

//Original: static void metriaComm(int sockInput, int numMarkers, double *out)
//11_18_2020: static void metriaComm(int sockInput, int numMarkers, double *out, double *out2)
//I imagine the "static" is in place because this same function exists in other .cpp files? It's been a while since I used static
//What I don't understand is why it has to return 'void' and uses a pointer for the output. Wouldn't it be easier to have it return the output? But whatever, I guess. *Talked to AMA, she said it may be a constraint for mex files
static void metriaComm(int sockInput, int *markerIDs, int numMarkers, int *cameraSerials, int numCameras, double *out) //12_3_2020
{
    //Pass in the pointer to the UDP port --> don't need to have the InitUDP function in here
    int len;
    int _socket;
    
    //Sabeen made a local copy of an input here. TODO: Is it good form to avoid direct reliance on the input arguments throughout a long function like this? Should I be concerned that other functions may affect the array the passed pointers refer to?
    _socket = sockInput;
    
    WSADATA wsaData;
    WSAStartup(0x0202, &wsaData);
    
    //Create arrays that act as booleans by which we make certain we've checked all cameras and markers that we should have (starts with 0, becomes 1 if we've seen it)
    int* markerID_ReadBools = new int[numMarkers](); //initialized to 0
    int* cameraSerial_ReadBools = new int[numCameras](); //initialized to 0
    
    //Prepare some variables that we will repeatedly use/update
    int i, currentCamera, pullCount = 0, pullLimit = 30;
    char currentRead[11]; //The camera name is only ever 10 characters
    char * pch; //For use with strstr and finding the camera serial in the hostname
    char cameraSerialCharArray[2]; //Character array for checking camera serials later
    mwSize jCounter = 0; //Used for keeping the output organized later
    
    // We'll loop until either we find all cameras on our list or we hit a limit. If we hit the limit without all cameras, we send out an error
    // I've noticed that the slight delay between pulls means that the data on a marker from one camera will be slightly different from the other(s). I can't imagine this delay is a huge problem, however.
    while (pullCount<30) {
        //Check to see which camera still needs to be read
        currentCamera = -1;
        for (i = 0; i<numCameras; i++) {
            if (cameraSerial_ReadBools[i]==0) { //0 means we haven't seen that camera yet
                currentCamera = i;
                break; //Once we determine the next unfound camera, we can leave this for loop
            }
        }
        
        // If we go through the entire boolean array for the cameras and we find that all have been seen, then we must have found all cameras and can leave the loop
        if (currentCamera==-1){
            break;
        }
//         mexPrintf("\nCamera we're looking for - index:%d, serial:%d\n",currentCamera,*(cameraSerials+currentCamera)); //TODO: Comment out
        
        //After we've determined our camera goal, we continue to pull from the Metria until we find the camera we're looking for
        while (pullCount<30) { 
            ProcessSocketFunction(len = recv(_socket, (char *)&sPacket, sizeof(UDPPacketV101_t), 0), "recv"); //Pull from the Metria
            pullCount++;
            
//             //Sabeen debug stuff that checks whether that pull was at all successful, TODO: comment out when not editing
//             mexPrintf("\n_socket: %d\n",_socket);
//             if (len == sizeof(UDPPacketV101_t) && sPacket.version == 101)
//                 mexPrintf("Passed the first check: correct packet size and version\n");
//             mexPrintf("version:     %03d\n", sPacket.version);
//             mexPrintf("frameNumber: %08d\n", sPacket.frameNumber);
//             mexPrintf("frameTime    %010ld.%09d\n", sPacket.frameTime_sec, sPacket.frameTime_nsec);
//             mexPrintf("irqTime      %010ld.%09d\n", sPacket.irqTime_sec, sPacket.irqTime_nsec);
            
            //Get info about this camera we've just pulled
            memset(currentRead, '\0', sizeof(currentRead)); //Make the char array empty to start
            strncpy(currentRead,sPacket.hostname,10); //Copy from the host name (just the important first 10 characters)
            currentRead[10] = 0; // null terminate destination
//             mexPrintf("Pullcount: %d, Hostname: %s\n", pullCount, currentRead); //TODO: comment out
            
            //Check whether this host/camera name contains the next serial that we're looking for       
            memset(cameraSerialCharArray, '\0', sizeof(cameraSerialCharArray)); //Make the char array empty to start
            _itoa (*(cameraSerials+currentCamera),cameraSerialCharArray,10); //Convert the int serial of the camera we're looking for into a char array, 10 refers to decimal base
            pch = strstr(currentRead,cameraSerialCharArray); //Find the serial in the current hostname
            if (pch!=NULL) { //The current pull is the camera we're looking for
                cameraSerial_ReadBools[i] = 1;
//                 mexPrintf("\nCamera we're looking for in char array: %s, Matches current host, bool set to %d\n",cameraSerialCharArray,cameraSerial_ReadBools[i]); //TODO: Comment out
                break;
            }
        }
        
        //If we didn't find the camera we're looking for, output an error
        if (cameraSerial_ReadBools[currentCamera]==0) {
            mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
                "MEXCPP collectPoint could not find a camera");
        }
        
        //If this is the first camera, output the frame and time information
        if (currentCamera==0) {                                  
            *(out+jCounter) = sPacket.frameNumber; jCounter++;  //Frame number. I've left this and the next two in as when data is pulled from two cameras the technical timing may be different between markers outputted together like this
            *(out+jCounter) = sPacket.frameTime_sec; jCounter++;//Frame time in OS seconds?
            *(out+jCounter) = sPacket.frameTime_nsec; jCounter++;//Frame time in real seconds?
        }
        
        //If we've gotten here, we must have found the camera we were looking for
        //Go through the list of marker IDs we need to check and get the required info from them
        for (i = 0; i<numMarkers; i++) {
            if (sPacket.aMarkers[*(markerIDs+i)].markerSeriesNumber > 0) { //Check to see if we find a series number for this marker ID we're now checking for (lets us know there's data there)
                //TODO: Comment these Printf lines out once everything's working
//                 mexPrintf("Marker[%04d:%03d] ", sPacket.aMarkers[*(markerIDs+i)].markerSeriesNumber, *(markerIDs+i));
//                 mexPrintf("XYZ:[%+09.3f %+09.3f %+09.3f] ", sPacket.aMarkers[*(markerIDs+i)].x, sPacket.aMarkers[*(markerIDs+i)].y, sPacket.aMarkers[*(markerIDs+i)].z);
//                 mexPrintf("Q:[%+08.5f %+08.5f %+08.5f %+08.5f]\n", sPacket.aMarkers[*(markerIDs+i)].qr, sPacket.aMarkers[*(markerIDs+i)].qx, sPacket.aMarkers[*(markerIDs+i)].qy, sPacket.aMarkers[*(markerIDs+i)].qz);

                if (markerID_ReadBools[i]==0) { //Do we still need data for this marker? If so, output all the relevant data   
                    //*(out+jCounter) = sPacket.aMarkers[*(markerIDs+i)].markerSeriesNumber; jCounter++; //Marker Series     
                    *(out+jCounter) = *(markerIDs+i); jCounter++;       //Marker ID     
                    *(out+jCounter) = sPacket.aMarkers[*(markerIDs+i)].x; jCounter++;
                    *(out+jCounter) = sPacket.aMarkers[*(markerIDs+i)].y; jCounter++;
                    *(out+jCounter) = sPacket.aMarkers[*(markerIDs+i)].z; jCounter++;
                    *(out+jCounter) = sPacket.aMarkers[*(markerIDs+i)].qx; jCounter++;
                    *(out+jCounter) = sPacket.aMarkers[*(markerIDs+i)].qy; jCounter++;
                    *(out+jCounter) = sPacket.aMarkers[*(markerIDs+i)].qz; jCounter++;
                    *(out+jCounter) = sPacket.aMarkers[*(markerIDs+i)].qr; jCounter++;
                    markerID_ReadBools[i]=1; //We've now found this marker and got the data for it
                }
                //TODO: In this current format, if a marker is missing we will only have 0's at the end of the output, not in columns that would typically store the marker's data. This could make parsing data where a marker disappears more irritating later on. Perhaps account for this in future versions
            }
        }
    }
    
    //Check to see if we found all the markers we were looking for
    for (i = 0; i<numMarkers; i++) {
        if (markerID_ReadBools[i]==0) { //0 means we haven't seen that marker ID yet
            mexPrintf("\nWarning: Marker %d not found\n",*(markerIDs+i));
            //TODO: Is just a printf enough? Should this be sufficient for an error?
        }
    }
    
    WSACleanup();
}

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Check for proper number of arguments
    if (nrhs != 3) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
                "MEXCPP collectPoint requires three input arguments.");
    } else if (nlhs > 2) { //I used 2 because that's what Sabeen had, but shouldn't it be 1?
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargout",
                "MEXCPP collectPoint has one output argument.");
    }
    
    // Variables for for-loops
    int i, j;
    
    // Get socket info (first input)
    int sockInput = mxGetScalar(prhs[0]); //Just a warning, this is conversion from 'double' to 'int', possible loss of data
    
    // Get markerIDs info (second input)
    int numMarkers = mxGetN(prhs[1]); // While mxGetN, according to help, gets the column length, I've found it's actually the row length in Matlab
    if (numMarkers < 1) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
            "MEXCPP collectPoint markerID input requires at least one marker ID");
    }
    int* markerIDs = new int[numMarkers]; // Prep the array for the markerIDs (can I preallocate memory more efficiently in the future?)
    for (i=0; i<numMarkers; i++) {
        markerIDs[i] = (int)*(mxGetPr(prhs[1])+i);
        if ((markerIDs[i]<0)||(markerIDs[i]>255)) { //Check that the marker ID is within range
            mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
                "MEXCPP collectPoint markerID input not within range (0-255)");
        }
        for (j=0; j<i; j++) {
            if (markerIDs[j]==markerIDs[i]) { //Check that there are no repeating marker IDs
                mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
                    "MEXCPP collectPoint markerID input requires unique marker IDs");
            }
        }
    }
    
    // Get cameraSerials info (third input)
    int numCameras = mxGetN(prhs[2]); // While mxGetN, according to help, gets the column length, I've found it's actually the row length in Matlab
    if (numCameras < 1) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
            "MEXCPP collectPoint cameraSerials input requires at least one camera serial");
    }
    int* cameraSerials = new int[numCameras]; // Prep the array for the markerIDs (can I preallocate memory more efficiently in the future?)
    for (i=0; i<numCameras; i++) {
        cameraSerials[i] = (int)*(mxGetPr(prhs[2])+i);
        if ((cameraSerials[i]>99)||(cameraSerials[i]<0)) { //Check that the camera serial is within range
            mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
                "MEXCPP collectPoint cameraSerials input not within range (0-99)");
        }
        for (j=0; j<i; j++) {
            if (cameraSerials[j]==cameraSerials[i]) { //Check that there are no repeating camera serials
                mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
                    "MEXCPP collectPoint cameraSerials input requires unique camera serials");
            }
        }
    }
    
    //***Debugging Printfs
//     mexPrintf("\nNumber of Left Hand Side outputs: %d\n",nlhs);
//     mexPrintf("Number of Right Hand Side arguments: %d\n",nrhs);
//     // Examine all input (right-hand-side) arguments
//     for (i=0; i<nrhs; i++)  {
//         mexPrintf("\n\tInput Arg %i is of type:\t%s ",i,mxGetClassName(prhs[i]));
//         mexPrintf("\n\tInput Arg %i contains pointer %d ",i,mxGetPr(prhs[i]));
//         mexPrintf("\n\twhose first entry contains %i in (int)",(int)*mxGetPr(prhs[i]));
//         mexPrintf("\n\tor %d in (double)",(double)*mxGetPr(prhs[i]));
//         mexPrintf("\n\tor %d when GetScalar is used",mxGetScalar(prhs[i]));
//         mexPrintf("\n\tbut it has %d rows",mxGetM(prhs[i]));
//         mexPrintf("\n\tand %d columns in total",mxGetN(prhs[i]));
//         mexPrintf("\n\tdespite supposedly having %d number of elements according to mxGetNumberOfElements\n",(double)mxGetNumberOfElements(prhs[i]));
//     }
//     // Second input should be the marker ids, check them
//     mexPrintf("\nMarker IDs: ");
//     for (i=0; i<numMarkers; i++) {
//         mexPrintf("%i, ",markerIDs[i]);        
//     }
//     mexPrintf("\nNumber of markers: %d\n",numMarkers);
//     // Third input should be the camera serials, check them
//     mexPrintf("\nCamera Serials: ");
//     for (i=0; i<numCameras; i++) {
//         mexPrintf("%i, ",cameraSerials[i]);        
//     }
//     mexPrintf("\nNumber of cameras: %d\n",numCameras);
    //***End Debugging Printfs
        
    
    //TODO: I believe this is for preallocating the outputs later, and should reference some defined globally defined length depending on what values we're interested it. Come back and clean this output stuff up later
    double *outMatrix;
    
    int mrows = 1;
    int ncols = (numMarkers*12); //TODO: THIS IS VERY IMPORTANT! The number that's multiplied here is the number of parameters we're outputting from each marker. In the current case, 12
    int ncols2 = 4; //Delete? Wasn't used
    
    plhs[0] = mxCreateDoubleMatrix( (mwSize)mrows, (mwSize)ncols, mxREAL);
    plhs[1] = mxCreateDoubleMatrix( (mwSize)mrows, (mwSize)ncols, mxREAL); //TODO: I don't know why there are two identical LHS outputs?
    //plhs[2] = mxCreateDoubleMatrix( (mwSize)mrows, (mwSize)ncols2, mxREAL); //This is what AMA and I used when we were outputting two outputs for two cameras
    
    outMatrix = mxGetPr(plhs[0]);
    //outMatrix2 = mxGetPr(plhs[1]);
    
    
    // And then we finally call metriaComm, which pulls from the Metria and organizes the information
    metriaComm(sockInput,markerIDs,numMarkers,cameraSerials,numCameras,outMatrix); //Attempt to pass array of markers
    //metriaComm(sockInput,numMarkers,outMatrix,outMatrix2); //Original
   // metriaComm(sockInput,numMarkers,outMatrix);
    
    return;
}
