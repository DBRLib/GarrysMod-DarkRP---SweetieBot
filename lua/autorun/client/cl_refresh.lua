//-----------------------------------------------------------------------------------------------
//
//Sweetie bot refresh message
//
//@author Deven Ronquillo
//@version 8/18/17
//-----------------------------------------------------------------------------------------------

function RefreshSuccess()

	chat.AddText(Color(217, 159, 242), "[SweetieBot] ", Color(255, 255, 255),"I have successfully refreshed your data!")	
end

net.Receive("NetRefreshReturn",function()

	RefreshSuccess()
end)








function DetermineServerRestart(day)

	DAYINSECONDS = 86400

	if (day > 1.75*DAYINSECONDS && day <= (2*DAYINSECONDS + 5*60*60)) then

		chat.AddText(Color(217, 159, 242), "[SweetieBot] ", Color(255, 255, 255),"A ", Color(244, 66, 131),"server restart ", Color(255, 255, 255),"will take place at approximately ", Color(157,242,215), "5:00 AM EST ", Color(255,255,255), ".")
	end
end

net.Receive("NetServerRestartReturn",function()

	DetermineServerRestart(net.ReadInt(32))
end)



function CreateTimers()



	timer.Create("RefreshPlayerData",600, 0,

	function() 

		if LocalPlayer():Alive() and IsValid(LocalPlayer()) then

			net.Start("NetRefresh")

				net.WriteEntity(LocalPlayer())
			net.SendToServer()
		end    
	end)





	timer.Create("CheckServerRestartTime",7200, 0,

	function() 

		if LocalPlayer():Alive() and IsValid(LocalPlayer()) then

			net.Start("NetServerRestart")

				net.WriteEntity(LocalPlayer())
			net.SendToServer()
		end    
	end)
end
net.Receive("NetPlayerTimersClient",function()

	CreateTimers()
end)