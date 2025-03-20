#Include Gdip_All.ahk
#Include Gdip_ImageSearch.ahk
#InstallMouseHook
#InstallKeybdHook
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1

;MsgBox, 0 ,QuickGuide, "To use this script, press CTL+ALT+s, then hold down the left mouse button on the top left corner of the video you want to save, then drag to the bottom right, this will activate the script."
^e::
    Reload
    Return
^!s::
    difCount := 0
    sameCount := 0
    pixelX := 0
    pixelY := 0
    num := 0

KeyWait, LButton, D
    MouseGetPos x, y
         
KeyWait, LButton, L
    MouseGetPos Xpos2, Ypos2   

w := Xpos2-x
h := YPos2-y
MsgBox, %x%, %y%, %Xpos2%, %Ypos2%
If (w <= 0 or h <= 0)
{
    MsgBox, 0, ERROR, "make sure to start at the top left and drag to the bottom right"
    Return
}



pToken := Gdip_Startup()
num := 0
    snap := Gdip_BitmapFromScreen(x,y,w,h)
    if (snap == -1)
    {
        MsgBox, "Gdip_BitmapFromScreen FAILED"
    }
    Gdip_SaveBitmapToFile(snap, "shreenshots/1shot.png")
Loop,
{

    snap := Gdip_BitmapFromScreen(x,y,w,h)
    if (snap == -1)
    {
        MsgBox, "Gdip_BitmapFromScreen FAILED"
    }
    Gdip_SaveBitmapToFile(snap, "shot.png")
    Sleep, 500
        snap2 := Gdip_BitmapFromScreen(x,y,w,h)
    if (snap2 == -1)
    {
        MsgBox, "Gdip_BitmapFromScreen FAILED"
    }

    Loop,
    {
        pixelY += 10
        Loop,
        {
            pixelX += 10
            if(Gdip_GetPixel(snap, pixelX, pixelY) == Gdip_GetPixel(snap2, pixelX, pixelY))
            {
                sameCount += 1
            }Else
            {
                difCount += 1
            }

            If (pixelX >= w)
            {
                pixelX := 0
                Break
            }
        }
        If (pixelY >= h)
        {
            Break
        }
    }
   
    percentdif := 100*(difCount/(sameCount+difcount))
   ; MsgBox, %percentdif%

    if (percentdif >= 1 )
    {   
        Gdip_SaveBitmapToFile(snap2, "shot" num ".png")
        percentdif := 0
        num +=1
        difCount := 0
        sameCount := 0
        pixelX := 0
        pixelY := 0
    }  
        percentdif := 0
        difCount := 0
        sameCount := 0
        pixelX := 0
        pixelY := 0
    Gdip_DisposeImage(snap2)
    Gdip_DisposeImage(snap) 
    ListVars
}
Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
