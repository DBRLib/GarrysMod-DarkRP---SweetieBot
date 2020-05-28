//-----------------------------------------------------------------------------------------------
//
//server help desk
//
//@author Deven Ronquillo
//@Professional codebreaker: MikomiHooves
//@version 7/26/17
//-----------------------------------------------------------------------------------------------

//----------colorssss-----------------

local default = Color(125,125, 125, 255)

local disagree = Color( 20, 20, 20, 255)
local disagreec = Color( 15, 15, 15, 255)
//--------scrub vals----------------------

local widthBase = ScrW()*.8
local heightBase = ScrH()*.8

//--------------fonts----------------------------
surface.CreateFont( "HelpDeskInfoFont", {
	font = "Arial",
	size = 25,
	weight = 750,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = true,
	outline = false,
} )

surface.CreateFont( "HelpDeskHeadingFont", {
	font = "Arial",
	size = 30,
	weight = 750,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = true,
	outline = false,
} )

surface.CreateFont( "HelpDeskTitleFont", {
	font = "Arial",
	size = 45,
	weight = 750,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = true,
	outline = false,
} )




//------------------------------------------------------------------------
//category Name
//------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self:SetContentAlignment(4)
    self:SetTextInset(5, 0)
    self:SetFont("HelpDeskHeadingFont")
end

function PANEL:Paint(w, h)

    draw.RoundedBox(4, 0, 0, w, h, Color(217, 159, 242))
end

function PANEL:SetCategory(cat)
    
    self:SetText(cat)
end

derma.DefineControl("HelpDeskCategoryHeader", "", PANEL, "DCategoryHeader")







--[[---------------------------------------------------------------------------
Contents of category headers
---------------------------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
    self:EnableVerticalScrollbar()
end

function PANEL:Rebuild()
    if #self.Items == 0 then return end

    local height = 0
    local k = 0
    for i, item in pairs(self.Items) do
        if not item:IsVisible() then continue end
        k = k + 1
        item:SetWide(self:GetWide() - 10)
        item:SetPos(5, height)
        height = height + item:GetTall() + 10
    end
    self:GetCanvas():SetTall(height)
    self:SetTall(height)
end

function PANEL:Paint()

	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(), Color(40,40,40,200))
end


function PANEL:Refresh()
    for k,v in pairs(self.Items) do
        if v.Refresh then v:Refresh() end
    end
    self:InvalidateLayout()
end

function PANEL:Add(dat)

	table.insert(self.Items, dat)
	dat:SetParent(self)
end
derma.DefineControl("HelpDeskCategoryContents", "", PANEL, "DPanelList")








--[[---------------------------------------------------------------------------
Category panel
---------------------------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
    if self.Header then self.Header:Remove() end
    self.Header = vgui.Create("HelpDeskCategoryHeader", self)
    self.Header:Dock(TOP)
    self.Header:SetSize(20, 40)
    self:SetSize(16, 16)
    self:SetExpanded(false)
    self:SetMouseInputEnabled(true)
    self:SetAnimTime(0.2)
    self.animSlide = Derma_Anim("Anim", self, self.AnimSlide)
    self:SetPaintBackgroundEnabled(false)
    self:DockMargin(10, 0, 10, 5)
    self:DockPadding(10,0, 10, 5)
    self.Contents = vgui.Create("HelpDeskCategoryContents", self)

    self:SetContents(self.Contents)
end

function PANEL:Paint()

end

function PANEL:SetButtonFactory(f)
    self.buttonFactory = f
end

function PANEL:SetCategory(cat)

    self.Header:SetCategory(cat)
end

function PANEL:SetPerformLayout(f)
    self.Contents.PerformLayout = function()
        f(self.Contents)
        self.Contents.BaseClass.PerformLayout(self.Contents)
    end
end

function PANEL:GetItems()
    return self.Contents:GetItems()
end

function PANEL:Add(dat)
   
   self.Contents:Add(dat)
end

function PANEL:Refresh()

    if IsValid(self.Contents) then

     self.Contents:Refresh()
	end
end

derma.DefineControl("HelpDeskCategory", "", PANEL, "DCollapsibleCategory")











function OpenHelpDesk()

	chat.AddText(Color(217, 159, 242), "[SweetieBot] ", Color(255, 255, 255),"Fetching Help Desk, one moment...")

	//-------main panel--------------------------------------

	helpDeskFrame = vgui.Create( "DFrame" )

	helpDeskFrame:SetPos( 0, 0 )
	helpDeskFrame:SetTitle("")
	helpDeskFrame:SetSize( ScrW(), ScrH())
	helpDeskFrame:SetBackgroundBlur( true )
	helpDeskFrame:SetVisible( true )
	helpDeskFrame:SetDraggable( false )
	helpDeskFrame:ShowCloseButton( false )
	helpDeskFrame:MakePopup()

	helpDeskFrame.Paint = function()

		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color (25, 25, 25, 250))
		draw.RoundedBox(0, (ScrW() / 2) - (widthBase/5)*2.5, (ScrH()/2) - (heightBase/10)*6, (widthBase/5)*4, heightBase/10, disagree)
	end

	//------------------panelllll-------------------------	
	local helpDeskPanel = vgui.Create("DScrollPanel", helpDeskFrame )

	helpDeskPanel:SetPos((ScrW()/2) - ((widthBase)/2), (ScrH()/2) - ((heightBase)/2))
	helpDeskPanel:SetSize(widthBase, heightBase)

	helpDeskPanel.Paint = function(self)

		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color (255, 255, 255, 255))

		self:GetVBar().Paint = function() end
        self:GetVBar().btnGrip.Paint = function() end
        self:GetVBar().btnUp.Paint = function() end
        self:GetVBar().btnDown.Paint = function() end
	end

	//-----------------butttonnnssss----------------------
		
	local helpDeskClose = vgui.Create( "DButton", DermaPanel )

	helpDeskClose:SetText( "Close" )
	helpDeskClose:SetSize( widthBase/5, heightBase/10 )
	helpDeskClose:SetPos((ScrW() / 2) - (widthBase/5)*-1.5, (ScrH()/2) - (heightBase/10)*6)
	helpDeskClose:SetFont("HelpDeskHeadingFont")
	helpDeskClose:SetTextColor(default)
	helpDeskClose:SetParent( helpDeskFrame )

	helpDeskClose.Paint = function()

		draw.RoundedBox( 0, 0, 0,  ScrW() / 6, ScrH() / 8, disagree)
		draw.RoundedBox( 0, 0, heightBase/10 - heightBase/60, widthBase/5, heightBase / 60, disagreec)
	end
		
	helpDeskClose.OnCursorEntered = function()

		surface.PlaySound("garrysmod/ui_return.wav")
		helpDeskClose:SetTextColor(Color(140,30, 20, 255))
		disagreec = Color(140,30,20,255)
	end		
		
	helpDeskClose.OnCursorExited = function()

		disagreec = Color(15, 15, 15, 255)
		helpDeskClose:SetTextColor(default)
	end
		
	helpDeskClose.DoClick = function()

		helpDeskFrame:Close()
		surface.PlaySound( "/buttons/bell1.wav" )
	end
		
	local HelpDeskTopTitle = vgui.Create( "DLabel", DermaPanel )

	HelpDeskTopTitle:SetText( "[SweetieBot] Help Desk" )
	HelpDeskTopTitle:SetSize( (widthBase/5)*4, heightBase/10 )
	HelpDeskTopTitle:SetPos((ScrW() / 2) - (widthBase/5)*2.5, (ScrH()/2) - (heightBase/10)*6)
	HelpDeskTopTitle:SetFont("HelpDeskTitleFont")
	HelpDeskTopTitle:SetTextColor(Color(217, 159, 242))
	HelpDeskTopTitle:SetParent( helpDeskFrame )

	//--------------------does cool shittt---------------------------

	local helpDeskList = vgui.Create( "DListLayout", helpDeskPanel )
	helpDeskList:SetSize( helpDeskPanel:GetWide(), helpDeskPanel:GetTall())
	helpDeskList:SetPos( 0, 0)

	//----------------------------------------THE HUD----------------------------------
	local helpDeskCategory = vgui.Create("HelpDeskCategory", helpDeskList)

	helpDeskCategory:SetCategory("The Hud")

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "Whats so great about the hud?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "Unlike traditional huds which only server the purpose of displaying information, ours contains aditional interactive buttons to make it 20% cooler. By pressing the [F3] key you will be able to interact with the buttons on the hud." )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "So, what do these buttons do?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "The first button, a man in black, is a staff call button.\n\n This allows you to call staff in a moments notice and avoids the need to deal with any pesky commands.\n\n The second button, a smol poni, takes you to our steam page.\n\n Here you can find all kinds of information like links to our media acounts, workshop addons, staff aplications, or iffin you're just looking for a chat you can chat it up in the comments section.\n\n The third and last button, a black cog, is a settings botton.\n\n My personal favorite of the three, this button allows you to to change the HUD colors, but it doesnt stop there. Networked into various guis across the server, the settings chosen here will apply across then all allowing for a custom tailored feel for everyone. Have an oc? Why not color your HUD after them!" )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	//--------------------------SILENT RAID-------------------------------------------------

	local helpDeskCategory = vgui.Create("HelpDeskCategory", helpDeskList)

	helpDeskCategory:SetCategory("Silent Raid")

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "What does it do?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "Silent raid makes raiding more immersive, by removing the need to advert your crimes to the whole server. No longer do you have to worry about people meta gaming, or the rediculous notion that a robber would announce to the whole city what they are doing. At the same time, any raid is logged to staff, and all staff are notified. However people may still report your suspicious activity to the police, so don't be seen!\n\n The addon also will track the amount of time you have been raiding, and if you die. If either of these conditions has been met the raid will be ended automatically for you. This will also be logged, and staff will be notified." )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "Neat, how do I use it?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "To begin your raid use the chat command /raid [Targets name] the target must be the main owner of the building. If your command is valid you will be notified. If it is invalid you will be notified of this. This could be due to an invalid target, or if you are the wrong job. Or maybe you want to just raid your self?\n\n To end the raid you use the command /over, this will notify the staff and log the action. This will occur automatically if you die, or if five minutes pass.\n\n The targets names will automatically fill, and you can press tab to alternate through matching targets." )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	//----------------------------------------Donate--------------------------------------

	local helpDeskCategory = vgui.Create("HelpDeskCategory", helpDeskList)

	helpDeskCategory:SetCategory("Donate Menu")

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "What does it do?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "This allows you to get to the donation website, and to retry the application of your sponsor status if there is an error." )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "How do I use it?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "Use the command !donate to open the menu. On the main screen, you will see your packages and the status of the package. \n\nClick the donate tab to be taken to the donation website." )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	//-----------------------------------------------------------mcore-----------------------------------------------------

	local helpDeskCategory = vgui.Create("HelpDeskCategory", helpDeskList)

	helpDeskCategory:SetCategory("MCore")

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "What does it do?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "Makes your game run better most likely. By default Gmod only uses one CPU core. Recently there was an update that enabled the functionality to use multiple cores. This allows the game to do more physics calculations and rendering before slowing down. On most systems, you will see at least a 20% improvement in coolness, performance, and fps. " )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "How do I use it?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "When you first spawn you will be asked to enable or disable this feature. You can check the box to have the server remember your setting and to not bother you. \n\nIn the event, you wish to change your choice simply use the command /mcore in the chat. This will open the menu again. \n\nIf you wish to change the setting quickly without altering your saved preference you can use the commands /mcore on and /mcore off to toggle the settings in chat. Doing so will not overwrite your saved or unsaved preference. So when you rejoin the server you will either be asked again, or your saved setting will be applied." )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	//---------------------------------------------------fist full of bits--------------------------------

	local helpDeskCategory = vgui.Create("HelpDeskCategory", helpDeskList)

	helpDeskCategory:SetCategory("Fist Full of Bits")

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "What does it do?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "This is a creative raiding addon where the value of the raid increases over time and is reset when a raid is complete. There is no cooldown for this however, the real incentive is to wait for the big score! Keep an eye out for the police though because the bank manager will press that silent alarm as soon as you begin the raid. " )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "How does it work?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "Press the use key while looking at the raid stack. On activation a 5 min timer will begin, if you survive you will be rewarded. If you die or leave the area you will lose it all, and the police will be rewarded for their effort in thwarting your scheme." )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	//----------------------------------------SweetieBot--------------------------------------

	local helpDeskCategory = vgui.Create("HelpDeskCategory", helpDeskList)

	helpDeskCategory:SetCategory("SweetieBot")

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "What is SweetieBot?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "SweetieBot is a collection of functions that work together to help you while on the server. Right now most of SweetieBot's functions are automated, needing no user input." )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "What functions may I use?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "Right now the only exposed functions are /motd which will call the motd for you and /help which calls the help desk containing all the information one would need, but you should already be familiar with that one >.<" )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "IMPORTANT" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "SweetieBot's automated functions are limited to the capability of gmod and therefore are handicapped in ways. The most notable of these handicaps is that which governs SweetieBot's user group functions. Due to discrepancies between gmod and the steam API, once a user has joined the steam group it may take an upwards of 15 minutes for the steam servers to update. Once this occurs the user may restart their client for gmod to fetch the latest libraries for its servers and finally have SweetieBot set their rank to its appropriate position based on the prerequisites." )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	helpDeskCategory.Contents:Rebuild()

	//--------------------------PrintsALot-------------------------------------------------

	local helpDeskCategory = vgui.Create("HelpDeskCategory", helpDeskList)

	helpDeskCategory:SetCategory("PrintsALot")

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "What does it do?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "PrintsALot is a homebrew printer addon that lets you print bits until they are falling out of your pocket! Printers currently have four upgrades sets. These sets are:\n\nPower Delivery: $500 per stage - Increases voltage output, allowing the system to push itself further.\nCooling System: $150 per stage - Increases the heat disipation power of the printer, allowing for smooth funtion at high loads.\n Eficiency: $250 per stage - Optomizes power usage across components to squeeze out that extra bit.\n Overdrive: $1000 per stage - The final tweak, pushing all system components well past their safety limits to achieve maximum bit production." )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

	local helpDeskTitleText = vgui.Create( "DLabel")

	helpDeskTitleText:SetText( "Neat, how do I use it?" )
	helpDeskTitleText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskTitleText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskTitleText:SetFont("HelpDeskHeadingFont")
	helpDeskTitleText:SetTextColor(Color(217, 159, 242))
	helpDeskTitleText:SetAutoStretchVertical(true)
	helpDeskTitleText:SetWrap(true)

	helpDeskCategory:Add(helpDeskTitleText)

	local helpDeskText = vgui.Create( "DLabel")

	helpDeskText:SetText( "Once you purchase your printer you just sit back and relax. Every 5 or so minutes of operation allocates one more free slot for an upgrade. Simply use the printer hud to find the desired upgrade and press your use key. That's it! You will be swimming in bits in no time^^ " )
	helpDeskText:SetSize( (widthBase/5)*4, heightBase/10 )
	helpDeskText:SetPos((ScrW() / 2) - (widthBase/5)*2.5)
	helpDeskText:SetFont("HelpDeskInfoFont")
	helpDeskText:SetTextColor(Color(217, 200, 242))
	helpDeskText:SetAutoStretchVertical(true)
	helpDeskText:SetWrap(true)

	helpDeskCategory:Add(helpDeskText)

end
net.Receive("NetHelpClient",OpenHelpDesk)
