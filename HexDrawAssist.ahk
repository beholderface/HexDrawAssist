
;Sadly, this script is only reliable when playing MC in windowed mode. I don't know why it doesn't like fullscreen.

#Requires AutoHotkey v2.0
#SingleInstance Force

;You can change this value if you like, it just dictates how large the search box for a hex grid dot is around the cursor. Default 15.
HexDotBaseSearchSize := 15
/*These values dicate which keys the script will respond to. MainKey is used for toggling the drawing, InputKey toggles manual anglesig entry, ExitKey1 and ExitKey2 exit the script is both are held at once.
All of them only function if your mouse is currently on a java window. Might recognize other java-based windows by accident, but I don't know a better way to check for "is this window Minecraft",
since many modpacks change the window name.
Manual anglesig entry works as follows: 
Imagine the hex grid rotated so that the dot formerly to the upper right of any other dot (initial dot) is now directly above that dot.
That upper dot is W, and then going clockwise around the initial dot there are E, D, S, A, and Q. This is based on Hexcasting's existing anglesig keyboard analogy.
To start manual anglesig entry, press InputKey after pressing MainKey. Then, choose a direction to start with.
These directions correspond to the aforementioned dots around the initial dot.
From there, enter whatever anglesig you like (while S does exist internally, here it's just backspace). Just note that I don't currently have a way to detect when an illegal stroke is being made, so
    if you accidentally make one you should hit S or Backspace immediately, as entering more non-backspace angles can cause it to break.
Press MainKey again to finish your pattern.
*/
MainKey := "X"
InputKey := "Z"
ExitKey1 := "Tab"
ExitKey2 := "W"
;This value changes how long the script pauses (in milliseconds) after detecting a MainKey press. Increase this value if you have trouble pushing a button for less than 1/8 of a second.
KeyPause := 125
;This value sets whether the script will beep. Note that with it disabled, it will be harder to be sure whether it's open or closed.
SoundAllowed := true

;Changing these values may break things.
MonitorScaleX := 1920 / A_ScreenWidth
MonitorScaleY := 1080 / A_ScreenHeight
HexDotColor := 0x7FFFE5
DimDotColor := 0x559185
SelectedDotColor := 0xE4B6CF
DimSelectedDot := 0x856F7B
HexDotSearchSize := ((HexDotBaseSearchSize / MonitorScaleX) + (HexDotBaseSearchSize / MonitorScaleY) / 2)
DrawHex := false
FoundColor := false
WinProcessName := "default value that should never actually come up"
Directions := [E := [1, 0], SE := [0.5, 0.86], SW := [-0.5, 0.86], W := [-1, 0], NW := [-0.5, -0.86], NE := [0.5, -0.86]]
DirHistory := []

Beep(Pitch := 523, Duration := 150){
    if SoundAllowed
        SoundBeep Pitch, Duration
}

DotSearch(TargetX, TargetY, ScaleFactor := 1){
    ScaledSearchSize := HexDotSearchSize * ScaleFactor
    FoundBright := PixelSearch(&FoundX, &FoundY, TargetX - ScaledSearchSize, TargetY - ScaledSearchSize, TargetX + ScaledSearchSize, TargetY + ScaledSearchSize, HexDotColor, 1)
    FoundDim := PixelSearch(&FoundX, &FoundY, TargetX - ScaledSearchSize, TargetY - ScaledSearchSize, TargetX + ScaledSearchSize, TargetY + ScaledSearchSize, DimDotColor, 1)
    if FoundBright{
        return FoundBright
    } else {
        return FoundDim
    }
}

SeekDot(Dir){
    FoundDotX := -1
    FoundDotY := -1
    ScaledSearchSize := HexDotSearchSize * 1
    FoundNewDot := false
    Increment := 60
    DirX := Dir[1] * Increment
    DirY := Dir[2] * Increment
    MouseGetPos &MouseX, &MouseY
    if not PixelSearch(&StartDotX, &StartDotY, MouseX - ScaledSearchSize, MouseY - ScaledSearchSize, MouseX + ScaledSearchSize, MouseY + ScaledSearchSize, SelectedDotColor, 1){
        PixelSearch(&StartDotX, &StartDotY, MouseX - ScaledSearchSize, MouseY - ScaledSearchSize, MouseX + ScaledSearchSize, MouseY + ScaledSearchSize, DimSelectedDot, 1)
    }
    if (StartDotX = "")
        StartDotX := MouseX
    if (StartDotY = "")
        StartDotY := MouseY
    MouseMove StartDotX, StartDotY, 0
    While (not FoundNewDot and A_Index < 20){
        DirX := Dir[1] * Increment
        DirY := Dir[2] * Increment
        MouseMove DirX, DirY, 0, "R"
        MouseGetPos &MouseX, &MouseY
        FoundNewDot := PixelSearch(&FoundDotX, &FoundDotY, MouseX - HexDotSearchSize, MouseY - HexDotSearchSize, MouseX + HexDotSearchSize, MouseY + HexDotSearchSize, SelectedDotColor, 1)
        if not FoundNewDot{
            FoundNewDot := PixelSearch(&FoundDotX, &FoundDotY, MouseX - HexDotSearchSize, MouseY - HexDotSearchSize, MouseX + HexDotSearchSize, MouseY + HexDotSearchSize, DimSelectedDot, 1)
        }
        Increment := 5
    }
    if FoundDotX = "" {
        FoundDotX := StartDotX
        FoundDotY := StartDotY
    }
    MouseMove FoundDotX, FoundDotY, 0
}

CharToDir(char){
    global Directions
    global DirHistory
}

CurrentKey(){
    if GetKeyState("W"){
        return "W"
    }
    if GetKeyState("E"){
        return "E"
    }
    if GetKeyState("D"){
        return "D"
    }
    if GetKeyState("S"){
        return "S"
    }
    if GetKeyState("A"){
        return "A"
    }
    if GetKeyState("Q"){
        return "Q"
    }
    if GetKeyState("Backspace"){
        return "B"
    }
    return " "
}

Reverse(){
    global DirHistory
    switch DirHistory[DirHistory.Length]{
        case 1: Output := 4
        case 2: Output := 5
        case 3: Output := 6
        case 4: Output := 1
        case 5: Output := 2
        case 6: Output := 3
    }
    DirHistory.Pop()
    return Output
}

InputSig(){
    global DirHistory
    While (not GetKeyState("X")){
        key := CurrentKey()
        Dir := 0
        if (DirHistory.Length = 0){
            switch key{
                case "W": Dir := 6
                case "E": Dir := 1
                case "D": Dir := 2
                case "S": Dir := 3
                case "A": Dir := 4
                case "Q": Dir := 5
            }
            if not (key = " " or key = "B"){
                SeekDot(Directions[Dir])
                DirHistory.Push(Dir)
                Sleep KeyPause
            }
        } else {
            switch key{
                case "Q": Dir := Mod((DirHistory[DirHistory.Length] + 4), 6) + 1
                case "W": Dir := DirHistory[DirHistory.Length]
                case "E": Dir := Mod((DirHistory[DirHistory.Length]), 6) + 1
                case "D": Dir := Mod((DirHistory[DirHistory.Length] + 1), 6) + 1
                case "A": Dir := Mod((DirHistory[DirHistory.Length] + 3), 6) + 1
                case "S": Dir := Reverse()
                case "B": Dir := Reverse()
            }
            if not (key = " "){
                SeekDot(Directions[Dir])
                DirHistory.Push(Dir)
                Sleep KeyPause
                if (key = "S" or key = "B"){
                    DirHistory.Pop()
                }
            }
        }
        ;sleep KeyPause
    }
    DirHistory := []
}

DrawSequence(anglesig){
    Loop anglesig.Length{
        SeekDot(Directions[anglesig[A_Index]])
        ;Sleep 10
    }
}

DrawCheck(){
    global DrawHex
    global WinProcessName
    global DirHistory
    MouseGetPos &MouseX, &MouseY, &WindowID
    ;don't let WinGetProcessName throw an annoying error box at your face
    Try{
        WinProcessName := WinGetProcessName(WindowID)
    }
    if(WinProcessName = "javaw.exe"){
        FoundColor := DotSearch(MouseX, MouseY)
        if (GetKeyState(MainKey) AND (DrawHex = false)){
            if (FoundColor){
                DrawHex := true
                Click "Down Right"
                Beep(250)
            }
            Sleep KeyPause
        }
        if ((DrawHex = true) AND GetKeyState(MainKey)){
            Beep(750)
            DrawHex := false
            DirHistory := []
            Click "Up Right"
            Sleep KeyPause
        }
        ;amogus
        if (DrawHex AND GetKeyState("A") AND GetKeyState("M") AND GetKeyState("O") AND GetKeyState("G")){
            Beep()
            DrawSequence([1, 3, 4, 4, 6, 1, 6, 4, 4, 4, 3, 4, 3, 3, 1, 3, 3, 1, 6, 1, 3, 1, 6, 6, 6])
        }
        ;enter typing mode
        if (DrawHex AND GetKeyState(InputKey)){
            Beep()
            InputSig()
        }
        if (GetKeyState(ExitKey1) and GetKeyState(ExitKey2)){
            Beep(500, 500)
            DrawHex := false
            DirHistory := []
            Click "Up Right"
            SetTimer , 0
        }
    ;makes sure the script doesn't accidentally keep the button held when your mouse leaves Minecraft
    } else if (DrawHex){
        Click "Up Right"
        DrawHex := false
        DirHistory := []
    }
    ;check if there is no java window active, to reduce the chance of the script from running in the background forever
    if !(WinExist("ahk_exe javaw.exe")){
        Beep()
        SetTimer , 0
    }
}

Beep()
SetTimer DrawCheck, 5
