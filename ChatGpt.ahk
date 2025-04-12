#Requires AutoHotkey v2.0
#NoTrayIcon

CHATGPT_PROFILE := EnvGet("CHATGPT_PROFILE") ? EnvGet("CHATGPT_PROFILE") : "Windows PowerShell"
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


RunChatGpt() {
    ; Command to run in the terminal
    Command := "chatgpt -i -p " CHATGPT_PROMPT_PATH

    ; Run the terminal with the specified profile and command
    RunTerminal(CHATGPT_PROFILE, Command)
}

RunChatGptWithImage() {
    imagePath := TakeScreenshotAndSave()
    if !imagePath {
        MsgBox "❌ Failed to capture and save screenshot."
        return
    }

    Command := 'chatgpt -i --image "' imagePath '" -p ' CHATGPT_PROMPT_PATH
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

TakeScreenshotAndSave() {
    ; Clear the clipboard - important for image capture
    A_Clipboard := ''

    ; Trigger screen snip tool
    Run "ms-screenclip:",, "UseErrorLevel"

    ; Wait 10 seconds before timing out 
    if !ClipWait(10, 1) {
        MsgBox "❌ Screenshot process timed out."
        return ""
    }

    Sleep 100 ; There's a race condition here - 100ms seems to be enough time. Results may vary per machine.

    return SaveClipboardWithImageMagick()
}

SaveClipboardWithImageMagick() {
    unixTime := DateDiff(A_NowUTC, "19700101000000", "Seconds")
    fileName := unixTime ".png"
    outputDir := EnvGet("USERPROFILE") . "\.chatgpt-cli\images"
    logFile := outputDir "\magick_output.txt"

    if !DirExist(outputDir)
        DirCreate outputDir

    fullPath := outputDir "\" fileName

    ; Command to run via cmd.exe, capturing stdout and stderr
    cmd := Format(
        '{} /c magick clipboard: "{}" > "{}" 2>&1',
        A_ComSpec,
        fullPath,
        logFile
    )

    ; Run the command
    RunWait cmd, , "Hide"

    ; Check if file was saved
    if FileExist(fullPath) {
        return fullPath
    } else {
        ; Show log contents if failed
        logText := FileRead(logFile)
        MsgBox "❌ ImageMagick failed. Output:`n" logText
        return ""
    }
}