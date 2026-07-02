#Requires AutoHotkey v2.0
;mouseless navigation: quadrants
;split screen into quadrants, press 1 of 4 keys to select a quadrant
;once in quadrant, subdivide that quadrant into subquadrants. mouse remains centered on selected quadrant, you can choose which region to center the cursor on.
global quadnum := 1
global quadlayer := 1
global quadoriginy := 0
global quadoriginx := 0

numpad3::{
    global quadoriginy := 0
    global quadoriginx := 0
    global quadlayer := 1
}

numpad7:: {
    selectquadrant(1)
    global quadlayer +=1
}
numpad8:: {
    selectquadrant(2)
    global quadlayer +=1
}
numpad4:: {
    selectquadrant(3)
    global quadlayer +=1
}
numpad5:: {
    selectquadrant(4)
    global quadlayer +=1
}

selectquadrant(qn){
    CoordMode("Mouse","Screen")
    global quadlayer
    global quadoriginy
    global quadoriginx
    qw := 1920/(2**quadlayer)
    qh := 1080/(2**quadlayer)

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
}