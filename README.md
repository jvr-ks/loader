# Loader
Windows > 10 only!  

# **Usable, but still under construction! (BETA)**

Simple App (Autohotkey script) to run a Scala/SBT *.jar via a Windows-*.exe file.  
  
Currently I use exe4j to package the fat-jar created by sbt assembly plugin into a fat exe-file.  
(All dependent library-files are contained).   
The development of Loader aims to use only a small starter-exe-file, holding all required libraries in the lib sub-directory.  
In case of using Scala, an additional step is required to manage the dependencies,  
which are otherwise (i.e. fat-jar) handled by SBT/Cousier.  
  
The advantages over just doubleclicking the *.jar file are:  
* Checking the Java-runtime (TODO),   
* Very small footprint in case of an update (via Updater),  
* Windows users like *.exe files :-)  

Operation:  
* Uses the \[Config-file]: "loader.ini" or the command-line or both as source of configuration.  
* Checks if an approbiate Java-runtime is installed.  
* Redefinable call of Java.  
* Storing dependencies in the "lib"-subdirectory (see "Loader Scala/SBT Support" below).       
* Has no Gui-window, but an error-message may be displayed.  
* Possible changes the clipboard content!
  
#### Download via Updater (preferred method)
Portable, run from any directory, but running from a subdirectory of the windows programm-directories   
(C:\Program Files, C:\Program Files (x86) etc.)  
requires admin-rights and is not recommended!  
**Directory must be writable by the app!**
 
Create a directory, example: "C:\jvrks\loader".  
  
Download Updater from Github to the previously created directory:  
**updater.exe** 64 bit Windows use:   
[updater.exe 64bit](https://github.com/jvr-ks/loader/raw/main/updater.exe)  
or  
[updater32.exe 32bit](https://github.com/jvr-ks/loader/raw/main/updater32.exe) 
  
[Updater viruscheck see Updater repository](https://github.com/jvr-ks/updater)  
  
And optional:  
(otherwise you must enter the appname "loader" once)  
Right-click, save target as:  
[Updater configuration file: updater.ini](https://github.com/jvr-ks/loader/raw/main/updater.ini)  

* From time to time there are some false positiv virus detections
[Virusscan](#virusscan) at Virustotal see below.
  
#### Start:  
Loader can be uses with or without a configuration-file "loader.ini" (name is fixed-hardcoded).  
System-commands like "dir", "copy", "batch-scripts" etc. must be preceded by opening a command-shell with "cmd /c"!  
(Get the error-message "Create process failed" otherwise).  
**Cannot run anything requesting a command-line user input!**  
**Doing so will make Loader unresponsive!**  

Examples without a configuration-file (just for demonstration):  
* loader.exe disableIni showResult --executor="cmd /c dir /B"
* loader.exe disableIni showResult --showresulttime="10000" --executor="java -version"

[Open the example target project "pricecompare_loader"](https://github.com/jvr-ks/pricecompare_loader)  
    
#### Latest changes:  
  
Version (>=)| Change  
------------ | -------------  
0.022 | Parameter "debug" removed, always using the clipboard to copy the result
0.018 | Parameter "nojavacheck" renamed to "checkjava" manually rename \[Config-file] -> \[config] -> approbiate, app parameter is renamed to nojavacheck  
0.016 | Parameter "requiresadmin" (Config only)
0.015 | Parameter "nojavacheck"
0.014 | Show Loader-start message: \[Config-file] -> \[config] -> splash
0.012 | showresulttime (milliseconds) in the \[Config-file] (default = 5000)
0.011 | Updater support removed (Loader is not directly runnable)
0.010 | showresult as parameter or in the \[Config-file] (1 === true)
0.005 | Alpha version.  
  
#### Known issues / bugs  
  
Issue / Bug | Type | fixed in version  
------------ | ------------- | -------------  
fails to start if splash is empty  | bug | 0.015  

#### \[Config-file] "loader.ini"  
Must contain in the section "config" the classpath, the main class and optional parameters.  
(If Loader is used to start a Java-application).  
````
Example:  
[config]  
classpath="pricecompare.jar;lib\\*"  
mainclass=de.jvr.pricecompare.Pricecompare  
parameter="--urlfile=pricecompare_urls.txt"  
````

#### Commandline  / \[Config-file] parameter
It is possible to overwrite parts or all of the \[Config-file] via commandline-parameters:  
Default values:  
showresulttime=5000 (Milliseconds)  
  
\[Config-file] | Commandline | Remarks  
------------ | ------------- | -------------  
requiresadmin=1 | --- | Admin rights requested  
checkjava=0 | nojavacheck | Checking the Java-runtime can be disabled  
splash="message" | --splash="message" | Show Loader-start message  
debug=1 | debug | \*4) Show debug messages, copy the result to the clipboard, 5 seconds delay befor exiting 
--- | disableini | \[Config-file] is completely ignored  \*1)  
consoleapp=1 | consoleapp \*3) | Return result in the clipboard, use supplied ["getfromclip.exe"](https://github.com/jvr-ks/lsimpletools) to retrieve it (example -> AAA_test_consoleapp.bat).  
showresult=1 | showresult | Show result message (top-center of the screen)
showresulttime=5000 | --showresulttime="5000" | Show result / debug timeout in milliseconds, default is 5000
executor="P" | --executor="P" | the command to execute | Windows builtin commands must be called via "cmd.exe" \*3   
classpath="P" | --classpath="P" | the classpath \*2,3)  
mainclass="P" | --mainclass="P" | the mainclass \*3) 
parameter="P" | --parameter="P" | the parameter \*2,3)  
javasourceurl="P" | - | Recomended Java-runtime download page

  
**Loader just concatenates the four parts!** \*2)  
  
\*1) Otherwise the configuration is a mix of \[Config-file] and commandline-parameters,  
commandline-parameters take precedence!  
  
\*2) classpath and parameter are internally enclosed in quotation marks, executor and mainclass are not.
  
\*3) Not case sensitive, parameter P has allways an untouched case  

\*4) Debug messages (top-center of the screen): Found Java version, the command executed, the result (text only)
   
Example 1 (same as the default configuration if using the supplied \[Config-file]):  
loader.exe disableIni showResult --executor="java -cp" --classpath="pricecompare.jar;lib\\*" --mainclass="de.jvr.pricecompare.Pricecompare" --parameter="--urlfile=pricecompare_urls.txt"
  
Example 2:  
loader.exe disableIni showResult --executor="java -version"  
  
Example 2:  
loader.exe disableIni showResult  
 
#### Loader Scala/SBT Support for use with Updater
All dependencies must be supplied in the "lib"-subdirectory.  
Add the following task to your "build.sbt"-file:
````  
val printDependencyClasspath = taskKey[Unit]("Prints location of the dependencies")

printDependencyClasspath := {
  import scala.tools.nsc.io.File

  val quot = "\""
  val cp = (Compile / dependencyClasspath).value
  cp.foreach(f => {
    val pn = (f.data).toString
    val fn = (pn.split("\\\\").takeRight(1))(0)
    val pnBatch = pn.replace("%","%%")
    val fnDecoded = java.net.URLDecoder.decode(fn, java.nio.charset.StandardCharsets.UTF_8.toString())
    
    File("_CopyDependencyClasspath.bat").appendAll("copy /Y " + quot + pnBatch + quot + " "  + quot + """.\lib\""" + fnDecoded  + quot + "\n")
    File("_updaterfiles$_$_$_append.txt").appendAll(fnDecoded + ",no,,lib" + "\n")
  })
}
````  
(Default download enable of files in the "lib"-subdirectory is set to "no", missing files are forced-download by default!)  
  
Then run the batch-file "loaderScalaSupport\generateCopyDependencyClasspath.bat" once (and each time dependencies had changed).  
It runs "sbt printDependencyClasspath" in the parent directory, creating the files: "_CopyDependencyClasspath.bat" 
(must be run once afterwards) and "_updaterfiles$_$_$_append.txt" to use with Updater (another project of mine). 
Copy or move the generated files to the target-project directory!  
  
**Run the batch-files "_CopyDependencyClasspath.bat" inside a target project directory,** 
**not inside the Loader repository directory**  

"_CopyDependencyClasspath.bat" copies all dependencies from the coursier cache to the "\lib"-subdirectory.  
Manually append the content of "updaterfiles$_$_$_append.txt" to the file "updaterfiles$_$_$.txt".  
  
**Attention:**

* Does not handle unmanaged dependencies!
* Check dependencies in "_updaterfiles$_$_$_append.txt" manually, before adding them to "_updaterfiles$_$_$.txt".  
  
#### Sourcecode / Github
[Sourcecode at Github](https://github.com/jvr-ks/loader), "loader.ahk" an [Autohotkey](https://www.autohotkey.com) script.  
  
##### Hotkeys  
Loader has no hotkey defined.  
[Overview of all default Hotkeys used by my Autohotkey "tools"](https://github.com/jvr-ks/loader/blob/main/hotkeys.md)  
  
#### Issues  
**Displayed fonts etc. are to small!**  

Old Java Swing apps fail to set the correct dpi-scaling,  
especially if started from the command-line.  
Let Windows (10) do the dpi-scaling:
(Selja has a menu entry BraalVM -> Open JAVA_HOME directory)
  
- Find java.exe you installed,  
- Right click -> Properties,  
- Go to Compatibility tab,  
- Check Override high DPI scaling behavior,  
- Choose "System" for Scaling performed by.  
  
##### License: MIT  
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sub license, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Copyright (c) 2022 J. v. Roos
  
<a name="virusscan">




##### Virusscan at Virustotal 
[Virusscan at Virustotal, loader.exe 64bit-exe, Check here](https://www.virustotal.com/gui/url/870e7ec7052da6d6aa8e0171d6bb06bc973da3b330791b5c11e4af7e111c5021/detection/u-870e7ec7052da6d6aa8e0171d6bb06bc973da3b330791b5c11e4af7e111c5021-1689161172
)  
[Virusscan at Virustotal, loader32.exe 32bit-exe, Check here](https://www.virustotal.com/gui/url/757855dbdbcda3cabe7634f97f3ba8f8e5214b0d1628186d7ec1b5a794a96946/detection/u-757855dbdbcda3cabe7634f97f3ba8f8e5214b0d1628186d7ec1b5a794a96946-1689161173
)  
