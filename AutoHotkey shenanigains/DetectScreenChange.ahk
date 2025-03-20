#Include Gdip_All.ahk
#Include Gdip_ImageSearch.ahk
#InstallMouseHook
#InstallKeybdHook
SendMode Input
SetWorkingDir, %A_ScriptDir%

^!c::
{
    difCount := 0
    sameCount := 0
    
    pixelX := 0
    pixelY := 0

    KeyWait, LButton, D
    MouseGetPos x, y
         
    KeyWait, LButton, L
    MouseGetPos Xpos2, Ypos2   

    w := Xpos2-x
    h := YPos2-y
   
    If (w <= 0 or h <= 0)
    {
        MsgBox, 0, ERROR, "make sure to start at the top left and drag to the bottom right"
        Return
    } 
    
    pToken := Gdip_Startup()
    MsgBox, %x%, %y%, %w%, %h%  
    snap := Gdip_BitmapFromScreen(x,y,w,h)
    if (snap == -1)
    {
        MsgBox, "Gdip_BitmapFromScreen snap FAILED"
    }
    xtwo = x-100
    ytwo = y-100
    snap2 := Gdip_BitmapFromScreen(xtwo,ytwo,w,h)
    if (snap2 == -1)
    {
        MsgBox, "Gdip_BitmapFromScreen, snap2 FAILED"
    }

    Loop,
    {
       
        pixelY += 5
        Loop,
        {
            pixelX += 5
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

    Gdip_SaveBitmapToFile(snap, "shot.png")
    Gdip_SaveBitmapToFile(snap2, "shot2.png")
    MsgBox, %percentdif%, %difCount%, %sameCount%, %pixelX%
    MsgBox, "done"

    Gdip_DisposeImage(snap) 
    Gdip_DisposeImage(snap2) 
}




imgdif(ByRef snap, ByRef snap2)
{

}