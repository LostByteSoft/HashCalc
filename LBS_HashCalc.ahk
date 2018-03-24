;;--- Head --- Informations --- AHK ---

;;	Compatibility: Windows Xp , Windows Vista , Windows 7 , Windows 8
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode
;;	Use as a developpement tool for AHK
;;	This entire thing (work) is a developpement tool for AHK scripting.
;;	Use an external EXE or DLL file for icon is shit load of job and the final quality is less.
;;	Windows 10 have NO icons but is compatible

;;--- Softwares Variables ---

	SetWorkingDir, %A_ScriptDir%
	#Persistent
	;; #Warn
	#NoEnv

	SetBatchLines, -1
	SetTitleMatchMode, Slow
	SetTitleMatchMode, 2

	SetEnv, title, LBS_HashCalc
	SetEnv, name, LBS_HashCalc
	SetEnv, mode, Verify hash files Creator and load from external file
	SetEnv, version, Version 2018-03-24-1551
	SetEnv, Author, LostByteSoft
	SetEnv, icofolder, C:\Program Files\Common Files
	SetEnv, logoicon, ico_hash.ico
	SetEnv, pause, 0
	SetEnv, debug, 0
	SetEnv, NoCalc, 1
	SetEnv, NoIcons, 0
	SetEnv, Loadhash, 0
	SetEnv, reimage, 0
	SetENv, clickfile, 0

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
	FileInstall, SharedIcons\ico_folder.ico, %icofolder%\ico_folder.ico, 0

;;--- Menu Tray options ---

	Menu, Tray, NoStandard
	Menu, tray, add, ---=== %title% ===---, about
	Menu, Tray, Icon, ---=== %title% ===---, %icofolder%\%logoicon%
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add, Secret MsgBox, secret					; Secret MsgBox, just show all options and variables of the program.
	Menu, Tray, Icon, Secret MsgBox, %icofolder%\ico_lock.ico
	Menu, tray, add, About && ReadMe, author				; infos about author
	Menu, Tray, Icon, About && ReadMe, %icofolder%\ico_about.ico
	Menu, tray, add, Author %author%, about					; author msg box
	menu, tray, disable, Author %author%
	Menu, tray, add, %version%, about					; version of the software
	menu, tray, disable, %version%
	Menu, tray, add, Open project web page, webpage				; open web page project
	Menu, Tray, Icon, Open project web page, %icofolder%\ico_HotKeys.ico
	Menu, tray, add,
	Menu, tray, add, --== Control ==--, about
	Menu, Tray, Icon, --== Control ==--, %icofolder%\ico_options.ico
	menu, tray, add, Show Gui (Same as click), start			; Default gui open
	Menu, Tray, Icon, Show Gui (Same as click), %icofolder%\ico_loupe.ico
	Menu, Tray, Default, Show Gui (Same as click)
	Menu, Tray, Click, 1
	Menu, tray, add, Set Debug (Toggle), debug				; debug msg
	Menu, Tray, Icon, Set Debug (Toggle), %icofolder%\ico_debug.ico
	Menu, tray, add, Open A_WorkingDir, A_WorkingDir			; open where the exe is
	Menu, Tray, Icon, Open A_WorkingDir, %icofolder%\ico_folder.ico
	Menu, tray, add,
	Menu, tray, add, Exit %title%, ExitApp					; Close exit program
	Menu, Tray, Icon, Exit %title%, %icofolder%\ico_shut.ico
	Menu, tray, add, Refresh (Ini mod), doReload 				; Reload the script.
	Menu, Tray, Icon, Refresh (Ini mod), %icofolder%\ico_reboot.ico
	Menu, tray, add, Pause (Toggle), pause					; pause the script
	Menu, Tray, Icon, Pause (Toggle), %icofolder%\ico_pause.ico
	Menu, tray, add,
	Menu, tray, add, --== Options ==--, about
	Menu, Tray, Icon, --== Options ==--, %icofolder%\ico_options.ico
	Menu, tray, add, 1 - File, File
	Menu, tray, add, 2 - Calculate, Calculate
	Menu, tray, add, 3 - Load File, LoadFile
	Menu, tray, add, 4 - Clear, Clear
	menu, tray, add,
	Menu, Tray, Tip, %mode%
	IfEqual, noicons, 1, goto, skip11
	Menu, Tray, Icon, %icofolder%\ico_hash.ico
	skip11:

;;--- Software start here ---

	TrayTip, %title%, Escape will exit !, 1, 2

start:
	Gui, Destroy					;; some errors appears some times, needed
	Gui, Margin, 10, 10
	Gui, Font, s9, Courier New
	Gui, Add, Text, x5 y5 w100 h15 , Data Format:

	Gui, Add, Text, x145 y5 w90 h15 , Path file:
	Gui, Add, Text, x465 y5 w350 h15 , Don't forget: bigger file must use more ram.
	Gui, Add, DropDownList, x5 y26 AltSubmit vDDL, Text String|Hex|File
	Gui, Add, Edit, x145 y26 w360 h23  vStr,
	Gui, Add, Button, x508 y26 w80 h23 gFile vFile, File
	Gui, Add, Checkbox, x5 y55 w100 h23 vCheck, HMAC
	Gui, Add, Edit, x115 y55 w390 h23 vHMAC,
	Gui, Add, Button, x598 y26 w180 h70 gCalculate, Calculate
	Gui, Add, Text, x115 y80 w65 h15 , Hash:
	Gui, Add, Text, x515 y80 w65 h15 , Clipboard
	Gui, Add, Checkbox, x5 y99 w100 h23 vCheckCRC32, CRC32

	Gui, Add, Edit, x115 y99 w390 h23 0x800 vCRC32, 

	Gui, Add, Button, x508 y99 w80 h23 gCopyCRC32 vCopyCRC32, Copy
	Gui, Add, Button, x598 y99 w90 h23, CreateCRC32
	Gui, Add, Button, x688 y99 w90 h23, LoadCRC32
	Gui, Add, Checkbox, x5 y128 w100 h23 vCheckMD2, MD2
	Gui, Add, Edit, x115 y128 w390 h23 0x800 vMD2, 

	Gui, Add, Button, x508 y128 w80 h23 gCopyMD2 vCopyMD2, Copy
	Gui, Add, Button, x598 y128 w90 h23, CreateMD2
	Gui, Add, Button, x688 y128 w90 h23, LoadMD2
	Gui, Add, Checkbox, x5 y157 w100 h23 vCheckMD4, MD4
	Gui, Add, Edit, x115 y157 w390 h23 0x800 vMD4,
	Gui, Add, Button, x508 y157 w80 h23 gCopyMD4 vCopyMD4, Copy
	Gui, Add, Button, x598 y157 w90 h23, CreateMD4
	Gui, Add, Button, x688 y157 w90 h23, LoadMD4
	Gui, Add, Checkbox, x5 y186 w100 h23 Checked vCheckMD5, MD5

	Gui, Add, Edit, x115 y186 w390 h23 0x800 vMD5, 

	Gui, Add, Button, x508 y186 w80 h23 gCopyMD5 vCopyMD5, Copy
	Gui, Add, Button, x598 y186 w90 h23, CreateMD5
	Gui, Add, Button, x688 y186 w90 h23, LoadMD5
	Gui, Add, Checkbox, x5 y215 w100 h23 Checked vCheckSHA, SHA-1
	Gui, Add, Edit, x115 y215 w390 h23 0x800 vSHA,
	Gui, Add, Button, x508 y215 w80 h23 gCopySHA vCopySHA, Copy
	Gui, Add, Button, x598 y215 w90 h23, CreateSHA1
	Gui, Add, Button, x688 y215 w90 h23, LoadSHA1
	Gui, Add, Checkbox, x5 y244 w100 h23 vCheckSHA2, SHA-256
	Gui, Add, Edit, x115 y244 w390 h23 0x800 vSHA2, 

	Gui, Add, Button, x508 y244 w80 h23 gCopySHA2 vCopySHA2, Copy
	Gui, Add, Button, x598 y244 w90 h23, CreateSHA256
	Gui, Add, Button, x688 y244 w90 h23, LoadSHA256
	Gui, Add, Checkbox, x5 y273 w100 h23 vCheckSHA3, SHA-384
	Gui, Add, Edit, x115 y273 w390 h23 0x800 vSHA3,

	Gui, Add, Button, x508 y273 w80 h23 gCopySHA3 vCopySHA3, Copy
	Gui, Add, Button, x598 y273 w90 h23, CreateSHA384
	Gui, Add, Button, x688 y273 w90 h23, LoadSHA384
	Gui, Add, Checkbox, x5 y302 w100 h23 vCheckSHA5, SHA-512
	Gui, Add, Edit, x115 y302 w390 h23 0x800 vSHA5,

	Gui, Add, Button, x508 y302 w80 h23 gCopySHA5 vCopySHA5, Copy
	Gui, Add, Button, x598 y302 w90 h23, CreateSHA512
	Gui, Add, Button, x688 y302 w90 h23, LoadSHA512
	Gui, Add, Text, xm y340 w760 h1 0x10
	Gui, Add, Text, x5 y366 w100 h23 , Verify

	Gui, Add, Edit, x115 y366 w390 h23 vVerify,
	Gui, Add, Edit, x508 y366 w80 h23 0x800 vHashOK,
	Gui, Add, Button, x598 y366 w90 h23 gloadFile, LoadFile
	Gui, Add, Button, x688 y366 w90 h23 gClear, Clear
	Gui, Add, Button, x598 y394 w180 h23 gClose, Close
	Gui, Add, Checkbox, x5 y400 w350 h23 vReImage checked, Auto-Load highest hash file if exist.
	Gui, Add, Text, x5 y425 w500 h21 , Made with AHK 2013-%A_YYYY%, jNizM
 and %author% %version%
	Gui, Add, Text, x625 y435 w200 h21 , Escape will quit !
	Gui, Show, AutoSize, %title% %mode%

	SetTimer, CheckEdit, 100
	SetTimer, VerifyHash, 200
	return


;;--- Gui buttons & control ---

Checkautoload:
	;;MsgBox, (Checkautoload) File=%File%
	OutputVar := file
	Test := file
	SplitPath, Test,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, BACK :`n`nOutputVar=%OutputVar%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	Gui, Submit, NoHide
	GuiControlGet, CheckSHA51,, CheckSHA5
	GuiControlGet, CheckSHA31,, CheckSHA3
	GuiControlGet, CheckSHA21,, CheckSHA2
	GuiControlGet, CheckSHA11,, CheckSHA
	GuiControlGet, Checkmd51,, Checkmd5
	GuiControlGet, Checkmd41,, Checkmd4
	GuiControlGet, Checkmd21,, Checkmd2
	GuiControlGet, Checkcrc321,, Checkcrc32
	IfEqual, debug, 1, msgbox, Checkcrc32=%Checkcrc321% Checkmd2=%Checkmd21% Checkmd4=%Checkmd41% Checkmd5=%Checkmd51% CheckSHA1=%CheckSHA11% CheckSHA2=%CheckSHA21% CheckSHA3=%CheckSHA31% CheckSHA5=%CheckSHA51%
	IfEqual, CheckSHA51, 0, goto, next1
	IfExist, %dir%\%name_no_ext%.sha512, goto, ButtonLoadsha512
	next1:
	IfEqual, CheckSHA31, 0, goto, next2
	IfExist, %dir%\%name_no_ext%.sha384, goto, ButtonLoadsha384
	next2:
	IfEqual, CheckSHA11, 0, goto, next3
	IfExist, %dir%\%name_no_ext%.sha1, goto, ButtonLoadsha1
	next3:
	IfEqual, Checkmd51, 0, goto, next4
	IfExist, %dir%\%name_no_ext%.md5, goto, ButtonLoadMD5
	next4:
	IfEqual, CheckSHA41, 0, goto, next5
	IfExist, %dir%\%name_no_ext%.md4, goto, ButtonLoadMD4
	next5:
	IfEqual, CheckSHA21, 0, goto, next6
	IfExist, %dir%\%name_no_ext%.md2, goto, ButtonLoadMD2
	next6:
	IfEqual, Checkcrc321, 0, goto, next7
	IfExist, %dir%\%name_no_ext%.crc32, goto, ButtonLoadcrc32
	next7:
	Return

LoadFile:
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before loading a file !
	IfEqual, NoCalc, 1, Return
	FileSelectFile, OutputVar,2 ,, Select a file to load... (ESC to quit) HashCalc, (*.txt; *.crc32; *.md2; *.md4; *.md5; *.sha1; sha256; *.sha384; *.sha512)
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
	SetENv, clickfile, 1
	GuiControl, Choose, DDL, 3
	FileSelectFile, File
	GuiControl,, Str, %File%
	return

Calculate:
	IfEqual, clickfile, 0, MsgBox, Load a file before calculate !
	IfEqual, clickfile, 0, return
	SetEnv, NoCalc, 0
	Gui, Submit, NoHide
		GuiControl,, CRC32, % ((CheckCRC32 = "1") ? ((DDL = "1") ? ((Check = "0") ? (CRC32(Str))  : "")                          : ((DDL = "2") ? (HexCRC32(Str))  : (FileCRC32(Str))))  : (""))
		GuiControl,, MD2,   % ((CheckMD2   = "1") ? ((DDL = "1") ? ((Check = "0") ? (MD2(Str))    : (HMAC(HMAC, Str, "MD2")))    : ((DDL = "2") ? (HexMD2(Str))    : (FileMD2(Str))))    : (""))
		GuiControl,, MD4,   % ((CheckMD4   = "1") ? ((DDL = "1") ? ((Check = "0") ? (MD4(Str))    : (HMAC(HMAC, Str, "MD4")))    : ((DDL = "2") ? (HexMD4(Str))    : (FileMD4(Str))))    : (""))
		GuiControl,, MD5,   % ((CheckMD5   = "1") ? ((DDL = "1") ? ((Check = "0") ? (MD5(Str))    : (HMAC(HMAC, Str, "MD5")))    : ((DDL = "2") ? (HexMD5(Str))    : (FileMD5(Str))))    : (""))
		GuiControl,, SHA,   % ((CheckSHA   = "1") ? ((DDL = "1") ? ((Check = "0") ? (SHA(Str))    : (HMAC(HMAC, Str, "SHA")))    : ((DDL = "2") ? (HexSHA(Str))    : (FileSHA(Str))))    : (""))
		GuiControl,, SHA2,  % ((CheckSHA2  = "1") ? ((DDL = "1") ? ((Check = "0") ? (SHA256(Str)) : (HMAC(HMAC, Str, "SHA256"))) : ((DDL = "2") ? (HexSHA256(Str)) : (FileSHA256(Str)))) : (""))
		GuiControl,, SHA3,  % ((CheckSHA3  = "1") ? ((DDL = "1") ? ((Check = "0") ? (SHA384(Str)) : (HMAC(HMAC, Str, "SHA384"))) : ((DDL = "2") ? (HexSHA384(Str)) : (FileSHA384(Str)))) : (""))
		GuiControl,, SHA5,  % ((CheckSHA5  = "1") ? ((DDL = "1") ? ((Check = "0") ? (SHA512(Str)) : (HMAC(HMAC, Str, "SHA512"))) : ((DDL = "2") ? (HexSHA512(Str)) : (FileSHA512(Str)))) : (""))
	;;if autoload goto autoload
	GuiControlGet, ReImage,, Reimage
	IfEqual, debug, 1, msgbox, reimage=%reimage%
	IfEqual, reimage, 1, goto, Checkautoload
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
	SetEnv, NoCalc, 1
	SetEnv, NoIcons, 0
	SetEnv, Loadhash, 0
	SetEnv, reimage, 0
	SetENv, clickfile, 0
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

; FUNCTIONS =========================================================================


;; THANKS TO jNizM/HashCalc
;; https://github.com/jNizM/HashCalc


; FUNCTIONS =========================================================================

; Verify ============================================================================
Hashify(Hash, CRC32, MD2, MD4, MD5, SHA, SHA2, SHA3, SHA5)
{
    return % (Hash = "")    ? ""
           : (Hash = CRC32) ? ("CRC32 OK")
           : (Hash = MD2)   ? ("MD2 OK")
           : (Hash = MD4)   ? ("MD4 OK")
           : (Hash = MD5)   ? ("MD5 OK")
           : (Hash = SHA)   ? ("SHA1 OK")
           : (Hash = SHA2)  ? ("SHA256 OK")
           : (Hash = SHA3)  ? ("SHA384 OK")
           : (Hash = SHA5)  ? ("SHA512 OK")
           : "FALSE"
}

; HMAC ==============================================================================
HMAC(Key, Message, Algo := "MD5")
{
    static Algorithms := {MD2:    {ID: 0x8001, Size:  64}
                        , MD4:    {ID: 0x8002, Size:  64}
                        , MD5:    {ID: 0x8003, Size:  64}
                        , SHA:    {ID: 0x8004, Size:  64}
                        , SHA256: {ID: 0x800C, Size:  64}
                        , SHA384: {ID: 0x800D, Size: 128}
                        , SHA512: {ID: 0x800E, Size: 128}}
    static iconst := 0x36
    static oconst := 0x5C
    if (!(Algorithms.HasKey(Algo)))
    {
        return ""
    }
    Hash := KeyHashLen := InnerHashLen := ""
    HashLen := 0
    AlgID := Algorithms[Algo].ID
    BlockSize := Algorithms[Algo].Size
    MsgLen := StrPut(Message, "UTF-8") - 1
    KeyLen := StrPut(Key, "UTF-8") - 1
    VarSetCapacity(K, KeyLen + 1, 0)
    StrPut(Key, &K, KeyLen, "UTF-8")
    if (KeyLen > BlockSize)
    {
        CalcAddrHash(&K, KeyLen, AlgID, KeyHash, KeyHashLen)
    }

    VarSetCapacity(ipad, BlockSize + MsgLen, iconst)
    Addr := KeyLen > BlockSize ? &KeyHash : &K
    Length := KeyLen > BlockSize ? KeyHashLen : KeyLen
    i := 0
    while (i < Length)
    {
        NumPut(NumGet(Addr + 0, i, "UChar") ^ iconst, ipad, i, "UChar")
        i++
    }
    if (MsgLen)
    {
        StrPut(Message, &ipad + BlockSize, MsgLen, "UTF-8")
    }
    CalcAddrHash(&ipad, BlockSize + MsgLen, AlgID, InnerHash, InnerHashLen)

    VarSetCapacity(opad, BlockSize + InnerHashLen, oconst)
    Addr := KeyLen > BlockSize ? &KeyHash : &K
    Length := KeyLen > BlockSize ? KeyHashLen : KeyLen
    i := 0
    while (i < Length)
    {
        NumPut(NumGet(Addr + 0, i, "UChar") ^ oconst, opad, i, "UChar")
        i++
    }
    Addr := &opad + BlockSize
    i := 0
    while (i < InnerHashLen)
    {
        NumPut(NumGet(InnerHash, i, "UChar"), Addr + i, 0, "UChar")
        i++
    }
    return CalcAddrHash(&opad, BlockSize + InnerHashLen, AlgID)
}

; MD2 ===============================================================================
MD2(string, encoding = "UTF-8")
{
    return CalcStringHash(string, 0x8001, encoding)
}
HexMD2(hexstring)
{
    return CalcHexHash(hexstring, 0x8001)
}
FileMD2(filename)
{
    return CalcFileHash(filename, 0x8001, 64 * 1024)
}
; MD4 ===============================================================================
MD4(string, encoding = "UTF-8")
{
    return CalcStringHash(string, 0x8002, encoding)
}
HexMD4(hexstring)
{
    return CalcHexHash(hexstring, 0x8002)
}
FileMD4(filename)
{
    return CalcFileHash(filename, 0x8002, 64 * 1024)
}
; MD5 ===============================================================================
MD5(string, encoding = "UTF-8")
{
    return CalcStringHash(string, 0x8003, encoding)
}
HexMD5(hexstring)
{
    return CalcHexHash(hexstring, 0x8003)
}
FileMD5(filename)
{
    return CalcFileHash(filename, 0x8003, 64 * 1024)
}
; SHA ===============================================================================
SHA(string, encoding = "UTF-8")
{
    return CalcStringHash(string, 0x8004, encoding)
}
HexSHA(hexstring)
{
    return CalcHexHash(hexstring, 0x8004)
}
FileSHA(filename)
{
    return CalcFileHash(filename, 0x8004, 64 * 1024)
}
; SHA256 ============================================================================
SHA256(string, encoding = "UTF-8")
{
    return CalcStringHash(string, 0x800c, encoding)
}
HexSHA256(hexstring)
{
    return CalcHexHash(hexstring, 0x800c)
}
FileSHA256(filename)
{
    return CalcFileHash(filename, 0x800c, 64 * 1024)
}
; SHA384 ============================================================================
SHA384(string, encoding = "UTF-8")
{
    return CalcStringHash(string, 0x800d, encoding)
}
HexSHA384(hexstring)
{
    return CalcHexHash(hexstring, 0x800d)
}
FileSHA384(filename)
{
    return CalcFileHash(filename, 0x800d, 64 * 1024)
}
; SHA512 ============================================================================
SHA512(string, encoding = "UTF-8")
{
    return CalcStringHash(string, 0x800e, encoding)
}
HexSHA512(hexstring)
{
    return CalcHexHash(hexstring, 0x800e)
}
FileSHA512(filename)
{
    return CalcFileHash(filename, 0x800e, 64 * 1024)
}

; CalcAddrHash ======================================================================
CalcAddrHash(addr, length, algid, byref hash = 0, byref hashlength = 0)
{
    static h := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, "a", "b", "c", "d", "e", "f"]
    static b := h.minIndex()
    hProv := hHash := o := ""
    if (DllCall("advapi32\CryptAcquireContext", "Ptr*", hProv, "Ptr", 0, "Ptr", 0, "UInt", 24, "UInt", 0xf0000000))
    {
        if (DllCall("advapi32\CryptCreateHash", "Ptr", hProv, "UInt", algid, "UInt", 0, "UInt", 0, "Ptr*", hHash))
        {
            if (DllCall("advapi32\CryptHashData", "Ptr", hHash, "Ptr", addr, "UInt", length, "UInt", 0))
            {
                if (DllCall("advapi32\CryptGetHashParam", "Ptr", hHash, "UInt", 2, "Ptr", 0, "UInt*", hashlength, "UInt", 0))
                {
                    VarSetCapacity(hash, hashlength, 0)
                    if (DllCall("advapi32\CryptGetHashParam", "Ptr", hHash, "UInt", 2, "Ptr", &hash, "UInt*", hashlength, "UInt", 0))
                    {
                        loop % hashlength
                        {
                            v := NumGet(hash, A_Index - 1, "UChar")
                            o .= h[(v >> 4) + b] h[(v & 0xf) + b]
                        }
                    }
                }
            }
            DllCall("advapi32\CryptDestroyHash", "Ptr", hHash)
        }
        DllCall("advapi32\CryptReleaseContext", "Ptr", hProv, "UInt", 0)
    }
    return o
}

; CalcStringHash ====================================================================
CalcStringHash(string, algid, encoding = "UTF-8", byref hash = 0, byref hashlength = 0)
{
    chrlength := (encoding = "CP1200" || encoding = "UTF-16") ? 2 : 1
    length := (StrPut(string, encoding) - 1) * chrlength
    VarSetCapacity(data, length, 0)
    StrPut(string, &data, floor(length / chrlength), encoding)
    return CalcAddrHash(&data, length, algid, hash, hashlength)
}

; CalcHexHash =======================================================================
CalcHexHash(hexstring, algid)
{
    length := StrLen(hexstring) // 2
    VarSetCapacity(data, length, 0)
    loop % length
    {
        NumPut("0x" SubStr(hexstring, 2 * A_Index -1, 2), data, A_Index - 1, "Char")
    }
    return CalcAddrHash(&data, length, algid)
}

; CalcFileHash ======================================================================
CalcFileHash(filename, algid, continue = 0, byref hash = 0, byref hashlength = 0)
{
    fpos := ""
    if (!(f := FileOpen(filename, "r")))
    {
        return
    }
    f.pos := 0
    if (!continue && f.length > 0x7fffffff)
    {
        return
    }
    if (!continue)
    {
        VarSetCapacity(data, f.length, 0)
        f.rawRead(&data, f.length)
        f.pos := oldpos
        return CalcAddrHash(&data, f.length, algid, hash, hashlength)
    }
    hashlength := 0
    while (f.pos < f.length)
    {
        readlength := (f.length - fpos > continue) ? continue : f.length - f.pos
        VarSetCapacity(data, hashlength + readlength, 0)
        DllCall("RtlMoveMemory", "Ptr", &data, "Ptr", &hash, "Ptr", hashlength)
        f.rawRead(&data + hashlength, readlength)
        h := CalcAddrHash(&data, hashlength + readlength, algid, hash, hashlength)
    }
    return h
}

; CRC32 =============================================================================
CRC32(string, encoding = "UTF-8")
{
    chrlength := (encoding = "CP1200" || encoding = "UTF-16") ? 2 : 1
    length := (StrPut(string, encoding) - 1) * chrlength
    VarSetCapacity(data, length, 0)
    StrPut(string, &data, floor(length / chrlength), encoding)
    hMod := DllCall("Kernel32.dll\LoadLibrary", "Str", "Ntdll.dll")
    SetFormat, Integer, % SubStr((A_FI := A_FormatInteger) "H", 0)
    CRC := DllCall("Ntdll.dll\RtlComputeCrc32", "UInt", 0, "UInt", &data, "UInt", length, "UInt")
    o := SubStr(CRC | 0x1000000000, -7)
    DllCall("User32.dll\CharLower", "Str", o)
    SetFormat, Integer, %A_FI%
    return o, DllCall("Kernel32.dll\FreeLibrary", "Ptr", hMod)
}

; HexCRC32 ==========================================================================
HexCRC32(hexstring)
{
    length := StrLen(hexstring) // 2
    VarSetCapacity(data, length, 0)
    loop % length
    {
        NumPut("0x" SubStr(hexstring, 2 * A_Index -1, 2), data, A_Index - 1, "Char")
    }
    hMod := DllCall("Kernel32.dll\LoadLibrary", "Str", "Ntdll.dll")
    SetFormat, Integer, % SubStr((A_FI := A_FormatInteger) "H", 0)
    CRC := DllCall("Ntdll.dll\RtlComputeCrc32", "UInt", 0, "UInt", &data, "UInt", length, "UInt")
    o := SubStr(CRC | 0x1000000000, -7)
    DllCall("User32.dll\CharLower", "Str", o)
    SetFormat, Integer, %A_FI%
    return o, DllCall("Kernel32.dll\FreeLibrary", "Ptr", hMod)
}

; FileCRC32 =========================================================================
FileCRC32(sFile := "", cSz := 4)
{
    Bytes := ""
    cSz := (cSz < 0 || cSz > 8) ? 2**22 : 2**(18 + cSz)
    VarSetCapacity(Buffer, cSz, 0)
    hFil := DllCall("Kernel32.dll\CreateFile", "Str", sFile, "UInt", 0x80000000, "UInt", 3, "Int", 0, "UInt", 3, "UInt", 0, "Int", 0, "UInt")
    if (hFil < 1)
    {
        return hFil
    }
    hMod := DllCall("Kernel32.dll\LoadLibrary", "Str", "Ntdll.dll")
    CRC := 0
    DllCall("Kernel32.dll\GetFileSizeEx", "UInt", hFil, "Int64", &Buffer), fSz := NumGet(Buffer, 0, "Int64")
    loop % (fSz // cSz + !!Mod(fSz, cSz))
    {
        DllCall("Kernel32.dll\ReadFile", "UInt", hFil, "Ptr", &Buffer, "UInt", cSz, "UInt*", Bytes, "UInt", 0)
        CRC := DllCall("Ntdll.dll\RtlComputeCrc32", "UInt", CRC, "UInt", &Buffer, "UInt", Bytes, "UInt")
    }
    DllCall("Kernel32.dll\CloseHandle", "Ptr", hFil)
    SetFormat, Integer, % SubStr((A_FI := A_FormatInteger) "H", 0)
    CRC := SubStr(CRC + 0x1000000000, -7)
    DllCall("User32.dll\CharLower", "Str", CRC)
    SetFormat, Integer, %A_FI%
    return CRC, DllCall("Kernel32.dll\FreeLibrary", "Ptr", hMod)
}



;;--- Create Function ---

ButtonCreateCRC32:
	;; Var = CRC32
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before create a file !
	IfEqual, NoCalc, 1, Return
    	GuiControlGet, CRC32,, CRC32
	IfEqual, debug, 1, MsgBox, CRC32=%CRC32% File=%file%
	OutputVar := file
	SplitPath, File,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, File=%file%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	IfExist, %Dir%\%name_no_ext%.CRC32, MsgBox, 36, %title%, File %Dir%\%name_no_ext%.CRC32 exist ! overwrite ?
	IfMsgBox, No, goto, skipCRC32
	FileDelete, %Dir%\%name_no_ext%.CRC32
	FileAppend, %CRC32%, %Dir%\%name_no_ext%.CRC32
	MsgBox, File %Dir%\%name_no_ext%.CRC32 was created !
	skipCRC32:
return

ButtonCreateMD2:
	;; Var = MD2
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before create a file !
	IfEqual, NoCalc, 1, Return
    	GuiControlGet, MD2,, MD2
	IfEqual, debug, 1, MsgBox, MD2=%MD2% File=%file%
	OutputVar := file
	SplitPath, File,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, File=%file%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	IfExist, %Dir%\%name_no_ext%.MD2, MsgBox, 36, %title%, File %Dir%\%name_no_ext%.MD2 exist ! overwrite ?
	IfMsgBox, No, goto, skipMD2
	FileDelete, %Dir%\%name_no_ext%.MD2
	FileAppend, %MD2%, %Dir%\%name_no_ext%.MD2
	MsgBox, File %Dir%\%name_no_ext%.MD2 was created !
	skipMD2:
return

ButtonCreateMD4:
	;; Var = MD4
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before create a file !
	IfEqual, NoCalc, 1, Return
    	GuiControlGet, MD4,, MD4
	IfEqual, debug, 1, MsgBox, MD4=%MD4% File=%file%
	OutputVar := file
	SplitPath, File,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, File=%file%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	IfExist, %Dir%\%name_no_ext%.MD4, MsgBox, 36, %title%, File %Dir%\%name_no_ext%.MD4 exist ! overwrite ?
	IfMsgBox, No, goto, skipMD4
	FileDelete, %Dir%\%name_no_ext%.MD4
	FileAppend, %MD4%, %Dir%\%name_no_ext%.MD4
	MsgBox, File %Dir%\%name_no_ext%.MD4 was created !
	skipMD4:
return

ButtonCreateMD5:
	;; Var = MD5
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before create a file !
	IfEqual, NoCalc, 1, Return
    	GuiControlGet, MD5,, MD5
	IfEqual, debug, 1, MsgBox, MD5=%MD5% File=%file%
	OutputVar := file
	SplitPath, File,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, File=%file%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	IfExist, %Dir%\%name_no_ext%.md5, MsgBox, 36, %title%, File %Dir%\%name_no_ext%.md5 exist ! overwrite ?
	IfMsgBox, No, goto, skipmd5
	FileDelete, %Dir%\%name_no_ext%.md5
	FileAppend, %MD5%, %Dir%\%name_no_ext%.md5
	MsgBox, File %Dir%\%name_no_ext%.md5 was created !
	skipmd5:
return

ButtonCreateSHA1:
	;; Var = SHA
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before create a file !
	IfEqual, NoCalc, 1, Return
    	GuiControlGet, SHA,, SHA
	IfEqual, debug, 1, MsgBox, SHA=%SHA% File=%file%
	OutputVar := file
	SplitPath, File,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, File=%file%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	IfExist, %Dir%\%name_no_ext%.SHA1, MsgBox, 36, %title%, File %Dir%\%name_no_ext%.SHA1 exist ! overwrite ?
	IfMsgBox, No, goto, skipSHA
	FileDelete, %Dir%\%name_no_ext%.SHA1
	FileAppend, %SHA%, %Dir%\%name_no_ext%.SHA1
	MsgBox, File %Dir%\%name_no_ext%.SHA1 was created !
	skipSHA:
return

ButtonCreateSHA256:
	;; Var = SHA256
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before create a file !
	IfEqual, NoCalc, 1, Return
    	GuiControlGet, SHA2,, SHA2
	IfEqual, debug, 1, MsgBox, SHA256=%SHA2% File=%file%
	OutputVar := file
	SplitPath, File,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, File=%file%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	IfExist, %Dir%\%name_no_ext%.SHA256, MsgBox, 36, %title%, File %Dir%\%name_no_ext%.SHA256 exist ! overwrite ?
	IfMsgBox, No, goto, skipSHA256
	FileDelete, %Dir%\%name_no_ext%.SHA256
	FileAppend, %SHA2%, %Dir%\%name_no_ext%.SHA256
	MsgBox, File %Dir%\%name_no_ext%.SHA256 was created !
	skipSHA256:
return

ButtonCreateSHA384:
	;; Var = SHA384
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before create a file !
	IfEqual, NoCalc, 1, Return
    	GuiControlGet, SHA3,, SHA3
	IfEqual, debug, 1, MsgBox, SHA384=%SHA3% File=%file%
	OutputVar := file
	SplitPath, File,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, File=%file%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	IfExist, %Dir%\%name_no_ext%.SHA384, MsgBox, 36, %title%, File %Dir%\%name_no_ext%.SHA384 exist ! overwrite ?
	IfMsgBox, No, goto, skipSHA384
	FileDelete, %Dir%\%name_no_ext%.SHA384
	FileAppend, %SHA3%, %Dir%\%name_no_ext%.SHA384
	MsgBox, File %Dir%\%name_no_ext%.SHA384 was created !
	skipSHA384:
return

ButtonCreateSHA512:
	;; Var = SHA512
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before create a file !
	IfEqual, NoCalc, 1, Return
    	GuiControlGet, SHA5,, SHA5
	IfEqual, debug, 1, MsgBox, SHA512=%SHA5% File=%file%
	OutputVar := file
	SplitPath, File,, Dir
	SplitPath, Dir, Folder
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1, msgbox, File=%file%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	IfExist, %Dir%\%name_no_ext%.SHA512, MsgBox, 36, %title%, File %Dir%\%name_no_ext%.SHA512 exist ! overwrite ?
	IfMsgBox, No, goto, skipSHA512
	FileDelete, %Dir%\%name_no_ext%.SHA512
	FileAppend, %SHA5%, %Dir%\%name_no_ext%.SHA512
	MsgBox, File %Dir%\%name_no_ext%.SHA512 was created !
	skipSHA512:
return

;;--- Load function ---

ButtonLoadCRC32:
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before loading a file !
	IfEqual, NoCalc, 1, Return
	IfEqual, debug, 1,msgbox, File=%File%
	OutputVar := file
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1,msgbox, OutputVar=%OutputVar%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	FileReadLine, Loadhash, %dir%\%name_no_ext%.CRC32, 1
	GuiControl,,Verify, %Loadhash%
return

ButtonLoadMD2:
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before loading a file !
	IfEqual, NoCalc, 1, Return
	IfEqual, debug, 1,msgbox, File=%File%
	OutputVar := file
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1,msgbox, OutputVar=%OutputVar%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	FileReadLine, Loadhash, %dir%\%name_no_ext%.md2, 1
	GuiControl,,Verify, %Loadhash%
return

ButtonLoadMD4:
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before loading a file !
	IfEqual, NoCalc, 1, Return
	IfEqual, debug, 1,msgbox, File=%File%
	OutputVar := file
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1,msgbox, OutputVar=%OutputVar%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	FileReadLine, Loadhash, %dir%\%name_no_ext%.md4, 1
	GuiControl,,Verify, %Loadhash%
return

ButtonLoadMD5:
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before loading a file !
	IfEqual, NoCalc, 1, Return
	IfEqual, debug, 1,msgbox, File=%File%
	OutputVar := file
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1,msgbox, OutputVar=%OutputVar%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	FileReadLine, Loadhash, %dir%\%name_no_ext%.md5, 1
	GuiControl,,Verify, %Loadhash%
return

ButtonLoadSHA1:
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before loading a file !
	IfEqual, NoCalc, 1, Return
	IfEqual, debug, 1,msgbox, File=%File%
	OutputVar := file
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1,msgbox, OutputVar=%OutputVar%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	FileReadLine, Loadhash, %dir%\%name_no_ext%.SHA1, 1
	GuiControl,,Verify, %Loadhash%
return

ButtonLoadSHA256:
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before loading a file !
	IfEqual, NoCalc, 1, Return
	IfEqual, debug, 1,msgbox, File=%File%
	OutputVar := file
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1,msgbox, OutputVar=%OutputVar%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	FileReadLine, Loadhash, %dir%\%name_no_ext%.SHA256, 1
	GuiControl,,Verify, %Loadhash%
return

ButtonLoadSHA384:
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before loading a file !
	IfEqual, NoCalc, 1, Return
	IfEqual, debug, 1,msgbox, File=%File%
	OutputVar := file
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1,msgbox, OutputVar=%OutputVar%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	FileReadLine, Loadhash, %dir%\%name_no_ext%.SHA384, 1
	GuiControl,,Verify, %Loadhash%
return

ButtonLoadSHA512:
	IfEqual, NoCalc, 1, MsgBox, Calculate Hash before loading a file !
	IfEqual, NoCalc, 1, Return
	IfEqual, debug, 1,msgbox, File=%File%
	OutputVar := file
	SplitPath, OutputVar, name, dir, ext, name_no_ext, drive
	IfEqual, debug, 1,msgbox, OutputVar=%OutputVar%`n`ndir=%dir%`n`next=%ext%`n`ndrive=%drive%`n`nname_no_ext=%name_no_ext%`n`nname=%name%`n`nIf in Folder=%folder%
	FileReadLine, Loadhash, %dir%\%name_no_ext%.SHA512, 1
	GuiControl,,Verify, %Loadhash%
return

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
	IfNotExist, %icofolder%\%logoicon%, goto, skiplogoicon
	Gui, 4:Add, Picture, x25 y25 w400 h400, %icofolder%\%logoicon%
	skiplogoicon:
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

webpage:
	run, https://github.com/LostByteSoft/HashCalc
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