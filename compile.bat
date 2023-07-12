@rem compile.bat

@echo off

SET appname=loader

call "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in %appname%.ahk /out %appname%.exe /icon %appname%.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin"

rem call "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in %appname%.ahk /out %appname%32.exe /icon %appname%.ico /bin "C:\Program Files\AutoHotkey\Compiler\Unicode 32-bit.bin"


