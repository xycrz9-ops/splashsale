-- SETTINGS
local TITLE = "Splash"
local KEYS_URL = "https://raw.githubusercontent.com/xycrz9-ops/splashsale/refs/heads/main/keys.txt"
local MAIN_SCRIPT = "https://raw.githubusercontent.com/xycrz9-ops/splashsale/refs/heads/main/script.lua"
local GET_KEY_LINK = "" -- optional: put a link here to show a "Copy key link" button

local ACCENT = Color3.fromRGB(60, 190, 90)
local BG = Color3.fromRGB(18, 18, 22)
local FIELD = Color3.fromRGB(30, 30, 36)
local RED = Color3.fromRGB(235, 85, 85)
local GREY = Color3.fromRGB(150, 150, 160)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function checkKey(input)
    local ok, list = pcall(function() return game:HttpGet(KEYS_URL) end)
    if not ok then return false, "Could not reach key server" end
    input = input:gsub("%s", "")
    for line in list:gmatch("[^\r\n]+") do
        local key = line:gsub("%s", "")
        if key ~= "" and key == input then return true end
    end
    return false, "Invalid key"
end

local function round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
end

local function outline(obj, color)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = 1
    s.Parent = obj
end

local function tween(obj, props)
    TweenService:Create(obj, TweenInfo.new(0.15), props):Play()
end

local gui = Instance.new("ScreenGui")
gui.Name = "SplashKeyGui"
gui.ResetOnSpawn = false
gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 220)
frame.Position = UDim2.new(0.5, -160, 0.5, -110)
frame.BackgroundColor3 = BG
frame.BorderSizePixel = 0
frame.Parent = gui
round(frame, 12)
outline(frame, Color3.fromRGB(45, 45, 55))

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 24)
title.Position = UDim2.new(0, 20, 0, 14)
title.BackgroundTransparency = 1
title.Text = TITLE
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, -40, 0, 18)
sub.Position = UDim2.new(0, 20, 0, 40)
sub.BackgroundTransparency = 1
sub.Text = "Enter your key to continue"
sub.TextColor3 = GREY
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Font = Enum.Font.Gotham
sub.TextSize = 13
sub.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -38, 0, 10)
close.BackgroundTransparency = 1
close.Text = "X"
close.TextColor3 = GREY
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = frame
close.MouseEnter:Connect(function() tween(close, {TextColor3 = RED}) end)
close.MouseLeave:Connect(function() tween(close, {TextColor3 = GREY}) end)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -40, 0, 38)
box.Position = UDim2.new(0, 20, 0, 72)
box.BackgroundColor3 = FIELD
box.BorderSizePixel = 0
box.PlaceholderText = "Paste your key here"
box.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
box.Text = ""
box.TextColor3 = Color3.new(1, 1, 1)
box.ClearTextOnFocus = false
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.Parent = frame
round(box, 8)
outline(box, Color3.fromRGB(50, 50, 60))

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -40, 0, 38)
btn.Position = UDim2.new(0, 20, 0, 120)
btn.BackgroundColor3 = ACCENT
btn.BorderSizePixel = 0
btn.Text = "Verify key"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 15
btn.AutoButtonColor = false
btn.Parent = frame
round(btn, 8)
btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(75, 210, 108)}) end)
btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = ACCENT}) end)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -40, 0, 22)
status.Position = UDim2.new(0, 20, 0, 170)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = GREY
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.Parent = frame

local function setStatus(text, color)
    status.Text = text
    status.TextColor3 = color
end

if GET_KEY_LINK ~= "" and setclipboard then
    frame.Size = UDim2.new(0, 320, 0, 240)
    frame.Position = UDim2.new(0.5, -160, 0.5, -120)
    local get = Instance.new("TextButton")
    get.Size = UDim2.new(1, -40, 0, 20)
    get.Position = UDim2.new(0, 20, 0, 200)
    get.BackgroundTransparency = 1
    get.Text = "Copy key link"
    get.TextColor3 = ACCENT
    get.Font = Enum.Font.Gotham
    get.TextSize = 13
    get.Parent = frame
    get.MouseButton1Click:Connect(function()
        setclipboard(GET_KEY_LINK)
        setStatus("Link copied", ACCENT)
    end)
end

local busy = false
local function submit()
    if busy then return end
    if box.Text:gsub("%s", "") == "" then
        setStatus("Enter a key first", RED)
        return
    end
    busy = true
    setStatus("Checking...", GREY)
    local ok, err = checkKey(box.Text)
    if ok then
        setStatus("Key accepted", ACCENT)
        task.wait(0.6)
        gui:Destroy()
        loadstring(game:HttpGet(MAIN_SCRIPT))()
    else
        setStatus(err or "Invalid key", RED)
        busy = false
    end
end

btn.MouseButton1Click:Connect(submit)
box.FocusLost:Connect(function(enterPressed)
    if enterPressed then submit() end
end)

-- drag the window by holding the top area
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.Y - frame.AbsolutePosition.Y < 60 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
