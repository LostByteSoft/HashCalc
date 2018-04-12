@echo --- Start ---
@taskkill /f /im "LBS_HashCalc.exe"
copy "LBS_HashCalc.exe" "C:\Program Files\"
copy "HashCalc.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\"
copy "HashCalc.lnk" "c:\users\%username%\Desktop\"
@echo --- Finish ---
@Echo You can clost this windows !
"C:\Program Files\LBS_HashCalc.exe"
@exit