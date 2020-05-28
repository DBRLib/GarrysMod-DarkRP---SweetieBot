//-----------------------------------------------------------------------------------------------
//
//server welcome message
//
//@author Deven Ronquillo
//@Professional codebreaker: MikomiHooves
//@version 7/26/17
//-----------------------------------------------------------------------------------------------

function DisplayWelcome(ans)

		timer.Simple(30,function()

		if ans then

			chat.AddText(Color(217, 159, 242), "[SweetieBot] ", Color(255, 255, 255),"Welcome back to ", Color(157,242,215), "Celestial Underground, \n", LocalPlayer(), Color(255,255,255), ".")
		else

			chat.AddText(Color(217, 159, 242), "[SweetieBot] ", Color(255, 255, 255),"Welcome to ", Color(157,242,215), "Celestial Underground, \n", LocalPlayer(), Color(255, 255, 255), ",\n consider joining our steam group for pac access or donating for special perks!")
		end
	end)
end

net.Receive("NetGroupResultsClient",function()

	DisplayWelcome(net.ReadBool())
end)