@rem AAA_test_executor.bat
@rem Autohotkey must be in the path

@cd %~dp0
@echo off

call loader.exe --Executor="java -version" --classpath="" --mainclass="" --parameter=""

call loader.exe Disableini --Executor="java " --classpath="-version" --mainclass="" --parameter=""

call loader.exe disableIni --Executor="java " --classpath="" --mainclass="-version" --parameter=""

call loader.exe disableIni --Executor="java " --classpath="" --mainclass="" --parameter="-version"

call loader.exe disableini --Executor="java -version" 

call loader.exe disableini debug --Executor="java -version" 

