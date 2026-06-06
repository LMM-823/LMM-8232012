-- [[ 1. GitHub 界面框架：基于你认可的最稳定版本修改 ]]
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 清理旧 UI
if CoreGui:FindFirstChild("AnimeLeagueUI") then CoreGui:FindFirstChild("AnimeLeagueUI"):Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "AnimeLeagueUI"; ScreenGui.ResetOnSpawn = false

-- 【星空美学配色】
local GalaxyColor = Color3.fromRGB(83, 58, 172)
local GalaxyDark = Color3.fromRGB(20, 18, 24)
local GalaxyBtnBg = Color3.fromRGB(41, 37, 51)

-- 【核心变量】
local SpeedVal = 50; local Noclip = false; local Fly = false; local FlySpeed = 50

-- 【功能驱动逻辑】
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if SpeedVal then hum.WalkSpeed = SpeedVal end
            if Noclip then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end
    end
end)

-- 飞行逻辑
local BG, BV = Instance.new("BodyGyro"), Instance.new("BodyVelocity")
BG.P = 9e4; BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if Fly and char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        BG.Parent = hrp; BV.Parent = hrp; BG.CFrame = Camera.CFrame
        BV.Velocity = (char:FindFirstChildOfClass("Humanoid").MoveDirection.Magnitude > 0) and (Camera.CFrame.LookVector * FlySpeed) or Vector3.zero
    else BG.Parent = nil; BV.Parent = nil end
end)

-- ==========================================
-- 🖼️ 稳定的 UI 框架
-- ==========================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 360); MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = GalaxyDark; MainFrame.BorderSizePixel = 0; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 9); MainFrame.Active = true

-- 悬浮球
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 48, 0, 48); ToggleBtn.Position = UDim2.new(0, 15, 0.5, -24); ToggleBtn.BackgroundColor3 = GalaxyColor
ToggleBtn.Text = "AL"; ToggleBtn.TextColor3 = Color3.new(1,1,1); ToggleBtn.Visible = false; Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 24)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; ToggleBtn.Visible = false; if Camera then Camera.CameraType = Enum.CameraType.Custom end end)

-- 【拖拽视角锁定逻辑】
local function setupDrag(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            if Camera then Camera.CameraType = Enum.CameraType.Scriptable end
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false; if Camera then Camera.CameraType = Enum.CameraType.Custom end end end)
end
setupDrag(MainFrame); setupDrag(ToggleBtn)

-- 页面管理
local Pages = {}
local PageContainer = Instance.new("Frame", MainFrame); PageContainer.Size = UDim2.new(1, -32, 1, -96); PageContainer.Position = UDim2.new(0, 16, 0, 86); PageContainer.BackgroundTransparency = 1

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", PageContainer); Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 6)
    Pages[name] = Page
end

local function AddBtn(tab, text, callback)
    local b = Instance.new("TextButton", Pages[tab]); b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = GalaxyBtnBg; b.Text = text; b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(callback)
end

CreatePage("Main"); CreatePage("Settings")

-- 注入功能
AddBtn("Main", "速度: 50 (切换)", function(b) SpeedVal = (SpeedVal == 50) and 100 or 50; b.Text = "速度: "..SpeedVal end)
AddBtn("Main", "穿墙 (Noclip): OFF", function(b) Noclip = not Noclip; b.Text = "穿墙: "..(Noclip and "ON" or "OFF") end)
AddBtn("Main", "飞行 (Fly): OFF", function(b) Fly = not Fly; b.Text = "飞行: "..(Fly and "ON" or "OFF") end)
AddBtn("Main", "自动连点器", function()
    local vim = game:GetService("VirtualInputManager")
    task.spawn(function() while true do vim:SendMouseButtonEvent(0,0,0,true,game,0); vim:SendMouseButtonEvent(0,0,0,false,game,0); task.wait(0.05) end end)
end)

AddBtn("Settings", "🔗 JOIN DISCORD", function() setclipboard("https://discord.gg/cjpezEZub") end)

-- 缩小与关闭
local MinBtn = Instance.new("TextButton", MainFrame); MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -40, 0, 5); MinBtn.Text = "—"; MinBtn.BackgroundColor3 = GalaxyBtnBg; MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; ToggleBtn.Visible = true end)
local CloseBtn = Instance.new("TextButton", MainFrame); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -75, 0, 5); CloseBtn.Text = "×"; CloseBtn.BackgroundColor3 = GalaxyBtnBg; CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

Pages["Main"].Visible = true
