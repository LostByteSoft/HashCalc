# HashCalc

THIS IS A FORKED WORK FROM jNizM

I added some functions, load and create hash form files.

Calculate hash from string, hex or file via AutoHotkey many options added.
* create files (*.md5 *.sha1 ... etc)
* load from file
* Gui arrangement
* Direct load hash files

## Features
* Generate hash value from string, hex or file
* Secure-Salted function
* Verify hash
* Load md5 sha ... etc from a file

### Hash Functions
* CRC32
* MD2, MD4, MD5
* SHA-1
* SHA-256, SHA-384, SHA-512
* HMAC

## Screenshot
![Screenshot](LBS_HashCalc_4.jpg)

## How to use it ?
* Click "File" to load something (larges files takes time...)
* Click on "Calculate" and wait
* Click on LoadMD5 if you have a file who respect the format
OR
* Copy Paste the hash in "Verify" edit line
OR
* Click "LoadFile" to load any hash file to auto compare

## What is the correct format for hash file ?
* A file with the same name of the file you want verify
* Inside this file on the first line include the hash
* The extension of this file is *.crc32 *.md2 *.md4 *.md5 *.sha1 *.sha256 *.sha384 *.sha512
* Extension *.txt is accepted too
* Look image for easy-way

![Screenshot](md5.jpg)
![Screenshot](format.jpg)

## Contributing

* THANKS ORIGINAL MAKER jNizM

* thanks to Bentschi for his functions CalcAddrHash(), CalcStringHash() & CalcFileHash()
* thanks to atnbueno for CalcHexHash()
* thanks to SKAN for his functions CRC() & FileCRC32()
* thanks to jNizM translated function HMAC()
* thanks to AutoHotkey Community

THIS IS A FORKED WORK FROM jNizM
