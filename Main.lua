-- [[ 1. GitHub 界面框架：全新 Neon Dark 极简极速版 ]]
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Camera = Workspace.CurrentCamera

-- 清理旧 UI
if CoreGui:FindFirstChild("NeonUI") then CoreGui:FindFirstChild("NeonUI"):Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "NeonUI"; ScreenGui.ResetOnSpawn = false

-- 【Neon 配色方案】
local Colors = {
    Bg = Color3.fromRGB(15, 15, 20),
    Tab = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(0, 255, 170), -- 霓虹绿
    Text = Color3.fromRGB(230, 230, 230)
}

-- 核心主界面
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 300); MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Colors.Bg; MainFrame.BorderSizePixel = 0; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
MainFrame.ClipsDescendants = true; MainFrame.Active = true; MainFrame.Draggable = true

-- 标题栏
local Title = Instance.new("TextLabel", MainFrame); Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundTransparency = 1
Title.Text = "NEON HUB | v1.0"; Title.TextColor3 = Colors.Accent; Title.Font = Enum.Font.GothamBold; Title.TextSize = 18

-- 关闭按钮
local CloseBtn = Instance.new("TextButton", Title); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "×"; CloseBtn.BackgroundTransparency = 1; CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- 内容区域
local PageContainer = Instance.new("ScrollingFrame", MainFrame); PageContainer.Size = UDim2.new(1, -20, 1, -50); PageContainer.Position = UDim2.new(0, 10, 0, 45)
PageContainer.BackgroundTransparency = 1; PageContainer.ScrollBarThickness = 2; Instance.new("UIListLayout", PageContainer).Padding = UDim.new(0, 8)

-- 极简按钮封装
local function AddFeature(text, callback)
    local b = Instance.new("TextButton", PageContainer); b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Colors.Tab
    b.Text = text; b.TextColor3 = Colors.Text; b.Font = Enum.Font.Gotham; b.TextSize = 14; b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(callback)
    
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(35, 35, 50) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Colors.Tab end)
end

-- 功能逻辑注入
local Speed = 50
AddFeature("⚡ 速度切换 (50/100)", function(b) Speed = (Speed == 50) and 100 or 50; LocalPlayer.Character.Humanoid.WalkSpeed = Speed; b.Text = "当前速度: "..Speed end)
AddFeature("🛡️ 穿墙 (Noclip)", function(b) 
    RunService.Stepped:Connect(function() for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end)
    b.Text = "已开启穿墙"
end)
AddFeature("🔗 Discord", function() setclipboard("https://discord.gg/cjpezEZub") end)

print("Neon UI 加载成功")
