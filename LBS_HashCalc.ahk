;;--- Head --- Informations --- AHK ---

;;	Compatibility: Windows Xp , Windows Vista , Windows 7 , Windows 8
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode
;;	Use as a developpement tool for AHK
;;	This entire thing (work) is a developpement tool for AHK scripting.
;;	Use an external EXE or DLL file for icon is shit load of job and the final quality is less.

;;--- Softwares Variables ---

	SetWorkingDir, %A_ScriptDir%
	#SingleInstance Force
	#Persistent
	#Warn
	#NoEnv
	;; #NoTrayIcon
	SetBatchLines, -1
	SetTitleMatchMode, Slow
	SetTitleMatchMode, 2

	SetEnv, title, LBS_HashCalc
	SetEnv, name, LBS_HashCalc
	SetEnv, mode, Get and Verify hash files and load from external file
	SetEnv, version, Version 2018-03-17-1014
	SetEnv, Author, LostByteSoft
	SetEnv, icofolder, C:\Program Files\Common Files
	SetEnv, logoicon, ico_hash.ico
	SetEnv, love, chr(9829)
	SetEnv, copyright, chr(169)
	SetEnv, pause, 0
	SetEnv, debug, 0
	SetEnv, NoCalc, 0

	;; Specific Icons (or files)
	FileInstall, ico_hash.ico, %icofolder%\ico_hash.ico, 0

	;; Common ico
	FileInstall, SharedIcons\ico_about.ico, %icofolder%\ico_about.ico, 0
	FileInstall, SharedIcons\ico_lock.ico, %icofolder%\ico_lock.ico, 0
	FileInstall, SharedIcons\ico_options.ico, %icofolder%\ico_options.ico, 0
	FileInstall, SharedIcons\ico_reboot.ico, %icofolder%\ico_reboot.ico, 0
	FileInstall, SharedIcons\ico_shut.ico, %icofolder%\ico_shut.ico, 0
	FileInstall, SharedIcons\ico_debug.ico, %icofolder%\ico_debug.ico, 0
	FileInstall, SharedIcons\ico_HotKeys.ico, %icofolder%\ico_HotKeys.ico, 0
	FileInstall, SharedIcons\ico_pause.ico, %icofolder%\ico_pause.ico, 0
	FileInstall, SharedIcons\ico_loupe.ico, %icofolder%\ico_loupe.ico, 0

;;--- Menu Tray options ---

	Menu, Tray, NoStandard
	Menu, tray, add, ---=== %title% ===---, about
	Menu, Tray, Icon, ---=== %title% ===---, %icofolder%\%logoicon%
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add, Secret MsgBox, secret					; Secret MsgBox, just show all options and variables of the program.
	Menu, Tray, Icon, Secret MsgBox, %icofolder%\ico_lock.ico
	Menu, tray, add, About && ReadMe, author
	Menu, Tray, Icon, About && ReadMe, %icofolder%\ico_about.ico
	Menu, tray, add, Author %author%, about
	menu, tray, disable, Author %author%
	Menu, tray, add, %version%, about
	menu, tray, disable, %version%
	menu, tray, add, Show Gui, start					; Default gui
	Menu, Tray, Icon, Show Gui, %icofolder%\ico_loupe.ico
	Menu, Tray, Default, Show Gui
	Menu, Tray, Click, 1
	Menu, tray, add,
	Menu, tray, add, --== Control ==--, about
	Menu, Tray, Icon, --== Control ==--, %icofolder%\ico_options.ico
	Menu, tray, add, Exit %title%, ExitApp					; Close exit program
	Menu, Tray, Icon, Exit %title%, %icofolder%\ico_shut.ico
	Menu, tray, add, Refresh (Ini mod), doReload 				; Reload the script.
	Menu, Tray, Icon, Refresh (Ini mod), %icofolder%\ico_reboot.ico
	Menu, tray, add, Set Debug (Toggle), debug
	Menu, Tray, Icon, Set Debug (Toggle), %icofolder%\ico_debug.ico
	Menu, tray, add, Pause (Toggle), pause
	Menu, Tray, Icon, Pause (Toggle), %icofolder%\ico_pause.ico
	Menu, tray, add, Open A_WorkingDir, A_WorkingDir
	Menu, tray, add,
	Menu, tray, add, --== Options ==--, about
	Menu, Tray, Icon, --== Options ==--, %icofolder%\ico_options.ico
	menu, tray, add,
	Menu, Tray, Tip, %mode%
	Menu, Tray, Icon, %icofolder%\ico_hash.ico

;;--- Software start here ---

	TrayTip, %title%, Escape will exit !, 1, 2

start:

	Gui, Destroy		;; some errors appears some times, needed

Gui, Margin, 10, 10
Gui, Font, s9, Courier New

Gui, Add, Text, x5 y5 w100 h15 , Data Format:

Gui, Add, Text, x115 y5 w390 h15 , Data:


Gui, Add, DropDownList, x5 y26 w100 h23 , File
Gui, Add, DropDownList, x5 y26 w100 h23 AltSubmit vDDL, Text String||Hex|File

Gui, Add, Edit, x115 y26 w390 h23  vStr,
Gui, Add, Button, x508 y26 w80 h23 gFile vFile, File

Gui, Add, Checkbox, x5 y55 w100 h23 vCheck, HMAC
Gui, Add, Edit, x115 y55 w390 h23 vHMAC,

Gui, Add, Button, x508 y56 w80 h23 gCalculate, Calculate

;;--- checksum ---

Gui, Add, Checkbox, x5 y99 w100 h23 vCheckCRC32, CRC32

Gui, Add, Edit, x115 y99 w390 h23 0x800 vCRC32, 

Gui, Add, Button, x508 y99 w80 h23 gCopyCRC32 vCopyCRC32, Copy

Gui, Add, Checkbox, x5 y128 w100 h23 vCheckMD2, MD2
Gui, Add, Edit, x115 y128 w390 h23 0x800 vMD2, 

Gui, Add, Button, x508 y128 w80 h23 gCopyMD2 vCopyMD2, Copy

Gui, Add, Checkbox, x5 y157 w100 h23 vCheckMD4, MD4
Gui, Add, Edit, x115 y157 w390 h23 0x800 vMD4,
Gui, Add, Button, x508 y157 w80 h23 gCopyMD4 vCopyMD4, Copy

Gui, Add, Checkbox, x5 y186 w100 h23 Checked vCheckMD5, MD5

Gui, Add, Edit, x115 y186 w390 h23 0x800 vMD5, 

Gui, Add, Button, x508 y186 w80 h23 gCopyMD5 vCopyMD5, Copy

Gui, Add, Checkbox, x5 y215 w100 h23 Checked vCheckSHA, SHA-1
Gui, Add, Edit, x115 y215 w390 h23 0x800 vSHA,
Gui, Add, Button, x508 y215 w80 h23 gCopySHA vCopySHA, Copy

Gui, Add, Checkbox, x5 y244 w100 h23 vCheckSHA2, SHA-256
Gui, Add, Edit, x115 y244 w390 h23 0x800 vSHA2, 

Gui, Add, Button, x508 y244 w80 h23 gCopySHA2 vCopySHA2, Copy

Gui, Add, Checkbox, x5 y273 w100 h23 vCheckSHA3, SHA-384
Gui, Add, Edit, x115 y273 w390 h23 vSHA3,

Gui, Add, Button, x508 y273 w80 h23 gCopySHA3 vCopySHA3, Copy

Gui, Add, Checkbox, x5 y302 w100 h23 vCheckSHA5, SHA-512
Gui, Add, Edit, x115 y302 w390 h23 vSHA5,

Gui, Add, Button, x508 y302 w80 h23 gCopySHA5 vCopySHA5, Copy
Gui, Add, Text, x5 y335 w584 h2 0x10

;;--- verification ---

Gui, Add, Text, x5 y346 w100 h23 , Verify

Gui, Add, Edit, x115 y346 w390 h23 vVerify,
Gui, Add, Edit, x508 y346 w80 h23 0x800 vHashOK,
Gui, Add, Text, x5 y379 w584 h2 0x10

Gui, Font, cSilver,
Gui, Add, Text, x5 y390 w300 h21 , made with %love% and AHK 2013-%A_YYYY%, jNizM

Gui, Font,,


Gui, Add, Button, x338 y384 w80 h23 gload, Load
Gui, Add, Button, x421 y384 w80 h23 gClear, Clear
Gui, Add, Button, x504 y384 w80 h23 gClose, Close

Gui, Show, AutoSize, %name% %version%

;;--- Gui buttons & control ---

SetTimer, CheckEdit, 100
SetTimer, VerifyHash, 200
return

Load:
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before loading a file !
	FileSelectFile, OutputVar,2 ,, Select a file to load... (ESC to quit) HashCalc, (*.crc32; *.md2; *.md4; *.md5; *.sha-1; sha-256; *.sha-384; *.sha-512)
		if ErrorLevel
			goto, Start

	IfEqual, OutputVar, , Goto, start
	Test := OutputVar
	SplitPath, Test,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, BACK :`n`nOutputVar=%OutputVar%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	FileReadLine, Loadhash, %OutputVar%, 1
	IfEqual, debug, 1, msgbox, LoadFile=%OutputVar% LoadHash=%Loadhash%

	GuiControl,,Verify, %Loadhash%

return

GuiDropFiles:
    FilePath := A_GuiEvent
    GuiControl,, Str, % FilePath
    GuiControl, Choose, DDL, 3
return

CheckEdit:
    Gui, Submit, NoHide
    if (DDL = 1)
    {
        GuiControl, % Check = "0" ? "Disable" : "Enable",  HMAC
        GuiControl, % DDL   = "1" ? "Enable"  : "Disable", Check
    }
    if (DDL = 2)
    {
        GuiControl, % DDL   = "2" ? "Disable" : "Enable",  HMAC
        GuiControl, % DDL   = "2" ? "Disable" : "Enable",  Check
        GuiControl, % DDL   = "2" ? "Enable"  : "Disable", File
    }
    if (DDL = 3)
    {
        GuiControl, % DDL   = "3" ? "Disable" : "Enable",  HMAC
        GuiControl, % DDL   = "3" ? "Disable" : "Enable",  Check
        GuiControl, % DDL   = "3" ? "Enable"  : "Disable", File
    }
    GuiControl, % Check = "1" ? "Disable" : "Enable",  CheckCRC32
    GuiControl, % CRC32 = ""  ? "Disable" : "Enable",  CopyCRC32
    GuiControl, % MD2   = ""  ? "Disable" : "Enable",  CopyMD2
    GuiControl, % MD4   = ""  ? "Disable" : "Enable",  CopyMD4
    GuiControl, % MD5   = ""  ? "Disable" : "Enable",  CopyMD5
    GuiControl, % SHA   = ""  ? "Disable" : "Enable",  CopySHA
    GuiControl, % SHA2  = ""  ? "Disable" : "Enable",  CopySHA2
    GuiControl, % SHA3  = ""  ? "Disable" : "Enable",  CopySHA3
    GuiControl, % SHA5  = ""  ? "Disable" : "Enable",  CopySHA5
return

File:
    GuiControl, Choose, DDL, 3
    FileSelectFile, File
    GuiControl,, Str, %File%
return

Calculate:
    Gui, Submit, NoHide
    GuiControl,, CRC32, % ((CheckCRC32 = "1") ? ((DDL = "1") ? ((Check = "0") ? (CRC32(Str))  : "")                          : ((DDL = "2") ? (HexCRC32(Str))  : (FileCRC32(Str))))  : (""))
    GuiControl,, MD2,   % ((CheckMD2   = "1") ? ((DDL = "1") ? ((Check = "0") ? (MD2(Str))    : (HMAC(HMAC, Str, "MD2")))    : ((DDL = "2") ? (HexMD2(Str))    : (FileMD2(Str))))    : (""))
    GuiControl,, MD4,   % ((CheckMD4   = "1") ? ((DDL = "1") ? ((Check = "0") ? (MD4(Str))    : (HMAC(HMAC, Str, "MD4")))    : ((DDL = "2") ? (HexMD4(Str))    : (FileMD4(Str))))    : (""))
    GuiControl,, MD5,   % ((CheckMD5   = "1") ? ((DDL = "1") ? ((Check = "0") ? (MD5(Str))    : (HMAC(HMAC, Str, "MD5")))    : ((DDL = "2") ? (HexMD5(Str))    : (FileMD5(Str))))    : (""))
    GuiControl,, SHA,   % ((CheckSHA   = "1") ? ((DDL = "1") ? ((Check = "0") ? (SHA(Str))    : (HMAC(HMAC, Str, "SHA")))    : ((DDL = "2") ? (HexSHA(Str))    : (FileSHA(Str))))    : (""))
    GuiControl,, SHA2,  % ((CheckSHA2  = "1") ? ((DDL = "1") ? ((Check = "0") ? (SHA256(Str)) : (HMAC(HMAC, Str, "SHA256"))) : ((DDL = "2") ? (HexSHA256(Str)) : (FileSHA256(Str)))) : (""))
    GuiControl,, SHA3,  % ((CheckSHA3  = "1") ? ((DDL = "1") ? ((Check = "0") ? (SHA384(Str)) : (HMAC(HMAC, Str, "SHA384"))) : ((DDL = "2") ? (HexSHA384(Str)) : (FileSHA384(Str)))) : (""))
    GuiControl,, SHA5,  % ((CheckSHA5  = "1") ? ((DDL = "1") ? ((Check = "0") ? (SHA512(Str)) : (HMAC(HMAC, Str, "SHA512"))) : ((DDL = "2") ? (HexSHA512(Str)) : (FileSHA512(Str)))) : (""))
return

Clear:
    GuiControl,, Str,
    GuiControl,, HMAC,
    GuiControl,, CRC32,
    GuiControl,, MD2,
    GuiControl,, MD4,
    GuiControl,, MD5,
    GuiControl,, SHA,
    GuiControl,, SHA2,
    GuiControl,, SHA3,
    GuiControl,, SHA5,
    GuiControl,, Verify,
return

VerifyHash:
    Gui, Submit, NoHide
    Result := Hashify(Verify, CRC32, MD2, MD4, MD5, SHA, SHA2, SHA3, SHA5)
    GuiControl, % (InStr(Result, "OK") ? "+c008000" : "+c800000"), HashOK
    GuiControl,, HashOk, %Result%
return

CopyCRC32:
    Clipboard := CRC32
return

CopyMD2:
    Clipboard := MD2
return

CopyMD4:
    Clipboard := MD4
return

CopyMD5:
    Clipboard := MD5
return

CopySHA:
    Clipboard := SHA
return

CopySHA2:
    Clipboard := SHA2
return

CopySHA3:
    Clipboard := SHA3
return

CopySHA5:
    Clipboard := SHA5
return

;;--- Functions ---

#include Include_Functions.ahk

;;--- Tray Bar (must be at end of file) ---

secret:
	FileReadLine, ExternalIP, ip.txt, 1
	SetEnv, ExternalIPnew, %ExternalIP%
	MsgBox, 64, %title%, (Secret:) All variables is shown here.`n`ntitle=%title% mode=%mode% version=%version% author=%author% LogoIcon=%logoicon% Debug=%debug%`n`nA_WorkingDir=%A_WorkingDir%`nIcoFolder=%icofolder%`n`nClipboard (if text)=%clipboard%
	Return

about:
	TrayTip, %title%, %mode% by %author%, 2, 1
	Sleep, 500
	Return

version:
	TrayTip, %title%, %version%, 2, 2
	Sleep, 500
	Return

Author:
	MsgBox, 64, %title%, (Author:) %title% %mode% %version% %author% This software is usefull to calculate a hash of a file. A file (ex: md5.txt contail only a string of a hash of a file)`n`n`tGo to https://github.com/LostByteSoft
	Return

Debug:
	IfEqual, debug, 0, goto, enable
	IfEqual, debug, 1, goto, disable

	enable:
		SetEnv, debug, 1
		TrayTip, %title%, Activated ! debug=%debug%, 1, 2
		Goto, start

	disable:
		SetEnv, debug, 0
		TrayTip, %title%, Deactivated ! debug=%debug%, 1, 2
		Goto, start

pause:
	Ifequal, pause, 0, goto, paused
	Ifequal, pause, 1, goto, unpaused

	paused:
		Menu, Tray, Icon, %icofolder%\ico_pause.ico
		SetEnv, pause, 1
		goto, start

	unpaused:
		Menu, Tray, Icon, %icofolder%\%logoicon%
		SetEnv, pause, 0
		Goto, start

Escape::
	ExitApp

GuiClose:
	Gui, destroy
	ExitApp

ExitApp:
	Gui, destroy
	ExitApp

doReload:
	Gui, destroy
	Reload
	ExitApp

Close:
	Gui, destroy
	ExitApp

GuiLogo:
	Gui, 4:Add, Picture, x25 y25 w400 h400, %icofolder%\%logoicon%
	Gui, 4:Show, w450 h450, %title% Logo
	Gui, 4:Color, 000000
	Gui, 4:-MinimizeBox
	Sleep, 500
	Return

	4GuiClose:
	Gui 4:Cancel
	return

A_WorkingDir:
	IfEqual, debug, 1, msgbox, (A_WorkingDir:) run explorer.exe "%A_WorkingDir%"
	run, explorer.exe "%A_WorkingDir%"
	Return

;;--- End of script ---
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   Version 3.14159265358979323846264338327950288419716939937510582
;                          March 2017
;
; Everyone is permitted to copy and distribute verbatim or modified
; copies of this license document, and changing it is allowed as long
; as the name is changed.
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
;
;              You just DO WHAT THE FUCK YOU WANT TO.
;
;		     NO FUCKING WARRANTY AT ALL
;
;	As is customary and in compliance with current global and
;	interplanetary regulations, the author of these pages disclaims
;	all liability for the consequences of the advice given here,
;	in particular in the event of partial or total destruction of
;	the material, Loss of rights to the manufacturer's warranty,
;	electrocution, drowning, divorce, civil war, the effects of
;	radiation due to atomic fission, unexpected tax recalls or
;	    encounters with extraterrestrial beings 'elsewhere.
;
;      LostByteSoft no copyright or copyleft we are in the center.
;
;	If you are unhappy with this software i do not care.
;
;;--- End of file ---