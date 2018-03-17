; FUNCTIONS =========================================================================


;; THANKS TO jNizM/HashCalc
;; https://github.com/jNizM/HashCalc


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
