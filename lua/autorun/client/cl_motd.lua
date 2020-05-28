//-----------------------------------------------------------------------------------------------
//
//server motd
//
//@author Deven Ronquillo
//@Professional codebreaker: MikomiHooves
//@version 7/26/17
//-----------------------------------------------------------------------------------------------

//-------- Config -------------------

local motdURL = "http://celestialunderground.org/"
local donateURL = "http://celestialunderground.org/donate"
local steamGroupURL = "http://steamcommunity.com/groups/celestialunderground"

//----------colorssss-----------------

local agree = Color( 20, 20, 20, 255)
local agreec = Color( 15, 15, 15, 255)
local default = Color(125,125, 125, 255)

local orange = Color(15, 15, 15, 255)
local blue = Color(15, 15, 15, 255)
local purple = Color(15, 15, 15, 255)
local disagree = Color( 20, 20, 20, 255)
local disagreec = Color( 15, 15, 15, 255)
//--------scrub vals----------------------

local widthBase = ScrW()*.8
local heightBase = ScrH()*.8

//--------------fonts----------------------------

surface.CreateFont( "DefaultMotdFont", {
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




function OpenMotd()

	chat.AddText(Color(217, 159, 242), "[SweetieBot] ", Color(255, 255, 255),"Fetching MOTD, one moment...")

	//-------main panel--------------------------------------

	MainMenu = vgui.Create( "DFrame" )

	MainMenu:SetPos( 0, 0 )
	MainMenu:SetTitle("")
	MainMenu:SetSize( ScrW(), ScrH())
	MainMenu:SetBackgroundBlur( true )
	MainMenu:SetVisible( true )
	MainMenu:SetDraggable( false )
	MainMenu:ShowCloseButton( false )
	MainMenu:MakePopup()

	MainMenu.Paint = function()

		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color (25, 25, 25, 250))
	end

	//------------------tabssssss-------------------------	
	local motd = vgui.Create("HTML", MainMenu )

	motd.SetParent( MainMenu )
	motd:SetPos((ScrW()/2) - ((widthBase)/2), (ScrH()/2) - ((heightBase)/2))
	motd:SetVisible(true)
	motd:SetSize(widthBase, heightBase)
	motd:OpenURL(motdURL)

	local steamGroup = vgui.Create("HTML", MainMenu )

	steamGroup.SetParent( MainMenu )
	steamGroup:SetPos((ScrW()/2) - ((widthBase)/2), (ScrH()/2) - ((heightBase)/2))
	steamGroup:SetVisible(false)
	steamGroup:SetSize(widthBase, heightBase)
	steamGroup:OpenURL(steamGroupURL)
		
	local donate = vgui.Create("HTML", MainMenu )

	donate.SetParent( MainMenu )
	donate:SetPos((ScrW()/2) - ((widthBase)/2), (ScrH()/2) - ((heightBase)/2))
	donate:SetVisible(false)
	donate:SetSize(widthBase, heightBase)
	donate:OpenURL(donateURL)

	//-----------------butttonnnssss----------------------
	
	local DermaButton = vgui.Create("DButton", DermaPanel)

	DermaButton:SetText( "Agree" )	
	DermaButton:SetSize( widthBase/5, heightBase/10 )
	DermaButton:SetPos( (ScrW() / 2) - (widthBase/5)*2.5, (ScrH()/2) - (heightBase/10)*6)
	DermaButton:SetFont("DefaultMotdFont")
	DermaButton:SetTextColor(default)
	DermaButton:SetParent( MainMenu )

	DermaButton.Paint = function()

		draw.RoundedBox( 0, 0, 0,  ScrW() / 6, ScrH() / 8, agree)
		draw.RoundedBox( 0, 0, heightBase/10 - heightBase/60, widthBase/5, heightBase / 60, agreec)
	end
			
	DermaButton.OnCursorEntered = function()

		surface.PlaySound("garrysmod/ui_return.wav")
		DermaButton:SetTextColor(Color(30,140,20,255))
		agreec = Color(30,140,20,255)
	end		

	DermaButton.OnCursorExited = function()

		DermaButton:SetTextColor(default)
		agreec = Color(15, 15, 15, 255)
	end
		
	DermaButton.DoClick = function()

		surface.PlaySound( "/buttons/bell1.wav")
		MainMenu:Close()
	end	

	local DermaButton = vgui.Create( "DButton", DermaPanel )

	DermaButton:SetText( "Steam Group" )
	DermaButton:SetSize( widthBase/5, heightBase/10 )
	DermaButton:SetPos((ScrW() / 2) - (widthBase/5)*-0.5, (ScrH()/2) - (heightBase/10)*6)
	DermaButton:SetFont("DefaultMotdFont")
	DermaButton:SetTextColor(default)
	DermaButton:SetParent( MainMenu )
	DermaButton.Paint = function()

		draw.RoundedBox( 0, 0, 0,  ScrW() / 6, ScrH() / 8, disagree)
		draw.RoundedBox( 0, 0, heightBase/10 - heightBase/60, widthBase/5, heightBase / 60, orange)
	end
		
	DermaButton.OnCursorEntered = function()

		surface.PlaySound("garrysmod/ui_return.wav")
		DermaButton:SetTextColor(Color(255,150,0,255))
		orange = Color(255,150,0,255)
	end	

	DermaButton.OnCursorExited = function()

		DermaButton:SetTextColor(default)
		orange = Color(15, 15, 15, 255)
	end
		
	DermaButton.DoClick = function()

		surface.PlaySound( "/buttons/bell1.wav")
		motd:MoveTo( 0 - (ScrW()/2) - ((widthBase)/2),  (ScrH()/2) - ((heightBase)/2), 1.1, -1, 4)
		donate:MoveTo( (ScrW()/2) - ((widthBase)/2), ScrH(), 1.1, -1, 4)
		timer.Simple( 1, function() motd:SetVisible(false)
		donate:SetVisible(false)
		end )

		timer.Simple( 0.7, function() 

			steamGroup:SetVisible(true)
			steamGroup:MoveTo( (ScrW()/2) - ((widthBase)/2), (ScrH()/2) - ((heightBase)/2), 1.1, -1, 4)
		end )
	end	
		
	local DermaButton = vgui.Create( "DButton", DermaPanel )

	DermaButton:SetText( "Disagree" )
	DermaButton:SetSize( widthBase/5, heightBase/10 )
	DermaButton:SetPos((ScrW() / 2) - (widthBase/5)*-1.5, (ScrH()/2) - (heightBase/10)*6)
	DermaButton:SetFont("DefaultMotdFont")
	DermaButton:SetTextColor(default)
	DermaButton:SetParent( MainMenu )

	DermaButton.Paint = function()

		draw.RoundedBox( 0, 0, 0,  ScrW() / 6, ScrH() / 8, disagree)
		draw.RoundedBox( 0, 0, heightBase/10 - heightBase/60, widthBase/5, heightBase / 60, disagreec)
	end
		
	DermaButton.OnCursorEntered = function()

		surface.PlaySound("garrysmod/ui_return.wav")
		DermaButton:SetTextColor(Color(140,30, 20, 255))
		disagreec = Color(140,30,20,255)
	end		
		
	DermaButton.OnCursorExited = function()

		disagreec = Color(15, 15, 15, 255)
		DermaButton:SetTextColor(default)
	end
		
	DermaButton.DoClick = function()

		MainMenu:Close()
		surface.PlaySound( "buttons/button8.wav" )
		RunConsoleCommand( "disconnect" )
	end
		
	local DermaButton = vgui.Create( "DButton", DermaPanel )

	DermaButton:SetText( "Donate" )
	DermaButton:SetSize( widthBase/5, heightBase/10 )
	DermaButton:SetPos((ScrW() / 2) - (widthBase/5)*0.5, (ScrH()/2) - (heightBase/10)*6)
	DermaButton:SetTextColor(default)
	DermaButton:SetFont("DefaultMotdFont")
	DermaButton:SetParent( MainMenu )
	DermaButton.Paint = function()

		draw.RoundedBox( 0, 0, 0,  ScrW() / 6, ScrH() / 8, disagree)
		draw.RoundedBox( 0, 0, heightBase/10 - heightBase/60, widthBase/5, heightBase / 60, blue)
	end
		
	DermaButton.OnCursorEntered = function()

		surface.PlaySound("garrysmod/ui_return.wav")
		DermaButton:SetTextColor(Color(30,140,165,255))
		blue = Color(30,140,165,255)
	end		

	DermaButton.OnCursorExited = function()

		DermaButton:SetTextColor(default)
		blue = Color(15, 15, 15, 255)
	end
		
	DermaButton.DoClick = function()

		surface.PlaySound( "/buttons/bell1.wav")
		steamGroup:MoveTo( ScrW(), (ScrH()/2) - ((heightBase)/2), 1.1, -1, 4)
		motd:MoveTo( 0 - (ScrW()/2) - ((widthBase)/2),  (ScrH()/2) - ((heightBase)/2), 1.1, -1, 4)
		timer.Simple( 1, function()

			steamGroup:SetVisible(false) 
			motd:SetVisible(false)
		end )

		timer.Simple( 0.7, function()

			donate:SetVisible(true)
			donate:MoveTo( (ScrW()/2) - ((widthBase)/2), (ScrH()/2) - ((heightBase)/2), 1.1, -1, 4)
		end )
	end	
		
	local DermaButton = vgui.Create( "DButton", DermaPanel )

	DermaButton:SetText( "MOTD" )
	DermaButton:SetSize( widthBase/5, heightBase/10 )
	DermaButton:SetPos((ScrW() / 2) - (widthBase/5)*1.5, (ScrH()/2) - (heightBase/10)*6)
	DermaButton:SetFont("DefaultMotdFont")
	DermaButton:SetTextColor(default)
	DermaButton:SetParent( MainMenu )

	DermaButton.Paint = function()

		draw.RoundedBox( 0, 0, 0,  ScrW() / 6, ScrH() / 8, disagree)
		draw.RoundedBox( 0, 0, heightBase/10 - heightBase/60, widthBase/5, heightBase / 60, purple)
	end
		
	DermaButton.OnCursorEntered = function()

		surface.PlaySound("garrysmod/ui_return.wav")
		DermaButton:SetTextColor(Color(200,0,255,255))
		purple = Color(200,0,255,255)
	end		

	DermaButton.OnCursorExited = function()

		DermaButton:SetTextColor(default)
		purple = Color(15, 15, 15, 255)
	end
		
	DermaButton.DoClick = function()

		surface.PlaySound( "/buttons/bell1.wav")
		steamGroup:MoveTo( ScrW(), (ScrH()/2) - ((heightBase)/2), 1.1, -1, 4)
		donate:MoveTo((ScrW()/2) - ((widthBase)/2), ScrH(), 1.1, -1, 4)
		timer.Simple( 1, function() 

			steamGroup:SetVisible(false) 
			donate:SetVisible(false)
		end )

		timer.Simple( 0.7, function() 

			motd:SetVisible(true)
			motd:MoveTo((ScrW()/2) - ((widthBase)/2),(ScrH()/2) - ((heightBase)/2), 1.1, -1, 4)
		end )
	end
end
net.Receive("NetMotdClient",OpenMotd)
