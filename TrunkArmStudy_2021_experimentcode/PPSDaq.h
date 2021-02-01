#ifndef _PPSDAQ_H_
#define _PPSDAQ_H_
//---------------------------------------------------------------------------
// PPSDaq.h
//
// PPS Data Acquisition API
// Copyright (c) 2009-2012 by Pressure Profile Systems, Inc.
// All Rights Reserved
//
//---------------------------------------------------------------------------
// We need standard Windows libraries to use BOOL type to preserve
// compatibility with C# apps. (They can't reliably read the bool type
// via DLL calls for some strange reason.)
//
#define WIN32_LEAN_AND_MEAN      // Don't load unnecessary Windows libraries
#define NOMINMAX                 // We'll use the STL min and max 
#include <windows.h>
//---------------------------------------------------------------------------
// Allows us to use the same header for building the library
// as for using it
//
#ifdef _PPS_DLL_BUILD_
#define DLL_FUNCTION __declspec(dllexport)
#else
#define DLL_FUNCTION __declspec(dllimport)
#endif
//---------------------------------------------------------------------------
// Variable Types
typedef float           output_t;
typedef unsigned long   time_stamp_t;
typedef char const*     string_t;
//---------------------------------------------------------------------------
// Only include this section for static linking or when building the DLL
#ifndef PPS_DYNAMIC_LINK   
//---------------------------------------------------------------------------
// API Function Definitions
//#ifdef __cplusplus
//extern "C"
//{  
   // Sets up and configures the PPS DAQ System
   //
   // configFile: PPS-created file specific to your setup
   // logLevel:   int from 0 (disabled) to 5 specifying log verbosity
   // returns: TRUE on success
   DLL_FUNCTION BOOL ppsInitialize(string_t configFile, int logLevel);

   // Begins data acquisition
   //
   // returns: TRUE on success
   DLL_FUNCTION BOOL ppsStart();

   // Ends data acquisition
   //
   // returns: TRUE on success
   DLL_FUNCTION BOOL ppsStop();

   // Retrieve the size (i.e. number of elements) in one frame
   //
   // returns: element count
   DLL_FUNCTION int  ppsGetRecordSize();

   // Retrieve the number of frames of data available for transfer
   //
   // returns: frame count
   DLL_FUNCTION int  ppsFramesReady();

   // Retrieve sensor data. The function assumes that memory has been
   // pre-allocated, and regardless of how much data is requested will
   // not copy more than is available at the time.
   //
   // nFrames: number of frames of data to copy
   // times: pointer to pre-allocated memory, one timestamp per frame
   // data: pointer to pre-allocated memory, (nFrames * recordSize) large
   // returns: the actual number of frames of data copied
   DLL_FUNCTION int  ppsGetData(int nFrames,
                                time_stamp_t* times,
                                output_t* data);

   // Send hardware-specific commands. Available commands and formats 
   // are dependent on the type of hardware connected. Contact PPS for
   // documentation on your specific hardware.
   //
   // command: C-style string with command request being sent
   // args: pointer to space for return data
   DLL_FUNCTION BOOL ppsDirectCommand(string_t command, void* args);
   
   // For raw data, retrieve the maximum output signal for use in
   // scaling data.
   //
   // returns: the maximum binary value available from the hardware
   DLL_FUNCTION int  ppsGetMaxSignal();

   // Set a new baseline value based on the current sensor readings.
   // This value will be subtracted from each element when data is 
   // returned.
   DLL_FUNCTION void ppsSetBaseline();

   // Reset any baseline values to zero
   DLL_FUNCTION void ppsClearBaseline();

   // Check to see if output reflects calibrated or raw data
   //
   // returns: TRUE for calibrated data
   DLL_FUNCTION BOOL ppsIsCalibrated();

   // If a function has returned FALSE indicating an error, this can
   // be used to retrieve the error message.
   DLL_FUNCTION string_t ppsGetLastError();
//}
//#endif
//---------------------------------------------------------------------------
// This portion is used in building dynamically-linked code
#else
//---------------------------------------------------------------------------
// Typedefs for each function type in the PPS API
typedef __declspec(dllimport) BOOL (*ppsInitialize_t)(string_t, int);
typedef __declspec(dllimport) BOOL (*ppsStart_t)();
typedef __declspec(dllimport) BOOL (*ppsStop_t)();
typedef __declspec(dllimport) int  (*ppsGetRecordSize_t)();
typedef __declspec(dllimport) int  (*ppsFramesReady_t)();
typedef __declspec(dllimport) int  (*ppsGetData_t)(int, 
                                                   time_stamp_t*, 
                                                   output_t*);
typedef __declspec(dllimport) BOOL (*ppsDirectCommand_t)(string_t, void*);
typedef __declspec(dllimport) int  (*ppsGetMaxSignal_t)();
typedef __declspec(dllimport) void (*ppsSetBaseline_t)();
typedef __declspec(dllimport) void (*ppsClearBaseline_t)();
typedef __declspec(dllimport) BOOL (*ppsIsCalibrated_t)();
typedef __declspec(dllimport) string_t (*ppsGetLastError_t)();
//---------------------------------------------------------------------------
// Function pointers for each API function
//
// Use these to actually call PPS API commands, such as
//    ppsInitialize("config.txt");
//    int nFrames = ppsFramesReady();
//    int nFrames = ppsGetData(nFramesRequested, times, signals);
//
extern ppsInitialize_t         ppsInitialize;
extern ppsStart_t              ppsStart;
extern ppsStop_t               ppsStop;
extern ppsGetRecordSize_t      ppsGetRecordSize;
extern ppsFramesReady_t        ppsFramesReady;
extern ppsGetData_t            ppsGetData;
extern ppsDirectCommand_t      ppsDirectCommand;
extern ppsGetMaxSignal_t       ppsGetMaxSignal;
extern ppsSetBaseline_t        ppsSetBaseline;
extern ppsClearBaseline_t      ppsClearBaseline;
extern ppsIsCalibrated_t       ppsIsCalibrated;
extern ppsGetLastError_t       ppsGetLastError;
//---------------------------------------------------------------------------
// Setup and Cleanup functions for Dynamic Linking
//    Compile the file PPSDaqDyn.cpp into your project to use these.

// Connects to DLL and loads all functions
//
// filepath: path to DLL (relative or fully-qualified)
// returns: TRUE on success
BOOL ppsConnectToApi(string_t filepath);

// Disconnects from DLL and releases resources
void ppsDisconnectApi();
//---------------------------------------------------------------------------
#endif      // End of Dynamic Link App Build Section
//---------------------------------------------------------------------------
#endif
