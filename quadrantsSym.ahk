#Requires AutoHotkey v2.0
;mouseless navigation: quadrants (SYMMETRICAL LAYOUT)
;split screen into quadrants, press 1 of 4 keys to select a quadrant
;once in quadrant, subdivide that quadrant into subquadrants. mouse remains centered on selected quadrant, you can choose which region to center the cursor on.
global quadlayer := 1
global quadoriginy := 0
global quadoriginx := 0
global monitoroffsetx := 0
global monitoroffsety := 0
global debugx := 0
global debugy := 0
global myGui := Gui("-Caption +AlwaysOnTop +ToolWindow")
global MsgGui
myGui.BackColor := "000000"
WinSetTransparent(60, myGui)
WinSetExStyle("+0x20", myGui) ; WS_EX_TRANSPARENT (click-through)


numpadAdd::{ ;reset all position variables
    resetter()
}

Numpad2::{ ;reset all position variables
    resetter()
}

numpad7:: { 
    selectquadrant(1)
    global quadlayer +=1
}
numpad9:: {
    selectquadrant(2)
    global quadlayer +=1
}
numpad1:: {
    selectquadrant(3)
    global quadlayer +=1
}
numpad3:: {
    selectquadrant(4)
    global quadlayer +=1
}

numpad4::(mover(-10,0)) ;manual key navigation
numpad6::(mover(10,0))
numpad5::(mover(0,10))
numpad8::(mover(0,-10))
NumpadDiv::{
    global monitoroffsetx -= 1920
    global quadoriginx += monitoroffsetx
}
NumpadMult::{
    global monitoroffsetx += 1920
    global quadoriginx += monitoroffsetx
}
NumpadSub::{
    global monitoroffsetx := 0
    global quadoriginx := 0
}

NumpadEnter::{
        Send(mouseClick("Left",,,,,"D"))
        KeyWait("NumpadEnter")
        Send(MouseClick("Left",,,,,"U"))
    }

+NumpadEnter::MouseClick('Right')

mover(mx,my){ ;move function
    global debugx
    global debugy
    CoordMode("Mouse","Screen")
    MouseGetPos(&x,&y)
    debugx := x
    debugy := y
    DllCall("SetCursorPos","int",x + mx,"int",y+my)
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
    myGui.Hide
}

boxer(qw,qh){ ;quadrant overlay setter
    global quadoriginx
    global quadoriginy
    global myGui
    myGui.Show("x" . quadoriginx . " y" . quadoriginy . " w" . qw . " h" . qh)
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


#SuspendExempt true
    NumpadDel::{
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