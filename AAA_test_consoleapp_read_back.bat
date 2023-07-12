@rem AAA_test_consoleapp_read_back.bat
@rem Autohotkey must be in the path

@cd %~dp0

@echo off

@loader.exe disableini consoleapp debug --Executor="cmd /c java -version"

rem *** read back into variable ***

echo.
echo single line only:
echo.
for /f %%i in ('getfromclip') do set var=%%i
echo %var%
echo.
pause

echo.
echo using all lines to do something:
echo.
for /f "delims=" %%a in ('getfromclip') do (
    echo %%a
)
echo.
pause

echo.
echo putting all lines in an array like structure:
echo.
rem from https://stackoverflow.com/questions/35747604/batch-script-read-multi-line-argument-in-variable
setlocal EnableDelayedExpansion
rem Capture lines in an 'array'
set /a i=0
for /f "delims=" %%a in ('getfromclip') do (
    set /a i+=1
    set var!i!=%%a
)

rem Loop through the 'array'
for /L %%a in (1,1,%i%) do (
   echo Do more stuff with !var%%a!
)
echo.
pause
