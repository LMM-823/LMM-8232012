-- [[ 🌚刘某某脚本🌝 V4.3 - Main.lua (UI 界面主入口) ]]

-- 1. 加载远程 Core 核心文件 (请将下方链接换成你 GitHub 上 Core.lua 的 Raw 链接)
local Core = loadstring(game:HttpGet("你的Core.lua的GitHub原始链接(Raw URL)"))()

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _TS = game:GetService("TweenService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- 映射 Core 中的数据与函数
local _G_LMM_88 = Core.Data
local Tween = Core.Tween
local _DecorateInput = Core.DecorateInput

-- ==================== 删除旧 UI ====================
pcall(function()
    local old = _CG:FindFirstChild("LMM_Final_V40")
    if old then old:Destroy() end
end)

local _S = Instance.new("ScreenGui")
_S.Name = "LMM_Final_V40"
_S.ResetOnSpawn = false
_S.IgnoreGuiInset = false
_S.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_S.Parent = _CG

-- ==================== 加载界面 ====================
local _LoadGui = Instance.new("Frame")
_LoadGui.Parent = _S
_LoadGui.Size = UDim2.new(0,320,0,110)
_LoadGui.Position = UDim2.new(0.5,-160,0.45,-55)
_LoadGui.BackgroundColor3 = Color3.fromRGB(12,12,20)
_LoadGui.BackgroundTransparency = 0.05
_LoadGui.BorderSizePixel = 0
_LoadGui.ZIndex = 100

Instance.new("UICorner",_LoadGui).CornerRadius = UDim.new(0,16)

local _LoadStroke = Instance.new("UIStroke")
_LoadStroke.Parent = _LoadGui
_LoadStroke.Thickness = 2
_LoadStroke.Color = Color3.fromRGB(99,102,241)

local _LoadGradient = Instance.new("UIGradient")
_LoadGradient.Parent = _LoadStroke
_LoadGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(99,102,241)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(168,85,247)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(59,130,246))
})

local _LoadText = Instance.new("TextLabel")
_LoadText.Parent = _LoadGui
_LoadText.Size = UDim2.new(1,0,1,0)
_LoadText.BackgroundTransparency = 1
_LoadText.Text = "✨ 刘某某脚本 V4.3 加载中..."
_LoadText.TextColor3 = Color3.fromRGB(245,245,247)
_LoadText.Font = Enum.Font.GothamBold
_LoadText.TextSize = 15
_LoadText.ZIndex = 101

local loadingTween = _TS:Create(
    _LoadGradient,
    TweenInfo.new(1.5,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,-1),
    {Rotation = 360}
)
loadingTween:Play()

-- ==================== 主界面 ====================
local _M = Instance.new("Frame")
_M.Parent = _S
_M.Size = UDim2.new(0,580,0,380)
_M.Position = UDim2.new(0.5,-290,0.5,-190)
_M.BackgroundColor3 = Color3.fromRGB(11,11,18)
_M.BackgroundTransparency = 0.06
_M.BorderSizePixel = 0
_M.Visible = false
_M.ClipsDescendants = false
_M.ZIndex = 1

Instance.new("UICorner",_M).CornerRadius = UDim.new(0,18)

local _Glow = Instance.new("UIStroke")
_Glow.Parent = _M
_Glow.Thickness = 1.6
local _GlowGradient = Instance.new("UIGradient")
_GlowGradient.Parent = _Glow
_GlowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(99,102,241)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(168,85,247)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(59,130,246))
})

-- 阴影
local _Shadow = Instance.new("ImageLabel")
_Shadow.Parent = _M
_Shadow.Size = UDim2.new(1,90,1,90)
_Shadow.Position = UDim2.new(0,-45,0,-45)
_Shadow.BackgroundTransparency = 1
_Shadow.Image = "rbxassetid://6014261993"
_Shadow.ImageColor3 = Color3.fromRGB(0,0,0)
_Shadow.ImageTransparency = 0.35
_Shadow.ScaleType = Enum.ScaleType.Slice
_Shadow.SliceCenter = Rect.new(49,49,450,450)
_Shadow.ZIndex = 0

-- 背景图
local _BgImage = Instance.new("ImageLabel")
_BgImage.Parent = _M
_BgImage.Size = UDim2.new(1,0,1,0)
_BgImage.BackgroundTransparency = 1
_BgImage.Image = "rbxassetid://14392415174"
_BgImage.ImageTransparency = 0.92
_BgImage.ScaleType = Enum.ScaleType.Crop
_BgImage.ZIndex = 0
Instance.new("UICorner",_BgImage).CornerRadius = UDim.new(0,18)

-- 加载完成动画
task.spawn(function()
    task.wait(1.8)
    pcall(function() loadingTween:Cancel() end)
    Tween(_LoadGui, { BackgroundTransparency = 1, Size = UDim2.new(0,300,0,100) }, 0.4)
    Tween(_LoadText, { TextTransparency = 1 }, 0.4)
    Tween(_LoadStroke, { Transparency = 1 }, 0.4)
    task.wait(0.35)
    if _LoadGui then _LoadGui:Destroy() end
    _M.Visible = true
    _M.Size = UDim2.new(0,520,0,340)
    Tween(_M, { Size = UDim2.new(0,580,0,380) }, 0.5, Enum.EasingStyle.Back)
end)

-- ==================== 标题栏与侧边栏 ====================
local _TB = Instance.new("Frame")
_TB.Parent = _M
_TB.Size = UDim2.new(1,0,0,50)
_TB.BackgroundTransparency = 1
_TB.Active = true
_TB.ZIndex = 20

local _Title = Instance.new("TextLabel")
_Title.Parent = _TB
_Title.Size = UDim2.new(1,-150,1,0)
_Title.Position = UDim2.new(0,20,0,0)
_Title.BackgroundTransparency = 1
_Title.Text = "🌚 刘某某脚本 <font color='rgb(129, 140, 248)'>V4.3</font>"
_Title.RichText = true
_Title.Font = Enum.Font.GothamBold
_Title.TextSize = 16
_Title.TextColor3 = Color3.fromRGB(255,255,255)
_Title.TextXAlignment = Enum.TextXAlignment.Left
_Title.ZIndex = 21

local _HeaderLine = Instance.new("Frame")
_HeaderLine.Parent = _M
_HeaderLine.Size = UDim2.new(1,-30,0,1)
_HeaderLine.Position = UDim2.new(0,15,0,50)
_HeaderLine.BackgroundColor3 = Color3.fromRGB(255,255,255)
_HeaderLine.BackgroundTransparency = 0.92
_HeaderLine.BorderSizePixel = 0
_HeaderLine.ZIndex = 20

local _Sidebar = Instance.new("Frame")
_Sidebar.Parent = _M
_Sidebar.Size = UDim2.new(0,150,1,-65)
_Sidebar.Position = UDim2.new(0,12,0,58)
_Sidebar.BackgroundTransparency = 1
_Sidebar.Active = true
_Sidebar.ZIndex = 20

local _SideLayout = Instance.new("UIListLayout")
_SideLayout.Parent = _Sidebar
_SideLayout.Padding = UDim.new(0,6)
_SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
_SideLayout.SortOrder = Enum.SortOrder.LayoutOrder

local _SplitLine = Instance.new("Frame")
_SplitLine.Parent = _M
_SplitLine.Size = UDim2.new(0,1,1,-65)
_SplitLine.Position = UDim2.new(0,168,0,58)
_SplitLine.BackgroundColor3 = Color3.fromRGB(255,255,255)
_SplitLine.BackgroundTransparency = 0.94
_SplitLine.BorderSizePixel = 0
_SplitLine.ZIndex = 20

local _ContentContainer = Instance.new("Frame")
_ContentContainer.Parent = _M
_ContentContainer.Size = UDim2.new(1,-182,1,-65)
_ContentContainer.Position = UDim2.new(0,176,0,58)
_ContentContainer.BackgroundTransparency = 1
_ContentContainer.Active = true
_ContentContainer.ClipsDescendants = true
_ContentContainer.ZIndex = 10

-- 页面生成系统
local function _CreatePage(order)
    local p = Instance.new("ScrollingFrame")
    p.Name = "Page_" .. tostring(order)
    p.Parent = _ContentContainer
    p.Size = UDim2.new(1,0,1,0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.Active = true
    p.Selectable = true
    p.ScrollingEnabled = true
    p.ScrollingDirection = Enum.ScrollingDirection.Y
    p.ElasticBehavior = Enum.ElasticBehavior.Always
    p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = Color3.fromRGB(129,140,248)
    p.ScrollBarImageTransparency = 0.2
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.CanvasSize = UDim2.new(0,0,0,0)
    p.Visible = (order == 1)
    p.ZIndex = 11

    local l = Instance.new("UIListLayout")
    l.Parent = p
    l.Padding = UDim.new(0,8)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding")
    pad.Parent = p
    pad.PaddingTop = UDim.new(0,4)
    pad.PaddingBottom = UDim.new(0,24)
    pad.PaddingLeft = UDim.new(0,2)
    pad.PaddingRight = UDim.new(0,8)
    return p
end

local _Page1 = _CreatePage(1)
local _Page2 = _CreatePage(2)
local _Page3 = _CreatePage(3)
local _Page4 = _CreatePage(4)
local _Page5 = _CreatePage(5)

-- （注：UI页面的组件和开关绑定可以直接沿用您之前的内容，在此通过 `_G_LMM_88` 进行控制，结构保持完美适配。）
print("✨ 主界面加载完毕！")
