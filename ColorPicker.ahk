;Krappy Color Picker
;by Lego_coder / Miguel Agullo

;===============================================================
; Gui


genColorPicker:
   
   gui, font,s14 w1000 cFF0000, Verdana
   Gui, Add, Text, x20 y20, R
   gui, font,s10 c000000 w400
   Gui, Add, Edit, x45 y20 w40 +right vRed_Value gChange_Red_Value,0
   Gui, Add, UpDown, Range0-255 Wrap, 0
   Gui, Add, Slider, x10 y50 w110 Range0-255 vRed_Slider gChange_Red_Slider ALtSubmit, 0
   
   gui, font,s14 w1000 C00CC00
   Gui, Add, Text, x20 y90, G
   gui, font,s10 c000000 w400
   Gui, Add, Edit, x45 y90 w40 +right vGreen_Value gChange_Green_Value, 0
   Gui, Add, UpDown, Range0-255 Wrap, 0
   Gui, Add, Slider, x10 y120 w110 Range0-255 vGreen_Slider gChange_Green_Slider ALtSubmit, 0
   
   gui, font,s14 w1000 C0000FF
   Gui, Add, Text, x20 y160, B
   gui, font,s10 c000000 w400
   Gui, Add, Edit, x45 y160 w40 +right vBlue_Value gChange_Blue_Value, 0
   Gui, Add, UpDown, Range0-255 Wrap, 0
   Gui, Add, Slider, x10 y190 w110 Range0-255 vBlue_Slider gChange_Blue_Slider ALtSubmit, 0

   gui, font,s14 w1000 c000000, Verdana
   Gui, Add, Text, x20 y230, A
   gui, font,s10 c000000 w400
   Gui, Add, Edit, x45 y230 w40 +right vOpacity_Value gChange_Opacity_Value,0
   Gui, Add, UpDown, Range0-255 Wrap, 255
   Gui, Add, Slider, x10 y260 w110 Range0-255 vOpacity_Slider gChange_Opacity_Slider ALtSubmit, 0

   Gui, Add, ListView, x124 y20 h120 w120 ReadOnly 0x4000 +Background000000 VColor_Block
  
   gui, font,s10 c000000 w400,
   Gui, Add, text, x124 y230 +right, Hex:
   Gui, Add, Edit, x161 y230 w81 +right VColor_Value
   
   ;Gui, Add, Button, x124 y196 w55 +center gGuiClose, Ok
   
   Gui, Add, Button, x190 y260 w55 +center gCopy_Hex_To_Clipboard, Okay
   
   Gosub Show_New_Color
   
   Gui, Show, x440 y329 h300 w260, Color Picker
   
   WinWait,Color Picker ahk_class AutoHotkeyGUI
   WinWaitClose
   
   Return
;===============================================================
;Gui Basics

;GuiClose:
;    Msgbox,4,, Copy hex code to clipboard before exiting?
;    IfMsgBox, Yes
;		gosub Copy_Hex_To_Clipboard	
;	ExitApp

;===============================================================
;Sliders
Change_Opacity_Slider:
      GuiControlGet, Opacity_Slider
      GuiControl, Text, Opacity_Value, %Opacity_Slider%
      gosub Show_New_Color
   Return 

   Change_Red_Slider:
      GuiControlGet, Red_Slider
      GuiControl, Text, Red_Value, %Red_Slider%
      gosub Show_New_Color
   Return   
   
   Change_Green_Slider:
      GuiControlGet, Green_Slider
      GuiControl, Text, Green_Value, %Green_Slider%
      Gosub Show_New_Color
   Return   
   
   Change_Blue_Slider:
      GuiControlGet, Blue_Slider
      GuiControl, Text, Blue_Value, %Blue_Slider%
      Gosub Show_New_Color
   Return   

;===============================================================
;Value  boxes
Change_Opacity_Value:
      GuiControlGet, Opacity_Value
      GuiControl, Text, Opacity_Slider, %Opacity_Value%
      Gosub Show_New_Color
   Return   

Change_Red_Value:
      GuiControlGet, Red_Value
      GuiControl, Text, Red_Slider, %Red_Value%
      Gosub Show_New_Color
   Return   
   
   Change_Green_Value:
      GuiControlGet, Green_Value
      GuiControl, Text, Green_Slider, %Green_Value%
      Gosub Show_New_Color
   Return   
   
   Change_Blue_Value:
      GuiControlGet, Blue_Value
      GuiControl, Text, Blue_Slider, %Blue_Value%
      Gosub Show_New_Color
Return   

;===============================================================
;Update new color   
Show_New_Color:
   
   Gui submit, nohide
   
   SetFormat, integer, hex
   Opacity_Value += 0
   Red_Value += 0
   Green_Value += 0
   Blue_Value += 0
   SetFormat, integer, d
   
   Stringright,Opacity_Value,Opacity_Value,StrLen(Opacity_Value)-2
   If (StrLen(Opacity_Value)=1)
      Opacity_Value=0%Opacity_Value%
   
   Stringright,Red_Value,Red_Value,StrLen(Red_Value)-2
   If (StrLen(Red_Value)=1)
      Red_Value=0%Red_Value%
      
   Stringright,Green_Value,Green_Value,StrLen(Green_Value)-2
   If (StrLen(Green_Value)=1)
      Green_Value=0%Green_Value%
      
   Stringright,Blue_Value,Blue_Value,StrLen(Blue_Value)-2
   If (StrLen(Blue_Value)=1)
      Blue_Value=0%Blue_Value%
   
   New_Color_Value=%Red_Value%%Green_Value%%Blue_Value%
   
   GuiControl, Text, Color_Value, %New_Color_Value%
   GuiControl, +Background%New_Color_Value%, Color_Block
   
Return 

;===============================================================
;Copy hex color code to clipboard 
GuiClose:
    Gui, Destroy
Return 

Copy_Hex_To_Clipboard:
	clipboard =
	GuiControlGet, Color_Value
	clipboard = %Color_Value%
    Gui, Destroy
     
Return 