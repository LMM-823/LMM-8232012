-- ==================== Main.lua ====================
-- 请确保已将 Core 上传并替换下方的 URL，或在本地环境直接加载
local Core = loadstring(game:HttpGet("https://github.com/LMM-823/LMM-8232012/blob/main/Core.lua"))()
local UI = Core.Load()

local _S = UI._S
local _M = UI._M
local _TB = UI._TB
local _Sidebar = UI._Sidebar
local _ContentContainer = UI._ContentContainer
local _HeaderLine = UI._HeaderLine
local _SplitLine = UI._SplitLine
local _Title = UI._Title
local _G_LMM_88 = UI._G_LMM_88
local Tween = UI.Tween

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _UIS = game:GetService("UserInputService")
local _TS = game:GetService("TweenService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- ==================== 页面创建系统 ====================
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

    local function RefreshScroll()
        task.defer(function()
            if not p or not p.Parent then return end
            pcall(function()
                local maxX = math.max(0, p.AbsoluteCanvasSize.X - p.AbsoluteWindowSize.X)
                local maxY = math.max(0, p.AbsoluteCanvasSize.Y - p.AbsoluteWindowSize.Y)
                p.CanvasPosition = Vector2.new(math.clamp(p.CanvasPosition.X,0,maxX), math.clamp(p.CanvasPosition.Y,0,maxY))
            end)
        end)
    end

    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RefreshScroll)
    p:GetPropertyChangedSignal("Visible"):Connect(function()
        if p.Visible then task.defer(function() task.wait() RefreshScroll() end) end
    end)
    p:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(RefreshScroll)
    return p
end

local _Page1 = _CreatePage(1)
local _Page2 = _CreatePage(2)
local _Page3 = _CreatePage(3)
local _Page4 = _CreatePage(4)
local _Page5 = _CreatePage(5)

local _Tabs = {}

local function _CreateTabBtn(name,order,targetPage)
    local b = Instance.new("TextButton")
    b.Parent = _Sidebar
    b.LayoutOrder = order
    b.Size = UDim2.new(1,0,0,36)
    b.BackgroundColor3 = (order == 1) and Color3.fromRGB(28,28,44) or Color3.fromRGB(16,16,26)
    b.BackgroundTransparency = (order == 1) and 0.15 or 0.6
    b.Text = "   " .. name
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    b.TextColor3 = (order == 1) and Color3.fromRGB(255,255,255) or Color3.fromRGB(150,150,170)
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.ZIndex = 22
    b.AutoButtonColor = false

    Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)

    local indicator = Instance.new("Frame")
    indicator.Parent = b
    indicator.Size = UDim2.new(0,3,0.5,0)
    indicator.Position = UDim2.new(0,0,0.25,0)
    indicator.BackgroundColor3 = Color3.fromRGB(129,140,248)
    indicator.BorderSizePixel = 0
    indicator.BackgroundTransparency = (order == 1) and 0 or 1
    indicator.ZIndex = 23
    Instance.new("UICorner",indicator).CornerRadius = UDim.new(1,0)

    _Tabs[b] = {page = targetPage, indicator = indicator, order = order}

    b.MouseButton1Click:Connect(function()
        for btn,data in pairs(_Tabs) do
            data.page.Visible = (btn == b)
            if btn == b then
                Tween(btn, {BackgroundColor3 = Color3.fromRGB(28,28,44), BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(255,255,255)}, 0.2)
                Tween(data.indicator, {BackgroundTransparency = 0, Size = UDim2.new(0,3,0.65,0), Position = UDim2.new(0,0,0.175,0)}, 0.2)
            else
                Tween(btn, {BackgroundColor3 = Color3.fromRGB(16,16,26), BackgroundTransparency = 0.6, TextColor3 = Color3.fromRGB(150,150,170)}, 0.2)
                Tween(data.indicator, {BackgroundTransparency = 1, Size = UDim2.new(0,3,0.5,0), Position = UDim2.new(0,0,0.25,0)}, 0.2)
            end
        end
    end)
end

_CreateTabBtn("🏠 主功能",1,_Page1)
_CreateTabBtn("⚡ 脚本合集(不要key)",2,_Page2)
_CreateTabBtn("🔑 脚本合集(要key)",3,_Page3)
_CreateTabBtn("📜 更新日志",4,_Page4)
_CreateTabBtn("⚙️ 设定中心",5,_Page5)

-- 其它小部件、组件加载和执行主循环与原脚本完全相同...
