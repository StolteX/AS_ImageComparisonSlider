B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.8
@EndOfDesignText@
'Author: Alexander Stolte
'V1.0

#If Documentation
Changelog:
V1.0
	-Release

#End If

#DesignerProperty: Key: ShowDescription, DisplayName: Show Description, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: DescriptionLeft, DisplayName: Description Left, FieldType: String, DefaultValue: Modified
#DesignerProperty: Key: DescriptionRight, DisplayName: Description Right, FieldType: String, DefaultValue: Original
#DesignerProperty: Key: SliderStayOnLastPosition, DisplayName: Slider Stay On Last Position, FieldType: Boolean, DefaultValue: True

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private mBase As B4XView 'ignore
	Private xui As XUI 'ignore
	
	'Views
	Private xlbl_description1,xlbl_description2 As B4XView
	Private xpnl_sliderbackground,xlbl_slider As B4XView
	
	Private downx As Float
			
	Private xbmp_1,xbmp_2 As B4XBitmap
	Dim xcv_main As B4XCanvas
	
	'Properties
	Private g_ShowDescription As Boolean
	Private g_DescriptionLeft,g_DescriptionRight As String
	Private g_SliderStayOnLastPosition As Boolean
	
	
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base

	If xpnl_sliderbackground.IsInitialized = False Then
		ini_props(Props)
		ini_views
	End If

#if B4A
	Base_Resize(mBase.Width,mBase.Height)
	
	Private r As Reflector
	r.Target = xpnl_sliderbackground
	r.SetOnTouchListener("xpnl_sliderbackground_Touch2")
	
#End If

End Sub

Private Sub ini_props(props As Map)
	g_ShowDescription = props.Get("ShowDescription")
	g_DescriptionLeft = props.Get("DescriptionLeft")
	g_DescriptionRight = props.Get("DescriptionRight")
	g_SliderStayOnLastPosition = props.Get("SliderStayOnLastPosition")
	
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
  
	xcv_main.Resize(Width,Height)
	
	xpnl_sliderbackground.SetLayoutAnimated(0,Width/2 - 40dip/2,Height/2 - 40dip/2,40dip,40dip)
	xlbl_slider.SetLayoutAnimated(0,0,0,xpnl_sliderbackground.Width,xpnl_sliderbackground.Height)
	If xbmp_1.IsInitialized = True And xbmp_2.IsInitialized = True Then SlideImages(xpnl_sliderbackground.Left + xpnl_sliderbackground.Width/2)
	
	xlbl_description1.Visible = g_ShowDescription
	xlbl_description2.Visible = g_ShowDescription
	
	xlbl_description1.SetLayoutAnimated(0,0,Height - 16dip,Width/2,16dip)
	xlbl_description2.SetLayoutAnimated(0,Width/2,Height - 16dip,Width/2,16dip)

End Sub

Private Sub ini_views
	
	xlbl_description1 = CreateLabel("")
	xlbl_description2 = CreateLabel("")
	
	xpnl_sliderbackground = xui.CreatePanel("xpnl_sliderbackground")
	xlbl_slider = CreateLabel("")
	
	mBase.AddView(xlbl_description1,0,0,0,0)
	mBase.AddView(xlbl_description2,0,0,0,0)
	
	mBase.AddView(xpnl_sliderbackground,0,0,0,0)
	xpnl_sliderbackground.AddView(xlbl_slider,0,0,40dip,40dip)
	
	xcv_main.Initialize(mBase)
	
	
	xlbl_description1.Text = g_DescriptionLeft
	xlbl_description2.Text = g_DescriptionRight
	
	xlbl_description1.Font = xui.CreateDefaultBoldFont(12)
	xlbl_description2.Font = xui.CreateDefaultBoldFont(12)
	
	xlbl_description1.TextColor = xui.Color_White
	xlbl_description2.TextColor = xui.Color_White
  
	xlbl_description1.SetTextAlignment("CENTER","LEFT")
	xlbl_description2.SetTextAlignment("CENTER","RIGHT")
	
	xlbl_slider.SetColorAndBorder(xui.Color_Blue,0,0,xlbl_slider.Height/2)
	xlbl_slider.Font = xui.CreateMaterialIcons(20)
	xlbl_slider.SetTextAlignment("CENTER","CENTER")
	xlbl_slider.TextColor = xui.Color_White
	xlbl_slider.Text = Chr(0xE86F)
	
End Sub

#Region Properties

Public Sub getImage1 As B4XView
	Return xbmp_1
End Sub

Public Sub getImage2 As B4XView
	Return xbmp_2
End Sub

Public Sub getSliderPanel As B4XView
	Return xpnl_sliderbackground
End Sub

Public Sub getSliderLabel As B4XView
	Return xlbl_slider
End Sub

Public Sub getDescriptionLabel_Right As B4XView
	Return xlbl_description2
End Sub

Public Sub getDescriptionLabel_Left As B4XView
	Return xlbl_description1
End Sub

Public Sub setImages(img1 As B4XBitmap,img2 As B4XBitmap)
	xbmp_1 = img1'.Resize(mBase.Width,mBase.Height,True)
	xbmp_2 = img2'.Resize(mBase.Width,mBase.Height,True)

	SlideImages(xpnl_sliderbackground.Left + xpnl_sliderbackground.Width/2)
	
End Sub

#End Region

Private Sub SlideImages(size As Float)
	
	Dim tmp_rect_1 As B4XRect
	tmp_rect_1.Initialize(0,0,mBase.Width,mBase.Height)
	
	Dim tmp_rect_2 As B4XRect
	tmp_rect_2.Initialize(size,0,mBase.Width,mBase.Height)

	xcv_main.DrawBitmap(xbmp_1.Resize(mBase.Width,mBase.Height,False).Crop(0,0,mBase.Width,mBase.Height),tmp_rect_1)
	xcv_main.DrawBitmap(xbmp_2.Resize(mBase.Width,mBase.Height,False).Crop(size,0,mBase.Width - size,mBase.Height),tmp_rect_2)
	xcv_main.Invalidate
End Sub

#IF B4A
Private Sub xpnl_sliderbackground_Touch2 (o As Object, ACTION As Int, x As Float, y As Float, motion As Object) As Boolean
#ELSE
Private Sub xpnl_sliderbackground_Touch(Action As Int, X As Float, Y As Float) As Boolean
#END IF
	If Action = xpnl_sliderbackground.TOUCH_ACTION_DOWN Then

		downx  = x
    
	Else if Action = xpnl_sliderbackground.TOUCH_ACTION_MOVE Then
    
		If xpnl_sliderbackground.Left + x - downx + xpnl_sliderbackground.Width < mBase.Width Then
		xpnl_sliderbackground.Left = Max(0,xpnl_sliderbackground.Left + x - downx)
		Else
			xpnl_sliderbackground.Left = Min(mBase.Width - xpnl_sliderbackground.Width,xpnl_sliderbackground.Left + x - downx + xpnl_sliderbackground.Width)
		End If
		
	Else if Action = xpnl_sliderbackground.TOUCH_ACTION_UP Then
    
		If g_SliderStayOnLastPosition = False Then	
			xpnl_sliderbackground.SetLayoutAnimated(250,mBase.Width/2 - xpnl_sliderbackground.Width/2,mBase.Height/2 - xlbl_slider.Height/2,xlbl_slider.Width,xlbl_slider.Height)
	'	Else
			'xpnl_sliderbackground.Left = xpnl_sliderbackground.Left + x - downx
		End If
      
	End If
	
	SlideImages(xpnl_sliderbackground.Left + xpnl_sliderbackground.Width/2)
	
	Return True
    
End Sub

#Region Functions
Private Sub CreateLabel(EventName As String) As B4XView
	Dim tmp_lbl As Label
	tmp_lbl.Initialize(EventName)
	Return tmp_lbl
End Sub
#End Region