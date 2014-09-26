;===Auto-execute========================================================================
/*
How to use:
- Click, drag, release F1 to draw new line (multiple lines supported)
- Drag line start or end point to move it
- Press F2 to delete last line
- Press F3 to delete all lines
- Press Esc to exit
*/

GuiArray := []
lineThickness =3

Restart:
CoordMode, mouse,Screen
MyGui:= new c_Gui()
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
return

F1::

if !MyGui
{
	
	MyGui:= new c_Gui()
}

ToolTip, Freehand Mode On, 
Sleep 400
ToolTip
Hotkey, LButton, DrawFree, On
return

F2::

if !MyGui
{
	
	MyGui:= new c_Gui()
}
Tooltip, Screengrab Mode On
Sleep 400
ToolTip
Hotkey, LButton, DrawRect, On
return

F3::
Tooltip, Movement Mode On
Sleep 400
ToolTip
Hotkey, LButton, Off
OnMessage(0x201, "WM_LBUTTONDOWN")
return

^l::
Hotkey, LButton, Off
InputBox, inLineSize, Line Size, Please enter a new line size., , 250, 150
if ErrorLevel
    ;user does not change line size
	lineThickness = 3
else
	lineThickness = %inLineSize%
return

Esc::
delGui := GuiArray.Remove()
delGui.DeleteAllLines()
delGui := ""
return



DrawFree:
	
	MyGui.DrawLine(lineThickness)
	GuiArray.Insert(MyGui)
	MyGui:= new c_Gui()
return

DrawRect:
	
	MyGui.DrawRect()
	GuiArray.Insert(MyGui)
	MyGui:= new c_Gui()
return



WM_LBUTTONDOWN()
{
	PostMessage, 0xA1, 2
}

;===Functions===========================================================================
#Include Gdip.ahk				; by Tic	www.autohotkey.com/community/viewtopic.php?f=2&t=32238


;===Classes=============================================================================
Class c_GUI {      ; demo by Learning one. http://www.autohotkey.com/community/viewtopic.php?p=572041#p572041
	
	__New(o="") {
		this.setLineThickness(3)
		Gui, New, +Hwndhwnd
		Gui %hwnd%: -Caption +E0x80000 +ToolWindow +AlwaysOnTop +OwnDialogs +Hwndhwnd
		Gui %hwnd%: Show, NA
		hbm := CreateDIBSection(A_ScreenWidth, A_ScreenHeight), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)      
		G := Gdip_GraphicsFromHDC(hdc)
		if (G < 1)
			pToken := Gdip_Startup(), G := Gdip_GraphicsFromHDC(hdc), this.pToken := pToken
		Gdip_SetSmoothingMode(G, 4), Gdip_SetInterpolationMode(G, 5)
		PenColor := (o.PenColor) ? o.PenColor : "ff0000ff", PenWidth := (o.PenWidth) ? o.PenWidth : 3
		pPen := Gdip_CreatePen("0x" PenColor, PenWidth)
		pBrush := Gdip_BrushCreateSolid("0x" PenColor)
		
		r := Gdip_GetClipRegion(G)
		Gdip_SetClipRegion(G, r)

		UpdateLayeredWindow(hwnd, hdc, 0, 0, A_ScreenWidth, A_ScreenHeight)
		this.hwnd := hwnd, this.hbm := hbm, this.hdc := hdc, this.obm := obm, this.G := G, this.pPen := pPen, this.pBrush := pBrush this.r := r
	}
	setLineThickness(inThickness){
		this.thickness := %inThickness%
	}
	getLineThickness(){
		return this.thickness
	}
	DrawLine(thickness) {
		
		
		MouseGetPos StartX, StartY
		While (GetKeyState("LButton", "p" )) {
			
			MouseGetPos, NextX, NextY
			;Sleep, 5
			
			
			
			
			x = 0
			while (x <= thickness) {
			Gdip_DrawLine(this.G, this.pPen, StartX + x, StartY, NextX + x, NextY)   ; draw new line
			x++
			}
			
			UpdateLayeredWindow(this.hwnd, this.hdc,0, 0, A_ScreenWidth, A_ScreenHeight)
			StartX := NextX
			StartY := NextY
			
		}
		
		return
	}
	
	DrawRect() {
		penWidth = 5
		pPen := Gdip_CreatePen(0x660000ff, penWidth)
		MouseGetPos StartX, StartY
		
		While (GetKeyState("LButton", "p" )) {
			
			
			UpdateLayeredWindow(this.hwnd, this.hdc, StartX, StartY, Abs(StartX - NextX), Abs(StartY - NextY))
			Gdip_GraphicsClear(this.G)
			Gdip_DrawRectangle(this.G, pPen, penWidth, penWidth, Abs(StartX - NextX)-penWidth*2, Abs(StartY - NextY)-penWidth*2)
			MouseGetPos, NextX, NextY
			
			
			
			}
		
		pBitmap := Gdip_BitmapfromRect(StartX, StartY, Abs(StartY - NextY), Abs(StartX - NextX))
		Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
		Gdip_DrawImage(this.G, pBitmap, penWidth, penWidth, Width-penWidth*2, Height-penWidth*2, penWidth, penWidth, Width-penWidth*2, Height-penWidth*2)
		
		Gdip_DrawRectangle(this.G, pPen, penWidth, penWidth, Abs(StartX - NextX)-penWidth*2, Abs(StartY - NextY)-penWidth*2)
		UpdateLayeredWindow(this.hwnd, this.hdc)
		Gdip_DeletePen(pPen)
}
	MoveLine() {
		Hotkey := RegExReplace(A_ThisHotkey, (A_IsUnicode = 1) ? "(*UCP)^(\w* & |\W*)" : "^(\w* & |\W*)")
		StartX := this.LineToMove.2, StartY := this.LineToMove.3
		this.Lines.Remove(this.LineToMove.1)   ; remove LineToMove from collection and treat is as new line
		While (GetKeyState(Hotkey, "p") = 1) {
			Sleep, 20
			MouseGetPos, EndX, EndY
			Gdip_GraphicsClear(this.G)
			For LineNum,pLine in this.Lines   ; draw all lines in collection
				Gdip_DrawLine(this.G, this.pPen, pLine.1, pLine.2, pLine.3, pLine.4)
			Gdip_DrawLine(this.G, this.pPen, StartX, StartY, EndX, EndY)   ; draw new line
			UpdateLayeredWindow(this.hwnd, this.hdc)
		}
		this.Lines.Insert(this.LineToMove.1, [ StartX, StartY, EndX, EndY]), this.LineToMove := ""   ; insert new line in collection, delete LineToMove info
	}
	DeleteAllLines() {
		this.Lines := [], this.LineToMove := "", Gdip_GraphicsClear(this.G), UpdateLayeredWindow(this.hwnd, this.hdc)
	}
	DeleteLine(LineNum="") {	; if LineNum is blank, last line will be deleted
		if (this.Lines.MaxIndex() = "")   ; no lines in collection
			return
		LineNum := (LineNum = "") ? this.Lines.MaxIndex() : LineNum	; last or specified
		this.Lines.Remove(LineNum)   ; remove from collection
		Gdip_GraphicsClear(this.G)
		For LineNum,pLine in this.Lines   ; draw all lines in collection
			Gdip_DrawLine(this.G, this.pPen, pLine.1, pLine.2, pLine.3, pLine.4)
		UpdateLayeredWindow(this.hwnd, this.hdc)
	}
	IsClickOnLineEnd(radius=6) {
		if (this.Lines.MaxIndex() = "")   ; no lines in collection
			return
		MouseGetPos, x, y
		TotalLines := this.Lines.MaxIndex()
		Loop % TotalLines   ; Z-order.   Reverse Z-order: For LineNum,pLine in this.Lines
		{
			LineNum := TotalLines-A_Index+1, pLine := this.Lines[LineNum]
			if (this.IsInCircle(pLine.1, pLine.2, x, y, radius) = 1) {
				this.LineToMove := [LineNum, pLine.3, pLine.4]   ; LineNum | Coord3 | Coord4
				return 1
			}
			else if (this.IsInCircle(pLine.3, pLine.4, x, y, radius) = 1) {
				this.LineToMove := [LineNum, pLine.1, pLine.2]   ; LineNum | Coord1 | Coord2
				return 1
			}
		}
		this.LineToMove := ""
	}
	IsInCircle(Xstart, Ystart, Xend, Yend, radius) {
		a := Abs(Xend-Xstart), b := Abs(Yend-Ystart), c := Sqrt(a*a+b*b)
		Return (c<radius) ? 1:0   ; if in circle returns 1, else 0
	}
	__Delete() {
		Gdip_DeletePen(this.pPen)
		Gdip_DeleteGraphics(this.G)
		SelectObject(this.hdc, this.obm), DeleteObject(this.hbm), DeleteDC(this.hdc)
		if (this.pToken != "")
			Gdip_Shutdown(this.pToken)
	}
}
