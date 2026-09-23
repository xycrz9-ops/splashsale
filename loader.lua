local KEYS_URL = "https://raw.githubusercontent.com/xycrz9-ops/splashsale/refs/heads/main/keys.txt"
local MAIN_SCRIPT = "https://raw.githubusercontent.com/xycrz9-ops/splashsale/refs/heads/main/script.lua"

local function checkKey(input)
    local ok, list = pcall(function() return game:HttpGet(KEYS_URL) end)
    if not ok then return false end
    input = input:gsub("%s", "")
    for line in list:gmatch("[^\r\n]+") do
        local key = line:gsub("%s", "")
        if key ~= "" and key == input then return true end
    end
    return false
end

local gui = Instance.new("ScreenGui")
gui.Name = "KeyGui"
gui.ResetOnSpawn = false
gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0.5, -150, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1, -20, 0, 35)
box.Position = UDim2.new(0, 10, 0, 15)
box.PlaceholderText = "Enter your key"
box.Text = ""

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, -20, 0, 35)
btn.Position = UDim2.new(0, 10, 0, 65)
btn.Text = "Check key"

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 115)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1, 1, 1)
status.Text = ""

btn.MouseButton1Click:Connect(function()
    status.Text = "Checking..."
    if checkKey(box.Text) then
        gui:Destroy()
        loadstring(game:HttpGet(MAIN_SCRIPT))()
    else
        status.Text = "Invalid key"
    end
end)
