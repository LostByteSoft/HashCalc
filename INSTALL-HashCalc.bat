echo off
pushd "%~dp0
@echo -------------------------------------
echo LostByteSoft
echo Install version 2.1 2021-06-23
echo Architecture: x64
echo Compatibility : w7 w8 w8.1 w10 w11

echo LBS_HashCalc
@echo -------------------------------------
taskkill /im "LBS_HashCalc.exe"
copy "SharedIcons\*.ico" "C:\Program Files\Common Files\"
@echo -------------------------------------
copy "*.exe" "C:\Program Files\"
copy "*.lnk" "C:\Users\Public\Desktop\"
@echo -------------------------------------
echo "You must close this command windows"
"C:\Program Files\LBS_HashCalc.exe"
exit