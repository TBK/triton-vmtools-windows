REM This file installs the tools into c:\triton
REM and sets c:\triton\bin as part of PATH

ECHO OFF
TITLE Triton Windows VM Tools - Install

cd %~dp0

CLS
ECHO Triton Windows VM Tools - Install
ECHO =======================================================
ECHO
ECHO This tool will install the tools and drivers necessary
ECHO to run Windows in a Triton or SmartOS environment
ECHO The tools and drivers will be installed to c:\triton
ECHO

PAUSE

mkdir c:\triton
xcopy * c:\triton /E /Q /Y
xcopy sysprep\SetupComplete.cmd %WINDIR%\Setup\Scripts\
xcopy /Y C:\triton\images\"Joyent Wiki.url" C:\Users\Default\Desktop\
xcopy /Y C:\triton\images\"Joyent Support.url" C:\Users\Default\Desktop\
