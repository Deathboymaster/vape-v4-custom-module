loadstring(game:HttpGet("https://raw.githubusercontent.com/0primeSkidsALot/vape-plus-plus/main/script/keystrokes"))()
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local repstorage = game:GetService("ReplicatedStorage")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local mouse = lplr:GetMouse()
local robloxfriends = {}
local bedwars = {}
local getfunctions
local origC0 = nil
local collectionservice = game:GetService("CollectionService")
local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("vape/"..scripturl)
	else
		return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
	end
end
local bettergetfocus = function()
	if KRNL_LOADED then
		-- krnl is so garbage, you literally cannot detect focused textbox with UIS
		if game:GetService("TextChatService").ChatVersion == "TextChatService" then
			return (game:GetService("CoreGui").ExperienceChat.appLayout.chatInputBar.Background.Container.TextContainer.TextBoxContainer.TextBox:IsFocused())
		elseif game:GetService("TextChatService").ChatVersion == "LegacyChatService" then
			return ((game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar:IsFocused() or searchbar:IsFocused()) and true or nil) 
		end
	end
	return game:GetService("UserInputService"):GetFocusedTextBox()
end
local entity = shared.vapeentity
local WhitelistFunctions = shared.vapewhitelist
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local teleportfunc
local betterisfile = function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
	if tab.Method == "GET" then
		return {
			Body = game:HttpGet(tab.Url, true),
			Headers = {},
			StatusCode = 200
		}
	else
		return {
			Body = "bad exploit",
			Headers = {},
			StatusCode = 404
		}
	end
end 
local getasset = getsynasset or getcustomasset
local storedshahashes = {}
local oldchanneltab
local oldchannelfunc
local oldchanneltabs = {}
local networkownertick = tick()
local networkownerfunc = isnetworkowner or function(part)
	if gethiddenproperty(part, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual then 
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownertick = tick() + 8
	end
	return networkownertick <= tick()
end


local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("vape/"..scripturl)
	else
		return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
	end
end

local function addvectortocframe2(cframe, newylevel)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x, newylevel, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function getSpeedMultiplier(reduce)
	local speed = 1
	if lplr.Character then 
		local speedboost = lplr.Character:GetAttribute("SpeedBoost")
		if speedboost and speedboost > 1 then 
			speed = speed + (speedboost - 1)
		end
		if lplr.Character:GetAttribute("GrimReaperChannel") then 
			speed = speed + 0.6
		end
		if lplr.Character:GetAttribute("SpeedPieBuff") then 
			speed = speed + (queueType == "SURVIVAL" and 0.15 or 0.3)
		end
	end
	return reduce and speed ~= 1 and speed * (0.9 - (0.15 * math.floor(speed))) or speed
end

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, num, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = game:GetService("RunService").RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, num, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = game:GetService("RunService").Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, num, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = game:GetService("RunService").Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

local function runcode(func)
	func()
end

local function betterfind(tab, obj)
	for i,v in pairs(tab) do
		if v == obj or type(v) == "table" and v.hash == obj then
			return v
		end
	end
	return nil
end

local function addvectortocframe(cframe, vec)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x + vec.X, y + vec.Y, z + vec.Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end

local function getcustomassetfunc(path)
	if not betterisfile(path) then
		task.spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat task.wait() until betterisfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

runcode(function()
    local flaggedremotes = {"SelfReport"}

    getfunctions = function()
        local Flamework = require(repstorage["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
		repeat task.wait() until Flamework.isInitialized
        local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
        local Client = require(repstorage.TS.remotes).default.Client
        local OldClientGet = getmetatable(Client).Get
		local OldClientWaitFor = getmetatable(Client).WaitFor
        bedwars = {
			BedwarsKits = require(repstorage.TS.games.bedwars.kit["bedwars-kit-shop"]).BedwarsKitShop,
            ClientHandler = Client,
            ClientStoreHandler = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
			EmoteMeta = require(repstorage.TS.locker.emote["emote-meta"]).EmoteMeta,
			QueryUtil = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil,
			KitMeta = require(repstorage.TS.games.bedwars.kit["bedwars-kit-meta"]).BedwarsKitMeta,
			LobbyClientEvents = KnitClient.Controllers.QueueController,
            sprintTable = KnitClient.Controllers.SprintController,
			WeldTable = require(repstorage.TS.util["weld-util"]).WeldUtil,
			QueueMeta = require(repstorage.TS.game["queue-meta"]).QueueMeta,
			getEntityTable = require(repstorage.TS.entity["entity-util"]).EntityUtil,
        }
		if not shared.vapebypassed then
			local realremote = repstorage:WaitForChild("GameAnalyticsError")
			realremote.Parent = nil
			local fakeremote = Instance.new("RemoteEvent")
			fakeremote.Name = "GameAnalyticsError"
			fakeremote.Parent = repstorage
			game:GetService("ScriptContext").Error:Connect(function(p1, p2, p3)
				if not p3 then
					return;
				end;
				local u2 = nil;
				local v4, v5 = pcall(function()
					u2 = p3:GetFullName();
				end);
				if not v4 then
					return;
				end;
				if p3.Parent == nil then
					return;
				end
				realremote:FireServer(p1, p2, u2);
			end)
			shared.vapebypassed = true
		end
		spawn(function()
			local chatsuc, chatres = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile("vape/Profiles/bedwarssettings.json")) end)
			if chatsuc then
				if chatres.crashed and (not chatres.said) then
					pcall(function()
						createwarning("Vape", "either ur poor or its a exploit moment", 10)
						createwarning("Vape", "getconnections crashed, chat hook not loaded.", 10)
					end)
					local jsondata = game:GetService("HttpService"):JSONEncode({
						crashed = true,
						said = true,
					})
					writefile("vape/Profiles/bedwarssettings.json", jsondata)
				end
				if chatres.crashed then
					return nil
				else
					local jsondata = game:GetService("HttpService"):JSONEncode({
						crashed = true,
						said = false,
					})
					writefile("vape/Profiles/bedwarssettings.json", jsondata)
				end
			else
				local jsondata = game:GetService("HttpService"):JSONEncode({
					crashed = true,
					said = false,
				})
				writefile("vape/Profiles/bedwarssettings.json", jsondata)
			end
			repeat task.wait() until WhitelistFunctions.Loaded
			for i3,v3 in pairs(WhitelistFunctions.WhitelistTable.chattags) do
				if v3.NameColor then
					v3.NameColor = Color3.fromRGB(v3.NameColor.r, v3.NameColor.g, v3.NameColor.b)
				end
				if v3.ChatColor then
					v3.ChatColor = Color3.fromRGB(v3.ChatColor.r, v3.ChatColor.g, v3.ChatColor.b)
				end
				if v3.Tags then
					for i4,v4 in pairs(v3.Tags) do
						if v4.TagColor then
							v4.TagColor = Color3.fromRGB(v4.TagColor.r, v4.TagColor.g, v4.TagColor.b)
						end
					end
				end
			end
			for i,v in pairs(getconnections(repstorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
				if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
					oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
					oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
					getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
						local tab = oldchannelfunc(Self, Name)
						if tab and tab.AddMessageToChannel then
							local addmessage = tab.AddMessageToChannel
							if oldchanneltabs[tab] == nil then
								oldchanneltabs[tab] = tab.AddMessageToChannel
							end
							tab.AddMessageToChannel = function(Self2, MessageData)
								if MessageData.FromSpeaker and players[MessageData.FromSpeaker] then
									local plrtype = WhitelistFunctions:CheckPlayerType(players[MessageData.FromSpeaker])
									local hash = WhitelistFunctions:Hash(players[MessageData.FromSpeaker].Name..players[MessageData.FromSpeaker].UserId)
									if plrtype == "VAPE PRIVATE" then
										MessageData.ExtraData = {
											NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(0, 1, 1) or players[MessageData.FromSpeaker].TeamColor.Color,
											Tags = {
												table.unpack(MessageData.ExtraData.Tags),
												{
													TagColor = Color3.new(0.7, 0, 1),
													TagText = "VAPE PRIVATE"
												}
											}
										}
									end
									if plrtype == "VAPE OWNER" then
										MessageData.ExtraData = {
											NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(1, 0, 0) or players[MessageData.FromSpeaker].TeamColor.Color,
											Tags = {
												table.unpack(MessageData.ExtraData.Tags),
												{
													TagColor = Color3.new(1, 0.3, 0.3),
													TagText = "VAPE OWNER"
												}
											}
										}
									end
									if WhitelistFunctions.WhitelistTable.chattags[hash] then
										MessageData.ExtraData = WhitelistFunctions.WhitelistTable.chattags[hash]
									end
								end
								return addmessage(Self2, MessageData)
							end
						end
						return tab
					end
				end
			end
			local jsondata = game:GetService("HttpService"):JSONEncode({
				crashed = false,
				said = false,
			})
			writefile("vape/Profiles/bedwarssettings.json", jsondata)
		end)
	end
end)
getfunctions()

GuiLibrary["SelfDestructEvent"].Event:Connect(function()
	if chatconnection then
		chatconnection:Disconnect()
	end
	if teleportfunc then
		teleportfunc:Disconnect()
	end
	if oldchannelfunc and oldchanneltab then
		oldchanneltab.GetChannel = oldchannelfunc
	end
	for i2,v2 in pairs(oldchanneltabs) do
		i2.AddMessageToChannel = v2
	end
end)

local function getNametagString(plr)
	local nametag = ""
	if WhitelistFunctions:CheckPlayerType(plr) == "VAPE PRIVATE" then
		nametag = '<font color="rgb(127, 0, 255)">[VAPE PRIVATE] '..(plr.DisplayName or plr.Name)..'</font>'
	end
	if WhitelistFunctions:CheckPlayerType(plr) == "VAPE OWNER" then
		nametag = '<font color="rgb(255, 80, 80)">[VAPE OWNER] '..(plr.DisplayName or plr.Name)..'</font>'
	end
	if WhitelistFunctions.WhitelistTable.chattags[WhitelistFunctions:Hash(plr.Name..plr.UserId)] then
		local data = WhitelistFunctions.WhitelistTable.chattags[WhitelistFunctions:Hash(plr.Name..plr.UserId)]
		local newnametag = ""
		if data.Tags then
			for i2,v2 in pairs(data.Tags) do
				newnametag = newnametag..'<font color="rgb('..math.floor(v2.TagColor.r)..', '..math.floor(v2.TagColor.g)..', '..math.floor(v2.TagColor.b)..')">['..v2.TagText..']</font> '
			end
		end
		nametag = newnametag..(newnametag.NameColor and '<font color="rgb('..math.floor(newnametag.NameColor.r)..', '..math.floor(newnametag.NameColor.g)..', '..math.floor(newnametag.NameColor.b)..')">' or '')..(plr.DisplayName or plr.Name)..(newnametag.NameColor and '</font>' or '')
	end
	return nametag
end

local function Cape(char, texture)
	for i,v in pairs(char:GetDescendants()) do
		if v.Name == "Cape" then
			v:Remove()
		end
	end
	local hum = char:WaitForChild("Humanoid")
	local torso = nil
	if hum.RigType == Enum.HumanoidRigType.R15 then
	torso = char:WaitForChild("UpperTorso")
	else
	torso = char:WaitForChild("Torso")
	end
	local p = Instance.new("Part", torso.Parent)
	p.Name = "Cape"
	p.Anchored = false
	p.CanCollide = false
	p.TopSurface = 0
	p.BottomSurface = 0
	p.FormFactor = "Custom"
	p.Size = Vector3.new(0.2,0.2,0.2)
	p.Transparency = 1
	local decal = Instance.new("Decal", p)
	decal.Texture = texture
	decal.Face = "Back"
	local msh = Instance.new("BlockMesh", p)
	msh.Scale = Vector3.new(9,17.5,0.5)
	local motor = Instance.new("Motor", p)
	motor.Part0 = p
	motor.Part1 = torso
	motor.MaxVelocity = 0.01
	motor.C0 = CFrame.new(0,2,0) * CFrame.Angles(0,math.rad(90),0)
	motor.C1 = CFrame.new(0,1,0.45) * CFrame.Angles(0,math.rad(90),0)
	local wave = false
	repeat wait(1/44)
		decal.Transparency = torso.Transparency
		local ang = 0.1
		local oldmag = torso.Velocity.magnitude
		local mv = 0.002
		if wave then
			ang = ang + ((torso.Velocity.magnitude/10) * 0.05) + 0.05
			wave = false
		else
			wave = true
		end
		ang = ang + math.min(torso.Velocity.magnitude/11, 0.5)
		motor.MaxVelocity = math.min((torso.Velocity.magnitude/111), 0.04) --+ mv
		motor.DesiredAngle = -ang
		if motor.CurrentAngle < -0.2 and motor.DesiredAngle > -0.2 then
			motor.MaxVelocity = 0.04
		end
		repeat wait() until motor.CurrentAngle == motor.DesiredAngle or math.abs(torso.Velocity.magnitude - oldmag) >= (torso.Velocity.magnitude/10) + 1
		if torso.Velocity.magnitude < 0.1 then
			wait(0.1)
		end
	until not p or p.Parent ~= torso.Parent
end

local AnticheatBypassNumbers = {
	TPSpeed = 0.1,
	TPCombat = 0.3,
	TPLerp = 0.39,
	TPCheck = 15
}

local function friendCheck(plr, recolor)
	if GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] then
		local friend = (table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)] and true or nil)
		if recolor then
			return (friend and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] and true or nil)
		else
			return friend
		end
	end
	return nil
end

local function renderNametag(plr)
	if WhitelistFunctions:CheckPlayerType(plr) ~= "DEFAULT" or WhitelistFunctions.WhitelistTable.chattags[WhitelistFunctions:Hash(plr.Name..plr.UserId)] then
		local playerlist = game:GetService("CoreGui"):FindFirstChild("PlayerList")
		if playerlist then
			pcall(function()
				local playerlistplayers = playerlist.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
				local targetedplr = playerlistplayers:FindFirstChild("p_"..plr.UserId)
				if targetedplr then 
					targetedplr.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon.Image = getcustomassetfunc("vape/assets/VapeIcon.png")
				end
			end)
		end
		local nametag = getNametagString(plr)
		plr.CharacterAdded:Connect(function(char)
			if char ~= oldchar then
				spawn(function()
					pcall(function() 
						bedwars["getEntityTable"]:getEntity(plr):setNametag(nametag)
						Cape(char, getcustomassetfunc("vape/assets/VapeCape.png"))
					end)
				end)
			end
		end)
		spawn(function()
			if plr.Character and plr.Character ~= oldchar then
				spawn(function()
					pcall(function() 
						bedwars["getEntityTable"]:getEntity(plr):setNametag(nametag)
						Cape(plr.Character, getcustomassetfunc("vape/assets/VapeCape.png"))
					end)
				end)
			end
		end)
	end
end

task.spawn(function()
	repeat task.wait() until WhitelistFunctions.Loaded
	for i,v in pairs(players:GetChildren()) do renderNametag(v) end
	players.PlayerAdded:Connect(renderNametag)
end)

GuiLibrary["RemoveObject"]("SilentAimOptionsButton")
GuiLibrary["RemoveObject"]("AutoClickerOptionsButton")
GuiLibrary["RemoveObject"]("MouseTPOptionsButton")
GuiLibrary["RemoveObject"]("ReachOptionsButton")
GuiLibrary["RemoveObject"]("HitBoxesOptionsButton")
GuiLibrary["RemoveObject"]("KillauraOptionsButton")
GuiLibrary["RemoveObject"]("LongJumpOptionsButton")
GuiLibrary["RemoveObject"]("HighJumpOptionsButton")
GuiLibrary["RemoveObject"]("SafeWalkOptionsButton")
GuiLibrary["RemoveObject"]("TriggerBotOptionsButton")
GuiLibrary["RemoveObject"]("ClientKickDisablerOptionsButton")

local teleportedServers = false
teleportfunc = lplr.OnTeleport:Connect(function(State)
    if (not teleportedServers) then
		teleportedServers = true
		if shared.vapeoverlay then
			queueteleport('shared.vapeoverlay = "'..shared.vapeoverlay..'"')
		end
    end
end)

local Sprint = {["Enabled"] = false}
Sprint = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Sprint",
	["Function"] = function(callback)
		if callback then
			spawn(function()
				repeat
					task.wait()
					if bedwars["sprintTable"].sprinting == false then
						getmetatable(bedwars["sprintTable"])["startSprinting"](bedwars["sprintTable"])
					end
				until Sprint["Enabled"] == false
			end)
		end
	end, 
	["HoverText"] = "Sets your sprinting to true."
})

GuiLibrary["RemoveObject"]("FlyOptionsButton")
local flymissile
runcode(function()
	local OldNoFallFunction
	local flyspeed = {["Value"] = 40}
	local flyverticalspeed = {["Value"] = 40}
	local flyupanddown = {["Enabled"] = true}
	local flypop = {["Enabled"] = true}
	local flyautodamage = {["Enabled"] = true}
	local olddeflate
	local flyrequests = 0
	local flytime = 60
	local flylimit = false
	local flyup = false
	local flydown = false
	local tnttimer = 0
	local flypress
	local flyendpress
	local flycorountine

	local flytog = false
	local flytogtick = tick()
	fly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Fly",
		["Function"] = function(callback)
			if callback then
				--buyballoons()
				flypress = uis.InputBegan:Connect(function(input1)
					if flyupanddown["Enabled"] and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.Space then
							flyup = true
						end
						if input1.KeyCode == Enum.KeyCode.LeftShift then
							flydown = true
						end
					end
				end)
				flyendpress = uis.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.Space then
						flyup = false
					end
					if input1.KeyCode == Enum.KeyCode.LeftShift then
						flydown = false
					end
				end)
				RunLoops:BindToHeartbeat("Fly", 1, function(delta) 
					if isAlive() then
						local mass = (lplr.Character.HumanoidRootPart:GetMass() - 1.4) * (delta * 100)
						mass = mass + (flytog and -10 or 10)
						if flytogtick <= tick() then
							flytog = not flytog
							flytogtick = tick() + 0.2
						end
						local flypos = lplr.Character.Humanoid.MoveDirection * math.clamp(flyspeed["Value"], 1, 20)
						local flypos2 = (lplr.Character.Humanoid.MoveDirection * math.clamp(flyspeed["Value"] - 20, 0, 1000)) * delta
						lplr.Character.HumanoidRootPart.Transparency = 1
						lplr.Character.HumanoidRootPart.Velocity = flypos + (Vector3.new(0, mass + (flyup and flyverticalspeed["Value"] or 0) + (flydown and -flyverticalspeed["Value"] or 0), 0))
						lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + flypos2
						flyvelo = flypos + Vector3.new(0, mass + (flyup and flyverticalspeed["Value"] or 0) + (flydown and -flyverticalspeed["Value"] or 0), 0)
					end
				end)
			else
				flyup = false
				flydown = false
				flypress:Disconnect()
				flyendpress:Disconnect()
				RunLoops:UnbindFromHeartbeat("Fly")
			end
		end,
		["HoverText"] = "Makes you go zoom (Balloons or TNT Required)"
	})
	flyspeed = fly.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 23,
		["Function"] = function(val) end, 
		["Default"] = 23
	})
	flyverticalspeed = fly.CreateSlider({
		["Name"] = "Vertical Speed",
		["Min"] = 1,
		["Max"] = 100,
		["Function"] = function(val) end, 
		["Default"] = 44
	})
	flyupanddown = fly.CreateToggle({
		["Name"] = "Y Level",
		["Function"] = function() end, 
		["Default"] = true
	})
end)

local function findfrom(name)
	for i,v in pairs(bedwars["QueueMeta"]) do 
		if v.title == name and i:find("voice") == nil then
			return i
		end
	end
	return "bedwars_to1"
end

local QueueTypes = {}
for i,v in pairs(bedwars["QueueMeta"]) do 
	if v.title:find("Test") == nil then
		table.insert(QueueTypes, v.title..(i:find("voice") and " (VOICE)" or "")) 
	end
end
local JoinQueue = {["Enabled"] = false}
local JoinQueueTypes = {["Value"] = ""}
local JoinQueueDelay = {["Value"] = 1}
local firstqueue = true
JoinQueue = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "AutoQueue",
	["Function"] = function(callback)
		if callback then
			spawn(function()
				repeat
					task.wait(JoinQueueDelay["Value"])
					firstqueue = false
					if shared.vapeteammembers and bedwars["ClientStoreHandler"]:getState().Party then
						repeat task.wait() until #bedwars["ClientStoreHandler"]:getState().Party.members >= shared.vapeteammembers or JoinQueue["Enabled"] == false
					end
					if JoinQueue["Enabled"] and JoinQueueTypes["Value"] ~= "" then
						if bedwars["ClientStoreHandler"]:getState().Party.queueState > 0 then
							bedwars["LobbyClientEvents"]:leaveQueue()
						end
						if bedwars["ClientStoreHandler"]:getState().Party.leader.userId == lplr.UserId and bedwars["LobbyClientEvents"]:joinQueue(findfrom(JoinQueueTypes["Value"])) then
							bedwars["LobbyClientEvents"]:leaveQueue()
						end
						repeat task.wait() until bedwars["ClientStoreHandler"]:getState().Party.queueState == 3 or JoinQueue["Enabled"] == false
						for i = 1, 10 do
							if JoinQueue["Enabled"] == false then
								break
							end
							task.wait(1)
						end
						if bedwars["ClientStoreHandler"]:getState().Party.queueState > 0 then
							bedwars["LobbyClientEvents"]:leaveQueue()
						end
					end
				until JoinQueue["Enabled"] == false
			end)
		else
			firstqueue = false
			shared.vapeteammembers = nil
			if bedwars["ClientStoreHandler"]:getState().Party.queueState > 0 then
				bedwars["LobbyClientEvents"]:leaveQueue()
			end
		end
	end
})
JoinQueueTypes = JoinQueue.CreateDropdown({
	["Name"] = "Mode",
	["List"] = QueueTypes,
	["Function"] = function(val) 
		if JoinQueue["Enabled"] and firstqueue == false then
			JoinQueue["ToggleButton"](false)
			JoinQueue["ToggleButton"](true)
		end
	end
})
JoinQueueDelay = JoinQueue.CreateSlider({
	["Name"] = "Delay",
	["Min"] = 1,
	["Max"] = 10,
	["Function"] = function(val) end,
	["Default"] = 1
})

runcode(function()
	local AutoKitTextList = {["ObjectList"] = {}, ["RefreshValues"] = function() end}

	local function betterfindkit()
		local tab = {}
		local tab2 = {}
		if #AutoKitTextList["ObjectList"] > 0 then
			for i,v in pairs(AutoKitTextList["ObjectList"]) do
				local splitstr = v:split(" : ")
				if #splitstr > 1 then
					tab[tonumber(splitstr[2])] = splitstr[1]:lower()
					if #splitstr > 2 then
						tab2[tonumber(splitstr[2])] = splitstr[3]:lower() == "true"
					end
				end
			end
		else
			tab = {
				[1] = "Trinity",
				[2] = "Grim Reaper",
				[3] = "Eldertree",
				[4] = "Miner",
				[5] = "Barbarian",
				[6] = "Metal Detector",
				[7] = "Baker"
			}
			tab2 = {}
		end
		return tab, tab2
	end

	local AutoKit = {["Enabled"] = false}
	local ownedkits = {}
	local ownedkitsamount = 0
	for i3,v3 in pairs(bedwars["BedwarsKits"].FreeKits) do
		ownedkitsamount = ownedkitsamount + 1
		ownedkits[bedwars["KitMeta"][v3.kitType].name:lower()] = v3.kitType
	end
	AutoKit = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoKit",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat task.wait() until ownedkitsamount > 0
					local tab, tab2 = betterfindkit()
					for i = 1, #tab do
						local v = tab[i]
						if ownedkits[v:lower()] then
							bedwars["ClientHandler"]:Get("BedwarsActivateKit"):CallServerAsync({
								kit = ownedkits[v:lower()]
							})
							bedwars["ClientHandler"]:Get("BedwarsSetUseKitSkin"):CallServerAsync({
								useKitSkin = tab2[i] and true or false
							})
							return
						end
					end
					local rand = math.random(1, ownedkitsamount)
					local ownedkitsnum = 0
					for i2,v2 in pairs(ownedkits) do
						ownedkitsnum = ownedkitsnum + 1
						if ownedkitsnum == rand then
							bedwars["ClientHandler"]:Get("BedwarsActivateKit"):CallServerAsync({
								kit = v2
							})
							bedwars["ClientHandler"]:Get("BedwarsSetUseKitSkin"):CallServerAsync({
								useKitSkin = false
							})
						end
					end
				end)
			end
		end,
		["HoverText"] = "Automatically Equips kits in a list."
	})
	AutoKitTextList = AutoKit.CreateTextList({
		["Name"] = "KitList",
		["TempText"] = "kit name : prio : kitskin",
	})
end)

runcode(function()
	local CameraFix = {["Enabled"] = false}
	CameraFix = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "CameraFix",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait()
						if (not CameraFix["Enabled"]) then break end
						UserSettings():GetService("UserGameSettings").RotationType = ((cam.CFrame.Position - cam.Focus.Position).Magnitude <= 0.5 and Enum.RotationType.CameraRelative or Enum.RotationType.MovementRelative)
					until (not CameraFix["Enabled"])
				end)
			end
		end,
		["HoverText"] = "Fixes third person camera face bug"
	})
end)

local AnticheatBypass = {["Enabled"] = false}
local Scaffold = {["Enabled"] = false}
local longjump = {["Enabled"] = false}
local flyvelo
GuiLibrary["RemoveObject"]("SpeedOptionsButton")
runcode(function()
	local speedmode = {["Value"] = "Normal"}
	local speedval = {["Value"] = 1}
	local speedjump = {["Enabled"] = false}
	local speedjumpheight = {["Value"] = 20}
	local speedjumpalways = {["Enabled"] = false}
	local speedspeedup = {["Enabled"] = false}
	local speedanimation = {["Enabled"] = false}
	local speedtick = tick()
	local bodyvelo
	local raycastparameters = RaycastParams.new()
	speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Speed",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until shared.VapeFullyLoaded
					if speed["Enabled"] then
						if AnticheatBypass["Enabled"] == false and GuiLibrary["ObjectsThatCanBeSaved"]["Blatant modeToggle"]["Api"]["Enabled"] == false then
							AnticheatBypass["ToggleButton"](false)
						end
					end
				end)
				local lastnear = false
				RunLoops:BindToHeartbeat("Speed", 1, function(delta)
					if entity.isAlive and (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) then
						if speedanimation["Enabled"] then
							for i,v in pairs(entity.character.Humanoid:GetPlayingAnimationTracks()) do
								if v.Name == "WalkAnim" or v.Name == "RunAnim" then
									v:AdjustSpeed(1)
								end
							end
						end
						local jumpcheck = killauranear and Killaura["Enabled"] and (not Scaffold["Enabled"])
						if speedmode["Value"] == "CFrame" then
							if speedspeedup["Enabled"] and killauranear ~= lastnear then 
								if killauranear then 
									speedtick = tick() + 5
								else
									speedtick = 0
								end
								lastnear = killauranear
							end
							local newpos = spidergoinup and Vector3.zero or ((entity.character.Humanoid.MoveDirection * (((speedval["Value"] + (speedspeedup["Enabled"] and killauranear and speedtick >= tick() and (48 - speedval["Value"]) or 0))) - 20))) * delta * (GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"] and 0 or 1)
							local movevec = entity.character.Humanoid.MoveDirection.Unit * 20
							movevec = movevec == movevec and movevec or Vector3.zero
							local velocheck = not (longjump["Enabled"] and newlongjumpvelo == Vector3.zero)
							raycastparameters.FilterDescendantsInstances = {lplr.Character}
							local ray = workspace:Raycast(entity.character.HumanoidRootPart.Position, newpos, raycastparameters)
							if ray then newpos = (ray.Position - entity.character.HumanoidRootPart.Position) end
							if networkownerfunc and networkownerfunc(entity.character.HumanoidRootPart) or networkownerfunc == nil then
								entity.character.HumanoidRootPart.CFrame = entity.character.HumanoidRootPart.CFrame + newpos
								entity.character.HumanoidRootPart.Velocity = Vector3.new(velocheck and movevec.X or 0, entity.character.HumanoidRootPart.Velocity.Y, velocheck and movevec.Z or 0)
							end
						else
							if (bodyvelo == nil or bodyvelo ~= nil and bodyvelo.Parent ~= entity.character.HumanoidRootPart) then
								bodyvelo = Instance.new("BodyVelocity")
								bodyvelo.Parent = entity.character.HumanoidRootPart
								bodyvelo.MaxForce = Vector3.new(100000, 0, 100000)
							else
								bodyvelo.MaxForce = ((entity.character.Humanoid:GetState() == Enum.HumanoidStateType.Climbing or entity.character.Humanoid.Sit or spidergoinup or GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"] or uninjectflag) and Vector3.zero or (longjump["Enabled"] and Vector3.new(100000, 0, 100000) or Vector3.new(100000, 0, 100000)))
								bodyvelo.Velocity = longjump["Enabled"] and longjumpvelo or entity.character.Humanoid.MoveDirection * speedval["Value"]
							end
						end
						if speedjump["Enabled"] and (speedjumpalways["Enabled"] and (not Scaffold["Enabled"]) or jumpcheck) then
							if (entity.character.Humanoid.FloorMaterial ~= Enum.Material.Air) and entity.character.Humanoid.MoveDirection ~= Vector3.zero then
								entity.character.HumanoidRootPart.Velocity = Vector3.new(entity.character.HumanoidRootPart.Velocity.X, speedjumpheight["Value"], entity.character.HumanoidRootPart.Velocity.Z)
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("Speed")
				if bodyvelo then
					bodyvelo:Remove()
				end
				if entity.isAlive then 
					for i,v in pairs(entity.character.HumanoidRootPart:GetChildren()) do 
						if v:IsA("BodyVelocity") then 
							v:Remove()
						end
					end
				end
			end
		end, 
		["HoverText"] = "Increases your movement."
	})
	speedmode = speed.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"Normal", "CFrame"},
		["Function"] = function(val)
			if speedspeedup["Object"] then 
				speedspeedup["Object"].Visible = val == "CFrame"
			end
			if bodyvelo then
				bodyvelo:Remove()
			end	
		end
	})
	speedval = speed.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 23,
		["Function"] = function(val) end,
		["Default"] = 23
	})
	speedjumpheight = speed.CreateSlider({
		["Name"] = "Jump Height",
		["Min"] = 0,
		["Max"] = 30,
		["Default"] = 25,
		["Function"] = function() end
	})
	speedjump = speed.CreateToggle({
		["Name"] = "AutoJump", 
		["Function"] = function(callback) 
			if speedjumpalways["Object"] then
				speedjump["Object"].ToggleArrow.Visible = callback
				speedjumpalways["Object"].Visible = callback
			end
		end,
		["Default"] = true
	})
	speedjumpalways = speed.CreateToggle({
		["Name"] = "Always Jump",
		["Function"] = function() end
	})
	speedspeedup = speed.CreateToggle({
		["Name"] = "Speedup",
		["Function"] = function() end,
		["HoverText"] = "Speeds up when using killaura."
	})
	speedspeedup["Object"].Visible = speedmode["Value"] == "CFrame"
	speedanimation = speed.CreateToggle({
		["Name"] = "Slowdown Anim",
		["Function"] = function() end
	})
	speedjumpalways["Object"].BackgroundTransparency = 0
	speedjumpalways["Object"].BorderSizePixel = 0
	speedjumpalways["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	speedjumpalways["Object"].Visible = speedjump["Enabled"]
end)

runcode(function()
	local AnticheatBypassTransparent = {["Enabled"] = false}
	local AnticheatBypassAlternate = {["Enabled"] = false}
	local AnticheatBypassNotification = {["Enabled"] = false}
	local AnticheatBypassAnimation = {["Enabled"] = true}
	local AnticheatBypassAnimationCustom = {["Value"] = ""}
	local AnticheatBypassDisguise = {["Enabled"] = false}
	local AnticheatBypassDisguiseCustom = {["Value"] = ""}
	local AnticheatBypassArrowDodge = {["Enabled"] = false}
	local AnticheatBypassAutoConfig = {["Enabled"] = false}
	local AnticheatBypassAutoConfigBig = {["Enabled"] = false}
	local AnticheatBypassAutoConfigSpeed = {["Value"] = 54}
	local AnticheatBypassAutoConfigSpeed2 = {["Value"] = 54}
	local AnticheatBypassTPSpeed = {["Value"] = 13}
	local AnticheatBypassTPLerp = {["Value"] = 50}
	local clone
	local changed = false
	local justteleported = false
	local anticheatconnection
	local anticheatconnection2
	local playedanim = ""
	local hip

	local function finishcframe(cframe)
		return shared.VapeOverrideAnticheatBypassCFrame and shared.VapeOverrideAnticheatBypassCFrame(cframe) or cframe
	end

	local function check()
		if clone and oldcloneroot and (oldcloneroot.Position - clone.Position).magnitude >= (AnticheatBypassNumbers.TPCheck * getSpeedMultiplier()) then
			clone.CFrame = oldcloneroot.CFrame
		end
	end

	local clonesuccess = false
	local doing = false
	local function disablestuff()
		if uninjectflag then return end
		repeat task.wait() until entity.isAlive
		if not AnticheatBypass["Enabled"] then doing = false return end
		oldcloneroot = entity.character.HumanoidRootPart
		lplr.Character.Parent = game
		clone = oldcloneroot:Clone()
		clone.Parent = lplr.Character
		oldcloneroot.Parent = cam
		bedwars["QueryUtil"]:setQueryIgnored(oldcloneroot, true)
		oldcloneroot.Transparency = AnticheatBypassTransparent["Enabled"] and 1 or 0
		clone.CFrame = oldcloneroot.CFrame
		lplr.Character.PrimaryPart = clone
		lplr.Character.Parent = workspace
		for i,v in pairs(lplr.Character:GetDescendants()) do 
			if v:IsA("Weld") or v:IsA("Motor6D") then 
				if v.Part0 == oldcloneroot then v.Part0 = clone end
				if v.Part1 == oldcloneroot then v.Part1 = clone end
			end
			if v:IsA("BodyVelocity") then 
				v:Destroy()
			end
		end
		for i,v in pairs(oldcloneroot:GetChildren()) do 
			if v:IsA("BodyVelocity") then 
				v:Destroy()
			end
		end
		if hip then 
			lplr.Character.Humanoid.HipHeight = hip
		end
		hip = lplr.Character.Humanoid.HipHeight
		local bodyvelo = Instance.new("BodyVelocity")
		bodyvelo.MaxForce = Vector3.new(0, 100000, 0)
		bodyvelo.Velocity = Vector3.zero
		bodyvelo.Parent = oldcloneroot
		pcall(function()
			RunLoops:UnbindFromHeartbeat("AnticheatBypass")
		end)
		local oldseat 
		local oldseattab = Instance.new("BindableEvent")
		RunLoops:BindToHeartbeat("AnticheatBypass", 1, function()
			if oldcloneroot and clone then
				oldcloneroot.AssemblyAngularVelocity = clone.AssemblyAngularVelocity
				if disabletpcheck then
					oldcloneroot.Velocity = clone.Velocity
				else
					local sit = entity.character.Humanoid.Sit
					if sit ~= oldseat then 
						oldseat = sit	
					end
					local targetvelo = (clone.AssemblyLinearVelocity)
					local speed = (sit and targetvelo.Magnitude or 20 * getSpeedMultiplier())
					targetvelo = (targetvelo.Unit == targetvelo.Unit and targetvelo.Unit or Vector3.zero) * speed
					bodyvelo.Velocity = Vector3.new(0, clone.Velocity.Y, 0)
					oldcloneroot.Velocity = Vector3.new(math.clamp(targetvelo.X, -speed, speed), clone.Velocity.Y, math.clamp(targetvelo.Z, -speed, speed))
				end
			end
		end)
		local lagbacknum = 0
		local lagbackcurrent = false
		local lagbacktime = 0
		local lagbackchanged = false
		local lagbacknotification = false
		local amountoftimes = 0
		local lastseat
		clonesuccess = true
		local pinglist = {}
		local fpslist = {}

		local function getaverageframerate()
			local frames = 0
			for i,v in pairs(fpslist) do 
				frames = frames + v
			end
			return #fpslist > 0 and (frames / (60 * #fpslist)) <= 1.2 or #fpslist <= 0 or AnticheatBypassAlternate["Enabled"]
		end

		local function didpingspike()
			local currentpingcheck = pinglist[1] or math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()))
			for i,v in pairs(fpslist) do 
				print("anticheatbypass fps ["..i.."]: "..v)
				if v < 40 then 
					return v.." fps"
				end
			end
			for i,v in pairs(pinglist) do 
				print("anticheatbypass ping ["..i.."]: "..v)
				if v ~= currentpingcheck and math.abs(v - currentpingcheck) >= 100 then 
					return currentpingcheck.." => "..v.." ping"
				else
					currentpingcheck = v
				end
			end
			return nil
		end

		local function notlasso()
			for i,v in pairs(game:GetService("CollectionService"):GetTagged("LassoHooked")) do 
				if v == lplr.Character then 
					return false
				end
			end
			return true
		end

		doing = false
		allowspeed = true
		task.spawn(function()
			repeat
				if (not AnticheatBypass["Enabled"]) then break end
				local ping = math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()))
				local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
				if #pinglist >= 10 then 
					table.remove(pinglist, 1)
				end
				if #fpslist >= 10 then 
					table.remove(fpslist, 1)
				end
				table.insert(pinglist, ping)
				table.insert(fpslist, fps)
				task.wait(1)
			until (not AnticheatBypass["Enabled"])
		end)
		if anticheatconnection2 then anticheatconnection2:Disconnect() end
		anticheatconnection2 = lplr:GetAttributeChangedSignal("LastTeleported"):Connect(function()
			if not AnticheatBypass["Enabled"] then if anticheatconnection2 then anticheatconnection2:Disconnect() end end
			if not (clone and oldcloneroot) then return end
			clone.CFrame = oldcloneroot.CFrame
		end)
		shared.VapeRealCharacter = {
			Humanoid = entity.character.Humanoid,
			Head = entity.character.Head,
			HumanoidRootPart = oldcloneroot
		}
		if shared.VapeOverrideAnticheatBypassPre then 
			shared.VapeOverrideAnticheatBypassPre(lplr.Character)
		end
		repeat
			task.wait()
			if entity.isAlive then
				local oldroot = oldcloneroot
				if oldroot then
					local cloneroot = clone
					if cloneroot then
						if oldroot.Parent ~= nil and ((networkownerfunc and (not networkownerfunc(oldroot)) or networkownerfunc == nil and gethiddenproperty(oldroot, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual)) then
							if amountoftimes ~= 0 then
								amountoftimes = 0
							end
							if not lagbackchanged then
								lagbackchanged = true
								lagbacktime = tick()
								task.spawn(function()
									local pingspike = didpingspike() 
									if pingspike then
										if AnticheatBypassNotification["Enabled"] then
											createwarning("AnticheatBypass", "Lagspike Detected : "..pingspike, 10)
										end
									else
										if matchState ~= 2 and notlasso() and (not recenttp) then
											lagbacks = lagbacks + 1
										end
									end
									task.spawn(function()
										if AnticheatBypass["Enabled"] then
											AnticheatBypass["ToggleButton"](false)
										end
										local oldclonecharcheck = lplr.Character
										repeat task.wait() until lplr.Character == nil or lplr.Character.Parent == nil or oldclonecharcheck ~= lplr.Character or networkownerfunc(oldroot)
										if AnticheatBypass["Enabled"] == false then
											AnticheatBypass["ToggleButton"](false)
										end
									end)
								end)
							end
							if (tick() - lagbacktime) >= 10 and (not lagbacknotification) then
								lagbacknotification = true
								createwarning("AnticheatBypass", "You have been lagbacked for a awfully long time", 10)
							end
							cloneroot.Velocity = Vector3.zero
							oldroot.Velocity = Vector3.zero
							cloneroot.CFrame = oldroot.CFrame
						else
							lagbackchanged = false
							lagbacknotification = false
							if not shared.VapeOverrideAnticheatBypass then
								if (not disabletpcheck) and entity.character.Humanoid.Sit ~= true then
									anticheatfunnyyes = true 
									local frameratecheck = getaverageframerate()
									local framerate = AnticheatBypassNumbers.TPSpeed <= 0.3 and frameratecheck and -0.22 or 0
									local framerate2 = AnticheatBypassNumbers.TPSpeed <= 0.3 and frameratecheck and -0.01 or 0
									framerate = math.floor((AnticheatBypassNumbers.TPLerp + framerate) * 100) / 100
									framerate2 = math.floor((AnticheatBypassNumbers.TPSpeed + framerate2) * 100) / 100
									for i = 1, 2 do 
										check()
										task.wait(i % 2 == 0 and 0.01 or 0.02)
										check()
										if oldroot and cloneroot then
											anticheatfunnyyes = false
											if (oldroot.CFrame.p - cloneroot.CFrame.p).magnitude >= 0.01 then
												if (Vector3.new(0, oldroot.CFrame.p.Y, 0) - Vector3.new(0, cloneroot.CFrame.p.Y, 0)).magnitude <= 1 then
													oldroot.CFrame = finishcframe(oldroot.CFrame:lerp(addvectortocframe2(cloneroot.CFrame, oldroot.CFrame.p.Y), framerate))
												else
													oldroot.CFrame = finishcframe(oldroot.CFrame:lerp(cloneroot.CFrame, framerate))
												end
											end
										end
										check()
									end
									check()
									task.wait(combatcheck and AnticheatBypassCombatCheck["Enabled"] and AnticheatBypassNumbers.TPCombat or framerate2)
									check()
									if oldroot and cloneroot then
										if (oldroot.CFrame.p - cloneroot.CFrame.p).magnitude >= 0.01 then
											if (Vector3.new(0, oldroot.CFrame.p.Y, 0) - Vector3.new(0, cloneroot.CFrame.p.Y, 0)).magnitude <= 1 then
												oldroot.CFrame = finishcframe(addvectortocframe2(cloneroot.CFrame, oldroot.CFrame.p.Y))
											else
												oldroot.CFrame = finishcframe(cloneroot.CFrame)
											end
										end
									end
									check()
								else
									if oldroot and cloneroot then
										oldroot.CFrame = cloneroot.CFrame
									end
								end
							end
						end
					end
				end
			end
		until AnticheatBypass["Enabled"] == false or oldcloneroot == nil or oldcloneroot.Parent == nil 
	end

	local spawncoro
	local function anticheatbypassenable()
		task.spawn(function()
			if spawncoro then return end
			spawncoro = true
			allowspeed = false
			shared.VapeRealCharacter = nil
			repeat task.wait() until entity.isAlive
			task.wait(0.4)
			lplr.Character:WaitForChild("Humanoid", 10)
			lplr.Character:WaitForChild("LeftHand", 10)
			lplr.Character:WaitForChild("RightHand", 10)
			lplr.Character:WaitForChild("LeftFoot", 10)
			lplr.Character:WaitForChild("RightFoot", 10)
			lplr.Character:WaitForChild("LeftLowerArm", 10)
			lplr.Character:WaitForChild("RightLowerArm", 10)
			lplr.Character:WaitForChild("LeftUpperArm", 10)
			lplr.Character:WaitForChild("RightUpperArm", 10)
			lplr.Character:WaitForChild("LeftLowerLeg", 10)
			lplr.Character:WaitForChild("RightLowerLeg", 10)
			lplr.Character:WaitForChild("LeftUpperLeg", 10)
			lplr.Character:WaitForChild("RightUpperLeg", 10)
			lplr.Character:WaitForChild("UpperTorso", 10)
			lplr.Character:WaitForChild("LowerTorso", 10)
			local root = lplr.Character:WaitForChild("HumanoidRootPart", 20)
			local head = lplr.Character:WaitForChild("Head", 20)
			task.wait(0.4)
			spawncoro = false
			if root ~= nil and head ~= nil then
				task.spawn(disablestuff)
			else
				createwarning("AnticheatBypass", "ur root / head no load L", 30)
			end
		end)
		anticheatconnection = lplr.CharacterAdded:Connect(function(char)
			task.spawn(function()
				if spawncoro then return end
				spawncoro = true
				allowspeed = false
				shared.VapeRealCharacter = nil
				repeat task.wait() until entity.isAlive
				task.wait(0.4)
				char:WaitForChild("Humanoid", 10)
				char:WaitForChild("LeftHand", 10)
				char:WaitForChild("RightHand", 10)
				char:WaitForChild("LeftFoot", 10)
				char:WaitForChild("RightFoot", 10)
				char:WaitForChild("LeftLowerArm", 10)
				char:WaitForChild("RightLowerArm", 10)
				char:WaitForChild("LeftUpperArm", 10)
				char:WaitForChild("RightUpperArm", 10)
				char:WaitForChild("LeftLowerLeg", 10)
				char:WaitForChild("RightLowerLeg", 10)
				char:WaitForChild("LeftUpperLeg", 10)
				char:WaitForChild("RightUpperLeg", 10)
				char:WaitForChild("UpperTorso", 10)
				char:WaitForChild("LowerTorso", 10)
				local root = char:WaitForChild("HumanoidRootPart", 20)
				local head = char:WaitForChild("Head", 20)
				task.wait(0.4)
				spawncoro = false
				if root ~= nil and head ~= nil then
					task.spawn(disablestuff)
				else
					createwarning("AnticheatBypass", "ur root / head no load L", 30)
				end
			end)
		end)
	end

	AnticheatBypass = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AnticheatBypass",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
				--	anticheatbypassenable()
				end)
			else
				if anticheatconnection then 
					anticheatconnection:Disconnect()
				end
				pcall(function() RunLoops:UnbindFromHeartbeat("AnticheatBypass") end)
				if clonesuccess and oldcloneroot and clone and lplr.Character.Parent == workspace and oldcloneroot.Parent ~= nil then 
					lplr.Character.Parent = game
					oldcloneroot.Parent = lplr.Character
					lplr.Character.PrimaryPart = oldcloneroot
					lplr.Character.Parent = workspace
					oldcloneroot.CanCollide = true
					oldcloneroot.Transparency = 1
					for i,v in pairs(lplr.Character:GetDescendants()) do 
						if v:IsA("Weld") or v:IsA("Motor6D") then 
							if v.Part0 == clone then v.Part0 = oldcloneroot end
							if v.Part1 == clone then v.Part1 = oldcloneroot end
						end
						if v:IsA("BodyVelocity") then 
							v:Destroy()
						end
					end
					for i,v in pairs(oldcloneroot:GetChildren()) do 
						if v:IsA("BodyVelocity") then 
							v:Destroy()
						end
					end
					lplr.Character.Humanoid.HipHeight = hip or 2
				end
				if clone then 
					clone:Destroy()
					clone = nil
				end
				oldcloneroot = nil
			end
		end,
		["HoverText"] = "Makes speed check more stupid.\n(thank you to MicrowaveOverflow.cpp#7030 for no more clone crap)",
	})
	local arrowdodgeconnection
	local arrowdodgedata
	
--[[	AnticheatBypassArrowDodge = AnticheatBypass.CreateToggle({
		["Name"] = "Arrow Dodge",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					bedwars["ClientHandler"]:WaitFor("ProjectileLaunch"):andThen(function(p6)
						arrowdodgeconnection = p6:Connect(function(data)
							if oldchar and clone and AnticheatBypass["Enabled"] and (arrowdodgedata == nil or arrowdodgedata.launchVelocity ~= data.launchVelocity) and entity.isAlive and tostring(data.projectile):find("arrow") then
								arrowdodgedata = data
								local projmetatab = bedwars["ProjectileMeta"][tostring(data.projectile)]
								local prediction = (projmetatab.predictionLifetimeSec or projmetatab.lifetimeSec or 3)
								local gravity = (projmetatab.gravitationalAcceleration or 196.2)
								local multigrav = gravity
								local offsetshootpos = data.position
								local pos = (oldchar.HumanoidRootPart.Position + Vector3.new(0, 0.8, 0)) 
								local calculated2 = FindLeadShot(pos, Vector3.zero, (Vector3.zero - data.launchVelocity).magnitude, offsetshootpos, Vector3.zero, multigrav) 
								local calculated = LaunchDirection(offsetshootpos, pos, (Vector3.zero - data.launchVelocity).magnitude, gravity, false)
								local initialvelo = calculated--(calculated - offsetshootpos).Unit * launchvelo
								local initialvelo2 = (calculated2 - offsetshootpos).Unit * (Vector3.zero - data.launchVelocity).magnitude
								local calculatedvelo = Vector3.new(initialvelo2.X, (initialvelo and initialvelo.Y or initialvelo2.Y), initialvelo2.Z).Unit * (Vector3.zero - data.launchVelocity).magnitude
								if (calculatedvelo - data.launchVelocity).magnitude <= 20 then 
									oldchar.HumanoidRootPart.CFrame = oldchar.HumanoidRootPart.CFrame:lerp(clone.HumanoidRootPart.CFrame, 0.6)
								end
							end
						end)
					end)
				end)
			else
				if arrowdodgeconnection then 
					arrowdodgeconnection:Disconnect()
				end
			end
		end,
		["Default"] = true,
		["HoverText"] = "Dodge arrows (tanqr moment)"
	})]]
	AnticheatBypassAlternate = AnticheatBypass.CreateToggle({
		["Name"] = "Alternate Numbers",
		["Function"] = function() end
	})
	AnticheatBypassTransparent = AnticheatBypass.CreateToggle({
		["Name"] = "Transparent",
		["Function"] = function(callback) 
			if oldcloneroot and AnticheatBypass["Enabled"] then
				oldcloneroot.Transparency = callback and 1 or 0
			end
		end,
		["Default"] = true
	})
	AnticheatBypassFlagCheck = AnticheatBypass.CreateToggle({
		["Name"] = "Flag Check",
		["Function"] = function(callback) end,
		["Default"] = true
	})
	local changecheck = false
--[[	AnticheatBypassCombatCheck = AnticheatBypass.CreateToggle({
		["Name"] = "Combat Check",
		["Function"] = function(callback) 
			if callback then 
				task.spawn(function()
					repeat 
						task.wait(0.1)
						if (not AnticheatBypassCombatCheck["Enabled"]) then break end
						if AnticheatBypass["Enabled"] then 
							local plrs = GetAllNearestHumanoidToPosition(true, 30, 1)
							combatcheck = #plrs > 0 and (not GuiLibrary["ObjectsThatCanBeSaved"]["LongJumpOptionsButton"]["Api"]["Enabled"]) and (not GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"])
							if combatcheck ~= changecheck then 
								if not combatcheck then 
									combatchecktick = tick() + 1
								end
								changecheck = combatcheck
							end
						end
					until (not AnticheatBypassCombatCheck["Enabled"])
				end)
			else
				combatcheck = false
			end
		end,
		["Default"] = true
	})]]
	AnticheatBypassNotification = AnticheatBypass.CreateToggle({
		["Name"] = "Notifications",
		["Function"] = function() end,
		["Default"] = true
	})
	if shared.VapeDeveloper then 
		AnticheatBypassTPSpeed = AnticheatBypass.CreateSlider({
			["Name"] = "TPSpeed",
			["Function"] = function(val) 
				AnticheatBypassNumbers.TPSpeed = val / 100
			end,
			["Double"] = 100,
			["Min"] = 1,
			["Max"] = 100,
			["Default"] = AnticheatBypassNumbers.TPSpeed * 100,
		})
		AnticheatBypassTPLerp = AnticheatBypass.CreateSlider({
			["Name"] = "TPLerp",
			["Function"] = function(val) 
				AnticheatBypassNumbers.TPLerp = val / 100
			end,
			["Double"] = 100,
			["Min"] = 1,
			["Max"] = 100,
			["Default"] = AnticheatBypassNumbers.TPLerp * 100,
		})
	end
end)

runcode(function()
	local transformed = false
	local OldBedwars = {["Enabled"] = false}
	local themeselected = {["Value"] = "OldBedwars"}

	local themefunctions = {
		Old = function()
			task.spawn(function()
				local oldbedwarstabofblocks = '{"wool_blue":"rbxassetid://5089281898","wool_pink":"rbxassetid://6856183009","clay_pink":"rbxassetid://6856283410","grass":["rbxassetid://6812582110","rbxassetid://6812616868","rbxassetid://6812616868","rbxassetid://6812616868","rbxassetid://6812616868","rbxassetid://6812616868"],"snow":"rbxassetid://6874651192","wool_cyan":"rbxassetid://6177124865","red_sandstone":"rbxassetid://6708703895","wool_green":"rbxassetid://6177123316","clay_black":"rbxassetid://5890435474","sand":"rbxassetid://6187018940","wool_orange":"rbxassetid://6177122584","hickory_log":"rbxassetid://6879467811","wood_plank_birch":"rbxassetid://6768647328","clay_gray":"rbxassetid://7126965624","wood_plank_spruce":"rbxassetid://6768615964","brick":"rbxassetid://6782607284","clay_dark_brown":"rbxassetid://6874651325","stone_brick":"rbxassetid://6710700118","ceramic":"rbxassetid://6875522401","clay_blue":"rbxassetid://4991097126","wood_plank_maple":"rbxassetid://6768632085","diamond_block":"rbxassetid://6734061546","wood_plank_oak":"rbxassetid://6768575772","ice":"rbxassetid://6874651262","marble":"rbxassetid://6594536339","spruce_log":"rbxassetid://6874161124","oak_log":"rbxassetid://6879467811","clay_light_brown":"rbxassetid://6874651634","clay_dark_green":"rbxassetid://6812653448","marble_pillar":["rbxassetid://6909328433","rbxassetid://6909328433","rbxassetid://6909323822","rbxassetid://6909323822","rbxassetid://6909323822","rbxassetid://6909323822"],"slate_brick":"rbxassetid://6708836267","obsidian":"rbxassetid://6855476765","iron_block":"rbxassetid://6734050333","wool_red":"rbxassetid://5089281973","clay_purple":"rbxassetid://6856099740","clay_orange":"rbxassetid://7017703219","clay_red":"rbxassetid://6856283323","wool_yellow":"rbxassetid://6829151816","tnt":["rbxassetid://6889157997","rbxassetid://6889157997","rbxassetid://6855533421","rbxassetid://6855533421","rbxassetid://6855533421","rbxassetid://6855533421"],"clay_yellow":"rbxassetid://4991097283","clay_white":"rbxassetid://7017705325","wool_purple":"rbxassetid://6177125247","sandstone":"rbxassetid://6708657090","wool_white":"rbxassetid://5089287375","clay_light_green":"rbxassetid://6856099550","birch_log":"rbxassetid://6856088949","emerald_block":"rbxassetid://6856082835","clay":"rbxassetid://6856190168","stone":"rbxassetid://6812635290","slime_block":"rbxassetid://6869286145"}'
				local oldbedwarsblocktab = game:GetService("HttpService"):JSONDecode(oldbedwarstabofblocks)
				local oldbedwarstabofimages = '{"clay_orange":"rbxassetid://7017703219","iron":"rbxassetid://6850537969","glass":"rbxassetid://6909521321","log_spruce":"rbxassetid://6874161124","ice":"rbxassetid://6874651262","marble":"rbxassetid://6594536339","zipline_base":"rbxassetid://7051148904","iron_helmet":"rbxassetid://6874272559","marble_pillar":"rbxassetid://6909323822","clay_dark_green":"rbxassetid://6763635916","wood_plank_birch":"rbxassetid://6768647328","watering_can":"rbxassetid://6915423754","emerald_helmet":"rbxassetid://6931675766","pie":"rbxassetid://6985761399","wood_plank_spruce":"rbxassetid://6768615964","diamond_chestplate":"rbxassetid://6874272898","wool_pink":"rbxassetid://6910479863","wool_blue":"rbxassetid://6910480234","wood_plank_oak":"rbxassetid://6910418127","diamond_boots":"rbxassetid://6874272964","clay_yellow":"rbxassetid://4991097283","tnt":"rbxassetid://6856168996","lasso":"rbxassetid://7192710930","clay_purple":"rbxassetid://6856099740","melon_seeds":"rbxassetid://6956387796","apple":"rbxassetid://6985765179","carrot_seeds":"rbxassetid://6956387835","log_oak":"rbxassetid://6763678414","emerald_chestplate":"rbxassetid://6931675868","wool_yellow":"rbxassetid://6910479606","emerald_boots":"rbxassetid://6931675942","clay_light_brown":"rbxassetid://6874651634","balloon":"rbxassetid://7122143895","cannon":"rbxassetid://7121221753","leather_boots":"rbxassetid://6855466456","melon":"rbxassetid://6915428682","wool_white":"rbxassetid://6910387332","log_birch":"rbxassetid://6763678414","clay_pink":"rbxassetid://6856283410","grass":"rbxassetid://6773447725","obsidian":"rbxassetid://6910443317","shield":"rbxassetid://7051149149","red_sandstone":"rbxassetid://6708703895","diamond_helmet":"rbxassetid://6874272793","wool_orange":"rbxassetid://6910479956","log_hickory":"rbxassetid://7017706899","guitar":"rbxassetid://7085044606","wool_purple":"rbxassetid://6910479777","diamond":"rbxassetid://6850538161","iron_chestplate":"rbxassetid://6874272631","slime_block":"rbxassetid://6869284566","stone_brick":"rbxassetid://6910394475","hammer":"rbxassetid://6955848801","ceramic":"rbxassetid://6910426690","wood_plank_maple":"rbxassetid://6768632085","leather_helmet":"rbxassetid://6855466216","stone":"rbxassetid://6763635916","slate_brick":"rbxassetid://6708836267","sandstone":"rbxassetid://6708657090","snow":"rbxassetid://6874651192","wool_red":"rbxassetid://6910479695","leather_chestplate":"rbxassetid://6876833204","clay_red":"rbxassetid://6856283323","wool_green":"rbxassetid://6910480050","clay_white":"rbxassetid://7017705325","wool_cyan":"rbxassetid://6910480152","clay_black":"rbxassetid://5890435474","sand":"rbxassetid://6187018940","clay_light_green":"rbxassetid://6856099550","clay_dark_brown":"rbxassetid://6874651325","carrot":"rbxassetid://3677675280","clay":"rbxassetid://6856190168","iron_boots":"rbxassetid://6874272718","emerald":"rbxassetid://6850538075","zipline":"rbxassetid://7051148904"}'
				local oldbedwarsicontab = game:GetService("HttpService"):JSONDecode(oldbedwarstabofimages)
				local oldbedwarssoundtable = {
					["QUEUE_JOIN"] = "rbxassetid://6691735519",
					["QUEUE_MATCH_FOUND"] = "rbxassetid://6768247187",
					["UI_CLICK"] = "rbxassetid://6732690176",
					["UI_OPEN"] = "rbxassetid://6732607930",
					["BEDWARS_UPGRADE_SUCCESS"] = "rbxassetid://6760677364",
					["BEDWARS_PURCHASE_ITEM"] = "rbxassetid://6760677364",
					["SWORD_SWING_1"] = "rbxassetid://6760544639",
					["SWORD_SWING_2"] = "rbxassetid://6760544595",
					["DAMAGE_1"] = "rbxassetid://6765457325",
					["DAMAGE_2"] = "rbxassetid://6765470975",
					["DAMAGE_3"] = "rbxassetid://6765470941",
					["CROP_HARVEST"] = "rbxassetid://4864122196",
					["CROP_PLANT_1"] = "rbxassetid://5483943277",
					["CROP_PLANT_2"] = "rbxassetid://5483943479",
					["CROP_PLANT_3"] = "rbxassetid://5483943723",
					["ARMOR_EQUIP"] = "rbxassetid://6760627839",
					["ARMOR_UNEQUIP"] = "rbxassetid://6760625788",
					["PICKUP_ITEM_DROP"] = "rbxassetid://6768578304",
					["PARTY_INCOMING_INVITE"] = "rbxassetid://6732495464",
					["ERROR_NOTIFICATION"] = "rbxassetid://6732495464",
					["INFO_NOTIFICATION"] = "rbxassetid://6732495464",
					["END_GAME"] = "rbxassetid://6246476959",
					["GENERIC_BLOCK_PLACE"] = "rbxassetid://4842910664",
					["GENERIC_BLOCK_BREAK"] = "rbxassetid://4819966893",
					["GRASS_BREAK"] = "rbxassetid://5282847153",
					["WOOD_BREAK"] = "rbxassetid://4819966893",
					["STONE_BREAK"] = "rbxassetid://6328287211",
					["WOOL_BREAK"] = "rbxassetid://4842910664",
					["TNT_EXPLODE_1"] = "rbxassetid://7192313632",
					["TNT_HISS_1"] = "rbxassetid://7192313423",
					["FIREBALL_EXPLODE"] = "rbxassetid://6855723746",
					["SLIME_BLOCK_BOUNCE"] = "rbxassetid://6857999096",
					["SLIME_BLOCK_BREAK"] = "rbxassetid://6857999170",
					["SLIME_BLOCK_HIT"] = "rbxassetid://6857999148",
					["SLIME_BLOCK_PLACE"] = "rbxassetid://6857999119",
					["BOW_DRAW"] = "rbxassetid://6866062236",
					["BOW_FIRE"] = "rbxassetid://6866062104",
					["ARROW_HIT"] = "rbxassetid://6866062188",
					["ARROW_IMPACT"] = "rbxassetid://6866062148",
					["TELEPEARL_THROW"] = "rbxassetid://6866223756",
					["TELEPEARL_LAND"] = "rbxassetid://6866223798",
					["CROSSBOW_RELOAD"] = "rbxassetid://6869254094",
					["VOICE_1"] = "rbxassetid://5283866929",
					["VOICE_2"] = "rbxassetid://5283867710",
					["VOICE_HONK"] = "rbxassetid://5283872555",
					["FORTIFY_BLOCK"] = "rbxassetid://6955762535",
					["EAT_FOOD_1"] = "rbxassetid://4968170636",
					["KILL"] = "rbxassetid://7013482008",
					["ZIPLINE_TRAVEL"] = "rbxassetid://7047882304",
					["ZIPLINE_LATCH"] = "rbxassetid://7047882233",
					["ZIPLINE_UNLATCH"] = "rbxassetid://7047882265",
					["SHIELD_BLOCKED"] = "rbxassetid://6955762535",
					["GUITAR_LOOP"] = "rbxassetid://7084168540",
					["GUITAR_HEAL_1"] = "rbxassetid://7084168458",
					["CANNON_MOVE"] = "rbxassetid://7118668472",
					["CANNON_FIRE"] = "rbxassetid://7121064180",
					["BALLOON_INFLATE"] = "rbxassetid://7118657911",
					["BALLOON_POP"] = "rbxassetid://7118657873",
					["FIREBALL_THROW"] = "rbxassetid://7192289445",
					["LASSO_HIT"] = "rbxassetid://7192289603",
					["LASSO_SWING"] = "rbxassetid://7192289504",
					["LASSO_THROW"] = "rbxassetid://7192289548",
					["GRIM_REAPER_CONSUME"] = "rbxassetid://7225389554",
					["GRIM_REAPER_CHANNEL"] = "rbxassetid://7225389512",
					["TV_STATIC"] = "rbxassetid://7256209920",
					["TURRET_ON"] = "rbxassetid://7290176291",
					["TURRET_OFF"] = "rbxassetid://7290176380",
					["TURRET_ROTATE"] = "rbxassetid://7290176421",
					["TURRET_SHOOT"] = "rbxassetid://7290187805",
					["WIZARD_LIGHTNING_CAST"] = "rbxassetid://7262989886",
					["WIZARD_LIGHTNING_LAND"] = "rbxassetid://7263165647",
					["WIZARD_LIGHTNING_STRIKE"] = "rbxassetid://7263165347",
					["WIZARD_ORB_CAST"] = "rbxassetid://7263165448",
					["WIZARD_ORB_TRAVEL_LOOP"] = "rbxassetid://7263165579",
					["WIZARD_ORB_CONTACT_LOOP"] = "rbxassetid://7263165647",
					["BATTLE_PASS_PROGRESS_LEVEL_UP"] = "rbxassetid://7331597283",
					["BATTLE_PASS_PROGRESS_EXP_GAIN"] = "rbxassetid://7331597220",
					["FLAMETHROWER_UPGRADE"] = "rbxassetid://7310273053",
					["FLAMETHROWER_USE"] = "rbxassetid://7310273125",
					["BRITTLE_HIT"] = "rbxassetid://7310273179",
					["EXTINGUISH"] = "rbxassetid://7310273015",
					["RAVEN_SPACE_AMBIENT"] = "rbxassetid://7341443286",
					["RAVEN_WING_FLAP"] = "rbxassetid://7341443378",
					["RAVEN_CAW"] = "rbxassetid://7341443447",
					["JADE_HAMMER_THUD"] = "rbxassetid://7342299402",
					["STATUE"] = "rbxassetid://7344166851",
					["CONFETTI"] = "rbxassetid://7344278405",
					["HEART"] = "rbxassetid://7345120916",
					["SPRAY"] = "rbxassetid://7361499529",
					["BEEHIVE_PRODUCE"] = "rbxassetid://7378100183",
					["DEPOSIT_BEE"] = "rbxassetid://7378100250",
					["CATCH_BEE"] = "rbxassetid://7378100305",
					["BEE_NET_SWING"] = "rbxassetid://7378100350",
					["ASCEND"] = "rbxassetid://7378387334",
					["BED_ALARM"] = "rbxassetid://7396762708",
					["BOUNTY_CLAIMED"] = "rbxassetid://7396751941",
					["BOUNTY_ASSIGNED"] = "rbxassetid://7396752155",
					["BAGUETTE_HIT"] = "rbxassetid://7396760547",
					["BAGUETTE_SWING"] = "rbxassetid://7396760496",
					["TESLA_ZAP"] = "rbxassetid://7497477336",
					["SPIRIT_TRIGGERED"] = "rbxassetid://7498107251",
					["SPIRIT_EXPLODE"] = "rbxassetid://7498107327",
					["ANGEL_LIGHT_ORB_CREATE"] = "rbxassetid://7552134231",
					["ANGEL_LIGHT_ORB_HEAL"] = "rbxassetid://7552134868",
					["ANGEL_VOID_ORB_CREATE"] = "rbxassetid://7552135942",
					["ANGEL_VOID_ORB_HEAL"] = "rbxassetid://7552136927",
					["DODO_BIRD_JUMP"] = "rbxassetid://7618085391",
					["DODO_BIRD_DOUBLE_JUMP"] = "rbxassetid://7618085771",
					["DODO_BIRD_MOUNT"] = "rbxassetid://7618085486",
					["DODO_BIRD_DISMOUNT"] = "rbxassetid://7618085571",
					["DODO_BIRD_SQUAWK_1"] = "rbxassetid://7618085870",
					["DODO_BIRD_SQUAWK_2"] = "rbxassetid://7618085657",
					["SHIELD_CHARGE_START"] = "rbxassetid://7730842884",
					["SHIELD_CHARGE_LOOP"] = "rbxassetid://7730843006",
					["SHIELD_CHARGE_BASH"] = "rbxassetid://7730843142",
					["ROCKET_LAUNCHER_FIRE"] = "rbxassetid://7681584765",
					["ROCKET_LAUNCHER_FLYING_LOOP"] = "rbxassetid://7681584906",
					["SMOKE_GRENADE_POP"] = "rbxassetid://7681276062",
					["SMOKE_GRENADE_EMIT_LOOP"] = "rbxassetid://7681276135",
					["GOO_SPIT"] = "rbxassetid://7807271610",
					["GOO_SPLAT"] = "rbxassetid://7807272724",
					["GOO_EAT"] = "rbxassetid://7813484049",
					["LUCKY_BLOCK_BREAK"] = "rbxassetid://7682005357",
					["AXOLOTL_SWITCH_TARGETS"] = "rbxassetid://7344278405",
					["HALLOWEEN_MUSIC"] = "rbxassetid://7775602786",
					["SNAP_TRAP_SETUP"] = "rbxassetid://7796078515",
					["SNAP_TRAP_CLOSE"] = "rbxassetid://7796078695",
					["SNAP_TRAP_CONSUME_MARK"] = "rbxassetid://7796078825",
					["GHOST_VACUUM_SUCKING_LOOP"] = "rbxassetid://7814995865",
					["GHOST_VACUUM_SHOOT"] = "rbxassetid://7806060367",
					["GHOST_VACUUM_CATCH"] = "rbxassetid://7815151688",
					["FISHERMAN_GAME_START"] = "rbxassetid://7806060544",
					["FISHERMAN_GAME_PULLING_LOOP"] = "rbxassetid://7806060638",
					["FISHERMAN_GAME_PROGRESS_INCREASE"] = "rbxassetid://7806060745",
					["FISHERMAN_GAME_FISH_MOVE"] = "rbxassetid://7806060863",
					["FISHERMAN_GAME_LOOP"] = "rbxassetid://7806061057",
					["FISHING_ROD_CAST"] = "rbxassetid://7806060976",
					["FISHING_ROD_SPLASH"] = "rbxassetid://7806061193",
					["SPEAR_HIT"] = "rbxassetid://7807270398",
					["SPEAR_THROW"] = "rbxassetid://7813485044",
				}
				task.spawn(function()
					for i,v in pairs(collectionservice:GetTagged("block")) do
						if oldbedwarsblocktab[v.Name] then
							if type(oldbedwarsblocktab[v.Name]) == "table" then
								for i2,v2 in pairs(v:GetDescendants()) do
									if v2:IsA("Texture") then
										if v2.Name == "Top" then
											v2.Texture = oldbedwarsblocktab[v.Name][1]
											v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
										elseif v2.Name == "Bottom" then
											v2.Texture = oldbedwarsblocktab[v.Name][2]
										else
											v2.Texture = oldbedwarsblocktab[v.Name][3]
										end
									end
								end
							else
								for i2,v2 in pairs(v:GetDescendants()) do
									if v2:IsA("Texture") then
										v2.Texture = oldbedwarsblocktab[v.Name]
									end
								end
							end
						end
					end
				end)
				game:GetService("CollectionService"):GetInstanceAddedSignal("block"):Connect(function(v)
					if oldbedwarsblocktab[v.Name] then
						if type(oldbedwarsblocktab[v.Name]) == "table" then
							for i2,v2 in pairs(v:GetDescendants()) do
								if v2:IsA("Texture") then
									if v2.Name == "Top" then
										v2.Texture = oldbedwarsblocktab[v.Name][1]
										v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
									elseif v2.Name == "Bottom" then
										v2.Texture = oldbedwarsblocktab[v.Name][2]
									else
										v2.Texture = oldbedwarsblocktab[v.Name][3]
									end
								end
							end
							v.DescendantAdded:Connect(function(v3)
								if v3:IsA("Texture") then
									if v3.Name == "Top" then
										v3.Texture = oldbedwarsblocktab[v.Name][1]
										v3.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
									elseif v3.Name == "Bottom" then
										v3.Texture = oldbedwarsblocktab[v.Name][2]
									else
										v3.Texture = oldbedwarsblocktab[v.Name][3]
									end
								end
							end)
						else
							for i2,v2 in pairs(v:GetDescendants()) do
								if v2:IsA("Texture") then
									v2.Texture = oldbedwarsblocktab[v.Name]
								end
							end
							v.DescendantAdded:Connect(function(v3)
								if v3:IsA("Texture") then
									v3.Texture = oldbedwarsblocktab[v.Name]
								end
							end)
						end
					end
				end)
				game:GetService("CollectionService"):GetInstanceAddedSignal("tnt"):Connect(function(v)
					if oldbedwarsblocktab[v.Name] then
						if type(oldbedwarsblocktab[v.Name]) == "table" then
							for i2,v2 in pairs(v:GetDescendants()) do
								if v2:IsA("Texture") then
									if v2.Name == "Top" then
										v2.Texture = oldbedwarsblocktab[v.Name][1]
										v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
									elseif v2.Name == "Bottom" then
										v2.Texture = oldbedwarsblocktab[v.Name][2]
									else
										v2.Texture = oldbedwarsblocktab[v.Name][3]
									end
								end
							end
							v.DescendantAdded:Connect(function(v3)
								if v3:IsA("Texture") then
									if v3.Name == "Top" then
										v3.Texture = oldbedwarsblocktab[v.Name][1]
										v3.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
									elseif v3.Name == "Bottom" then
										v3.Texture = oldbedwarsblocktab[v.Name][2]
									else
										v3.Texture = oldbedwarsblocktab[v.Name][3]
									end
								end
							end)
						else
							for i2,v2 in pairs(v:GetDescendants()) do
								if v2:IsA("Texture") then
									v2.Texture = oldbedwarsblocktab[v.Name]
								end
							end
							v.DescendantAdded:Connect(function(v3)
								if v3:IsA("Texture") then
									v3.Texture = oldbedwarsblocktab[v.Name]
								end
							end)
						end
					end
				end)
				for i,v in pairs(bedwars["ItemTable"]) do 
					if oldbedwarsicontab[i] then 
						v.image = oldbedwarsicontab[i]
					end
				end			
				for i,v in pairs(oldbedwarssoundtable) do 
					local item = bedwars["SoundList"][i]
					if item then
						bedwars["SoundList"][i] = v
					end
				end	
				local oldweld = bedwars["WeldTable"].weldCharacterAccessories
				local alreadydone = {}
				bedwars["WeldTable"].weldCharacterAccessories = function(self, model, ...)
					for i,v in pairs(model:GetChildren()) do
						local died = v.Name == "HumanoidRootPart" and v:FindFirstChild("Died")
						if died then 
							died.Volume = 0
						end
						if oldbedwarsblocktab[v.Name] then
							task.spawn(function()
								local hand = v:WaitForChild("Handle", 10)
								if hand then
									hand.CastShadow = false
								end
								for i2,v2 in pairs(v:GetDescendants()) do
									if v2:IsA("Texture") then
										if v2.Name == "Top" then
											v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][1] or oldbedwarsblocktab[v.Name])
											v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
										elseif v2.Name == "Bottom" then
											v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][2] or oldbedwarsblocktab[v.Name])
										else
											v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][3] or oldbedwarsblocktab[v.Name])
										end
									end
								end
								v.DescendantAdded:Connect(function(v3)
									if v3:IsA("Texture") then
										if v3.Name == "Top" then
											v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][1] or oldbedwarsblocktab[v.Name])
											v3.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
										elseif v3.Name == "Bottom" then
											v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][2] or oldbedwarsblocktab[v.Name])
										else
											v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][3] or oldbedwarsblocktab[v.Name])
										end
									end
								end)
							end)
						end
					end
					return oldweld(self, model, ...)
				end
				sethiddenproperty(lighting, "Technology", "ShadowMap")
				lighting.Ambient = Color3.fromRGB(69, 69, 69)
				lighting.Brightness = 3
				lighting.EnvironmentDiffuseScale = 1
				lighting.EnvironmentSpecularScale = 1
				lighting.OutdoorAmbient = Color3.fromRGB(69, 69, 69)
				lighting.Atmosphere.Density = 0.1
				lighting.Atmosphere.Offset = 0.25
				lighting.Atmosphere.Color = Color3.fromRGB(198, 198, 198)
				lighting.Atmosphere.Decay = Color3.fromRGB(104, 112, 124)
				lighting.Atmosphere.Glare = 0
				lighting.Atmosphere.Haze = 0
				lighting.ClockTime = 13
				lighting.GeographicLatitude = 0
				lighting.GlobalShadows = false
				lighting.TimeOfDay = "13:00:00"
				lighting.Sky.SkyboxBk = "rbxassetid://7018684000"
				lighting.Sky.SkyboxDn = "rbxassetid://6334928194"
				lighting.Sky.SkyboxFt = "rbxassetid://7018684000"
				lighting.Sky.SkyboxLf = "rbxassetid://7018684000"
				lighting.Sky.SkyboxRt = "rbxassetid://7018684000"
				lighting.Sky.SkyboxUp = "rbxassetid://7018689553"
			end)
		end,
		Winter = function() 
			task.spawn(function()
				for i,v in pairs(lighting:GetChildren()) do
					if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
						v:Remove()
					end
				end
				local sky = Instance.new("Sky")
				sky.StarCount = 5000
				sky.SkyboxUp = "rbxassetid://8139676647"
				sky.SkyboxLf = "rbxassetid://8139676988"
				sky.SkyboxFt = "rbxassetid://8139677111"
				sky.SkyboxBk = "rbxassetid://8139677359"
				sky.SkyboxDn = "rbxassetid://8139677253"
				sky.SkyboxRt = "rbxassetid://8139676842"
				sky.SunTextureId = "rbxassetid://6196665106"
				sky.SunAngularSize = 11
				sky.MoonTextureId = "rbxassetid://8139665943"
				sky.MoonAngularSize = 30
				sky.Parent = lighting
				local sunray = Instance.new("SunRaysEffect")
				sunray.Intensity = 0.03
				sunray.Parent = lighting
				local bloom = Instance.new("BloomEffect")
				bloom.Threshold = 2
				bloom.Intensity = 1
				bloom.Size = 2
				bloom.Parent = lighting
				local atmosphere = Instance.new("Atmosphere")
				atmosphere.Density = 0.3
				atmosphere.Offset = 0.25
				atmosphere.Color = Color3.fromRGB(198, 198, 198)
				atmosphere.Decay = Color3.fromRGB(104, 112, 124)
				atmosphere.Glare = 0
				atmosphere.Haze = 0
				atmosphere.Parent = lighting
			end)
			task.spawn(function()
				local snowpart = Instance.new("Part")
				snowpart.Size = Vector3.new(240, 0.5, 240)
				snowpart.Name = "SnowParticle"
				snowpart.Transparency = 1
				snowpart.CanCollide = false
				snowpart.Position = Vector3.new(0, 120, 286)
				snowpart.Anchored = true
				snowpart.Parent = workspace
				local snow = Instance.new("ParticleEmitter")
				snow.RotSpeed = NumberRange.new(300)
				snow.VelocitySpread = 35
				snow.Rate = 28
				snow.Texture = "rbxassetid://8158344433"
				snow.Rotation = NumberRange.new(110)
				snow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
				snow.Lifetime = NumberRange.new(8,14)
				snow.Speed = NumberRange.new(8,18)
				snow.EmissionDirection = Enum.NormalId.Bottom
				snow.SpreadAngle = Vector2.new(35,35)
				snow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
				snow.Parent = snowpart
				local windsnow = Instance.new("ParticleEmitter")
				windsnow.Acceleration = Vector3.new(0,0,1)
				windsnow.RotSpeed = NumberRange.new(100)
				windsnow.VelocitySpread = 35
				windsnow.Rate = 28
				windsnow.Texture = "rbxassetid://8158344433"
				windsnow.EmissionDirection = Enum.NormalId.Bottom
				windsnow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
				windsnow.Lifetime = NumberRange.new(8,14)
				windsnow.Speed = NumberRange.new(8,18)
				windsnow.Rotation = NumberRange.new(110)
				windsnow.SpreadAngle = Vector2.new(35,35)
				windsnow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
				windsnow.Parent = snowpart
				for i = 1, 30 do
					for i2 = 1, 30 do
						local clone = snowpart:Clone()
						clone.Position = Vector3.new(240 * (i - 1), 400, 240 * (i2 - 1))
						clone.Parent = workspace
					end
				end
			end)
		end,
		Halloween = function()
			task.spawn(function()
				for i,v in pairs(lighting:GetChildren()) do
					if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
						v:Remove()
					end
				end
				lighting.TimeOfDay = "00:00:00"
				pcall(function() workspace.Clouds:Destroy() end)
				local colorcorrection = Instance.new("ColorCorrectionEffect")
				colorcorrection.TintColor = Color3.fromRGB(255, 185, 81)
				colorcorrection.Brightness = 0.05
				colorcorrection.Parent = lighting
			end)
		end,
		Valentines = function()
			task.spawn(function()
				for i,v in pairs(lighting:GetChildren()) do
					if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
						v:Remove()
					end
				end
				local sky = Instance.new("Sky")
				sky.SkyboxBk = "rbxassetid://1546230803"
				sky.SkyboxDn = "rbxassetid://1546231143"
				sky.SkyboxFt = "rbxassetid://1546230803"
				sky.SkyboxLf = "rbxassetid://1546230803"
				sky.SkyboxRt = "rbxassetid://1546230803"
				sky.SkyboxUp = "rbxassetid://1546230451"
				sky.Parent = lighting
				pcall(function() workspace.Clouds:Destroy() end)
				local colorcorrection = Instance.new("ColorCorrectionEffect")
				colorcorrection.TintColor = Color3.fromRGB(255, 199, 220)
				colorcorrection.Brightness = 0.05
				colorcorrection.Parent = lighting
			end)
		end
	}

	OldBedwars = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "GameTheme",
		["Function"] = function(callback) 
			if callback then 
				if not transformed then
					transformed = true
					themefunctions[themeselected["Value"]]()
				else
					OldBedwars["ToggleButton"](false)
				end
			else
				createwarning("GameTheme", "Disabled Next Game", 10)
			end
		end,
		["ExtraText"] = function()
			return themeselected["Value"]
		end
	})
	themeselected = OldBedwars.CreateDropdown({
		["Name"] = "Theme",
		["Function"] = function() end,
		["List"] = {"Old", "Winter", "Halloween", "Valentines"}
	})
end)

runcode(function()
	local SetEmote = {Enabled = false}
	local SetEmoteList = {Value = ""}
	local oldemote
	local emo2 = {}
	SetEmote = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "SetEmote",
		Function = function(callback)
			if callback then
				oldemote = bedwars.ClientStoreHandler:getState().Locker.selectedSpray
				bedwars.ClientStoreHandler:getState().Locker.selectedSpray = emo2[SetEmoteList.Value]
			else
				if oldemote then 
					bedwars.ClientStoreHandler:getState().Locker.selectedSpray = oldemote
					oldemote = nil 
				end
			end
		end
	})
	local emo = {}
	for i,v in pairs(bedwars.EmoteMeta) do 
		table.insert(emo, v.name)
		emo2[v.name] = i
	end
	SetEmoteList = SetEmote.CreateDropdown({
		Name = "Emote",
		List = emo,
		Function = function()
			if SetEmote.Enabled then 
				bedwars.ClientStoreHandler:getState().Locker.selectedSpray = emo2[SetEmoteList.Value]
			end
		end
	})
end)

runcode(function()
	local tpstring = shared.vapeoverlay or nil
	local origtpstring = tpstring
	local Overlay = GuiLibrary.CreateCustomWindow({
		["Name"] = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png",
		["IconSize"] = 16
	})
	local overlayframe = Instance.new("Frame")
	overlayframe.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	overlayframe.Size = UDim2.new(0, 200, 0, 120)
	overlayframe.Position = UDim2.new(0, 0, 0, 5)
	overlayframe.Parent = Overlay.GetCustomChildren()
	local overlayframe2 = Instance.new("Frame")
	overlayframe2.Size = UDim2.new(1, 0, 0, 10)
	overlayframe2.Position = UDim2.new(0, 0, 0, -5)
	overlayframe2.Parent = overlayframe
	local overlayframe3 = Instance.new("Frame")
	overlayframe3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	overlayframe3.Size = UDim2.new(1, 0, 0, 6)
	overlayframe3.Position = UDim2.new(0, 0, 0, 6)
	overlayframe3.BorderSizePixel = 0
	overlayframe3.Parent = overlayframe2
	local oldguiupdate = GuiLibrary["UpdateUI"]
	GuiLibrary["UpdateUI"] = function(h, s, v, ...)
		overlayframe2.BackgroundColor3 = Color3.fromHSV(h, s, v)
		return oldguiupdate(h, s, v, ...)
	end
	local framecorner1 = Instance.new("UICorner")
	framecorner1.CornerRadius = UDim.new(0, 5)
	framecorner1.Parent = overlayframe
	local framecorner2 = Instance.new("UICorner")
	framecorner2.CornerRadius = UDim.new(0, 5)
	framecorner2.Parent = overlayframe2
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -7, 1, -5)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Font = Enum.Font.GothamBold
	label.LineHeight = 1.2
	label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	label.TextSize = 16
	label.Text = ""
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Position = UDim2.new(0, 7, 0, 5)
	label.Parent = overlayframe
	Overlay["Bypass"] = true
	local oldnetworkowner
	local mapname = "Lobby"
	GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Api"].CreateCustomToggle({
		["Name"] = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png", 
		["Function"] = function(callback)
			Overlay.SetVisible(callback) 
			if callback then
				task.spawn(function()
					repeat
						wait(1)
						if not tpstring then
							tpstring = tick().."/0/0/0/0/0/0/0"
							origtpstring = tpstring
						end
						local splitted = origtpstring:split("/")
						label.Text = "Session Info\nTime Played : "..os.date("!%X",math.floor(tick() - splitted[1])).."\nKills : "..(splitted[2]).."\nBeds : "..(splitted[3]).."\nWins : "..(splitted[4]).."\nGames : "..splitted[5].."\nLagbacks : "..(splitted[6]).."\nUniversal Lagbacks : "..(splitted[7]).."\nReported : "..(splitted[8]).."\nMap : "..mapname
						local textsize = textservice:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(100000, 100000))
						overlayframe.Size = UDim2.new(0, math.max(textsize.X + 19, 200), 0, (textsize.Y * 1.2) + 10)
						tpstring = splitted[1].."/"..(splitted[2]).."/"..(splitted[3]).."/"..(splitted[4]).."/"..(splitted[5]).."/"..(splitted[6]).."/"..(splitted[7]).."/"..(splitted[8])
					until (Overlay and Overlay.GetCustomChildren() and Overlay.GetCustomChildren().Parent and Overlay.GetCustomChildren().Parent.Visible == false)
				end)
			end
		end, 
		["Priority"] = 2
	})
end)

spawn(function()
	local url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/CustomModules/bedwarsdata"

	local function createannouncement(announcetab)
		local notifyframereal = Instance.new("TextButton")
		notifyframereal.AnchorPoint = Vector2.new(0.5, 0)
		notifyframereal.BackgroundColor3 = announcetab.Error and Color3.fromRGB(235, 87, 87) or Color3.fromRGB(100, 103, 167)
		notifyframereal.BorderSizePixel = 0
		notifyframereal.AutoButtonColor = false
		notifyframereal.Text = ""
		notifyframereal.Position = UDim2.new(0.5, 0, 0.01, -36)
		notifyframereal.Size = UDim2.new(0.4, 0, 0, 0)
		notifyframereal.Parent = GuiLibrary["MainGui"]
		local notifyframe = Instance.new("Frame")
		notifyframe.BackgroundTransparency = 1
		notifyframe.Size = UDim2.new(1, 0, 1, 0)
		notifyframe.Parent = notifyframereal
		local notifyframecorner = Instance.new("UICorner")
		notifyframecorner.CornerRadius = UDim.new(0, 5)
		notifyframecorner.Parent = notifyframereal
		local notifyframeaspect = Instance.new("UIAspectRatioConstraint")
		notifyframeaspect.AspectRatio = 10
		notifyframeaspect.DominantAxis = Enum.DominantAxis.Height
		notifyframeaspect.Parent = notifyframereal
		local notifyframelist = Instance.new("UIListLayout")
		notifyframelist.SortOrder = Enum.SortOrder.LayoutOrder
		notifyframelist.FillDirection = Enum.FillDirection.Horizontal
		notifyframelist.HorizontalAlignment = Enum.HorizontalAlignment.Left
		notifyframelist.VerticalAlignment = Enum.VerticalAlignment.Center
		notifyframelist.Parent = notifyframe
		local notifyframe2 = Instance.new("Frame")
		notifyframe2.BackgroundTransparency = 1
		notifyframe2.BorderSizePixel = 0
		notifyframe2.LayoutOrder = 1
		notifyframe2.Size = UDim2.new(0.3, 0, 0, 0)
		notifyframe2.SizeConstraint = Enum.SizeConstraint.RelativeYY
		notifyframe2.Parent = notifyframe
		local notifyframesat = Instance.new("ImageLabel")
		notifyframesat.BackgroundTransparency = 1
		notifyframesat.BorderSizePixel = 0
		notifyframesat.Size = UDim2.new(0.7, 0, 0.7, 0)
		notifyframesat.LayoutOrder = 2
		notifyframesat.SizeConstraint = Enum.SizeConstraint.RelativeYY
		notifyframesat.Image = announcetab.Error and "rbxassetid://6768383834" or "rbxassetid://6685538693"
		notifyframesat.Parent = notifyframe
		local notifyframe3 = Instance.new("Frame")
		notifyframe3.BackgroundTransparency = 1
		notifyframe3.BorderSizePixel = 0
		notifyframe3.LayoutOrder = 3
		notifyframe3.Size = UDim2.new(4.1, 0, 0.8, 0)
		notifyframe3.SizeConstraint = Enum.SizeConstraint.RelativeYY
		notifyframe3.Parent = notifyframe
		local notifyframenotifyframelist = Instance.new("UIPadding")
		notifyframenotifyframelist.PaddingBottom = UDim.new(0.08, 0)
		notifyframenotifyframelist.PaddingLeft = UDim.new(0.06, 0)
		notifyframenotifyframelist.PaddingTop = UDim.new(0.08, 0)
		notifyframenotifyframelist.Parent = notifyframe3
		local notifyframeaspectnotifyframeaspect = Instance.new("UIListLayout")
		notifyframeaspectnotifyframeaspect.Parent = notifyframe3
		notifyframeaspectnotifyframeaspect.VerticalAlignment = Enum.VerticalAlignment.Center
		local notifyframelistnotifyframeaspect = Instance.new("TextLabel")
		notifyframelistnotifyframeaspect.BackgroundTransparency = 1
		notifyframelistnotifyframeaspect.BorderSizePixel = 0
		notifyframelistnotifyframeaspect.Size = UDim2.new(1, 0, 0.6, 0)
		notifyframelistnotifyframeaspect.Font = Enum.Font.Roboto
		notifyframelistnotifyframeaspect.Text = "Vape Announcement"
		notifyframelistnotifyframeaspect.TextColor3 = Color3.fromRGB(255, 255, 255)
		notifyframelistnotifyframeaspect.TextScaled = true
		notifyframelistnotifyframeaspect.TextWrapped = true
		notifyframelistnotifyframeaspect.TextXAlignment = Enum.TextXAlignment.Left
		notifyframelistnotifyframeaspect.Parent = notifyframe3
		local notifyframe2notifyframeaspect = Instance.new("TextLabel")
		notifyframe2notifyframeaspect.BackgroundTransparency = 1
		notifyframe2notifyframeaspect.BorderSizePixel = 0
		notifyframe2notifyframeaspect.Size = UDim2.new(1, 0, 0.4, 0)
		notifyframe2notifyframeaspect.Font = Enum.Font.Roboto
		notifyframe2notifyframeaspect.Text = "<b>"..announcetab.Text.."</b>"
		notifyframe2notifyframeaspect.TextColor3 = Color3.fromRGB(255, 255, 255)
		notifyframe2notifyframeaspect.TextScaled = true
		notifyframe2notifyframeaspect.TextWrapped = true
		notifyframe2notifyframeaspect.RichText = true
		notifyframe2notifyframeaspect.TextXAlignment = Enum.TextXAlignment.Left
		notifyframe2notifyframeaspect.Parent = notifyframe3
		local notifyprogress = Instance.new("Frame")
		notifyprogress.Parent = notifyframereal
		notifyprogress.BorderSizePixel = 0
		notifyprogress.BackgroundColor3 = Color3.new(1, 1, 1)
		notifyprogress.Position = UDim2.new(0, 0, 1, -3)
		notifyprogress.Size = UDim2.new(1, 0, 0, 3)
		local notifyprogresscorner = Instance.new("UICorner")
		notifyprogresscorner.CornerRadius = UDim.new(0, 100)
		notifyprogresscorner.Parent = notifyprogress
		game:GetService("TweenService"):Create(notifyframereal, TweenInfo.new(0.12), {Size = UDim2.fromScale(0.4, 0.065)}):Play()
		game:GetService("TweenService"):Create(notifyprogress, TweenInfo.new(announcetab.Time or 20, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)}):Play()
		local sound = Instance.new("Sound")
		sound.PlayOnRemove = true
		sound.SoundId = "rbxassetid://6732495464"
		sound.Parent = workspace
		sound:Remove()
		notifyframereal.MouseButton1Click:Connect(function()
			local sound = Instance.new("Sound")
			sound.PlayOnRemove = true
			sound.SoundId = "rbxassetid://6732690176"
			sound.Parent = workspace
			sound:Remove()
			notifyframereal:Remove()
			notifyframereal = nil
		end)
		task.wait(announcetab.Time or 20)
		if notifyframereal then
			notifyframereal:Remove()
		end
	end

	local function rundata(datatab, olddatatab)
		if not olddatatab then
			if datatab.Disabled then 
				coroutine.resume(coroutine.create(function()
					repeat task.wait() until shared.VapeFullyLoaded
					task.wait(1)
					GuiLibrary.SelfDestruct()
				end))
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Vape",
					Text = "Vape is currently disabled, check the discord for updates discord.gg/vxpe",
					Duration = 30,
				})
			end
			if datatab.KickUsers and datatab.KickUsers[tostring(lplr.UserId)] then
				lplr:Kick(datatab.KickUsers[tostring(lplr.UserId)])
			end
		else
			local newdatatab = {}
			for i,v in pairs(datatab) do 
				if not olddatatab or olddatatab[i] ~= v then 
					newdatatab[i] = v
				end
			end
			if newdatatab.Disabled then 
				coroutine.resume(coroutine.create(function()
					repeat task.wait() until shared.VapeFullyLoaded
					task.wait(1)
					GuiLibrary.SelfDestruct()
				end))
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Vape",
					Text = "Vape is currently disabled, check the discord for updates discord.gg/vxpe",
					Duration = 30,
				})
			end
			if datatab.KickUsers and datatab.KickUsers[tostring(lplr.UserId)] then
				lplr:Kick(datatab.KickUsers[tostring(lplr.UserId)])
			end
			if newdatatab.Announcement and newdatatab.Announcement.ExpireTime >= os.time() then 
				spawn(function()
					createannouncement(newdatatab.Announcement)
				end)
			end
		end
	end

	pcall(function()
		if betterisfile("vape/Profiles/bedwarsdata.txt") == false then 
			writefile("vape/Profiles/bedwarsdata.txt", game:HttpGet(url, true))
		end
		local olddata = readfile("vape/Profiles/bedwarsdata.txt")
		local newdata = game:HttpGet(url, true)
		if newdata ~= olddata then 
			rundata(game:GetService("HttpService"):JSONDecode(newdata), game:GetService("HttpService"):JSONDecode(olddata))
			olddata = newdata
			writefile("vape/Profiles/bedwarsdata.txt", newdata)
		else
			rundata(game:GetService("HttpService"):JSONDecode(olddata))
		end
		repeat
			task.wait(60)
			newdata = game:HttpGet(url, true)
			if newdata ~= olddata then 
				rundata(game:GetService("HttpService"):JSONDecode(newdata), game:GetService("HttpService"):JSONDecode(olddata))
				olddata = newdata
				writefile("vape/Profiles/bedwarsdata.txt", newdata)
			end
		until uninjectflag
	end)
end)

runcode(function()
	local TPAura = {["Enabled"] = false}
	TPAura = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoWin",
		Function = function(callback)
			if callback then
			task.spawn(function()
				warningNotification("Vape", "You need Bow and arrows", 10)
				local bow = getBow()
				if bow and getItem("arrow") then
					if matchState ~= 0 then
						entityLibrary.character.HumanoidRootPart.Anchored = true  -- removed from the loop :>
					end
				end
				repeat
					task.wait(0.03)
					if (GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"]["Api"].Enabled == false or matchState ~= 0) and TPAura["Enabled"] then
						local bow = getBow()
						if bow and getItem("arrow") then
							targetedPlayer = TPloaderthing(10000)  -- add one more zero if you want it to target inf fly aswelll
								if cam.Enabled then 
									workspace.CurrentCamera.CameraType = Enum.CameraType.Fixed
								end
								if targetedPlayer and targetedPlayer.Character and targetedPlayer.Character.Humanoid.Health > 0 then
									lplr.Character.HumanoidRootPart.CFrame = targetedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
								end
								if targetedPlayer and (lplr.Character.Head.Position - targetedPlayer.Character.Head.Position).magnitude <= 1000000 then
									lplr.Character.HumanoidRootPart.CFrame = targetedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
								end
							end
						end
					until TPAura.Enabled == false
				end)
			else
				entityLibrary.character.HumanoidRootPart.Anchored = false
				workspace.CurrentCamera.CameraType = Enum.CameraType.Track
			end
		end,
		HoverText = "Attack players around you\nwithout aiming at them."
	})
	cam = TPAura.CreateToggle({
		Name = "NoCamera",
		Function = function() end,
		HoverText = "removes your Camera"
	})
end)

runcode(function()
        local ClickTP = {Enabled = false}
        ClickTP = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
                Name = "MouseTP",
                Function = function(callback)
                        if callback then
                                lplr.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p)
                                ClickTP.ToggleButton(false)
                        end
                end
        })
end)



runcode(function()
local FPSCrashShield = {Enabled = false}
FPSCrashShield = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
	Name = "FPSCrashShield",
	Function = function(callback)
		if callback then
			task.spawn(function()
			  repeat
                     task.wait(0.1)
                      spawn(function()
                        for i=1, 2 do
					
                                  bedwars.ClientHandler:Get(bedwars.RaiseShieldRemote).instance:FireServer({raised = true})
                           end
			end)
				until FPSCrashShield.Enabled == false
			end)
		end
	end, 
	HoverText = "Trollage"
})
end)


			
runcode(function()
	local Old4bigguysAura = {["Enabled"] = false}
        Old4bigguysAura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
        Name = "4bigguysexploit",
        Function = function(callback)
            if callback then
                task.spawn(function()
					repeat
						task.wait(0.03)
						if (GuiLibrary.ObjectsThatCanBeSaved["Lobby CheckToggle"]["Api"].Enabled == false or matchState ~= 0) and Old4bigguysAura["Enabled"] then
							local plrs = GetAllNearestHumanoidToPosition(true, 18.8, 1, false)
							for i,plr in pairs(plrs) do
								if plrs then 
								   game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.HellBladeRelease:FireServer({
                                   ["chargeTime"] = 0.999,
                                   ["player"] = game:GetService("Players").LocalPlayer,
                                   ["weapon"] =game:GetService("ReplicatedStorage").Inventories:FindFirstChild(lplr.Name.."infernal_saber"),
                               })                                    
								end
							end
						end
					until Old4bigguysAura.Enabled == false
				end)
            end
        end,
        ["HoverText"] = "Attack players around you\without aiming at them."
    })
end)



runcode(function()
local PlayAnnoyer = {Enabled = false}
PlayAnnoyer = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
	Name = "PlayerAnnoyer",
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat
					task.wait(1)
                                game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.DragonBreath:FireServer(" ")
                               if ConfettiPopper.Enabled then 
					      game:GetService("ReplicatedStorage")["events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"].useAbility:FireServer("PARTY_POPPER")
                            end
                            if Yuzi.Enabled then 
					     game:GetService("ReplicatedStorage"):FindFirstChild("events-@easy-games/game-core:shared/game-core-networking@getEvents.Events").useAbility:FireServer("dash")
                        end
				until PlayAnnoyer.Enabled == false
			end)
		end
	end, 
	HoverText = "Trollage",
     ["ExtraText"] = function() return "Trollage" end
})
ConfettiPopper = PlayAnnoyer.CreateToggle({
		Name = "ConfettiPopper",
		Function = function() end,
		HoverText = "Uses the ConfettiPopper remote"
	})
Yuzi = PlayAnnoyer.CreateToggle({
		Name = "Yuzi",
		Function = function() end,
		HoverText = "Uses the Yuzi remote"
	})
end)

runcode(function()
local Visuals = {Enabled = false}
Visuals = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
	Name = "Visuals",
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat
					task.wait(1)
                                task.spawn(function()
				           game:GetService("Chat"):SetBubbleChatSettings({
                                   BackgroundColor3 = Color3.fromRGB(15,15,15),
                                   TextColor3 =  Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Gui ColorSliderColor"].Api.Value) --:)
                                  })
                               end)
				until Visuals.Enabled == false
			end)
		end
	end, 
	HoverText = "Trollage"
})
end)


local SmallWeapons = {["Enabled"] = false}
SmallWeapons = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
    ["Name"] = "Small Weapons",
       ["Function"] = function(Callback)
            Enabled = Callback
            if Enabled then
                Connection = cam.Viewmodel.ChildAdded:Connect(function(v)
                    if v:FindFirstChild("Handle") then
                        pcall(function()
                            v:FindFirstChild("Handle").Size = v:FindFirstChild("Handle").Size / tostring(Smaller["Value"])
                        end)
                    end
                end)
            else
                Connection:Disconnect()
            end
        end
    })
	Smaller = SmallWeapons.CreateSlider({
		["Name"] = "Valua",
		["Min"] = 0,
		["Max"] = 10,
		["Function"] = function(val) end,
		["Default"] = 3
	})
    
			local PurpleTextures = {["Enabled"] = false}
			PurpleTextures = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
				["Name"] = "Neon Purple Items",
				   ["Function"] = function(Callback)
						Enabled = Callback
						if Enabled then
							Connection = cam.Viewmodel.ChildAdded:Connect(function(v)
								if v:FindFirstChild("Handle") then
									pcall(function()
										v:FindFirstChild("Handle").Size = v:FindFirstChild("Handle").Size / 1.5
										v:FindFirstChild("Handle").Material = Enum.Material.Neon
										v:FindFirstChild("Handle").TextureID = ""
										v:FindFirstChild("Handle").Color = Color3.fromRGB(126,84,217)
									end)
									local vname = string.lower(v.Name)
									if vname:find("sword") or vname:find("blade") then
										v:FindFirstChild("Handle").MeshId = "rbxassetid://11216117592"
									elseif vname:find("snowball") then
										v:FindFirstChild("Handle").MeshId = "rbxassetid://11216343798"
									end
								end
							end)
						else
							Connection:Disconnect()
						end
					end,
					HoverText = "Broken For Certain Items"
				})


local BoostAirJump = {["Enabled"] = false}
BoostAirJump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
    Name = "BoostAirJump",
    Function = function(callback)
        if callback then
            task.spawn(function()
                repeat
                    task.wait(0.1)
                    if BoostAirJump.Enabled == false then break end
                    entity.character.HumanoidRootPart.Velocity = entity.character.HumanoidRootPart.Velocity + Vector3.new(0,70,0)
                until BoostAirJump.Enabled == false
            end)
        end
    end,
    HoverText = "Highjump but smooth"
})

	runcode(function()
		local Multiaura = {["Enabled"] = false}
		Multiaura = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Multiaura",
			["Function"] = function(callback)
				if callback then
					task.spawn(function()
						repeat
							task.wait(0.03)
							if (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) and Multiaura["Enabled"] then
								local plrs = GetAllNearestHumanoidToPosition(true, 17.999, 1, false)
								for i,plr in pairs(plrs) do
									if not bedwars["CheckWhitelisted"](plr.Player) then 
										local selfpos = entity.character.HumanoidRootPart.Position
										local newpos = plr.RootPart.Position
										bedwars["ClientHandler"]:Get(bedwars["PaintRemote"]):SendToServer(selfpos, CFrame.lookAt(selfpos, newpos).lookVector)
									end
								end
							end
						until Multiaura["Enabled"] == false
					end)
				end
			end,
			["HoverText"] = "Attack players around you\nwithout aiming at them."
		})
	end)

local bypassed = false
runcode(function()
	local anticheatdisabler = {["Enabled"] = false}
	local anticheatdisablerauto = {["Enabled"] = false}
	local anticheatdisablerconnection
	local anticheatdisablerconnection2
	anticheatdisabler = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Float Disabler {basically inf fly but worse}",
		["Function"] = function(callback)
			if callback then
				local balloonitem = getItem("balloon")
				if balloonitem then
					local oldfunc3 = bedwars["BalloonController"].hookBalloon
					local oldfunc4 = bedwars["BalloonController"].enableBalloonPhysics
					local oldfunc5 = bedwars["BalloonController"].deflateBalloon
					bedwars["BalloonController"].inflateBalloon()
					bedwars["BalloonController"].enableBalloonPhysics = function() end
					bedwars["BalloonController"].deflateBalloon = function() end
					bedwars["BalloonController"].hookBalloon = function(Self, plr, attachment, balloon)
						if tostring(plr) == lplr.Name then
							balloon:WaitForChild("Balloon").CFrame = CFrame.new(0, -1995, 0)
							balloon.Balloon:ClearAllChildren()
							local threadidentity = syn and syn.set_thread_identity or setidentity
							threadidentity(7)
							spawn(function()
								task.wait(0.5)
								createwarning("FloatDisabler", "Disabled float check!", 5)
								bypassed = true
							end)
							threadidentity(2)
							bedwars["BalloonController"].hookBalloon = oldfunc3
							bedwars["BalloonController"].enableBalloonPhysics = oldfunc4
						end
					end
				end
				anticheatdisabler["ToggleButton"](true)
			end
		end,
		["HoverText"] = "Disables float check. You need a balloon"
	})
	anticheatdisablerauto = anticheatdisabler.CreateToggle({
		["Name"] = "Auto Disable",
		["Function"] = function(callback)
			if callback then
				anticheatdisablerconnection = repstorage.Inventories.DescendantAdded:connect(function(p3)
					if p3.Parent.Name == lplr.Name then
						if p3.Name == "balloon" then
							repeat task.wait() until getItem("balloon")
							anticheatdisabler["ToggleButton"](false)
						end
					end
				end)
			else
				if anticheatdisablerconnection then
					anticheatdisablerconnection:Disconnect()
				end
			end
		end,
	})
end)

runcode(function()
	local funnyfly = {["Enabled"] = false}
	local flyacprogressbar
	local flyacprogressbarframe
	local flyacprogressbarframe2
	local flyacprogressbartext
	local bodyvelo
	funnyfly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "FunnyFlyV2",
		["Function"] = function(callback)
			if callback then 
				local starty
				local starttick = tick()
				task.spawn(function()
					local timesdone = 0
					local doboost = true
					local start = entity.character.HumanoidRootPart.Position
					flyacprogressbartext = Instance.new("TextLabel")
					flyacprogressbartext.Text = "Unsafe"
					flyacprogressbartext.Font = Enum.Font.Gotham
					flyacprogressbartext.TextStrokeTransparency = 0
					flyacprogressbartext.TextColor3 =  Color3.new(0.9, 0.9, 0.9)
					flyacprogressbartext.TextSize = 20
					flyacprogressbartext.Size = UDim2.new(0, 0, 0, 20)
					flyacprogressbartext.BackgroundTransparency = 1
					flyacprogressbartext.Position = UDim2.new(0.5, 0, 0.5, 40)
					flyacprogressbartext.Parent = GuiLibrary["MainGui"]
					repeat
						timesdone = timesdone + 1
						if entity.isAlive then
							local root = entity.character.HumanoidRootPart
							if starty == nil then 
								starty = root.Position.Y
							end
							if not bodyvelo then 
								bodyvelo = Instance.new("BodyVelocity")
								bodyvelo.MaxForce = Vector3.new(0, 1000000, 0)
								bodyvelo.Parent = root
								bodyvelo.Velocity = Vector3.zero
							else
								bodyvelo.Parent = root
							end
							for i = 2, 30, 2 do 
								task.wait(0.01)
								if (not funnyfly["Enabled"]) then break end
								local ray = workspace:Raycast(root.Position + (entity.character.Humanoid.MoveDirection * 50), Vector3.new(0, -2000, 0), blockraycast)
								flyacprogressbartext.Text = ray and "No Lagback" or "lagback 100%"
								bodyvelo.Velocity = Vector3.new(0, 25 + i, 0)
							end
							if (not networkownerfunc(root)) then
								break 
							end
						else
							break
						end
					until (not funnyfly["Enabled"])
					if funnyfly["Enabled"] then 
						funnyfly["ToggleButton"](false)
					end
				end)
			else
				if bodyvelo then 
					bodyvelo:Destroy()
					bodyvelo = nil
				end
				if flyacprogressbartext then
					flyacprogressbartext:Destroy()
				end
			end
		end
	})
end)

runcode(function()
	local PurpleAntivoid = {["Enabled"] = false}
	PurpleAntivoid = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Purple Antivoid",
			["HoverText"] = "Purple Antivoid",
			["Function"] = function(callback)
				if callback then
		local part = Instance.new("Part", Workspace)
				part.Name = "AntiVoid"
				part.Size = Vector3.new(2100, 0.5, 2000)
				part.Position = Vector3.new(160.5, 25, 247.5)
				part.Transparency = 0.4
				part.Anchored = true
			part.Color = Color3.fromRGB(111, 43, 150)
				else               
			game.Workspace.AntiVoid:Destroy()
				end
			end
		})
	end)

runcode(function()
    local HeatseekerSpeed = {["Enabled"] = false}
    HeatseekerSpeed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "Heatseeker",
        ["HoverText"] = "trash heatseeker",
        ["Function"] = function(v)
	speedlol = v
        if speedlol then
	task.wait(2.4)
	spawn(function()           
	repeat
        if (not speedlol and not onground) then return end
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
        createwarning("Ape", "boost", 10.7)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 80
	task.wait(0.07)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
	task.wait(1)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 55
	task.wait(0.05)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
	task.wait(10)
        until (not speedlol) 
            end)
        else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
      	end
      end
    })
    end)

	local Chat = {["Enabled"] = false}
	Chat = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Chat",
		["HoverText"] = "Moves the Chat",
		["Function"] = function(callback)
			if callback then
				game:GetService("StarterGui"):SetCore('ChatWindowPosition', UDim2.new(0.0, 0, 0.0, 700))
				else
				game:GetService("StarterGui"):SetCore('ChatWindowPosition', UDim2.new(0.0, 0, 0.0, 0.0))
			end
		end
	})
	
	local KillFeed = {["Enabled"] = false}
	KillFeed = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "KillFeed",
		["HoverText"] = "Destroys the KillFeed",
		["Function"] = function(callback)
			if callback then
				game:GetService("Players").LocalPlayer.PlayerGui.KillFeedGui.KillFeedContainer.Visible = false
				else
				game:GetService("Players").LocalPlayer.PlayerGui.KillFeedGui.KillFeedContainer.Visible = true
			end
		end
	})
	
	local HumanoidRootPart = {["Enabled"] = false}
	HumanoidRootPart = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "HumanoidRootPart",
		["HoverText"] = "Destroys your HumanoidRootPart",
		["Function"] = function(callback)
			if callback then
			repeat task.wait() until game:IsLoaded()
			repeat task.wait() until game:GetService("ReplicatedStorage"):FindFirstChild("Inventories"):FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChild("wood_sword");
			local plr = game.Players.LocalPlayer
					local chr = plr.Character
					local hrp = chr.HumanoidRootPart
						hrp.Parent = nil
						   chr:MoveTo(chr:GetPivot().p)
								task.wait()
								hrp.Parent = chr
				else
				createwarning("Ape", "Reset to disable", 3)
			end
		end
	})
	
	local CFrameHighJump = {["Enabled"] = false}
	CFrameHighJump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "CFrameHighJump",
		["HoverText"] = "DISABLE GRAVITY",
		["Function"] = function(v)
		verticalflylol = v
		if verticalflylol then
		Workspace.Gravity = 0
		lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, -2, 0)
		spawn(function()
					repeat
		if (not verticalflylol) then return end
		Workspace.Gravity = 0
		lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
		task.wait(0.05)
		lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
		until (not verticalflylol) 
			end)	
		else
		Workspace.Gravity = 196.2
		end
		end
	})
	
	runcode(function()
	local NameHider = {["Enabled"] = true}
	NameHider = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NameHider",
		["HoverText"] = "Disable TargetHud",
		["Function"] = function(callback)
			if callback then
			repeat task.wait() until game:IsLoaded()
	
	local fakeplr = {["Name"] = "hacker", ["UserId"] = "239702688"}
	local otherfakeplayers = {["Name"] = "retards", ["UserId"] = "1"}
	local lplr = game:GetService("Players").LocalPlayer
	
	local function plrthing(obj, property)
		for i,v in pairs(game:GetService("Players"):GetChildren()) do
			if v ~= lplr then
				obj[property] = obj[property]:gsub(v.Name, otherfakeplayers["Name"])
				obj[property] = obj[property]:gsub(v.DisplayName, otherfakeplayers["Name"])
				obj[property] = obj[property]:gsub(v.UserId, otherfakeplayers["UserId"])
			else
				obj[property] = obj[property]:gsub(v.Name, fakeplr["Name"])
				obj[property] = obj[property]:gsub(v.DisplayName, fakeplr["Name"])
				obj[property] = obj[property]:gsub(v.UserId, fakeplr["UserId"])
			end
		end
	end
	
	local function newobj(v)
		if v:IsA("TextLabel") or v:IsA("TextButton") then
			plrthing(v, "Text")
			v:GetPropertyChangedSignal("Text"):connect(function()
				plrthing(v, "Text")
			end)
		end
		if v:IsA("ImageLabel") then
			plrthing(v, "Image")
			v:GetPropertyChangedSignal("Image"):connect(function()
				plrthing(v, "Image")
			end)
		end
	end
	
	for i,v in pairs(game:GetDescendants()) do
		newobj(v)
	end
	game.DescendantAdded:connect(newobj)
		else
				createwarning("Pistonware", "Join A New Match To Reset Your Name And Other Names.", 3)
			end
		end
	})
	end)
	
	runcode(function()
	local PistonwareLongJump = {["Enabled"] = false}
	PistonwareLongJump = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Old LongJump",
		["HoverText"] = "LongJump Before Vape Christmas Update",
		["Function"] = function(callback)
			if callback then
			Workspace.Gravity = 10
			lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
				else
				Workspace.Gravity = 196.2
			end
		end
	})
	end)

local BedTP = {["Enabled"] = false}
BedTP = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
	["Name"] = "BedTP",
	["HoverText"] = "TPs To The Nearest Bed",
	["Function"] = function(callback)
		if callback then
			if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local ClosestBedMag = math.huge
				local ClosestBed = false
				local lplr = game.Players.LocalPlayer
				function GetNearestBedToPosition()
					for i,v in pairs(game.Workspace:GetChildren()) do
						if v.Name == "bed" and v:FindFirstChild("Covers") and v.Covers.BrickColor ~= game.Players.LocalPlayer.Team.TeamColor then
							if (lplr.Character.HumanoidRootPart.Position - v.Position).Magnitude < ClosestBedMag then
								ClosestBedMag = (lplr.Character.HumanoidRootPart.Position - v.Position).Magnitude
								ClosestBed = v
							end
						end
					end
					return ClosestBed
				end
				local real = GetNearestBedToPosition().Position
				game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(real) + Vector3.new(0,5,0)
				BedTP["ToggleButton"](false)
			else
				BedTP["ToggleButton"](false)
			end
		end
	end
})

	runcode(function()
		local InfiniteYield = {["Enabled"] = false}
		InfiniteYield = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			["Name"] = "Admin Commands",
			["HoverText"] = "loads the most popular admin script",
			["Function"] = function(callback)
				if callback then
					InfiniteYield["ToggleButton"](false)
					if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
						createwarning("Ape", "loaded", 2)
					else
					end
				end
			end
		})
	end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local yes = Players.LocalPlayer.Name
local ChatTag = {}
ChatTag[yes] =
    {
        TagText = "EZHub Owner",
        TagColor = Color3.new(0.7, 0, 1),
    }



    local oldchanneltab
    local oldchannelfunc
    local oldchanneltabs = {}


for i, v in pairs(getconnections(ReplicatedStorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
    if
        v.Function
        and #debug.getupvalues(v.Function) > 0
        and type(debug.getupvalues(v.Function)[1]) == "table"
        and getmetatable(debug.getupvalues(v.Function)[1])
        and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
    then
        oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
        oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
        getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
            local tab = oldchannelfunc(Self, Name)
            if tab and tab.AddMessageToChannel then
                local addmessage = tab.AddMessageToChannel
                if oldchanneltabs[tab] == nil then
                    oldchanneltabs[tab] = tab.AddMessageToChannel
                end
                tab.AddMessageToChannel = function(Self2, MessageData)
                    if MessageData.FromSpeaker and Players[MessageData.FromSpeaker] then
                        if ChatTag[Players[MessageData.FromSpeaker].Name] then
                            MessageData.ExtraData = {
                                NameColor = Players[MessageData.FromSpeaker].Team == nil and Color3.new(128,0,128)
                                    or Players[MessageData.FromSpeaker].TeamColor.Color,
                                Tags = {
                                    table.unpack(MessageData.ExtraData.Tags),
                                    {
                                        TagColor = ChatTag[Players[MessageData.FromSpeaker].Name].TagColor,
                                        TagText = ChatTag[Players[MessageData.FromSpeaker].Name].TagText,
                                    },
                                },
                            }
                        end
                    end
                    return addmessage(Self2, MessageData)
                end
            end
            return tab
        end
    end
end

runcode(function()
	local anticheat222 = {["Enabled"] = false}
	anticheat222 = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "/DIE",
		["HoverText"] = "/die real command",
		["Function"] = function(callback)
			if callback then
				wait(0.001)
				local x = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.x
local y = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.y 
local z = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.z
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x,y-10000,z)
			else
				print ("rip lol")
			end
		end 
	})
end)

	
	local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart	
	


	local lplr = game:GetService("Players").LocalPlayer
local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client


local notifications = {["Enabled"] = false}

Client:WaitFor("BedwarsBedBreak"):andThen(function(p13)
	p13:Connect(function(p14)
		if notifications["Enabled"] then
			local team = p14.brokenBedTeam.displayName
			if team == lplr.Team.Name then
				createwarning("Bed broken!", "Your bed got broken LOL", 7)
			end
		end
	end)
end)


Client:WaitFor("BedwarsBedBreak"):andThen(function(p13)
	p13:Connect(function(p14)
		if notifications["Enabled"] then
			if p14.player.Name == lplr.Name then
				createwarning("Broken bed!", "you broke a bed", 7)
			end
		end
	end)
end)

Client:WaitFor("EntityDeathEvent"):andThen(function(p13)
	p13:Connect(function(p14)
		if notifications["Enabled"] then
			if p14.player.Name == lplr.Name then
				createwarning("LOL!", "oof lol", 7)
			end
		end
	end)
end)



Client:WaitFor("EntityDeathEvent"):andThen(function(p6)
	p6:Connect(function(p7)
		if notifications["Enabled"] then
			if p7.fromEntity and p7.fromEntity == lplr.Character then
				local plr = players:GetPlayerFromCharacter(p7.entityInstance)
				createwarning("you killed", plr.Name.." ez", 7)
			end
		end
	end)
end)

local notifications = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Notifications",
	["Function"]= function(callback) notifications["Enabled"] = callback end,
	["HoverText"] = "Sends you a notification when certain actions happen (bed break,kill,ect)"
})

inffly = {["Enabled"] = false}
local testing
local partthingy
inffly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "azura fly",
	["Function"] = function(callback)
		if callback then
			lplr.Character.Archivable = true
			local clonethingy = lplr.Character:Clone()
			clonethingy.Name = "clonethingy"
			clonethingy:FindFirstChild("HumanoidRootPart").Transparency = 1
			clonethingy.Parent = workspace
			 workspace.Camera.CameraSubject = clonethingy.Humanoid
			partthingy = Instance.new("Part",workspace)
			partthingy.Size = Vector3.new(2048,1,2048)
			partthingy.CFrame = clonethingy.HumanoidRootPart.CFrame * CFrame.new(0,-4,0)
			partthingy.Anchored = true
			partthingy.Transparency = 1
			partthingy.Name = "partthingy"
			RunLoops:BindToHeartbeat("BoostSilentFly", 1, function(delta)
				clonethingy.HumanoidRootPart.CFrame = CFrame.new(entity.character.HumanoidRootPart.CFrame.X,clonethingy.HumanoidRootPart.CFrame.Y,entity.character.HumanoidRootPart.CFrame.Z)
				clonethingy.HumanoidRootPart.Rotation = entity.character.HumanoidRootPart.Rotation
			end)
			repeat
				task.wait(0.001)
				if inffly["Enabled"] == false then break end
				clonethingy.HumanoidRootPart.CFrame = CFrame.new(entity.character.HumanoidRootPart.CFrame.X,clonethingy.HumanoidRootPart.CFrame.Y,entity.character.HumanoidRootPart.CFrame.Z)
			until testing == true
					local starty
			local starttick = tick()
			task.spawn(function()
				local timesdone = 0
				if GuiLibrary["ObjectsThatCanBeSaved"]["SpeedModeDropdown"]["Api"]["Value"] == "CFrame" then
					local doboost = true
					repeat
						timesdone = timesdone + 1
						if entity.isAlive then
							local root = entity.character.HumanoidRootPart
							if starty == nil then 
								starty = root.Position.Y
							end
							if not bodyvelo then 
								bodyvelo = Instance.new("BodyVelocity")
								bodyvelo.MaxForce = vec3(0, 1000000, 0)
								bodyvelo.Parent = root
								bodyvelo.Velocity = Vector3.zero
							else
								bodyvelo.Parent = root
							end
							for i = 1, 15 do 
								task.wait(0.01)
								if (not inffly["Enabled"]) then break end
								bodyvelo.Velocity = vec3(0, i * (infflyhigh["Enabled"] and 2 or 1), 0)
							end
							if (not isnetworkowner(root)) then
								break 
							end
						else
							break
						end
					until (not inffly["Enabled"])
				else
					local warning = createwarning("inffly", "inffly is very cool", 5)
					pcall(function()
						warning:GetChildren()[5].Position = UDim2.new(0, 46, 0, 38)
					end)
				end
				if inffly["Enabled"] then 
					inffly["ToggleButton"](false)
				end
			end)
		else
			if workspace:FindFirstChild("clonethingy") or workspace:FindFirstChild("partthingy") then
				workspace:FindFirstChild("clonethingy"):Destroy()
				workspace:FindFirstChild("partthingy"):Destroy()
				RunLoops:UnbindFromHeartbeat("BoostSilentFly")
				testing = true
				workspace.Camera.CameraSubject = lplr.Character.Humanoid
			end
			if bodyvelo then 
				bodyvelo:Destroy()
				bodyvelo = nil
			end
		end
	end
})
infflyhigh = inffly.CreateToggle({
	["Name"] = "High",
	["Function"] = function() end
})

youtubedetector = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Star Detector", 
	["Function"] = function(callback)
		if callback then
			for i, plr in pairs(players:GetChildren()) do
				if plr:IsInGroup(4199740) and plr:GetRankInGroup(4199740) >= 1 then
					createwarning("Ape", "Star found! Name: " .. plr.Name .. "(" .. plr.DisplayName .. ")", 20)
					end
				end
			end
		end
})

--boat config
runcode(function()
	local randomBed = {['Enabled'] = false}
	randomBed = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		Name = 'TeleportRandomBed';
		Function = function(callback)
			if callback then
				for i,v in pairs(game:GetService('Workspace'):GetChildren()) do
					if v.Name == 'bed' and (v:FindFirstChild("Covers").BrickColor ~= lPlayer.TeamColor) then
						for i=1,5 do
							wait(0.1)
							lPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = v.Covers.CFrame * CFrame.new(1,3,-2)
						end
						break
					end
				end
				randomBed['ToggleButton'](false)
			end
		end
	})
	end)
	-- not doing vape entity bc confusing to me 
	function GetClosest()
		local plr = nil
		local radius = 21;
		for i,v in pairs(game:GetService("Players"):GetPlayers()) do
			if v ~= lPlayer and isAliveOld(v) then
				local Magnitude = (lPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
				if radius >= Magnitude then
					plr = v;
					break
				end
			end
		end
		return plr
	end
	runcode(function()
	local Closest
		local TPClosestPlayer = {['Enabled'] = false}
		TPClosestPlayer = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
			Name = 'TPClosestPlayer';
			Function = function(callback)
				if callback then
					Closest = GetClosest()
					if Closest ~= nil then 
					lPlayer.Character:FindFirstChild('HumanoidRootPart').CFrame = Closest.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0);
					createwarning('Ape', 'Wait 5 seconds to not lagback',5)
					wait(5)
					Closest = nil
					TPClosestPlayer['ToggleButton'](false)
				else
						createwarning('No Player Found', 'No Player was found close to you!', 5)
				end
			end
		end
		})
	end)

--heee
--OFFICAL APE SRC CODE
--purple Skybox
  local skybox11 = {["Enabled"] = false}
  skybox11 = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
      ["Name"] = "PurpleSkybox",
      ["Function"] = function(callback)
          if callback then
              local sky = Instance.new("Sky",game.Lighting)
              sky.MoonAngularSize = "0"
              sky.MoonTextureId = "rbxassetid://6444320592"
              sky.SkyboxBk = "rbxassetid://8107841671"
              sky.SkyboxDn = "rbxassetid://6444884785"
              sky.SkyboxFt = "rbxassetid://8107841671"
              sky.SkyboxLf = "rbxassetid://8107841671"
              sky.SkyboxRt = "rbxassetid://8107841671"
              sky.SkyboxUp = "rbxassetid://8107849791"
              sky.SunTextureId = "rbxassetid://6196665106"

          else
              local sky2 = Instance.new("Sky",game.Lighting)
              sky2.MoonAngularSize = "11"
              sky2.MoonTextureId = "rbxasset://sky/moon.jpg"
              sky2.SkyboxBk = "rbxassetid://7018684000"
              sky2.SkyboxDn = "rbxassetid://6334928194"
              sky2.SkyboxFt = "rbxassetid://7018684000"
              sky2.SkyboxLf = "rbxassetid://7018684000"
              sky2.SkyboxRt = "rbxassetid://7018684000"
              sky2.SkyboxUp = "rbxassetid://7018689553"
              sky2.SunTextureId = "rbxasset://sky/sun.jpg"
              sky2.SunAngularSize = "21"
          end
      end
  })

      --purple Ambience
  local Ambience1 = {["Enabled"] = false}
  Ambience1 = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
      ["Name"] = "PurpleAmbience",
      ["Function"] = function(callback)
          if callback then
              game.Lighting.ColorCorrection.TintColor = Color3.fromRGB(170, 170, 255)
              game.Lighting.Ambient = Color3.fromRGB(170, 170, 255)
              game.Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 255)
          else
              game.Lighting.ColorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
              game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
              game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
          end
      end
  })

--Bhop
local Bhop = {["Enabled"] = false}
Bhop = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Bhop",
	["Function"] = function(callback)
		if callback then
			getgenv().bhop = true;
			while wait(DEL) do
				if getgenv().bhop == true then
					game.Players.LocalPlayer.Character.Humanoid.Jump = true
				end
			end
		else
			getgenv().bhop = false;
		end
	end
})


DEL = Bhop.CreateSlider({
	["Name"] = "Delay",
	["Min"] = 0,
	["Max"] = 10,
	["Default"] = 2,
	["Function"] = function(val)
		DEL = val
	 end
})

  runcode(function()
	local GravityFly = {["Enabled"] = true}
	GravityFly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "GravityFly",
		["HoverText"] = "Lets you fly",
		["Function"] = function(callback)
			if callback then
				game.workspace.Gravity = 50
				game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				wait(GravityFlyTime)
				game.workspace.Gravity = GravityFlyPart
			else
				game.workspace.Gravity = 192.6
			end
		end
	})
	GravityFlyTime = GravityFly.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 0.5,
		["Max"] = 1,
		["Default"] = 1,
		["Function"] = function(val)
			GravityFlyTime = val
		end
	})
	GravityFlyPart = GravityFly.CreateSlider({
		["Name"] = "Gravity",
		["Min"] = 5,
		["Max"] = 10,
		["Default"] = 5,
		["Function"] = function(val)
			GravityFlyPart = val
		end
	})
  end)
  game.Players.LocalPlayer.character.HumanoidRootPart.Velocity = game.Players.LocalPlayer.character.HumanoidRootPart.Velocity + Vector3.new(0,35,0)
  --end of code HT76

  local plr1 = game.Players.LocalPlayer
createwarning("Ape", "Logged in as "..(plr1.Name or plr1.DisplayName), 1.2)
createwarning("Ape", "thanks for using EZHub APE", 2)


--more ape
--L bozo xv
runcode(function()
	local TPMiddle = {["Enabled"] = false}
	TPMiddle = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SkywarsMiddle",
		["HoverText"] = "Teleports You To The Middle In Skywars (no game check L)",
		["Function"] = function(callback)
			if callback then
				local TPMiddleCONNECT = game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.MatchStateEvent.OnClientEvent:Connect(function()
					game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = game:GetService("Workspace").SpectatorPlatform:FindFirstChild("floor").CFrame - Vector3.new(0,15,0)
					task.wait(.2)
					game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = game:GetService("Workspace").SpectatorPlatform:FindFirstChild("floor").CFrame - Vector3.new(0,15,0)
				end)
			else
				TPMiddleCONNECT:Disconnect()
			end
		end
	})

end)

runcode(function()
	local SizeChanger = {["Enabled"] = false}
    SizeChanger = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "SizeChanger",
		["HoverText"] = "Changes The Size Of a Item",
        ["Function"] = function(callback)
            if callback then
				RunLoops:BindToHeartbeat("SizeThing", 1, function()
					for i, v in pairs(game:GetService("Workspace").Camera.Viewmodel:GetChildren()) do
						if (v:IsA("Accessory")) then
							if v:FindFirstChild("Handle").Anchored == true then
								break
							else
								if v:FindFirstChild("Handle") then
									v.Handle.Size =  v.Handle.Size / 3
									v:FindFirstChild("Handle").Anchored = true
								end
								if v:FindFirstChild("Handle"):FindFirstChild("Neon") then
									v:FindFirstChild("Handle"):FindFirstChild("Neon"):Destroy()
								end
								if v:FindFirstChild("Handle"):FindFirstChild("gem") then
									v:FindFirstChild("Handle"):FindFirstChild("gem"):Destroy()
								end
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("SizeThing")
				createwarning("Ape", "Disabled Next Time You Die", 3)
			end
		end
	})
end)

runcode(function()
	local HypixelFly = {["Enabled"] = false}
    HypixelFly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "HypixelFly",
		["HoverText"] = "A Fly",
        ["Function"] = function(callback)
            if callback then
				if entity.isAlive then
					local OriginalPosX = game.Players.LocalPlayer.character.HumanoidRootPart.Position.y
					if game.Players.LocalPlayer.character.HumanoidRootPart.Position.y == OriginalPosX then
						game.workspace.Gravity = 0
						local TS = game:GetService("TweenService")
						for i = 1, 3 do
							task.wait()
							local Prim = game.Players.LocalPlayer.Character.PrimaryPart.CFrame
							local tween = TS:Create(game.Players.LocalPlayer.Character.PrimaryPart, TweenInfo.new(0.5), {CFrame = Prim + Prim.lookVector * 10})
							tween:play()
							tween.Completed:Wait()
						end
						repeat
							task.wait()
							local mag = workspace:Raycast(entity.character.HumanoidRootPart.Position, Vector3.new(0, -32, 0), blockraycast)
							if mag then
								if HypixelFly["Enabled"] then
									HypixelFly["ToggleButton"](false)
								end
							end
						until (not HypixelFly["Enabled"])
					end
				end
			else
				game.workspace.Gravity = 192.6
			end
		end
	})
end)


runcode(function()
	local VelocityHighJump = {["Enabled"] = true}
    VelocityHighJump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "BetterFly",
		["HoverText"] = "For Short Distances [20 Blocks]",
        ["Function"] = function(callback)
            if callback then
				if YlevelTeller["Enabled"] then
					local Ylevel = Instance.new("TextLabel")
                    Ylevel.Name = "Ylevel"
                    Ylevel.Parent = game.CoreGui.RobloxGui
                    Ylevel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Ylevel.BackgroundTransparency = 1.000
                    Ylevel.Position = UDim2.new(0.885590136, 0, 0.916458845, 0)
                    Ylevel.Size = UDim2.new(0, 200, 0, 50)
                    Ylevel.Font = Enum.Font.SourceSans
                    Ylevel.Text = "Ylevel  = 1"
                    Ylevel.TextColor3 = Color3.fromRGB(0, 0, 0)
                    Ylevel.TextSize = 28.000
					spawn(function()
						repeat
							local YlevelThingy = game.Players.LocalPlayer.Character.HumanoidRootPart.Position.y
							YlevelThingy = math.floor(YlevelThingy)
							task.wait(0.1)
							Ylevel.Text = "Ylevel = "..YlevelThingy
						until Ylevel.Text == nil
					end)
				end
				local OriginalPosX = game.Players.LocalPlayer.character.HumanoidRootPart.Position.y 
                local CameraPart = Instance.new("Part", game.workspace)
				CameraPart.Size = Vector3.new(1,1,1)
                CameraPart.Anchored = true
                CameraPart.Transparency = 1
                CameraPart.CanCollide = false
                CameraPart.Name = "CameraPart"
				cam.CameraSubject = game.workspace.CameraPart
				RunLoops:BindToHeartbeat("HumanoidToCamera", 1, function()
					local Pos = game.Players.LocalPlayer.character.HumanoidRootPart.Position
					CameraPart.Position = Vector3.new(Pos.x, OriginalPosX, Pos.z)
				end)
				if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					iea2 = 0
					while iea2 <= VelocityHighJumpAmmount do
						iea2 = iea2 + 1
						game.Players.LocalPlayer.character.HumanoidRootPart.Velocity = game.Players.LocalPlayer.character.HumanoidRootPart.Velocity + Vector3.new(0,30,0)
					end
					wait(5)
					for i , v in pairs(game.CoreGui.RobloxGui:GetChildren()) do
						if v.Name == "Ylevel" then
							game.CoreGui.RobloxGui.Ylevel:Destroy()
						else
							print("no")
						end
					end
					VelocityHighJump["ToggleButton"](false)
					iea2 = iea2 + 10
					if iea2 > VelocityHighJumpAmmount then
						createwarning("Ape", "Please Do Not PressKeys", 3)
						RunLoops:UnbindFromHeartbeat("HumanoidToCamera")
						task.wait(1.7)
						cam.CameraSubject = game.Players.LocalPlayer.character.Humanoid
						game.workspace.CameraPart:Destroy()
					end

				else
					VelocityHighJump["ToggleButton"](false)
				end
			end
		end
	})

	
	VelocityHighJumpAmmount = VelocityHighJump.CreateSlider({
		["Name"] = "Amount",
		["Min"] = 5,
		["Max"] = 20,
		["Default"] = 20,
		["Function"] = function(val)
			VelocityHighJumpAmmount = val
		end
	})

	YlevelTeller = VelocityHighJump.CreateToggle({
		["Name"] = "Ylevel",
		["Function"] = function() end, 
		["Default"] = true,
		["HoverText"] = "Ylevel"
	})

end)
