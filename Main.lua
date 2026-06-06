-- [[ 1. GitHub 界面框架：极致复刻截图质感版 ]]
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if CoreGui:FindFirstChild("AnimeLeagueUI") then CoreGui:FindFirstChild("AnimeLeagueUI"):Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "AnimeLeagueUI"; ScreenGui.ResetOnSpawn = false
local ShieldFrame = Instance.new("TextButton", ScreenGui); ShieldFrame.Size = UDim2.new(1,0,1,0); ShieldFrame.BackgroundTransparency = 1; ShieldFrame.Text = ""; ShieldFrame.Modal = true; ShieldFrame.Visible = false

-- 【质感色彩体系】
local BGColor = Color3.fromRGB(18, 18, 22)      -- 深邃底色
local TabColor = Color3.fromRGB(28, 28, 35)      -- 标签栏暗色
local BtnColor = Color3.fromRGB(38, 38, 48)      -- 按钮块色彩
local Accent = Color3.fromRGB(135, 95, 230)      -- 高级紫/蓝强调色

-- 主界面 (极度复刻圆角与比例)
local MainFrame = Instance.new("Frame", ScreenGui); MainFrame.Size = UDim2.new(0, 500, 0, 320); MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = BGColor; MainFrame.BorderSizePixel = 0; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)
MainFrame.Active = true

-- 拖拽逻辑 (顶级丝滑)
local function setupDrag(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position; ShieldFrame.Visible = true
            if Camera then Camera.CameraType = Enum.CameraType.Scriptable end
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart; obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragging = false; ShieldFrame.Visible = false; if Camera then Camera.CameraType = Enum.CameraType.Custom end 
        end
    end)
end
setupDrag(MainFrame)

-- 标签栏布局 (高度仿照截图)
local TabBar = Instance.new("Frame", MainFrame); TabBar.Size = UDim2.new(1, -30, 0, 45); TabBar.Position = UDim2.new(0, 15, 0, 15); TabBar.BackgroundColor3 = TabColor; Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 12)
local PageContainer = Instance.new("ScrollingFrame", MainFrame); PageContainer.Size = UDim2.new(1, -30, 1, -80); PageContainer.Position = UDim2.new(0, 15, 0, 70); PageContainer.BackgroundTransparency = 1; Instance.new("UIListLayout", PageContainer).Padding = UDim.new(0, 8)

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", TabBar); TabBtn.Size = UDim2.new(0.23, 0, 0.8, 0); TabBtn.BackgroundColor3 = BtnColor; TabBtn.Text = name; TabBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
    local Page = Instance.new("ScrollingFrame", PageContainer); Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    TabBtn.MouseButton1Click:Connect(function() for _,p in pairs(PageContainer:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end; Page.Visible = true end)
    return Page
end

local MainTab = CreateTab("Main")
local SettingsTab = CreateTab("Settings")

-- 极简按钮复刻
local function AddB(p, t, c)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = BtnColor; b.Text = t; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8); b.MouseButton1Click:Connect(c)
end

AddB(MainTab, "⚡ 速度: 50", function(b) SpeedVal = (SpeedVal == 50) and 100 or 50; b.Text = "速度: "..SpeedVal end)
AddB(MainTab, "🛡️ 穿墙 (Noclip)", function() end)
AddB(SettingsTab, "🔗 JOIN DISCORD", function() setclipboard("https://discord.gg/cjpezEZub") end)

MainTab.Visible = true
