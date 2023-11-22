
;Sadly, this script is only reliable when playing MC in windowed mode. I don't know why it doesn't like fullscreen.

#Requires AutoHotkey v2.0
#SingleInstance Force

;You can change this value if you like, it just dictates how large the search box for a hex grid dot is around the cursor. Default 15.
HexDotBaseSearchSize := 15
;These values dicate which keys the script will respond to. MainKey is used for toggling the drawing, ExitKey1 and ExitKey2 exit the script is both are held at once.
;Both of them only function if your mouse is currently on a java window. Might recognize other java-based windows by accident, but I don't know a better way to check for "is this window Minecraft",
;since many modpacks change the window name.
MainKey := "X"
ExitKey1 := "Tab"
ExitKey2 := "W"
;This value changes how long the script pauses (in milliseconds) after detecting a MainKey press. Increase this value if you have trouble pushing a button for less than 1/4 of a second.
KeyPause := 250
;This value sets whether the script will beep. Note that with it disabled, it will be harder to be sure whether it's open or closed.
SoundAllowed := true

;Changing these values may break things.
MonitorScaleX := 1920 / A_ScreenWidth
MonitorScaleY := 1080 / A_ScreenHeight
HexDotColor := 0x7FFFE5
HexDotSearchSize := ((HexDotBaseSearchSize / MonitorScaleX) + (HexDotBaseSearchSize / MonitorScaleY) / 2)
DrawHex := false
FoundColor := false
WinProcessName := "default value that should never actually come up"

DrawCheck(){
    global DrawHex
    global WinProcessName
    MouseGetPos &MouseX, &MouseY, &WindowID
    ;don't let WinGetProcessName throw an annoying error box at your face
    Try{
        WinProcessName := WinGetProcessName(WindowID)
    }
    if(WinProcessName = "javaw.exe"){
        FoundColor := PixelSearch(&FoundX, &FoundY, MouseX - HexDotSearchSize, MouseY - HexDotSearchSize, MouseX + HexDotSearchSize, MouseY + HexDotSearchSize, HexDotColor, 1)
        if (GetKeyState(MainKey) AND (DrawHex = false)){
            if (FoundColor){
                DrawHex := true
                Click "Down Right"
                if SoundAllowed
                    SoundBeep 250
            }
            Sleep KeyPause
        }
        if ((DrawHex = true) AND GetKeyState(MainKey)){
            if SoundAllowed
                SoundBeep 750
            DrawHex := false
            Click "Up Right"
            Sleep KeyPause
        }
        if (GetKeyState(ExitKey1) and GetKeyState(ExitKey2)){
            if SoundAllowed
                SoundBeep 500, 500
            DrawHex := false
            Click "Up Right"
            SetTimer , 0
        }
    ;makes sure the script doesn't accidentally keep the button held when your mouse leaves Minecraft
    } else if (DrawHex){
        Click "Up Right"
        DrawHex := false
    }
    ;check if there is no java window active, to reduce the chance of the script from running in the background forever
    if !(WinExist("ahk_exe javaw.exe")){
        if SoundAllowed
            SoundBeep
        SetTimer , 0
    }
}

if SoundAllowed
    SoundBeep
SetTimer DrawCheck, 5