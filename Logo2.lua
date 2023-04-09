local GuiLibrary = {}
local Gui = Instance.new("ScreenGui")
local EditGui = Instance.new("ScreenGui")
local WatermarkGui = Instance.new("ScreenGui")
local Keystrokes = Instance.new("ScreenGui")
local GameSave = shared["azuragame"]
local Azura = shared["azura"]
local ProtectUI = function(v)
    v.Name = game:GetService("HttpService"):GenerateGUID(false)
    if syn then syn.protect_gui(v) end
    if gethui then
        v.Parent = gethui()
    else
        v.Parent = game:GetService("CoreGui")
    end
end
Gui.ResetOnSpawn = false
Gui.Enabled = false
ProtectUI(Gui)
Gui.Name = 'blackazura'
EditGui.ResetOnSpawn = false
EditGui.Enabled = false
ProtectUI(EditGui)
WatermarkGui.ResetOnSpawn = false
WatermarkGui.Enabled = true
ProtectUI(WatermarkGui)
Keystrokes.ResetOnSpawn = false
Keystrokes.Enabled = false
ProtectUI(Keystrokes)
local Notifications = Instance.new("ScreenGui")
Notifications.ResetOnSpawn = false
ProtectUI(Notifications)
local LineFrm = Instance.new("Frame")
LineFrm.BackgroundTransparency = 1
LineFrm.AnchorPoint = Vector2.new(0.5, 0.5)
LineFrm.Size = UDim2.new(0, 932, 0, 0)
LineFrm.Position = UDim2.new(0.499, 0, -1, 0)
LineFrm.Parent = Gui
local UIL = Instance.new("UIListLayout")
UIL.FillDirection = Enum.FillDirection.Horizontal
UIL.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIL.SortOrder = Enum.SortOrder.LayoutOrder
UIL.Padding = UDim.new(0, 30)
UIL.Parent = LineFrm
local mainmark = Instance.new("TextLabel")
mainmark.TextStrokeTransparency = 0.75
mainmark.BackgroundTransparency = 1
mainmark.Size = UDim2.new(0, 250, 0, 85)
mainmark.Text = "EZHub"
mainmark.TextColor3 = Color3.fromRGB(255, 255, 255)
mainmark.TextScaled = true
mainmark.Font = Enum.Font.GothamMedium
mainmark.Parent = WatermarkGui
local markgrandient = Instance.new("UIGradient")
markgrandient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(180, 80, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(230, 120, 228))}
markgrandient.Parent = mainmark
local uidmark = mainmark:Clone()
uidmark.Text = "Version 5.2 | Owner Variation"
uidmark.Size = UDim2.new(0, 250, 0, 20)
uidmark.Position = UDim2.new(0, 0, 0.871, 0)
uidmark.Parent = mainmark
local infolabel = Instance.new("TextLabel")
infolabel.BackgroundTransparency = 0.3
infolabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
infolabel.BorderSizePixel = 0
infolabel.Size = UDim2.new(0, 1223, 0, 60)
infolabel.Font = Enum.Font.GothamMedium
infolabel.Text = "Made By EZHub Owner"
infolabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infolabel.Position = UDim2.new(0.126, 0, 0.881, 0)
infolabel.TextSize = 28
infolabel.TextXAlignment = Enum.TextXAlignment.Left
infolabel.TextYAlignment = Enum.TextYAlignment.Bottom
infolabel.Parent = Gui
