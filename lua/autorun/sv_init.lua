//-----------------------------------------------------------------------------------------------
//
//SweetieBot version 0.11 
//
//0.11 now with motd
//
//@author Deven Ronquillo
//@version 8/18/17
//-----------------------------------------------------------------------------------------------

if SERVER then

	require ('gxml')

	util.AddNetworkString("NetMotdClient")
	util.AddNetworkString("NetGroupResultsClient")
	util.AddNetworkString("NetHelpClient")
	util.AddNetworkString("NetRefresh")
	util.AddNetworkString("NetRefreshReturn")
	util.AddNetworkString("NetServerRestart")
	util.AddNetworkString("NetServerRestartReturn")
	util.AddNetworkString("NetPlayerTimersClient")


	function CheckForSteamGroup(ply)

		if ply:GetUserGroup() == "user" then

			print("------DETECTED NEW PLAYER------")
			print("Player: "..ply:Nick()) 

			http.Fetch("https://steamcommunity.com/groups/celestialunderground/memberslistxml/?xml=1",

			function(data)

				local members = XMLToTable(data)
				local count = 1

				print("------CHECKING STEAMGROUP FOR PLAYER------")

				print("player--key--value")

				for k ,v in pairs(members["memberList"]["members"]["steamID64"]) do

					print(ply:SteamID64().."	".."	"..k.."		"..v)

					if ply:SteamID64() == v then

						print("------FOUND MATCH SETTING RANK------")

						ply:SetUserGroup("Pony")

						net.Start("NetGroupResultsClient")

							net.WriteBool(true)
						net.Send(ply)

						return
					end

					if table.Count(members["memberList"]["members"]["steamID64"]) == count then

						print("------NO MATCH FOUND------")

						net.Start("NetGroupResultsClient")

							net.WriteBool(false)
						net.Send(ply)
					end

					count = count + 1
				end
			end,

			function()

				print("Error in fetching XML tables for group check on "..ply:GetName())
			end)
		else

			net.Start("NetGroupResultsClient")

				net.WriteBool(true)
			net.Send(ply)
		end
	end
	hook.Add("PlayerInitialSpawn", "CheckPlyForGroup", CheckForSteamGroup)

	function NetPlayerTimers(ply)

		net.Start("NetPlayerTimersClient")
		net.Send(ply)
	end
	hook.Add("PlayerInitialSpawn","TimerSPawnHook",NetPlayerTimers)



	function NetMotd(ply)

		net.Start("NetMotdClient")
		net.Send(ply)
	end
	hook.Add("PlayerInitialSpawn","MOTDSPawnHook",NetMotd)




	function NetHelp(ply)

		net.Start("NetHelpClient")
		net.Send(ply)
	end





	function RefreshSweetie(ply)

		if ply:GetUserGroup() == "user" then

			http.Fetch("https://steamcommunity.com/groups/equestriandreams/memberslistxml/?xml=1",

			function(data)

				local members = XMLToTable(data)

				for k ,v in pairs(members["memberList"]["members"]["steamID64"]) do

					if ply:SteamID64() == v then

						ply:SetUserGroup("Pony")

						net.Start("NetRefreshReturn")
						net.Send(ply)

						return
					end
				end
			end,

			function()

				print("Error in fetching XML tables for group check on "..ply:GetName())
			end)
		end
	end
	net.Receive("NetRefresh",function() RefreshSweetie(net.ReadEntity()) end)


	function CheckServerRestart(ply)

		CURRENTTIME = os.time()

		currentDayInSeconds = CURRENTTIME % 604800//seconds in a week modulus to get current day ranging from thursday to wednesday

		net.Start("NetServerRestartReturn")

			net.WriteInt(currentDayInSeconds, 32)
		net.Send(ply)	
	end
	net.Receive("NetServerRestart",function() CheckServerRestart(net.ReadEntity()) end)






	function CheckPlyChat( ply, text)

	
		if text == "/motd" then
			
			NetMotd(ply)
			return ""
		end

		if text == "/help" then
			
			NetHelp(ply)
			return ""
		end

		return
	end
	hook.Add( "PlayerSay", "CheckPlayerChat", CheckPlyChat)




	

	function InitialMapCleanUp()

		game.CleanUpMap(true)
		hook.Remove("PlayerInitialSpawn", "RunInitialMapCleanUp")
	end
	hook.Add("PlayerInitialSpawn","RunInitialMapCleanUp", InitialMapCleanUp)
end