@rem compile.bat

@echo off

SET appname=loader
SET exename=ESPlorer


call "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in %appname%.ahk /out %exename%.exe /icon %exename%.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin"

call "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in %appname%.ahk /out %exename%32.exe /icon %exename%.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 32-bit.bin"


