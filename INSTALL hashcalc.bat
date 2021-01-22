echo off
echo Install version 1.0
taskkill /im "LBS_HashCalc.exe"

copy "SharedIcons\*.ico" "C:\Program Files\Common Files\"
copy "*.exe" "C:\Program Files\"
copy "*.lnk" "C:\Users\Public\Desktop\"

echo "You must close this command windows"
"C:\Program Files\LBS_HashCalc.exe"
exit