@PATH C:\Program Files\AutoHotkey\Compiler;C:\windows\system32
@if not exist "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" goto notins
@taskkill /F /IM "LBS_HashCalc.exe"

Ahk2Exe.exe /in "LBS_HashCalc.ahk" /out "LBS_HashCalc.exe" /icon "SharedIcons/ico_hash.ico" /mpress "0"

@exit

:notins
@echo Ahk is not installed.
@pause

:exit
@exit