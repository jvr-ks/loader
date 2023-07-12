@rem AAA_test_consoleapp.bat
@rem Autohotkey must be in the path

@cd %~dp0

@echo off

@loader.exe disableini consoleapp --Executor="cmd /c java -version"

getfromclip

pause
