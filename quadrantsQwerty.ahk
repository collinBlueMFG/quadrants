#Requires AutoHotkey v2.0
;mouseless navigation: quadrants (SYMMETRICAL LAYOUT)
;split screen into quadrants, press 1 of 4 keys to select a quadrant
;once in quadrant, subdivide that quadrant into subquadrants. mouse remains centered on selected quadrant, you can choose which region to center the cursor on.
global quadlayer := 1
global quadoriginy := 0
global quadoriginx := 0
global monitoroffsetx := 0
global monitoroffsety := 0
global myGui := Gui("-Caption +AlwaysOnTop +ToolWindow")
global MsgGui
myGui.BackColor := "000000"
WinSetTransparent(60, myGui)
WinSetExStyle("+0x20", myGui) ; WS_EX_TRANSPARENT (click-through)

;---------------------------------
;HOTKEY ASSIGNMENTS
;---------------------------------

`;::{ ;reset all position variables
    resetter()
}

u:: { 
    selectquadrant(1)
    global quadlayer +=1
}
o:: {
    selectquadrant(2)
    global quadlayer +=1
}
m:: {
    selectquadrant(3)
    global quadlayer +=1
}
.:: {
    selectquadrant(4)
    global quadlayer +=1
}
j::(mover(-10,0,false)) ;manual key navigation
k::(mover(0,10,false))
i::(mover(0,-10,false))
l::(mover(10,0,false))

+j::(mover(-1,0,true)) ;move relative to current quadrant
+k::(mover(0,1,true))
+i::(mover(0,-1,true))
+l::(mover(1,0,true))

1::{
    global monitoroffsetx -= 1920
    global quadoriginx += monitoroffsetx
}
3::{
    global monitoroffsetx += 1920
    global quadoriginx += monitoroffsetx
}
2::{
    global monitoroffsetx := 0
    global quadoriginx := 0
}
Space::{
        Send(mouseClick("Left",,,,,"D"))
        KeyWait("Space")
        Send(MouseClick("Left",,,,,"U"))
    }

+Space::MouseClick('Right')

;---------------------------------
;MOVEMENT LOGIC:
;---------------------------------

mover(mx,my,inquadrant){ ;move function
    global quadlayer
    global quadoriginx
    global quadoriginy
    qw := 1920/(2**quadlayer)
    qh := 1080/(2**quadlayer)
    if inquadrant{
        CoordMode("Mouse", "Screen")
        MouseGetPos(&x,&y)
        DllCall("SetCursorPos", "int",x+qw*mx, "int", y+ qh*my)
    }
    else{
        CoordMode("Mouse","Screen")
        MouseGetPos(&x,&y)
        DllCall("SetCursorPos","int",x + mx,"int",y+my)
    }
}

selectquadrant(qn){ ;quadrant movement function
    CoordMode("Mouse","Screen")
    global quadlayer
    global quadoriginy
    global quadoriginx
    global monitoroffsetx
    global monitoroffsety

    qw := 1920/(2**quadlayer)
    qh := 1080/(2**quadlayer)

    if quadlayer > 8{
        resetter()
        quadlayer -= 1
    }

    if qn = 1{       
    }
    if qn = 2{
        quadoriginx += qw
    }
    if qn = 3{
        quadoriginy += qh
    }
    if qn = 4{
        quadoriginx += qw
        quadoriginy += qh
    }

    x := quadoriginx + qw/2
    y := quadoriginy + qh/2

    DllCall("SetCursorPos", "int", x , "int", y)
    boxer(qw,qh)
}

resetter(){ ;reset quadrant variables
    global quadoriginy := 0
    global quadoriginx := monitoroffsetx
    global quadlayer := 1
    global myGui
    myGui.Destroy()
    myGui := Gui("-Caption +AlwaysOnTop +ToolWindow")
    myGui.BackColor := "000000"
    WinSetTransparent(60, myGui)
    WinSetExStyle("+0x20", myGui)
}

;---------------------------------
;GUI STUFF
;---------------------------------

boxer(qw,qh){ ;quadrant overlay setter
    global quadoriginx
    global quadoriginy
    global myGui

    myGui.Destroy()
    myGui := Gui("-Caption +AlwaysOnTop +ToolWindow")
    myGui.BackColor := "000000"
    WinSetTransparent(60, myGui)
    WinSetExStyle("+0x20", myGui) ; click-through

    myGui.AddText("x0 y" . qh*0.5 . " w" . qw . " h1 BackgroundWhite")
    myGui.AddText("x" . qw*0.5 . " y0 w1 h" . qh . " BackgroundWhite")
    myGui.Show("x" . quadoriginx . " y" . quadoriginy . " w" . qw . " h" . qh . " NoActivate")
}

ShowMsg(txt, color := "FFFFFF") {
    global MsgGui

    try MsgGui.Destroy()

    MsgGui := Gui("-Caption +AlwaysOnTop +ToolWindow")
    MsgGui.BackColor := "202020"

    MsgGui.SetFont("s12 Bold", "Segoe UI")
    MsgGui.AddText("c" color " w200 Center", txt)	
    MsgGui.Show("x1150 y1036 NoActivate AutoSize")
}

HideMsg() {
	global MsgGui
	try MsgGui.Destroy()
}

;---------------------------------
;SUSPENDTOGGLE
;---------------------------------

#SuspendExempt true
    CapsLock::{
        Suspend(-1)
        if(A_IsSuspended){
            HideMsg
            ShowMsg("SUSPENDED")
        }
        if(A_isSuspended = False){
            HideMsg
            ShowMsg("ACTIVE")
        }
    }