#Requires AutoHotkey v2.0
#NoTrayIcon
#SingleInstance
;#Warn

CHATGPT_PROFILE := EnvGet("CHATGPT_PROFILE") ? EnvGet("CHATGPT_PROFILE") : "ChatGPT"
CHATGPT_PROMPT_PATH := EnvGet("CHATGPT_PROMPT_PATH") ? EnvGet("CHATGPT_PROMPT_PATH") : "%USERPROFILE%\\.chatgpt-cli\\prompt.md"
CHATGPT_IMAGE_PROFILE := EnvGet("CHATGPT_IMAGE_PROFILE") ? EnvGet("CHATGPT_IMAGE_PROFILE") : "ChatGPTImage"
CHATGPT_IMAGE_DIR := EnvGet("CHATGPT_IMAGE_DIR") ? EnvGet("CHATGPT_IMAGE_DIR") : "%USERPROFILE%\\.chatgpt-cli\\images"
DEFAULT_TERMINAL_PROFILE := EnvGet("DEFAULT_TERMINAL_PROFILE") ? EnvGet("DEFAULT_TERMINAL_PROFILE") : "Windows PowerShell"

!MButton:: ; Alt + Middle Click
{
    RunChatGptWithImage()
}

!XButton2:: ; Alt + Mouse 5
{
    RunChatGpt()
}

!XButton1:: ; Alt + Mouse 4
{
    RunTerminalDefault()
}

/**
 * Takes a screenshot of the screen.
 * @param {str} filepath output file path
 * @param {int} x coordinate
 * @param {int} y coordinate
 * @param {int} w width
 * @param {int} h height
 * 
 * @credit iseahound - ImagePut v1.11 ScreenshotToBuffer
 * https://github.com/iseahound/ImagePut
 */
Screenshot(filepath, x := 0, y := 0, w := 0, h := 0) {
    
    ; Preload GDI+ library.
    #DllLoad GdiPlus.dll

    ; Start GDI+.
    GdiplusVersion := 1
    si := Buffer(32, 0)
    Numput("int", GdiplusVersion, si)
    DllCall("Gdiplus\GdiplusStartup", "ptr*", &pToken:=0, "ptr", si, "ptr", 0)
    if (!pToken) {
        throw Error("Gdiplus failed to start.")
    }
    
    (!w) ? w := A_ScreenWidth : 0
    (!h) ? h := A_ScreenHeight : 0

    hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
    bi := Buffer(40, 0)          ; sizeof(bi) = 40
    NumPut(  "uint", 40, bi,  0) ; Size
    NumPut(   "int",  w, bi,  4) ; Width
    NumPut(   "int", -h, bi,  8) ; Height - Negative so (0, 0) is top-left
    NumPut("ushort",  1, bi, 12) ; Planes
    NumPut("ushort", 32, bi, 14) ; BitCount / BitsPerPixel
    hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
    obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")

    ; Retrieve the device context for the screen.
    sdc := DllCall("GetDC", "ptr", 0, "ptr")

    ; Copies a portion of the screen to a new device context.
    DllCall("gdi32\BitBlt"
        , "ptr", hdc, "int", 0, "int", 0, "int", w, "int", h
        , "ptr", sdc, "int", x, "int", y, "uint", 0x00CC0020 | 0x40000000) ; SRCCOPY | CAPTUREBLT

    DllCall("ReleaseDC", "ptr", 0, "ptr", sdc)

    DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hbm, "ptr", 0, "ptr*", &pBitmap := 0)

    ; Cleanup the hBitmap and device contexts.
    DllCall("SelectObject", "ptr", hdc, "ptr", obm)
    DllCall("DeleteObject", "ptr", hbm)
    DllCall("DeleteDC",     "ptr", hdc)

    pCodec := Buffer(16)
    ; Get the CLSID of the PNG codec.
    DllCall("ole32\CLSIDFromString", "wstr", "{557CF406-1A04-11D3-9A73-0000F81EF32E}", "ptr", pCodec, "hresult")
    DllCall("gdiplus\GdipSaveImageToFile", "ptr", pBitmap, "wstr", filepath, "ptr", pCodec, "ptr", 0)
    DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap)

    ; Shutdown GDI+.
    DllCall("gdiplus\GdiplusShutdown", "ptr", pToken)
    return
}

RunChatGpt() {
    ; Command to run in the terminal
    Command := "chatgpt -i -p " CHATGPT_PROMPT_PATH

    ; Run the terminal with the specified profile and command
    RunTerminal(CHATGPT_PROFILE, Command)
}

RunChatGptWithImage() {

    local fileName, fullPath, outputDir, Command

    outputDir := EnvGet("USERPROFILE") . "\.chatgpt-cli\images"
    if !DirExist(outputDir)
        DirCreate outputDir

    fileName := TimeStamp() ".png"
    fullPath := outputDir "\" fileName
    
    Screenshot(fullPath)

    Command := 'chatgpt -i --image "' fullPath '" -p ' CHATGPT_PROMPT_PATH
    RunTerminal(CHATGPT_IMAGE_PROFILE, Command)
}

RunTerminalDefault() {
    Command := ""
    RunTerminal(DEFAULT_TERMINAL_PROFILE, Command)
}

RunTerminal(ProfileName, Command := "") {
    ; Build the command to run Windows Terminal
    FullCommand := 'wt.exe -p "' ProfileName '"'
    if Command
        FullCommand .= " -- " Command

    ; Run the terminal
    Run FullCommand
    WinWait "ahk_exe WindowsTerminal.exe"
    WinActivate "ahk_exe WindowsTerminal.exe"
}

TimeStamp() {
    return DateDiff(A_NowUTC, "19700101000000", "Seconds")
}
