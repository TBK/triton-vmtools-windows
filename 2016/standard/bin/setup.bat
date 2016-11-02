for /f "delims=" %%a in ('C:\triton\bin\mdata-get.exe administrator_pw') do @set password=%%a
net user administrator "%password%"
diskpart /s C:\triton\lib\diskpart-commands
cscript //B "%windir%\system32\slmgr.vbs" /ipk XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
cscript //B "%windir%\system32\slmgr.vbs" /ato
rmdir /Q /S C:\triton\sysprep
del C:\triton\install.bat
del C:\Windows\Setup\Scripts\SetupComplete.cmd
@echo off
call :heredoc joyenttask > C:\triton\tmp\JoyentTask.xml && goto next3
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2013-11-06T18:40:00.189996</Date>
    <Author>Administrator</Author>
  </RegistrationInfo>
  <Triggers>
    <BootTrigger>
      <Enabled>true</Enabled>
    </BootTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>Administrator</UserId>
      <LogonType>Password</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>P3D</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>powershell.exe</Command>
      <Arguments>-executionpolicy bypass -file C:\triton\lib\run-userdata.ps1</Arguments>
    </Exec>
    <Exec>
      <Command>powershell.exe</Command>
      <Arguments>-executionpolicy bypass -file C:\triton\lib\run-userscript.ps1</Arguments>
    </Exec>
  </Actions>
</Task>
:next3
for /f "delims=" %%a in ('C:\triton\bin\mdata-get.exe administrator_pw') do @set password=%%a
schtasks /Create /TN "JoyentTask" /XML "C:\triton\tmp\JoyentTask.xml" /RU "%COMPUTERNAME%\Administrator" /RP "%password%"
powershell.exe -executionpolicy bypass -file C:\triton\lib\run-userdata.ps1
powershell.exe -executionpolicy bypass -file C:\triton\lib\run-userscript.ps1
del C:\triton\bin\setup.bat

:: End of main script
goto :EOF

:: ########################################
:: ## Here's the heredoc processing code ##
:: ########################################
:heredoc <uniqueIDX>
setlocal enabledelayedexpansion
set go=
for /f "delims=" %%A in ('findstr /n "^" "%~f0"') do (
    set "line=%%A" && set "line=!line:*:=!"
    if defined go (if #!line:~1!==#!go::=! (goto :EOF) else echo(!line!)
    if "!line:~0,13!"=="call :heredoc" (
        for /f "tokens=3 delims=>^ " %%i in ("!line!") do (
            if #%%i==#%1 (
                for /f "tokens=2 delims=&" %%I in ("!line!") do (
                    for /f "tokens=2" %%x in ("%%I") do set "go=%%x"
                )
            )
        )
    )
)
goto :EOF
