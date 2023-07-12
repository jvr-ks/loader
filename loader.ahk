/*
 *********************************************************************************
 * 
 * loader.ahk
 * 
 * all files are UTF-8 no BOM encoded
 * 
 * from https://www.autohotkey.com/board/topic/10384-download-progress-bar/
 * 
 * Copyright (c) 2022 jvr.de. All rights reserved.
 *
 * Licens -> Licenses.txt
 * 
 *********************************************************************************
*/

#NoEnv
#Warn
#SingleInstance

SendMode Input
SetWorkingDir %A_ScriptDir%

fontDefault := "Calibri"
font := fontDefault

fontsizeDefault := 10
fontsize := fontsizeDefault

wrkDir := A_ScriptDir . "\"
configFile := wrkDir . "loader.ini"

appName := "Loader"
appnameLower := "loader"
extension := ".exe"
appVersion := "0.022"

bit := (A_PtrSize=8 ? "64" : "32")

if (!A_IsUnicode)
  bit := "A" . bit

app := appName . " " . appVersion . " " . bit . "-bit"

theCmd := ""
result := ""

CR := "`n"
CR2 := "`n`n"
quot := """"

disableini := 0

javasourceurlDefault := "https://www.graalvm.org/downloads/index.html"
javasourceurl := javasourceurlDefault

executorDefault := "echo Hello world!"
executor := executorDefault
consoleapp := 0
classpath := ""
mainclass := ""
parameter := ""
showresult := 1
showresulttime := 5000
checkjava := 1
requiresadmin := 0
splash := "Loader running ..."

hasParams := A_Args.Length()

;Autoclose in case of failure
setTimer,exit,-30000

if (hasParams > 0){
  Loop % hasParams
  {
    if(eq(StrLower(StrLower(A_Args[A_index])),"disableini")){
      disableini := 1
    }
  }
}

if (!disableini && FileExist(configFile)){
  readIni()
}
  
if (hasParams > 0)
  readParams()
  
if (requiresadmin){
  ; force admin rights
  if (A_IsCompiled){
    allparams := ""
    for keyGL, valueGL in A_Args {
      allparams .= valueGL . " "
    }
    full_command_line := DllCall("GetCommandLine", "str")

    if (!A_IsAdmin){
      if (!RegExMatch(full_command_line, " /restart(?!\S)")){
        try
        {
          tipTopTime("Restart as admin ...", 2000)
          sleep, 2000
          Run *RunAs %A_ScriptFullPath% /restart %allparams%
        }
        exitApp
      }
      MsgBox, Error`, could not get admin-rights`, exiting %appName% due to this error!
      exit()
    }

  } else {
    if (!A_IsAdmin){
      MsgBox, Script must be run as an admin!
      exit()
    }
  }
}

if (checkjava)
   if (!isJavaOk())
    installJava()
  
quot1 := quot
quot2 := quot

if (classpath == "")
  quot1 := ""
  
if (parameter == "")
  quot2 := ""


theCmd := trim(executor . A_Space . quot1 . classpath . quot1 . A_Space . mainclass . A_Space . quot2 . parameter  . quot2)

if (splash != ""){
  tipTopLeftTime(splash, 5000)
}

runwait, %comspec% /c %theCmd% | clip,,hide

result := clipboard

if (showresult){
  tipTopTime(result, showresulttime)
  sleep, %showresulttime%
}

if (consoleapp){
  if (0 + result == 0)
    exitcode := 0
  else
    exitcode := 1

  exit(exitcode) 
}

exit(0)

return

Escape::
exit(1)
;-------------------------------- readParams --------------------------------
readParams(){
  global hasParams, disableini, consoleapp, showresult

  global executor, classpath, mainclass, parameter, showresulttime, splash, checkjava, requiresadmin
  
 
  Loop % hasParams
  {
    if(eq(StrLower(StrLower(A_Args[A_index])),"consoleapp")){
      consoleapp := 1
    }

    if(eq(StrLower(StrLower(A_Args[A_index])),"showresult")){
      showresult := 1
    }
    if(eq(StrLower(StrLower(A_Args[A_index])),"nojavacheck")){
      checkjava := 1
    }
    if(eq(StrLower(StrLower(A_Args[A_index])),"requiresadmin")){
      requiresadmin := 1
    }
    
    ; parameter with arguments
    FoundPos := RegExMatch(A_Args[A_index],"Oi)--executor=(.*)", m)
    if(FoundPos > 0){
      executor := m.value(m.Count())
    }
    FoundPos := RegExMatch(A_Args[A_index],"Oi)--classpath=(.*)", m)
    if(FoundPos > 0){
      classpath := m.value(m.Count())
    }    
    FoundPos := RegExMatch(A_Args[A_index],"Oi)--mainclass=(.*)", m)
    if(FoundPos > 0){
      mainclass := m.value(m.Count())
    }   
    FoundPos := RegExMatch(A_Args[A_index],"Oi)--parameter=(.*)", m)
    if(FoundPos > 0){
      parameter := m.value(m.Count())
    }
    FoundPos := RegExMatch(A_Args[A_index],"Oi)--showresulttime=(.*)", m)
    if(FoundPos > 0){
      showresulttime := m.value(m.Count())
    }
    FoundPos := RegExMatch(A_Args[A_index],"Oi)--splash=(.*)", m)
    if(FoundPos > 0){
      splash := m.value(m.Count())
    }
  }
    
  return
}
;--------------------------------- StrLower ---------------------------------
StrLower(s){
	r := ""
	StringLower, r, s
	
	return r
}
;---------------------------------- readIni ----------------------------------
readIni(){
  global configFile
  
  global javasourceurlDefault, javasourceurl, executorDefault, executor
  global consoleapp, classpath, mainclass
  global parameter, showresult, showresulttime, checkjava
  global requiresadmin, splash

  IniRead, javasourceurl, %configFile%, config, javasourceurl, javasourceurlDefault
  IniRead, executor, %configFile%, config, executor, executorDefault
  IniRead, consoleapp, %configFile%, config, consoleapp, 0
  IniRead, classpath, %configFile%, config, classpath, %A_Space%
  IniRead, mainclass, %configFile%, config, mainclass, %A_Space%
  IniRead, parameter, %configFile%, config, parameter, %A_Space%
  IniRead, showresult, %configFile%, config, showresult, 0
  IniRead, showresulttime, %configFile%, config, showresulttime, 5000
  IniRead, checkjava, %configFile%, config, checkjava, 1
  IniRead, requiresadmin, %configFile%, config, requiresadmin, 0
  IniRead, splash, %configFile%, config, splash, %A_Space%
  
  return
}
;------------------------------------ eq ------------------------------------
eq(a, b) {
  if (InStr(a, b) && InStr(b, a))
    return 1
  return 0
}
;--------------------------------- errorExit ---------------------------------
errorExit(theMsgArr,clp := "") {
  global CR, result
 
  msgComplete := ""
  for index, element in theMsgArr
  {
    msgComplete .= element . CR
  }

  msgbox, 48, ERROR, %msgComplete%
  if (clp != "")
    clipboard := clp
  
  result := msgComplete
  exit(1)
  
  return
}
;---------------------------------- CmdRet ----------------------------------
CmdRet() {
  global theCmd, result

  static HANDLE_FLAG_INHERIT := 0x00000001, flags := HANDLE_FLAG_INHERIT
      , STARTF_USESTDHANDLES := 0x100, CREATE_NO_WINDOW := 0x08000000 , hPipeRead := "", hPipeWrite := "", sOutput := ""
      
  callBackFuncObj := ""
  encoding := "CP0"

  DllCall("CreatePipe", "PtrP", hPipeRead, "PtrP", hPipeWrite, "Ptr", 0, "UInt", 0)
  DllCall("SetHandleInformation", "Ptr", hPipeWrite, "UInt", flags, "UInt", HANDLE_FLAG_INHERIT)

  VarSetCapacity(STARTUPINFO , siSize :=    A_PtrSize*4 + 4*8 + A_PtrSize*5, 0)
  NumPut(siSize              , STARTUPINFO)
  NumPut(STARTF_USESTDHANDLES, STARTUPINFO, A_PtrSize*4 + 4*7)
  NumPut(hPipeWrite          , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*3)
  NumPut(hPipeWrite          , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*4)

  VarSetCapacity(PROCESS_INFORMATION, A_PtrSize*2 + 4*2, 0)

  if !DllCall("CreateProcess", "Ptr", 0, "Str", theCmd, "Ptr", 0, "Ptr", 0, "UInt", true, "UInt", CREATE_NO_WINDOW
                            , "Ptr", 0, "Ptr", 0, "Ptr", &STARTUPINFO, "Ptr", &PROCESS_INFORMATION)
  {
    DllCall("CloseHandle", "Ptr", hPipeRead)
    DllCall("CloseHandle", "Ptr", hPipeWrite)
    throw Exception("CreateProcess is failed")
  }
  DllCall("CloseHandle", "Ptr", hPipeWrite)
  VarSetCapacity(sTemp, 4096), nSize := 0
  while DllCall("ReadFile", "Ptr", hPipeRead, "Ptr", &sTemp, "UInt", 4096, "UIntP", nSize, "UInt", 0) {
    sOutput .= stdOut := StrGet(&sTemp, nSize, encoding)
    ( callBackFuncObj && callBackFuncObj.Call(stdOut) )
  }
  DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION))
  DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, A_PtrSize))
  DllCall("CloseHandle", "Ptr", hPipeRead)
  
  result := sOutput

  Return
}
;--------------------------------- isOkJava ---------------------------------
isJavaOk(){
  global theCmd, result  
  ret := false

  try {
    theCmd := "java -version"
    CmdRet()
    javaFoundPos := RegExMatch(result,"O)version(.*)", mJava)
    if(javaFoundPos > 0){
      a := mJava.value(mJava.Count())
        
      ret := true
    }
  } catch e {
    eMsg  := e.Message
    msgArr := {}
    msgArr.push("Error: " . eMsg)
    msgArr.push("Closing Loader due to an error!")
    
    errorExit(msgArr,eMsg)
  }
  result := ""

  return ret
}
;-------------------------------- installJava --------------------------------
installJava(){
  global javasourceurl, CR, CR2
  
  msgLines := {}
  msgLines.push("No suitable Java runtime found, please install Java first!" . CR)
  msgLines.push("Closing Loader and opening your browser" . CR)
  msgLines.push("with a suitable Java-download webpage now!" . CR)
  msgLines.push("(Current Java selection: GraalVM.)" . CR2)
  msgLines.push("Look for the latest Java installation-package, like:  graalvm-ce-java11-windows-amd64-22.x.y.z.zip")
  msgLines.push("Follow the docs and install Java!" . CR)
  
  msgComplete := ""
  for index, element in msgLines
  {
    msgComplete .= element . CR
  }
  
  msgbox,48,STOP,%msgComplete%
  
  ; a temporary file, running directory must be writeable
  outputFile := "webpageloader_$$$$$$.html"

if (FileExist(outputFile))
  FileDelete, %outputFile%

  FileAppend,
(
<html>
  <body>
    <script>
      document.location.href="
),%outputFile%

  FileAppend,%javasourceurl%,%outputFile%

  FileAppend,
(
"
    </script>
  </body>
</html>
),%outputFile%

  run, %comspec% /c %outputFile%

  sleep,5000

  ; remove temporary file
  if (FileExist(outputFile))
      FileDelete, %outputFile%

  exit()
  
  return
}
;-------------------------------- tipTopTime --------------------------------
tipTopTime(msg, t := 1000){

  n := Min(n, 9)
  n := Max(n, 1)
    
  s := StrReplace(msg,"^",",")
  
  toolX := Floor(A_ScreenWidth / 2)
  toolY := 2

  CoordMode, ToolTip, Screen
  ToolTip,%s%, toolX, toolY
  
  WinGetPos, X,Y,W,H, ahk_class tooltips_class32

  toolX := (A_ScreenWidth / 2) - W / 2
     
  ToolTip,%s%, toolX, toolY
  
  duration := t * -1
  settimer,tipTopTimeRemove,%duration%
  
  return
}
;----------------------------- tipTopTimeRemove -----------------------------
tipTopTimeRemove(){

  ToolTip

  return
}
;------------------------------ tipTopLeftTime ------------------------------
tipTopLeftTime(msg, t := 1000){
  ; fixed boxnumber 9

  s := StrReplace(msg,"^",",")
  
  toolX := 5
  toolY := 5

  CoordMode, ToolTip, Screen
  
  ToolTip,%s%, toolX, toolY, 9
  
  duration := t * -1
  settimer,tipTopLeftTimeRemove,%duration%
  
  return
}
;--------------------------- tipTopLeftTimeRemove ---------------------------
tipTopLeftTimeRemove(){

  ToolTip,,,9

  return
}
;----------------------------------- Beep -----------------------------------
Beep(Freq, Duration) {
; example: Beep(750, 300)

    if !(DllCall("kernel32.dll\Beep", "UInt", Freq, "UInt", Duration))
        return DllCall("kernel32.dll\GetLastError")
    return 1
}
;----------------------------------- exit -----------------------------------
exit(exitCode := 1) {
    
  setTimer,exit,delete

  exitApp, exitCode
  
  return
}
;----------------------------------------------------------------------------





