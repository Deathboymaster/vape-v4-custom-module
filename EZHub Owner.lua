loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/"..readfile("vape/commithash.txt").."/CustomModules/6872274481.lua", true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/0primeSkidsALot/vape-plus-plus/main/script/keystrokes"))()
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local repstorage = game:GetService("ReplicatedStorage")
local tweenservice = game:GetService("TweenService")
local lplr = players.LocalPlayer
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local vec3 = Vector3.new
local cfnew = CFrame.new
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	cam = (workspace.CurrentCamera or workspace:FindFirstChild("Camera") or Instance.new("Camera"))
end)
local targetinfo = shared.VapeTargetInfo
local collectionservice = game:GetService("CollectionService")
local uis = game:GetService("UserInputService")
local mouse = lplr:GetMouse()
local bedwars = {}
local bedwarsblocks = {}
local blockraycast = RaycastParams.new()
blockraycast.FilterType = Enum.RaycastFilterType.Whitelist
local getfunctions
local oldchar
local oldcloneroot
local matchState = 0
local kit = ""
local lagbackevent = Instance.new("BindableEvent")
local textchatservice = game:GetService("TextChatService")
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
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local storedshahashes = {}
local blocktable
local inventories = {}
local currentinventory = {
	inventory = {
		items = {},
		armor = {},
		hand = nil
	}
}
local currenthand = {}
local queueType = "bedwars_test"
local oldchanneltab
local oldchannelfunc
local oldchanneltabs = {}
local connectionstodisconnect = {}
local tpstring
local networkownertick = tick()
local isnetworkowner = isnetworkowner or function(part)
	if gethiddenproperty(part, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual then 
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownertick = tick() + 8
	end
	return networkownertick <= tick()
end
local uninjectflag = false
local clients = {
	ChatStrings1 = {
		["KVOP25KYFPPP4"] = "vape"
	},
	ChatStrings2 = {
		["vape"] = "KVOP25KYFPPP4"
	},
	ClientUsers = {}
}
local entityLibrary = shared.vapeentity
local WhitelistFunctions = shared.vapewhitelist

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


local function LaunchAngle(v: number, g: number, d: number, h: number, higherArc: boolean)
	local v2 = v * v
	local v4 = v2 * v2
	local root = math.sqrt(v4 - g*(g*d*d + 2*h*v2))
	if not higherArc then root = -root end
	return math.atan((v2 + root) / (g * d))
end

local function LaunchDirection(start, target, v, g, higherArc: boolean)
	-- get the direction flattened:
	local horizontal = Vector3.new(target.X - start.X, 0, target.Z - start.Z)
	
	local h = target.Y - start.Y
	local d = horizontal.Magnitude
	local a = LaunchAngle(v, g, d, h, higherArc)
	
	-- NaN ~= NaN, computation couldn't be done (e.g. because it's too far to launch)
	if a ~= a then 
		return g == 0 and (target - start).Unit * v
	end
	
	-- speed if we were just launching at a flat angle:
	local vec = horizontal.Unit * v
	
	-- rotate around the axis perpendicular to that direction...
	local rotAxis = Vector3.new(-horizontal.Z, 0, horizontal.X)
	
	-- ...by the angle amount
	return CFrame.fromAxisAngle(rotAxis, a) * vec
end

local function predictGravity(pos, vel, mag, targetPart, Gravity)
	local newVelocity = vel.Y
	local rootSize = (targetPart.Humanoid.HipHeight + (targetPart.RootPart.Size.Y / 2))
	local check = (tick() - targetPart.JumpTick) < 0.2
	for i = 1, math.floor(mag / 0.016) do 
		if check then 
			newVelocity = newVelocity - (Gravity * 0.016)
		else
			newVelocity = 0
		end
		local floorDetection = workspace:Raycast(pos, Vector3.new(vel.X * 0.016, (newVelocity * 0.016) - rootSize, vel.Z * 0.016), blockraycast)
		if floorDetection then 
			pos = Vector3.new(pos.X, floorDetection.Position.Y + rootSize, pos.Z)
			newVelocity = targetPart.Jumping and targetPart.Humanoid.JumpPower or 0
		end
		pos = pos + Vector3.new(vel.X * 0.016, newVelocity * 0.016, vel.Z * 0.016)
	end
	return pos, Vector3.new(0, 0, 0)
end

local function replaceYLevel(cframe, newylevel)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x, newylevel, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function FindLeadShot(targetPosition: Vector3, targetVelocity: Vector3, projectileSpeed: Number, shooterPosition: Vector3, shooterVelocity: Vector3, gravity: Number)
	local distance = (targetPosition - shooterPosition).Magnitude

	local p = targetPosition - shooterPosition
	local v = targetVelocity - shooterVelocity
	local a = Vector3.zero

	local timeTaken = (distance / projectileSpeed)
	
	if gravity > 0 then
		local timeTaken = projectileSpeed/gravity+math.sqrt(2*distance/gravity+projectileSpeed^2/gravity^2)
	end

	local goalX = targetPosition.X + v.X*timeTaken + 0.5 * a.X * timeTaken^2
	local goalY = targetPosition.Y + v.Y*timeTaken + 0.5 * a.Y * timeTaken^2
	local goalZ = targetPosition.Z + v.Z*timeTaken + 0.5 * a.Z * timeTaken^2
	
	return vec3(goalX, goalY, goalZ)
end

local function warningNotification(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local function runcode(func)
	func()
end

runcode(function()
	local textlabel = Instance.new("TextLabel")
	textlabel.Size = UDim2.new(1, 0, 0, 36)
	textlabel.Text = "Moderators can ban you at any time, Always use alts."
	textlabel.BackgroundTransparency = 1
	textlabel.ZIndex = 10
	textlabel.TextStrokeTransparency = 0
	textlabel.TextScaled = true
	textlabel.Font = Enum.Font.SourceSans
	textlabel.TextColor3 = Color3.new(1, 1, 1)
	textlabel.Position = UDim2.new(0, 0, 0, -36)
	textlabel.Parent = GuiLibrary["MainGui"].ScaledGui.ClickGui
	task.spawn(function()
		repeat task.wait() until matchState ~= 0
		textlabel:Destroy()
	end)
end)

local cachedassets = {}
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
			textlabel:Destroy()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	if cachedassets[path] == nil then
		cachedassets[path] = getasset(path) 
	end
	return cachedassets[path]
end

local function CreateAutoHotbarGUI(children2, argstable)
	local buttonapi = {}
	buttonapi["Hotbars"] = {}
	buttonapi["CurrentlySelected"] = 1
	local currentanim
	local amount = #children2:GetChildren()
	local sortableitems = {
		{itemType = "swords", itemDisplayType = "diamond_sword"},
		{itemType = "pickaxes", itemDisplayType = "diamond_pickaxe"},
		{itemType = "axes", itemDisplayType = "diamond_axe"},
		{itemType = "shears", itemDisplayType = "shears"},
		{itemType = "wool", itemDisplayType = "wool_white"},
		{itemType = "iron", itemDisplayType = "iron"},
		{itemType = "diamond", itemDisplayType = "diamond"},
		{itemType = "emerald", itemDisplayType = "emerald"},
		{itemType = "bows", itemDisplayType = "wood_bow"},
	}
	local items = bedwars.ItemTable
	if items then
		for i2,v2 in pairs(items) do
			if (i2:find("axe") == nil or i2:find("void")) and i2:find("bow") == nil and i2:find("shears") == nil and i2:find("wool") == nil and v2.sword == nil and v2.armor == nil and v2["dontGiveItem"] == nil and bedwars.ItemTable[i2] and bedwars.ItemTable[i2].image then
				table.insert(sortableitems, {itemType = i2, itemDisplayType = i2})
			end
		end
	end
	local buttontext = Instance.new("TextButton")
	buttontext.AutoButtonColor = false
	buttontext.BackgroundTransparency = 1
	buttontext.Name = "ButtonText"
	buttontext.Text = ""
	buttontext.Name = argstable["Name"]
	buttontext.LayoutOrder = 1
	buttontext.Size = UDim2.new(1, 0, 0, 40)
	buttontext.Active = false
	buttontext.TextColor3 = Color3.fromRGB(162, 162, 162)
	buttontext.TextSize = 17
	buttontext.Font = Enum.Font.SourceSans
	buttontext.Position = UDim2.new(0, 0, 0, 0)
	buttontext.Parent = children2
	local toggleframe2 = Instance.new("Frame")
	toggleframe2.Size = UDim2.new(0, 200, 0, 31)
	toggleframe2.Position = UDim2.new(0, 10, 0, 4)
	toggleframe2.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
	toggleframe2.Name = "ToggleFrame2"
	toggleframe2.Parent = buttontext
	local toggleframe1 = Instance.new("Frame")
	toggleframe1.Size = UDim2.new(0, 198, 0, 29)
	toggleframe1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	toggleframe1.BorderSizePixel = 0
	toggleframe1.Name = "ToggleFrame1"
	toggleframe1.Position = UDim2.new(0, 1, 0, 1)
	toggleframe1.Parent = toggleframe2
	local addbutton = Instance.new("ImageLabel")
	addbutton.BackgroundTransparency = 1
	addbutton.Name = "AddButton"
	addbutton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	addbutton.Position = UDim2.new(0, 93, 0, 9)
	addbutton.Size = UDim2.new(0, 12, 0, 12)
	addbutton.ImageColor3 = Color3.fromRGB(5, 133, 104)
	addbutton.Image = getcustomassetfunc("vape/assets/AddItem.png")
	addbutton.Parent = toggleframe1
	local children3 = Instance.new("Frame")
	children3.Name = argstable["Name"].."Children"
	children3.BackgroundTransparency = 1
	children3.LayoutOrder = amount
	children3.Size = UDim2.new(0, 220, 0, 0)
	children3.Parent = children2
	local uilistlayout = Instance.new("UIListLayout")
	uilistlayout.Parent = children3
	uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		children3.Size = UDim2.new(1, 0, 0, uilistlayout.AbsoluteContentSize.Y)
	end)
	local uicorner = Instance.new("UICorner")
	uicorner.CornerRadius = UDim.new(0, 5)
	uicorner.Parent = toggleframe1
	local uicorner2 = Instance.new("UICorner")
	uicorner2.CornerRadius = UDim.new(0, 5)
	uicorner2.Parent = toggleframe2
	buttontext.MouseEnter:Connect(function()
		tweenservice:Create(toggleframe2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(79, 78, 79)}):Play()
	end)
	buttontext.MouseLeave:Connect(function()
		tweenservice:Create(toggleframe2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(38, 37, 38)}):Play()
	end)
	local ItemListBigFrame = Instance.new("Frame")
	ItemListBigFrame.Size = UDim2.new(1, 0, 1, 0)
	ItemListBigFrame.Name = "ItemList"
	ItemListBigFrame.BackgroundTransparency = 1
	ItemListBigFrame.Visible = false
	ItemListBigFrame.Parent = GuiLibrary["MainGui"]
	local ItemListFrame = Instance.new("Frame")
	ItemListFrame.Size = UDim2.new(0, 660, 0, 445)
	ItemListFrame.Position = UDim2.new(0.5, -330, 0.5, -223)
	ItemListFrame.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	ItemListFrame.Parent = ItemListBigFrame
	local ItemListExitButton = Instance.new("ImageButton")
	ItemListExitButton.Name = "ItemListExitButton"
	ItemListExitButton.ImageColor3 = Color3.fromRGB(121, 121, 121)
	ItemListExitButton.Size = UDim2.new(0, 24, 0, 24)
	ItemListExitButton.AutoButtonColor = false
	ItemListExitButton.Image = getcustomassetfunc("vape/assets/ExitIcon1.png")
	ItemListExitButton.Visible = true
	ItemListExitButton.Position = UDim2.new(1, -31, 0, 8)
	ItemListExitButton.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	ItemListExitButton.Parent = ItemListFrame
	local ItemListExitButtonround = Instance.new("UICorner")
	ItemListExitButtonround.CornerRadius = UDim.new(0, 16)
	ItemListExitButtonround.Parent = ItemListExitButton
	ItemListExitButton.MouseEnter:Connect(function()
		tweenservice:Create(ItemListExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	ItemListExitButton.MouseLeave:Connect(function()
		tweenservice:Create(ItemListExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26), ImageColor3 = Color3.fromRGB(121, 121, 121)}):Play()
	end)
	ItemListExitButton.MouseButton1Click:Connect(function()
		ItemListBigFrame.Visible = false
		GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = true
	end)
	local ItemListFrameShadow = Instance.new("ImageLabel")
	ItemListFrameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	ItemListFrameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	ItemListFrameShadow.Image = getcustomassetfunc("vape/assets/WindowBlur.png")
	ItemListFrameShadow.BackgroundTransparency = 1
	ItemListFrameShadow.ZIndex = -1
	ItemListFrameShadow.Size = UDim2.new(1, 6, 1, 6)
	ItemListFrameShadow.ImageColor3 = Color3.new(0, 0, 0)
	ItemListFrameShadow.ScaleType = Enum.ScaleType.Slice
	ItemListFrameShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	ItemListFrameShadow.Parent = ItemListFrame
	local ItemListFrameText = Instance.new("TextLabel")
	ItemListFrameText.Size = UDim2.new(1, 0, 0, 41)
	ItemListFrameText.BackgroundTransparency = 1
	ItemListFrameText.Name = "WindowTitle"
	ItemListFrameText.Position = UDim2.new(0, 0, 0, 0)
	ItemListFrameText.TextXAlignment = Enum.TextXAlignment.Left
	ItemListFrameText.Font = Enum.Font.SourceSans
	ItemListFrameText.TextSize = 17
	ItemListFrameText.Text = "    New AutoHotbar"
	ItemListFrameText.TextColor3 = Color3.fromRGB(201, 201, 201)
	ItemListFrameText.Parent = ItemListFrame
	local ItemListBorder1 = Instance.new("Frame")
	ItemListBorder1.BackgroundColor3 = Color3.fromRGB(40, 39, 40)
	ItemListBorder1.BorderSizePixel = 0
	ItemListBorder1.Size = UDim2.new(1, 0, 0, 1)
	ItemListBorder1.Position = UDim2.new(0, 0, 0, 41)
	ItemListBorder1.Parent = ItemListFrame
	local ItemListFrameCorner = Instance.new("UICorner")
	ItemListFrameCorner.CornerRadius = UDim.new(0, 4)
	ItemListFrameCorner.Parent = ItemListFrame
	local ItemListFrame1 = Instance.new("Frame")
	ItemListFrame1.Size = UDim2.new(0, 112, 0, 113)
	ItemListFrame1.Position = UDim2.new(0, 10, 0, 71)
	ItemListFrame1.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
	ItemListFrame1.Name = "ItemListFrame1"
	ItemListFrame1.Parent = ItemListFrame
	local ItemListFrame2 = Instance.new("Frame")
	ItemListFrame2.Size = UDim2.new(0, 110, 0, 111)
	ItemListFrame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ItemListFrame2.BorderSizePixel = 0
	ItemListFrame2.Name = "ItemListFrame2"
	ItemListFrame2.Position = UDim2.new(0, 1, 0, 1)
	ItemListFrame2.Parent = ItemListFrame1
	local ItemListFramePicker = Instance.new("ScrollingFrame")
	ItemListFramePicker.Size = UDim2.new(0, 495, 0, 220)
	ItemListFramePicker.Position = UDim2.new(0, 144, 0, 122)
	ItemListFramePicker.BorderSizePixel = 0
	ItemListFramePicker.ScrollBarThickness = 3
	ItemListFramePicker.ScrollBarImageTransparency = 0.8
	ItemListFramePicker.VerticalScrollBarInset = Enum.ScrollBarInset.None
	ItemListFramePicker.BackgroundTransparency = 1
	ItemListFramePicker.Parent = ItemListFrame
	local ItemListFramePickerGrid = Instance.new("UIGridLayout")
	ItemListFramePickerGrid.CellPadding = UDim2.new(0, 4, 0, 3)
	ItemListFramePickerGrid.CellSize = UDim2.new(0, 51, 0, 52)
	ItemListFramePickerGrid.Parent = ItemListFramePicker
	ItemListFramePickerGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ItemListFramePicker.CanvasSize = UDim2.new(0, 0, 0, ItemListFramePickerGrid.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
	end)
	local ItemListcorner = Instance.new("UICorner")
	ItemListcorner.CornerRadius = UDim.new(0, 5)
	ItemListcorner.Parent = ItemListFrame1
	local ItemListcorner2 = Instance.new("UICorner")
	ItemListcorner2.CornerRadius = UDim.new(0, 5)
	ItemListcorner2.Parent = ItemListFrame2
	local selectedslot = 1
	local hoveredslot = 0
	
	local refreshslots
	local refreshList
	refreshslots = function()
		local startnum = 144
		local oldhovered = hoveredslot
		for i2,v2 in pairs(ItemListFrame:GetChildren()) do
			if v2.Name:find("ItemSlot") then
				v2:Remove()
			end
		end
		for i3,v3 in pairs(ItemListFramePicker:GetChildren()) do
			if v3:IsA("TextButton") then
				v3:Remove()
			end
		end
		for i4,v4 in pairs(sortableitems) do
			local ItemFrame = Instance.new("TextButton")
			ItemFrame.Text = ""
			ItemFrame.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
			ItemFrame.Parent = ItemListFramePicker
			ItemFrame.AutoButtonColor = false
			local ItemFrameIcon = Instance.new("ImageLabel")
			ItemFrameIcon.Size = UDim2.new(0, 32, 0, 32)
			ItemFrameIcon.Image = bedwars.getIcon({itemType = v4.itemDisplayType}, true) 
			ItemFrameIcon.ResampleMode = (bedwars.getIcon({itemType = v4.itemDisplayType}, true):find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			ItemFrameIcon.Position = UDim2.new(0, 10, 0, 10)
			ItemFrameIcon.BackgroundTransparency = 1
			ItemFrameIcon.Parent = ItemFrame
			local ItemFramecorner = Instance.new("UICorner")
			ItemFramecorner.CornerRadius = UDim.new(0, 5)
			ItemFramecorner.Parent = ItemFrame
			ItemFrame.MouseButton1Click:Connect(function()
				for i5,v5 in pairs(buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"]) do
					if v5.itemType == v4.itemType then
						buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i5)] = nil
					end
				end
				buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(selectedslot)] = v4
				refreshslots()
				refreshList()
			end)
		end
		for i = 1, 9 do
			local item = buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i)]
			local ItemListFrame3 = Instance.new("Frame")
			ItemListFrame3.Size = UDim2.new(0, 55, 0, 56)
			ItemListFrame3.Position = UDim2.new(0, startnum - 2, 0, 380)
			ItemListFrame3.BackgroundTransparency = (selectedslot == i and 0 or 1)
			ItemListFrame3.BackgroundColor3 = Color3.fromRGB(35, 34, 35)
			ItemListFrame3.Name = "ItemSlot"
			ItemListFrame3.Parent = ItemListFrame
			local ItemListFrame4 = Instance.new("TextButton")
			ItemListFrame4.Size = UDim2.new(0, 51, 0, 52)
			ItemListFrame4.BackgroundColor3 = (oldhovered == i and Color3.fromRGB(31, 30, 31) or Color3.fromRGB(20, 20, 20))
			ItemListFrame4.BorderSizePixel = 0
			ItemListFrame4.AutoButtonColor = false
			ItemListFrame4.Text = ""
			ItemListFrame4.Name = "ItemListFrame4"
			ItemListFrame4.Position = UDim2.new(0, 2, 0, 2)
			ItemListFrame4.Parent = ItemListFrame3
			local ItemListImage = Instance.new("ImageLabel")
			ItemListImage.Size = UDim2.new(0, 32, 0, 32)
			ItemListImage.BackgroundTransparency = 1
			local img = (item and bedwars.getIcon({itemType = item.itemDisplayType}, true) or "")
			ItemListImage.Image = img
			ItemListImage.ResampleMode = (img:find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			ItemListImage.Position = UDim2.new(0, 10, 0, 10)
			ItemListImage.Parent = ItemListFrame4
			local ItemListcorner3 = Instance.new("UICorner")
			ItemListcorner3.CornerRadius = UDim.new(0, 5)
			ItemListcorner3.Parent = ItemListFrame3
			local ItemListcorner4 = Instance.new("UICorner")
			ItemListcorner4.CornerRadius = UDim.new(0, 5)
			ItemListcorner4.Parent = ItemListFrame4
			ItemListFrame4.MouseEnter:Connect(function()
				ItemListFrame4.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
				hoveredslot = i
			end)
			ItemListFrame4.MouseLeave:Connect(function()
				ItemListFrame4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				hoveredslot = 0
			end)
			ItemListFrame4.MouseButton1Click:Connect(function()
				selectedslot = i
				refreshslots()
			end)
			ItemListFrame4.MouseButton2Click:Connect(function()
				buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i)] = nil
				refreshslots()
				refreshList()
			end)
			startnum = startnum + 55
		end
	end	

	local function createHotbarButton(num, items)
		num = tonumber(num) or #buttonapi["Hotbars"] + 1
		local hotbarbutton = Instance.new("TextButton")
		hotbarbutton.Size = UDim2.new(1, 0, 0, 30)
		hotbarbutton.BackgroundTransparency = 1
		hotbarbutton.LayoutOrder = num
		hotbarbutton.AutoButtonColor = false
		hotbarbutton.Text = ""
		hotbarbutton.Parent = children3
		buttonapi["Hotbars"][num] = {["Items"] = items or {}, Object = hotbarbutton, ["Number"] = num}
		local hotbarframe = Instance.new("Frame")
		hotbarframe.BackgroundColor3 = (num == buttonapi["CurrentlySelected"] and Color3.fromRGB(54, 53, 54) or Color3.fromRGB(31, 30, 31))
		hotbarframe.Size = UDim2.new(0, 200, 0, 27)
		hotbarframe.Position = UDim2.new(0, 10, 0, 1)
		hotbarframe.Parent = hotbarbutton
		local uicorner3 = Instance.new("UICorner")
		uicorner3.CornerRadius = UDim.new(0, 5)
		uicorner3.Parent = hotbarframe
		local startpos = 11
		for i = 1, 9 do
			local item = buttonapi["Hotbars"][num]["Items"][tostring(i)]
			local hotbarbox = Instance.new("ImageLabel")
			hotbarbox.Name = i
			hotbarbox.Size = UDim2.new(0, 17, 0, 18)
			hotbarbox.Position = UDim2.new(0, startpos, 0, 5)
			hotbarbox.BorderSizePixel = 0
			hotbarbox.Image = (item and bedwars.getIcon({itemType = item.itemDisplayType}, true) or "")
			hotbarbox.ResampleMode = ((item and bedwars.getIcon({itemType = item.itemDisplayType}, true) or ""):find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			hotbarbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			hotbarbox.Parent = hotbarframe
			startpos = startpos + 18
		end
		hotbarbutton.MouseButton1Click:Connect(function()
			if buttonapi["CurrentlySelected"] == num then
				ItemListBigFrame.Visible = true
				GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = false
				refreshslots()
			end
			buttonapi["CurrentlySelected"] = num
			refreshList()
		end)
		hotbarbutton.MouseButton2Click:Connect(function()
			if buttonapi["CurrentlySelected"] == num then
				buttonapi["CurrentlySelected"] = (num == 2 and 0 or 1)
			end
			table.remove(buttonapi["Hotbars"], num)
			refreshList()
		end)
	end

	refreshList = function()
		local newnum = 0
		local newtab = {}
		for i3,v3 in pairs(buttonapi["Hotbars"]) do
			newnum = newnum + 1
			newtab[newnum] = v3
		end
		buttonapi["Hotbars"] = newtab
		for i,v in pairs(children3:GetChildren()) do
			if v:IsA("TextButton") then
				v:Remove()
			end
		end
		for i2,v2 in pairs(buttonapi["Hotbars"]) do
			createHotbarButton(i2, v2["Items"])
		end
		GuiLibrary["Settings"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["CurrentlySelected"] = buttonapi["CurrentlySelected"]}
	end
	buttonapi["RefreshList"] = refreshList

	buttontext.MouseButton1Click:Connect(function()
		createHotbarButton()
	end)

	GuiLibrary["Settings"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["CurrentlySelected"] = buttonapi["CurrentlySelected"]}
	GuiLibrary.ObjectsThatCanBeSaved[children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["Api"] = buttonapi, Object = buttontext}

	return buttonapi
end

GuiLibrary.LoadSettingsEvent.Event:Connect(function(res)
	for i,v in pairs(res) do
		local obj = GuiLibrary.ObjectsThatCanBeSaved[i]
		if obj and v["Type"] == "ItemList" and obj.Api then
			obj["Api"]["Hotbars"] = v["Items"]
			obj["Api"]["CurrentlySelected"] = v["CurrentlySelected"]
			obj["Api"]["RefreshList"]()
		end
	end
end)

local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local function getItemNear(itemName, inv)
	for i5, v5 in pairs(inv or currentinventory.inventory.items) do
		if v5.itemType:find(itemName) then
			return v5, i5
		end
	end
	return nil
end

local function getItem(itemName, inv)
	for i5, v5 in pairs(inv or currentinventory.inventory.items) do
		if v5.itemType == itemName then
			return v5, i5
		end
	end
	return nil
end

local function getHotbarSlot(itemName)
	for i5, v5 in pairs(currentinventory.hotbar) do
		if v5["item"] and v5["item"].itemType == itemName then
			return i5 - 1
		end
	end
	return nil
end

local function getSword()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if bedwars.ItemTable[v5.itemType]["sword"] then
			local swordrank = bedwars.ItemTable[v5.itemType]["sword"]["damage"] or 0
			if swordrank > bestswordnum then
				bestswordnum = swordrank
				bestswordslot = i5
				bestsword = v5
			end
		end
	end
	return bestsword, bestswordslot
end

local function getBlock()
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if bedwars.ItemTable[v5.itemType]["block"] then
			return v5.itemType, v5.amount
		end
	end
	return
end

local function getSlotFromItem(item)
	for i,v in pairs(currentinventory.inventory.items) do
		if v.itemType == item.itemType then
			return i
		end
	end
	return nil
end

local function getShield(char)
	local shield = 0
	for i,v in pairs(char:GetAttributes()) do 
		if i:find("Shield") and type(v) == "number" then 
			shield = shield + v
		end
	end
	return shield
end

local function getAxe()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if v5.itemType:find("axe") and v5.itemType:find("pickaxe") == nil and v5.itemType:find("void") == nil then
			bestswordnum = swordrank
			bestswordslot = i5
			bestsword = v5
		end
	end
	return bestsword, bestswordslot
end

local function getPickaxe()
	return getItemNear("pick")
end

local function getBaguette()
	return getItemNear("baguette")
end

local function getwool()
	local wool = getItemNear("wool")
	return wool and wool.itemType, wool and wool.amount
end

local function isAliveOld(plr, alivecheck)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return entityLibrary.isAlive
end

local function isAlive(plr, alivecheck)
	if plr then
		local ind, tab = entityLibrary.getEntityFromPlayer(plr)
		return ((not alivecheck) or tab and tab.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead) and tab
	end
	return entityLibrary.isAlive
end

local function hashvec(vec)
	return {
		["value"] = vec
	}
end

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end

local function betterfind(tab, obj)
	for i,v in pairs(tab) do
		if v == obj or type(v) == "table" and v.hash == obj then
			return v
		end
	end
	return nil
end

local function randomString()
	local randomlength = math.random(10,100)
	local array = {}

	for i = 1, randomlength do
		array[i] = string.char(math.random(32, 126))
	end

	return table.concat(array)
end

local function getWhitelistedBed(bed)
	for i,v in pairs(players:GetPlayers()) do
		if v:GetAttribute("Team") and bed and bed:GetAttribute("Team"..v:GetAttribute("Team").."NoBreak") and WhitelistFunctions:CheckWhitelisted(v) then
			return true
		end
	end
	return false
end

local OldClientGet 
local oldbreakremote
local oldbob
local oldzephyr
local zephyrorbs = 0
local globalgroundtouchedtime = tick()
local jumptable = {}
runcode(function()
    getfunctions = function()
		local Flamework = require(repstorage["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
        local KnitGotten, KnitClient
		repeat
			task.wait()
			KnitGotten, KnitClient = pcall(function()
				return debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
			end)
		until KnitGotten
		repeat task.wait() until debug.getupvalue(KnitClient.Start, 1) == true
        local Client = require(repstorage.TS.remotes).default.Client
        local InventoryUtil = require(repstorage.TS.inventory["inventory-util"]).InventoryUtil
        OldClientGet = getmetatable(Client).Get
        getmetatable(Client).Get = function(Self, remotename)
			if uninjectflag then return OldClientGet(Self, remotename) end
			local res = OldClientGet(Self, remotename)
			if remotename == "DamageBlock" then
				return {
					["CallServerAsync"] = function(Self, tab)
						local block = bedwars.BlockController:getStore():getBlockAt(tab.blockRef.blockPosition)
						if block and block.Name == "bed" then
							if getWhitelistedBed(block) then
								return {andThen = function(self, func) 
									func("failed")
								end}
							end
						end
						return res:CallServerAsync(tab)
					end,
					["CallServer"] = function(Self, tab)
						local block = bedwars.BlockController:getStore():getBlockAt(tab.blockRef.blockPosition)
						if block and block.Name == "bed" then
							if getWhitelistedBed(block) then
								return {andThen = function(self, func) 
									func("failed")
								end}
							end
						end
						return res:CallServer(tab)
					end
				}
			elseif remotename == bedwars.AttackRemote then
				return {
					["instance"] = res["instance"],
					["SendToServer"] = function(Self, tab)
						local suc, plr = pcall(function() return players:GetPlayerFromCharacter(tab.entityInstance) end)
						if suc and plr then
							local playertype, playerattackable = WhitelistFunctions:CheckPlayerType(plr)
							if not playerattackable then 
								return nil
							end
							if Reach.Enabled then
								local selfcheck = entityLibrary.LocalPosition or tab.validate.selfPosition.value
								if (selfcheck - (entityLibrary.OtherPosition[plr] or tab.validate.targetPosition.value)).Magnitude > 18 then return res:SendToServer(tab) end
								local mag = (tab.validate.selfPosition.value - tab.validate.targetPosition.value).magnitude
								local newres = hashvec(tab.validate.selfPosition.value + (mag > 14.4 and (CFrame.lookAt(tab.validate.selfPosition.value, tab.validate.targetPosition.value).lookVector * 4) or Vector3.zero))
								tab.validate.selfPosition = newres
							end
						end
						return res:SendToServer(tab)
					end
				}
			end
            return res
        end
		bedwars = {
			AnimationType = require(repstorage.TS.animation["animation-type"]).AnimationType,
			AnimationUtil = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].util["animation-util"]).AnimationUtil,
			AppController = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController,
			AbilityController = Flamework.resolveDependency("@easy-games/game-core:client/controllers/ability/ability-controller@AbilityController"),
			AttackRemote = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.SwordController)["attackEntity"])),
			BalloonController = KnitClient.Controllers.BalloonController,
			BalanceFile = require(repstorage.TS.balance["balance-file"]).BalanceFile,
			BatteryEffectController = KnitClient.Controllers.BatteryEffectsController,
			BatteryRemote = getremote(debug.getconstants(debug.getproto(debug.getproto(KnitClient.Controllers.BatteryController.KnitStart, 1), 1))),
			BlockBreaker = KnitClient.Controllers.BlockBreakController.blockBreaker,
			BlockController = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out).BlockEngine,
			BlockPlacer = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]).BlockPlacer,
			BlockEngine = require(lplr.PlayerScripts.TS.lib["block-engine"]["client-block-engine"]).ClientBlockEngine,
			BlockEngineClientEvents = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client["block-engine-client-events"]).BlockEngineClientEvents,
			BlockPlacementController = KnitClient.Controllers.BlockPlacementController,
			BowConstantsTable = debug.getupvalue(KnitClient.Controllers.ProjectileController.enableBeam, 5),
			ProjectileController = KnitClient.Controllers.ProjectileController,
			ChestController = KnitClient.Controllers.ChestController,
			CannonHandController = KnitClient.Controllers.CannonHandController,
			CannonAimRemote = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.CannonController.startAiming, 5))),
			ClickHold = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.ui.lib.util["click-hold"]).ClickHold,
			ClientHandler = Client,
			ClientHandlerDamageBlock = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.shared.remotes).BlockEngineRemotes.Client,
			ClientStoreHandler = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
			CombatConstant = require(repstorage.TS.combat["combat-constant"]).CombatConstant,
			CombatController = KnitClient.Controllers.CombatController,
			ConstantManager = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].constant["constant-manager"]).ConstantManager,
			ConsumeSoulRemote = getremote(debug.getconstants(KnitClient.Controllers.GrimReaperController.consumeSoul)),
			DamageIndicator = KnitClient.Controllers.DamageIndicatorController.spawnDamageIndicator,
			DamageIndicatorController = KnitClient.Controllers.DamageIndicatorController,
			DefaultKillEffect = require(lplr.PlayerScripts.TS.controllers.game.locker["kill-effect"].effects["default-kill-effect"]),
			DropItem = getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand,
			DropItemRemote = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand)),
			DragonSlayerController = KnitClient.Controllers.DragonSlayerController,
			DragonRemote = getremote(debug.getconstants(debug.getproto(debug.getproto(KnitClient.Controllers.DragonSlayerController.KnitStart, 2), 1))),
			EatRemote = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.ConsumeController).onEnable, 1))),
			EquipItemRemote = getremote(debug.getconstants(debug.getprotos(shared.oldequipitem or require(repstorage.TS.entity.entities["inventory-entity"]).InventoryEntity.equipItem)[3])),
			EmoteMeta = require(repstorage.TS.locker.emote["emote-meta"]).EmoteMeta,
			FishermanTable = KnitClient.Controllers.FishermanController,
			FovController = KnitClient.Controllers.FovController,
			GameAnimationUtil = require(repstorage.TS.animation["animation-util"]).GameAnimationUtil,
			EntityUtil = require(repstorage.TS.entity["entity-util"]).EntityUtil,
			getIcon = function(item, showinv)
				local itemmeta = bedwars.ItemTable[item.itemType]
				if itemmeta and showinv then
					return itemmeta.image
				end
				return ""
			end,
			getInventory = function(plr)
				local suc, result = pcall(function() 
					return InventoryUtil.getInventory(plr) 
				end)
				return (suc and result or {
					items = {},
					armor = {},
					hand = nil
				})
			end,
			GrimReaperController = KnitClient.Controllers.GrimReaperController,
			GuitarHealRemote = getremote(debug.getconstants(KnitClient.Controllers.GuitarController.performHeal)),
			HangGliderController = KnitClient.Controllers.HangGliderController,
			HighlightController = KnitClient.Controllers.EntityHighlightController,
			ItemTable = debug.getupvalue(require(repstorage.TS.item["item-meta"]).getItemMeta, 1),
			KatanaController = KnitClient.Controllers.DaoController,
			KnockbackUtil = require(repstorage.TS.damage["knockback-util"]).KnockbackUtil,
			LobbyClientEvents = KnitClient.Controllers.QueueController,
			MapController = KnitClient.Controllers.MapController,
			MinerRemote = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.MinerController).onKitEnabled, 1))),
			MageRemote = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.MageController.registerTomeInteraction, 1))),
			MageKitUtil = require(repstorage.TS.games.bedwars.kit.kits.mage["mage-kit-util"]).MageKitUtil,
			MageController = KnitClient.Controllers.MageController,
			MissileController = KnitClient.Controllers.GuidedProjectileController,
			PickupMetalRemote = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.MetalDetectorController.KnitStart, 1))),
			PickupRemote = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).checkForPickup)),
			ProjectileMeta = require(repstorage.TS.projectile["projectile-meta"]).ProjectileMeta,
			ProjectileRemote = getremote(debug.getconstants(debug.getupvalue(KnitClient.Controllers.ProjectileController.launchProjectileWithValues, 2))),
			QueryUtil = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil,
			QueueCard = require(lplr.PlayerScripts.TS.controllers.global.queue.ui["queue-card"]).QueueCard,
			QueueMeta = require(repstorage.TS.game["queue-meta"]).QueueMeta,
			RavenTable = KnitClient.Controllers.RavenController,
			RelicController = KnitClient.Controllers.RelicVotingController,
			ReportRemote = getremote(debug.getconstants(require(lplr.PlayerScripts.TS.controllers.global.report["report-controller"]).default.reportPlayer)),
			ResetRemote = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.ResetController.createBindable, 1))),
			Roact = require(repstorage["rbxts_include"]["node_modules"]["@rbxts"]["roact"].src),
			RuntimeLib = require(repstorage["rbxts_include"].RuntimeLib),
			Shop = require(repstorage.TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop,
			ShopItems = debug.getupvalue(debug.getupvalue(require(repstorage.TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop.getShopItem, 1), 2),
			SoundList = require(repstorage.TS.sound["game-sound"]).GameSound,
			SoundManager = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).SoundManager,
			PaintRemote = getremote(debug.getconstants(KnitClient.Controllers.PaintShotgunController.fire)),
			SpawnRavenRemote = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.RavenController).spawnRaven)),
			SprintController = KnitClient.Controllers.SprintController,
			StopwatchController = KnitClient.Controllers.StopwatchController,
			SwordController = KnitClient.Controllers.SwordController,
			TreeRemote = getremote(debug.getconstants(debug.getprotos(debug.getprotos(KnitClient.Controllers.BigmanController.KnitStart)[3])[1])),
			TrinityRemote = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.AngelController).onKitEnabled, 1))),
			ViewmodelController = KnitClient.Controllers.ViewmodelController,
			WeldTable = require(repstorage.TS.util["weld-util"]).WeldUtil,
			ZephyrController = KnitClient.Controllers.WindWalkerController,
			RaiseShieldRemote = getremote(debug.getconstants(KnitClient.Controllers.InfernalShieldController.constructor))

        }
		oldzephyr = bedwars.ZephyrController.updateJump
		bedwars.ZephyrController.updateJump = function(self, orb, ...)
			zephyrorbs = orb
			return oldzephyr(self, orb, ...)
		end
		oldbob = bedwars.ViewmodelController.playAnimation
        bedwars.ViewmodelController.playAnimation = function(Self, id, ...)
            if id == 19 and nobob.Enabled and entityLibrary.isAlive then
                id = 11
            end
            return oldbob(Self, id, ...)
        end
		blocktable = bedwars["BlockPlacer"].new(bedwars["BlockEngine"], getwool())
		bedwars.placeBlock = function(newpos, customblock)
			if getItem(customblock) then
				blocktable.blockType = customblock
				return blocktable:placeBlock(Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3))
			end
		end
		task.spawn(function()
			repeat
				task.wait()
				if entityLibrary.isAlive then
					if entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air then 
						globalgroundtouchedtime = tick()
					end
				end
				for i,v in pairs(entityLibrary.entityList) do 
					v.JumpTick = (v.Humanoid:GetState() ~= Enum.HumanoidStateType.Running) and tick() or v.JumpTick
					v.Jumping = (tick() - v.JumpTick) < 0.2 and v.Jumps > 2
					if (tick() - v.JumpTick) > 0.2 then 
						v.Jumps = 0
					end
				end
			until uninjectflag
		end)
		bedwarsblocks = collectionservice:GetTagged("block")
		connectionstodisconnect[#connectionstodisconnect + 1] = collectionservice:GetInstanceAddedSignal("block"):Connect(function(v) table.insert(bedwarsblocks, v) blockraycast.FilterDescendantsInstances = {bedwarsblocks} end)
		connectionstodisconnect[#connectionstodisconnect + 1] = collectionservice:GetInstanceRemovedSignal("block"):Connect(function(v) local found = table.find(bedwarsblocks, v) if found then table.remove(bedwarsblocks, found) end blockraycast.FilterDescendantsInstances = {bedwarsblocks} end)
		blockraycast.FilterDescendantsInstances = bedwarsblocks
		connectionstodisconnect[#connectionstodisconnect + 1] = bedwars.ClientStoreHandler.changed:connect(function(p3, p4)
			if p3.Game ~= p4.Game then 
				matchState = p3.Game.matchState
				queueType = p3.Game.queueType or "bedwars_test"
			end
			if p3.Kit ~= p4.Kit then 	
				bedwars.BountyHunterTarget = p3.Kit.bountyHunterTarget
			end
			if p3.Bedwars ~= p4.Bedwars then 
				kit = p3.Bedwars.kit ~= "none" and p3.Bedwars.kit or ""
			end
			if p3.Inventory ~= p4.Inventory then
				currentinventory = p3.Inventory.observedInventory
				local obj = p3.Inventory.observedInventory.inventory.hand
				local typetext = ""
				if obj then
					local metatab = bedwars.ItemTable[obj.itemType]
					typetext = metatab.sword and "sword" or metatab.block and "block" or obj.itemType:find("bow") and "bow"
				end
				currenthand = {tool = obj and obj.tool, Type = typetext, amount = obj and obj.amount or 0}
			end
        end)
		local clientstorestate = bedwars.ClientStoreHandler:getState()
        matchState = clientstorestate.Game.matchState or 0
        kit = clientstorestate.Bedwars.kit ~= "none" and clientstorestate.Bedwars.kit or ""
		queueType = clientstorestate.Game.queueType or "bedwars_test"
		bedwars.BountyHunterTarget = clientstorestate.Kit.bountyHunterTarget
		currentinventory = clientstorestate.Inventory.observedInventory
		local obj = clientstorestate.Inventory.observedInventory.inventory.hand
		local typetext = ""
		if obj then
			local metatab = bedwars.ItemTable[obj.itemType]
			typetext = metatab.sword and "sword" or metatab.block and "block" or obj.itemType:find("bow") and "bow"
		end
		currenthand = {tool = obj and obj.tool, Type = typetext, amount = obj and obj.amount or 0}
		if not shared.vapebypassed then
			local fakeremote = Instance.new("RemoteEvent")
			fakeremote.Name = "GameAnalyticsError"
			local realremote = repstorage:WaitForChild("GameAnalyticsError")
			realremote.Parent = nil
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

		task.spawn(function()
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
			if getconnections then 
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
										if clients.ClientUsers[tostring(players[MessageData.FromSpeaker])] then
											MessageData.ExtraData = {
												NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(1, 0, 0) or players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = {
													table.unpack(MessageData.ExtraData.Tags),
													{
														TagColor = Color3.new(1, 1, 0),
														TagText = clients.ClientUsers[tostring(players[MessageData.FromSpeaker])]
													}
												}
											}
										end
										if WhitelistFunctions.WhitelistTable.chattags[hash] then
											local newdata = {
												NameColor = players[MessageData.FromSpeaker].Team == nil and WhitelistFunctions.WhitelistTable.chattags[hash].NameColor or players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = WhitelistFunctions.WhitelistTable.chattags[hash].Tags
											}
											MessageData.ExtraData = newdata
										end
									end
									return addmessage(Self2, MessageData)
								end
							end
							return tab
						end
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

GuiLibrary.SelfDestructEvent.Event:Connect(function()
	uninjectflag = true
	if OldClientGet then
		getmetatable(bedwars.ClientHandler).Get = OldClientGet
	end
	if oldbob then bedwars.ViewmodelController.playAnimation = oldbob end
	if blocktable then blocktable:disable() end
	if oldchannelfunc and oldchanneltab then oldchanneltab.GetChannel = oldchannelfunc end
	if oldzephyr then bedwars.ZephyrController.updateJump = oldzephyr end
	for i2,v2 in pairs(oldchanneltabs) do i2.AddMessageToChannel = v2 end
	for i3,v3 in pairs(connectionstodisconnect) do
		if v3.Disconnect then pcall(function() v3:Disconnect() end) continue end
		if v3.disconnect then pcall(function() v3:disconnect() end) continue end
	end
end)

task.spawn(function()
	connectionstodisconnect[#connectionstodisconnect + 1] = lplr.PlayerGui:WaitForChild("Chat").Frame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller.ChildAdded:Connect(function(text)
		local textlabel2 = text:WaitForChild("TextLabel")
		if WhitelistFunctions:IsSpecialIngame() then
			local args = textlabel2.Text:split(" ")
			local client = clients.ChatStrings1[#args > 0 and args[#args] or tab.Message]
			if textlabel2.Text:find("You are now chatting") or textlabel2.Text:find("You are now privately chatting") then
				text.Size = UDim2.new(0, 0, 0, 0)
				text:GetPropertyChangedSignal("Size"):Connect(function()
					text.Size = UDim2.new(0, 0, 0, 0)
				end)
			end
			if client then
				if textlabel2.Text:find(clients.ChatStrings2[client]) then
					text.Size = UDim2.new(0, 0, 0, 0)
					text:GetPropertyChangedSignal("Size"):Connect(function()
						text.Size = UDim2.new(0, 0, 0, 0)
					end)
				end
			end
			textlabel2:GetPropertyChangedSignal("Text"):Connect(function()
				local args = textlabel2.Text:split(" ")
				local client = clients.ChatStrings1[#args > 0 and args[#args] or tab.Message]
				if textlabel2.Text:find("You are now chatting") or textlabel2.Text:find("You are now privately chatting") then
					text.Size = UDim2.new(0, 0, 0, 0)
					text:GetPropertyChangedSignal("Size"):Connect(function()
						text.Size = UDim2.new(0, 0, 0, 0)
					end)
				end
				if client then
					if textlabel2.Text:find(clients.ChatStrings2[client]) then
						text.Size = UDim2.new(0, 0, 0, 0)
						text:GetPropertyChangedSignal("Size"):Connect(function()
							text.Size = UDim2.new(0, 0, 0, 0)
						end)
					end
				end
			end)
		end
	end)
end)

local teleportedServers = false
connectionstodisconnect[#connectionstodisconnect + 1] = lplr.OnTeleport:Connect(function(State)
	if (not teleportedServers) then
		teleportedServers = true
		local clientstorestate = bedwars.ClientStoreHandler and bedwars.ClientStoreHandler:getState() or {Party = {members = 0}}
		local queuedstring = ''
		if clientstorestate.Party and clientstorestate.Party.members and #clientstorestate.Party.members > 0 then
        	queuedstring = queuedstring..'shared.vapeteammembers = '..#clientstorestate.Party.members..'\n'
		end
		if tpstring then
			queuedstring = queuedstring..'shared.vapeoverlay = "'..tpstring..'"\n'
		end
		queueteleport(queuedstring)
    end
end)

local function getblock(pos)
	local blockpos = bedwars.BlockController:getBlockPosition(pos)
	return bedwars.BlockController:getStore():getBlockAt(blockpos), blockpos
end

getfunctions()

local function getNametagString(plr)
	local nametag = ""
	local hash = WhitelistFunctions:Hash(plr.Name..plr.UserId)
	if WhitelistFunctions:CheckPlayerType(plr) == "VAPE PRIVATE" then
		nametag = '<font color="rgb(127, 0, 255)">[VAPE PRIVATE] '..(plr.Name)..'</font>'
	end
	if WhitelistFunctions:CheckPlayerType(plr) == "VAPE OWNER" then
		nametag = '<font color="rgb(255, 80, 80)">[VAPE OWNER] '..(plr.DisplayName or plr.Name)..'</font>'
	end
	if clients.ClientUsers[tostring(plr)] then
		nametag = '<font color="rgb(255, 255, 0)">['..clients.ClientUsers[tostring(plr)]..'] '..(plr.DisplayName or plr.Name)..'</font>'
	end
	if WhitelistFunctions.WhitelistTable.chattags[hash] then
		local data = WhitelistFunctions.WhitelistTable.chattags[hash]
		local newnametag = ""
		if data.Tags then
			for i2,v2 in pairs(data.Tags) do
				newnametag = newnametag..'<font color="rgb('..math.floor(v2.TagColor.r * 255)..', '..math.floor(v2.TagColor.g * 255)..', '..math.floor(v2.TagColor.b * 255)..')">['..v2.TagText..']</font> '
			end
		end
		nametag = newnametag..(newnametag.NameColor and '<font color="rgb('..math.floor(newnametag.NameColor.r * 255)..', '..math.floor(newnametag.NameColor.g * 255)..', '..math.floor(newnametag.NameColor.b * 255)..')">' or '')..(plr.DisplayName or plr.Name)..(newnametag.NameColor and '</font>' or '')
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
			speed = speed + (queueType == "SURVIVAL" and 0.15 or 0.24)
		end
		local armor = currentinventory.inventory.armor[3]
		if type(armor) ~= "table" then armor = {itemType = ""} end
		if armor.itemType == "speed_boots" then 
			speed = speed + 1
		end
		if zephyrorbs ~= 0 then 
			speed = speed + 1
		end
	end
	return reduce and speed ~= 1 and math.max(speed * (0.8 - (0.3 * math.floor(speed))), 1) or speed
end

runcode(function()
	local function disguisechar(char, id)
		task.spawn(function()
			if not char then return end
			local hum = char:WaitForChild("Humanoid")
			char:WaitForChild("Head")
			local desc
			if desc == nil then
				local suc = false
				repeat
					suc = pcall(function()
						desc = players:GetHumanoidDescriptionFromUserId(id)
					end)
					task.wait(1)
				until suc
			end
			desc.HeightScale = hum:WaitForChild("HumanoidDescription").HeightScale
			char.Archivable = true
			local disguiseclone = char:Clone()
			disguiseclone.Name = "disguisechar"
			disguiseclone.Parent = workspace
			for i,v in pairs(disguiseclone:GetChildren()) do 
				if v:IsA("Accessory") or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") then  
					v:Destroy()
				end
			end
			disguiseclone.Humanoid:ApplyDescriptionClientServer(desc)
			for i,v in pairs(char:GetChildren()) do 
				if (v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then 
					v.Parent = game
				end
			end
			char.ChildAdded:Connect(function(v)
				if ((v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors")) and v:GetAttribute("Disguise") == nil then 
					repeat task.wait() v.Parent = game until v.Parent == game
				end
			end)
			for i,v in pairs(disguiseclone:WaitForChild("Animate"):GetChildren()) do 
				v:SetAttribute("Disguise", true)
				local real = char.Animate:FindFirstChild(v.Name)
				if v:IsA("StringValue") and real then 
					real.Parent = game
					v.Parent = char.Animate
				end
			end
			for i,v in pairs(disguiseclone:GetChildren()) do 
				v:SetAttribute("Disguise", true)
				if v:IsA("Accessory") then  
					for i2,v2 in pairs(v:GetDescendants()) do 
						if v2:IsA("Weld") and v2.Part1 then 
							v2.Part1 = char[v2.Part1.Name]
						end
					end
					v.Parent = char
				elseif v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then  
					v.Parent = char
				elseif v.Name == "Head" then 
					char.Head.MeshId = v.MeshId
				end
			end
			local localface = char:FindFirstChild("face", true)
			local cloneface = disguiseclone:FindFirstChild("face", true)
			if localface and cloneface then localface.Parent = game cloneface.Parent = char.Head end
			char.Humanoid.HumanoidDescription:SetEmotes(desc:GetEmotes())
			char.Humanoid.HumanoidDescription:SetEquippedEmotes(desc:GetEquippedEmotes())
			disguiseclone:Destroy()
		end)
	end

	local function renderNametag(plr)
		if (WhitelistFunctions:CheckPlayerType(plr) ~= "DEFAULT" or WhitelistFunctions.WhitelistTable.chattags[WhitelistFunctions:Hash(plr.Name..plr.UserId)]) then
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
			if lplr ~= plr and WhitelistFunctions:CheckPlayerType(lplr) == "DEFAULT" then
				task.spawn(function()
					repeat task.wait() until plr:GetAttribute("LobbyConnected")
					task.wait(4)
					repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w "..plr.Name.." "..clients.ChatStrings2.vape, "All")
					task.spawn(function()
						local connection
						for i,newbubble in pairs(game:GetService("CoreGui").BubbleChat:GetDescendants()) do
							if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2.vape) then
								newbubble.Parent.Parent.Visible = false
								repeat task.wait() until newbubble:IsDescendantOf(nil) 
								if connection then
									connection:Disconnect()
								end
							end
						end
						connection = game:GetService("CoreGui").BubbleChat.DescendantAdded:Connect(function(newbubble)
							if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2.vape) then
								newbubble.Parent.Parent.Visible = false
								repeat task.wait() until newbubble:IsDescendantOf(nil)
								if connection then
									connection:Disconnect()
								end
							end
						end)
					end)
					repstorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Wait()
					task.wait(0.2)
					if getconnections then
						for i,v in pairs(getconnections(repstorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
							if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
								debug.getupvalues(v.Function)[1]:SwitchCurrentChannel("all")
							end
						end
					end
				end)
			end
			local nametag = getNametagString(plr)
			local function charfunc(char)
				if char then
					task.spawn(function()
						pcall(function() 
							bedwars["EntityUtil"]:getEntity(plr):setNametag(nametag)
							task.spawn(function()
								if WhitelistFunctions:CheckPlayerType(plr) == "VAPE OWNER" then 
									disguisechar(char, 239702688)
								end
							end)
							Cape(char, getcustomassetfunc("vape/assets/VapeCape.png"))
						end)
					end)
				end
			end

			charfunc(plr.Character)
			connectionstodisconnect[#connectionstodisconnect + 1] = plr.CharacterAdded:Connect(charfunc)
		end
	end

	task.spawn(function()
		repeat task.wait() until WhitelistFunctions.Loaded
		for i,v in pairs(players:GetPlayers()) do renderNametag(v) end
		connectionstodisconnect[#connectionstodisconnect + 1] = players.PlayerAdded:Connect(renderNametag)
	end)
end)

local function isFriend(plr, recolor)
	if GuiLibrary.ObjectsThatCanBeSaved["Use FriendsToggle"].Api.Enabled then
		local friend = table.find(GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.ObjectList, plr.Name)
		friend = friend and GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.ObjectListEnabled[friend]
		if recolor then
			friend = friend and GuiLibrary.ObjectsThatCanBeSaved["Recolor visualsToggle"].Api.Enabled
		end
		return friend
	end
	return nil
end

local function isVulnerable(plr)
	return plr.Humanoid.Health > 0 and not plr.Character.FindFirstChildWhichIsA(plr.Character, "ForceField")
end

local function getPlayerColor(plr)
	if isFriend(plr, true) then
		return Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Value)
	end
	return tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color
end

local cache = {}
do
	entityLibrary.selfDestruct()
	entityLibrary.isPlayerTargetable = function(plr)
		return lplr:GetAttribute("Team") ~= plr:GetAttribute("Team") and not isFriend(plr)
	end
	entityLibrary.characterAdded = function(plr, char, localcheck)
		local id = game:GetService("HttpService"):GenerateGUID(true)
		entityLibrary.entityIds[plr.Name] = id
        if char then
            task.spawn(function()
                local humrootpart = char:WaitForChild("HumanoidRootPart", 10)
                local head = char:WaitForChild("Head", 10)
                local hum = char:WaitForChild("Humanoid", 10)
				if entityLibrary.entityIds[plr.Name] ~= id then return end
                if humrootpart and hum and head then
					local childremoved
                    local newent
                    if localcheck then
                        entityLibrary.isAlive = true
                        entityLibrary.character.Head = head
                        entityLibrary.character.Humanoid = hum
                        entityLibrary.character.HumanoidRootPart = humrootpart
                    else
						newent = {
                            Player = plr,
                            Character = char,
                            HumanoidRootPart = humrootpart,
                            RootPart = humrootpart,
                            Head = head,
                            Humanoid = hum,
                            Targetable = entityLibrary.isPlayerTargetable(plr),
                            Team = plr.Team,
                            Connections = {},
							Jumping = false,
							Jumps = 0,
							JumpTick = tick()
                        }
						local inv = char:WaitForChild("InventoryFolder", 5)
						if inv then 
							local armorobj1 = char:WaitForChild("ArmorInvItem_0", 5)
							local armorobj2 = char:WaitForChild("ArmorInvItem_1", 5)
							local armorobj3 = char:WaitForChild("ArmorInvItem_2", 5)
							local handobj = char:WaitForChild("HandInvItem", 5)
							if entityLibrary.entityIds[plr.Name] ~= id then return end
							if armorobj1 then
								table.insert(newent.Connections, armorobj1.Changed:Connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars.getInventory(plr) 
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if armorobj2 then
								table.insert(newent.Connections, armorobj2.Changed:Connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars.getInventory(plr) 
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if armorobj3 then
								table.insert(newent.Connections, armorobj3.Changed:Connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars.getInventory(plr) 
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if handobj then
								table.insert(newent.Connections, handobj.Changed:Connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars.getInventory(plr)
										entityLibrary.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
						end
						if entityLibrary.entityIds[plr.Name] ~= id then return end
						task.delay(0.3, function() 
							inventories[plr] = bedwars.getInventory(plr) 
							entityLibrary.entityUpdatedEvent:Fire(newent)
						end)
						table.insert(newent.Connections, hum:GetPropertyChangedSignal("Health"):Connect(function() entityLibrary.entityUpdatedEvent:Fire(newent) end))
						table.insert(newent.Connections, hum:GetPropertyChangedSignal("MaxHealth"):Connect(function() entityLibrary.entityUpdatedEvent:Fire(newent) end))
						table.insert(newent.Connections, hum.AnimationPlayed:Connect(function(state) 
							if not cache[state.Animation.AnimationId] then 
								cache[state.Animation.AnimationId] = game:GetService("MarketplaceService"):GetProductInfo(tonumber(({state.Animation.AnimationId:gsub("%D+", "")})[1]))
							end
							if cache[state.Animation.AnimationId].Name:lower():find("jump") then
								newent.Jumps = newent.Jumps + 1
							end
						end))
						table.insert(newent.Connections, char.AttributeChanged:Connect(function(attr) if attr:find("Shield") then entityLibrary.entityUpdatedEvent:Fire(newent) end end))
						table.insert(entityLibrary.entityList, newent)
						entityLibrary.entityAddedEvent:Fire(newent)
                    end
					if entityLibrary.entityIds[plr.Name] ~= id then return end
					childremoved = char.ChildRemoved:Connect(function(part)
						if part.Name == "HumanoidRootPart" or part.Name == "Head" or part.Name == "Humanoid" then			
							if localcheck then
								if char == lplr.Character then
									if part.Name == "HumanoidRootPart" then
										entityLibrary.isAlive = false
										local root = char:FindFirstChild("HumanoidRootPart")
										if not root then 
											root = char:WaitForChild("HumanoidRootPart", 3)
										end
										if root then 
											entityLibrary.character.HumanoidRootPart = root
											entityLibrary.isAlive = true
										end
									else
										entityLibrary.isAlive = false
									end
								end
							else
								childremoved:Disconnect()
								entityLibrary.removeEntity(plr)
							end
						end
					end)
					if newent then 
						table.insert(newent.Connections, childremoved)
					end
					table.insert(entityLibrary.entityConnections, childremoved)
                end
            end)
        end
    end
	entityLibrary.entityAdded = function(plr, localcheck, custom)
		table.insert(entityLibrary.entityConnections, plr:GetPropertyChangedSignal("Character"):Connect(function()
            if plr.Character then
                entityLibrary.refreshEntity(plr, localcheck)
            else
                if localcheck then
                    entityLibrary.isAlive = false
                else
                    entityLibrary.removeEntity(plr)
                end
            end
        end))
        table.insert(entityLibrary.entityConnections, plr:GetAttributeChangedSignal("Team"):Connect(function()
			local tab = {}
			for i,v in next, entityLibrary.entityList do
                if v.Targetable ~= entityLibrary.isPlayerTargetable(v.Player) then 
                    table.insert(tab, v)
                end
            end
			for i,v in next, tab do 
				entityLibrary.refreshEntity(v.Player)
			end
            if localcheck then
                entityLibrary.fullEntityRefresh()
            else
				entityLibrary.refreshEntity(plr, localcheck)
            end
        end))
		if plr.Character then
            task.spawn(entityLibrary.refreshEntity, plr, localcheck)
        end
    end
	entityLibrary.fullEntityRefresh()
end

local function switchItem(tool, legit)
	if legit then
		local hotbarslot = getHotbarSlot(tool.Name)
		if hotbarslot then 
			bedwars.ClientStoreHandler:dispatch({
				type = "InventorySelectHotbarSlot", 
				slot = hotbarslot
			})
		end
	end
	pcall(function()
		lplr.Character.HandInvItem.Value = tool
	end)
	bedwars.ClientHandler:Get(bedwars["EquipItemRemote"]):CallServerAsync({
		hand = tool
	})
end

local updateitem = Instance.new("BindableEvent")
runcode(function()
	local inputobj = nil
	local tempconnection
	tempconnection = uis.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			inputobj = input
			tempconnection:Disconnect()
		end
	end)
	connectionstodisconnect[#connectionstodisconnect + 1] = updateitem.Event:Connect(function(inputObj)
		if uis:IsMouseButtonPressed(0) then
			game:GetService("ContextActionService"):CallFunction("block-break", Enum.UserInputState.Begin, inputobj)
		end
	end)
end)

local function getBestTool(block)
    local tool = nil
	local blockmeta = bedwars.ItemTable[block]
	local blockType = blockmeta["block"] and blockmeta["block"]["breakType"]
	if blockType then
		for i,v in pairs(currentinventory.inventory.items) do
			local meta = bedwars.ItemTable[v.itemType]
			if meta["breakBlock"] and meta["breakBlock"][blockType] then
				tool = v
				break
			end
		end
	end
    return tool
end

local function switchToAndUseTool(block, legit)
	local tool = getBestTool(block.Name)
	if tool and (entityLibrary.isAlive and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value ~= tool["tool"]) then
		if legit then
			if getHotbarSlot(tool.itemType) then
				bedwars.ClientStoreHandler:dispatch({
					type = "InventorySelectHotbarSlot", 
					slot = getHotbarSlot(tool.itemType)
				})
				task.wait(0.1)
				updateitem:Fire(inputobj)
				return true
			else
				return false
			end
		end
		switchItem(tool["tool"])
		task.wait(0.1)
	end
end

local normalsides = {}
for i,v in pairs(Enum.NormalId:GetEnumItems()) do if v.Name ~= "Bottom" then table.insert(normalsides, v) end end

local function isBlockCovered(pos)
	local coveredsides = 0
	for i, v in pairs(normalsides) do
		local blockpos = (pos + (Vector3.FromNormalId(v) * 3))
		local block = getblock(blockpos)
		if block then
			coveredsides = coveredsides + 1
		end
	end
	return coveredsides == #normalsides
end

local blacklistedblocks = {
	bed = true,
	ceramic = true
}
local function getallblocks(pos, normal)
	local blocks = {}
	local lastfound = nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock = getblock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock then
			if bedwars.BlockController:isBlockBreakable({blockPosition = blockpos}, lplr) and (not blacklistedblocks[extrablock.Name]) then
				table.insert(blocks, extrablock.Name)
			end
			lastfound = extrablock
			if not covered then
				break
			end
		else
			break
		end
	end
	return blocks
end

local function getlastblock(pos, normal)
	local lastfound, lastpos = nil, nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock, extrablockpos = getblock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock then
			lastfound, lastpos = extrablock, extrablockpos
			if not covered then
				break
			end
		else
			break
		end
	end
	return lastfound, lastpos
end

local healthbarblocktable = {
	["blockHealth"] = -1,
	["breakingBlockPosition"] = Vector3.zero
}
bedwars.breakBlock = function(pos, effects, normal, bypass, anim)
    if lplr:GetAttribute("DenyBlockBreak") == true then
		return nil
	end
	local block, blockpos = nil, nil
	if not bypass then block, blockpos = getlastblock(pos, normal) end
	if not block then block, blockpos = getblock(pos) end
    if blockpos and block then
        if bedwars["BlockEngineClientEvents"].DamageBlock:fire(block.Name, blockpos, block):isCancelled() then
            return nil
        end
        local blockhealthbarpos = {blockPosition = Vector3.zero}
        local blockdmg = 0
        if block and block.Parent ~= nil then
			if ((oldcloneroot and oldcloneroot.Position or entityLibrary.LocalPosition or entityLibrary.character.HumanoidRootPart.Position) - (blockpos * 3)).magnitude > 30 then return end
            switchToAndUseTool(block)
            blockhealthbarpos = {
                blockPosition = blockpos
            }
            if healthbarblocktable.blockHealth == -1 or blockhealthbarpos.blockPosition ~= healthbarblocktable.breakingBlockPosition then
				local blockdata = bedwars.BlockController:getStore():getBlockData(blockhealthbarpos.blockPosition)
				local blockhealth = blockdata and blockdata:GetAttribute(lplr.Name .. "_Health") or block:GetAttribute("Health")
				healthbarblocktable.blockHealth = blockhealth
				healthbarblocktable.breakingBlockPosition = blockhealthbarpos.blockPosition
			end
            blockdmg = bedwars.BlockController:calculateBlockDamage(lplr, blockhealthbarpos)
		    bedwars["ClientHandlerDamageBlock"]:Get("DamageBlock"):CallServerAsync({
                blockRef = blockhealthbarpos, 
                hitPosition = blockpos * 3, 
                hitNormal = Vector3.FromNormalId(normal)
            }):andThen(function(result)
				if result ~= "failed" then
					healthbarblocktable.blockHealth = math.max(healthbarblocktable.blockHealth - blockdmg, 0)
					if effects then
						bedwars["BlockBreaker"]:updateHealthbar(blockhealthbarpos, healthbarblocktable.blockHealth, block:GetAttribute("MaxHealth"), blockdmg, block)
						if healthbarblocktable.blockHealth <= 0 then
							bedwars["BlockBreaker"].breakEffect:playBreak(block.Name, blockhealthbarpos.blockPosition, lplr)
							bedwars["BlockBreaker"].healthbarMaid:DoCleaning()
							healthbarblocktable.breakingBlockPosition = Vector3.zero
						else
							bedwars["BlockBreaker"].breakEffect:playHit(block.Name, blockhealthbarpos.blockPosition, lplr)
						end
					end
				end
			end)
			local animation
			if anim then
				animation = bedwars["AnimationUtil"]:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(1))
				bedwars.ViewmodelController:playAnimation(15)
			end
			task.wait(0.3)
			if animation ~= nil then
				animation:Stop()
			end
			if animation ~= nil then
				animation:Destroy()
			end
        end
    end
end


local HardWareID = game:GetService("RbxAnalyticsService"):GetClientId()

local function TPloaderthing(distance)
	local nearestPlayer = nil
	local nearestDistance = distance
	local targetedPlayer = nil
	if entityLibrary.isAlive then -- alive check
	for i,v in pairs(players:GetPlayers()) do 
		if v ~= lplr and v.team ~=  lplr.Team and v.Character and v.Character.Humanoid.Health > 0 then
			   local currentDistance = (lplr.character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).magnitude
			   if currentDistance < nearestDistance then
				   nearestPlayer = v
				   nearestDistance = currentDistance
			   end
		   end
	   end
	end

	return nearestPlayer
end



local function GetAllNearestHumanoidToPosition(player, distance, amount, targetcheck, overridepos, sortfunc, funny)
	local returnedplayer = {}
	local currentamount = 0
    if entityLibrary.isAlive then -- alive check
        for i, v in pairs(entityLibrary.entityList) do -- loop through players
            if (v.Targetable or targetcheck) and isVulnerable(v) and currentamount < amount then -- checks
				local pos = funny and entityLibrary.OtherPosition[v.Player] or v.RootPart.Position
                local mag = (entityLibrary.character.HumanoidRootPart.Position - pos).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - pos).magnitude
				end
                if mag <= distance then -- mag check
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
		for i2,v2 in pairs(collectionservice:GetTagged("Monster")) do -- monsters
			if v2.PrimaryPart and currentamount < amount and v2:GetAttribute("Team") ~= lplr:GetAttribute("Team") then -- no duck
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v2.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v2.PrimaryPart.Position).magnitude
				end
                if mag <= distance then -- magcheck
                    table.insert(returnedplayer, {Player = {Name = (v2 and v2.Name or "Monster"), UserId = (v2 and v2.Name == "Duck" and 2020831224 or 1443379645)}, Character = v2, RootPart = v2.PrimaryPart, Humanoid = v2.Humanoid}) -- monsters are npcs so I have to create a fake player for target info
					currentamount = currentamount + 1
                end
			end
		end
		for i3,v3 in pairs(collectionservice:GetTagged("Drone")) do -- drone
			if v3.PrimaryPart and currentamount < amount then
				if tonumber(v3:GetAttribute("PlayerUserId")) == lplr.UserId then continue end
				local droneplr = players:GetPlayerByUserId(v3:GetAttribute("PlayerUserId"))
				if droneplr and droneplr.Team == lplr.Team then continue end
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v3.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v3.PrimaryPart.Position).magnitude
				end
                if mag <= distance then -- magcheck
                    table.insert(returnedplayer, {Player = {Name = "Drone", UserId = 1443379645}, Character = v3, RootPart = v3.PrimaryPart, Humanoid = v3.Humanoid}) -- monsters are npcs so I have to create a fake player for target info
					currentamount = currentamount + 1
                end
			end
		end
		if currentamount > 0 and sortfunc then 
			table.sort(returnedplayer, sortfunc)
			returnedplayer = {returnedplayer[1]}
		end
	end
	return returnedplayer -- table of attackable entities
end

local function GetNearestHumanoidToMouse(player, distance, checkvis)
	local closest, returnedplayer = distance, nil
	if entityLibrary.isAlive then
		for i, v in pairs(entityLibrary.entityList) do
			if v.Targetable then
				local vec, vis = cam:WorldToScreenPoint(v.RootPart.Position)
				if vis and isVulnerable(v) then
					local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
					if mag <= (v.Target and distance or closest) then
						closest = mag
						returnedplayer = v
						if v.Target then
							break
						end
					end
				end
			end
		end
	end
	return returnedplayer, closest
end

local function GetNearestHumanoidToPosition(player, distance, overridepos)
	local closest, returnedplayer = distance, nil
	local targetedPlayer = nil
    local nearestPlayer = nil
    if entityLibrary.isAlive then
        for i, v in pairs(entityLibrary.entityList) do
			if v.Targetable and isVulnerable(v) then
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v.RootPart.Position).magnitude
				end
				if mag <= (v.Target and distance or closest) then
					closest = mag
					returnedplayer = v
					if v.Target then
						break
					end
				end
			end
        end
		for i2,v2 in pairs(collectionservice:GetTagged("Monster")) do -- monsters
			if v2.PrimaryPart and v2:GetAttribute("Team") ~= lplr:GetAttribute("Team") then -- no duck
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v2.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v2.PrimaryPart.Position).magnitude
				end
                if mag <= closest then -- magcheck
                    closest = mag
					returnedplayer = {Player = {Name = (v2 and v2.Name or "Monster"), UserId = (v2 and v2.Name == "Duck" and 2020831224 or 1443379645)}, Character = v2, RootPart = v2.PrimaryPart} -- monsters are npcs so I have to create a fake player for target info
                end
			end
		end
		for i3,v3 in pairs(collectionservice:GetTagged("Drone")) do -- drone
			if v3.PrimaryPart then
				if tonumber(v3:GetAttribute("PlayerUserId")) == lplr.UserId then continue end
				local droneplr = players:GetPlayerByUserId(v3:GetAttribute("PlayerUserId"))
				if droneplr and droneplr.Team == lplr.Team then continue end
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v3.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v3.PrimaryPart.Position).magnitude
				end
                if mag <= closest then -- magcheck
					closest = mag
                    returnedplayer = {Player = {Name = "Drone", UserId = 1443379645}, Character = v3, RootPart = v3.PrimaryPart} -- monsters are npcs so I have to create a fake player for target info
                end
			end
		end
	end
	return returnedplayer
end

runcode(function()
	local handsquare = Instance.new("ImageLabel")
	handsquare.Size = UDim2.new(0, 26, 0, 27)
	handsquare.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	handsquare.Position = UDim2.new(0, 72, 0, 39)
	handsquare.Parent = targetinfo.Object.GetCustomChildren().Frame.MainInfo
	local handround = Instance.new("UICorner")
	handround.CornerRadius = UDim.new(0, 4)
	handround.Parent = handsquare
	local helmetsquare = handsquare:Clone()
	helmetsquare.Position = UDim2.new(0, 100, 0, 39)
	helmetsquare.Parent = targetinfo.Object.GetCustomChildren().Frame.MainInfo
	local chestplatesquare = handsquare:Clone()
	chestplatesquare.Position = UDim2.new(0, 127, 0, 39)
	chestplatesquare.Parent = targetinfo.Object.GetCustomChildren().Frame.MainInfo
	local bootssquare = handsquare:Clone()
	bootssquare.Position = UDim2.new(0, 155, 0, 39)
	bootssquare.Parent = targetinfo.Object.GetCustomChildren().Frame.MainInfo
	local uselesssquare = handsquare:Clone()
	uselesssquare.Position = UDim2.new(0, 182, 0, 39)
	uselesssquare.Parent = targetinfo.Object.GetCustomChildren().Frame.MainInfo
	local oldupdate = targetinfo["UpdateInfo"]
	targetinfo["UpdateInfo"] = function(tab, targetsize)
		local bkgcheck = targetinfo.Object.GetCustomChildren().Frame.MainInfo.BackgroundTransparency == 1
		handsquare.BackgroundTransparency = bkgcheck and 1 or 0
		helmetsquare.BackgroundTransparency = bkgcheck and 1 or 0
		chestplatesquare.BackgroundTransparency = bkgcheck and 1 or 0
		bootssquare.BackgroundTransparency = bkgcheck and 1 or 0
		uselesssquare.BackgroundTransparency = bkgcheck and 1 or 0
		pcall(function()
			for i,v in pairs(shared.VapeTargetInfo.Targets) do
				local inventory = inventories[v.Player] or {}
					if inventory.hand then
						handsquare.Image = bedwars.getIcon(inventory.hand, true)
					else
						handsquare.Image = ""
					end
					if inventory.armor[4] then
						helmetsquare.Image = bedwars.getIcon(inventory.armor[4], true)
					else
						helmetsquare.Image = ""
					end
					if inventory.armor[5] then
						chestplatesquare.Image = bedwars.getIcon(inventory.armor[5], true)
					else
						chestplatesquare.Image = ""
					end
					if inventory.armor[6] then
						bootssquare.Image = bedwars.getIcon(inventory.armor[6], true)
					else
						bootssquare.Image = ""
					end
				break
			end
		end)
		return oldupdate(tab, targetsize)
	end
end)

local function getBow()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if v5.itemType:find("bow") then 
			local tab = bedwars.ItemTable[v5.itemType].projectileSource
			local ammo = tab.projectileType("arrow")	
			local dmg = bedwars.ProjectileMeta[ammo].combat.damage
			if dmg > bestswordnum then
				bestswordnum = dmg
				bestswordslot = i5
				bestsword = v5
			end
		end
	end
	return bestsword, bestswordslot
end

local function getCustomItem(v2)
	local realitem = v2.itemType
	if realitem == "swords" then
		realitem = getSword() and getSword().itemType or "wood_sword"
	elseif realitem == "pickaxes" then
		realitem = getPickaxe() and getPickaxe().itemType or "wood_pickaxe"
	elseif realitem == "axes" then
		realitem = getAxe() and getAxe().itemType or "wood_axe"
	elseif realitem == "bows" then
		realitem = getBow() and getBow().itemType or "wood_bow"
	elseif realitem == "wool" then
		realitem = getwool() or "wool_white"
	end
	return realitem
end

local function findItemInTable(tab, item)
	for i,v in pairs(tab) do
		if v.itemType then
			local gottenitem, gottenitemnum = getItem(getCustomItem(v))
			if gottenitem and gottenitem.itemType == item.itemType then
				return i
			end
		end
	end
	return nil
end

task.spawn(function()
	repeat task.wait() until shared.VapeFullyLoaded
	if GuiLibrary.ObjectsThatCanBeSaved["Blatant modeToggle"]["Api"].Enabled then return end
	if AutoLeave.Enabled == false then
		AutoLeave.ToggleButton(false)
	end
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

SnoopyTxtPack = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
    ["Name"] = "Textures",
    ["Function"] = function(callback)
        if callback then
			Enabled = callback
            if Enabled then
                Connection = cam.Viewmodel.ChildAdded:Connect(function(v)
                    if v:FindFirstChild("Handle") then
                        pcall(function()
                            v:FindFirstChild("Handle").Size = v:FindFirstChild("Handle").Size / 1.5
                            v:FindFirstChild("Handle").Material = Enum.Material.SmoothPlastic
                            v:FindFirstChild("Handle").TextureID = "rbxassetid://12736332126"
                            v:FindFirstChild("Handle").Color = Color3.fromRGB(61, 21, 133)
                        end)
                        local vname = string.lower(v.Name)
                        if vname:find("sword") or vname:find("blade") then
                            v:FindFirstChild("Handle").MeshId = "rbxassetid://12741430220"
                        elseif vname:find("pick") then
                            v:FindFirstChild("Handle").MeshId = "rbxassetid://12342364179"
                        end
                    end
                end)
            else
                Connection:Disconnect()
			end
        end
    end
})

InfiniteJump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
    ["Name"] = "InfiniteJump",
    ["Function"] = function(callback)
        if callback then
			local InfiniteJumpEnabled = true
			game:GetService("UserInputService").JumpRequest:connect(function()
				if InfiniteJumpEnabled then
					game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
				end
			end)
        else
			InfiniteJumpEnabled = false
		end
    end
})

CustomSpaceSky = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
    ["Name"] = "SpaceSky",
    ["Function"] = function(callback)
        if callback then
			game.Lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=159454299"
            game.Lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=159454296"
            game.Lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=159454293"
            game.Lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=159454286"
            game.Lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=159454300"
            game.Lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=159454288"
            game.Lighting.FogColor = Color3.new(236, 88, 241)
            game.Lighting.FogEnd = "200"
            game.Lighting.FogStart = "0"
            game.Lighting.Ambient = Color3.new(0.5, 0, 1)
        else
			game.Lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=7018684000"
            game.Lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=6334928194"
            game.Lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=7018684000"
            game.Lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=7018684000"
            game.Lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=7018684000"
            game.Lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=7018689553"
            game.Lighting.FogColor = Color3.new(1, 1, 1)
            game.Lighting.FogEnd = "10000"
            game.Lighting.FogStart = "0"
            game.Lighting.Ambient = Color3.new(0, 0, 0)
        end
    end
})
