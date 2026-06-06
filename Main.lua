-- [[ 1. GitHub 界面框架：Main.lua (基于稳定版修改：星空色 + 修复悬浮球拖拽) ]]
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- 清理旧 UI
if CoreGui:FindFirstChild("AnimeLeagueUI") then
    CoreGui:FindFirstChild("AnimeLeagueUI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimeLeagueUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 缓存摄像机
local Camera = Workspace.CurrentCamera

-- 【完美星空色系：高级暗夜渐变】
local GalaxyColor = Color3.fromRGB(83, 58, 172)       -- 星空核心高贵蓝紫（代替原来的紫色）
local GalaxyDark = Color3.fromRGB(20, 18, 24)         -- 暗夜宇宙黑底色
local GalaxyTabBg = Color3.fromRGB(31, 28, 38)        -- 标签栏色调
local GalaxyBtnBg = Color3.fromRGB(41, 37, 51)        -- 页面按钮底色

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = GalaxyDark
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 9)
MainCorner.Parent = MainFrame

-- 创建一个悬浮小球（初始隐藏）- 全新星空色
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -24)
ToggleBtn.BackgroundColor3 = GalaxyColor
ToggleBtn.Text = "AL"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 15
ToggleBtn.Visible = false
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 24)
BtnCorner.Parent = ToggleBtn

-- 悬浮球的点击事件 (恢复主框架，隐藏自己)
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleBtn.Visible = false
end)

-- 【完美修复】给缩小悬浮球加上平滑移动逻辑 (同时锁视角)
local ballDragging, ballInput, ballStart, ballPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ballDragging = true
        ballStart = input.Position
        ballPos = ToggleBtn.Position
        
        if Camera then Camera.CameraType = Enum.CameraType.Scriptable end
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then 
                ballDragging = false 
                if Camera then Camera.CameraType = Enum.CameraType.Custom end
            end
        end)
    end
end)

ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        ballInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == ballInput and ballDragging then
        local delta = input.Position - ballStart
        ToggleBtn.Position = UDim2.new(ballPos.X.Scale, ballPos.X.Offset + delta.X, ballPos.Y.Scale, ballPos.Y.Offset + delta.Y)
    end
end)

-- 主大框架拖拽逻辑 (带防背景视角乱转)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        if Camera then Camera.CameraType = Enum.CameraType.Scriptable end
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then 
                dragging = false 
                if Camera then Camera.CameraType = Enum.CameraType.Custom end
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.Text = "ANIME LEAGUE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- 右侧关闭按钮 (×)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- 打叉左边的缩小按钮 (—)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -75, 0.5, -15)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Parent = TopBar

-- 缩小按钮点击事件 (隐藏主框架，显示左侧小悬浮球)
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
    if Camera then Camera.CameraType = Enum.CameraType.Custom end
end)

local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -32, 0, 38)
TabBar.Position = UDim2.new(0, 16, 0, 42)
TabBar.BackgroundColor3 = GalaxyTabBg
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 6)
TabBarCorner.Parent = TabBar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabListLayout.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 6)
TabPadding.Parent = TabBar

local PageContainer = Instance.new("Frame")
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1, -32, 1, -96)
PageContainer.Position = UDim2.new(0, 16, 0, 86)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local function CreateTab(tabName, order)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tabName .. "_Btn"
    TabBtn.Size = UDim2.new(0, 100, 0, 28)
    TabBtn.BackgroundColor3 = GalaxyBtnBg
    TabBtn.Text = tabName
    TabBtn.TextColor3 = Color3.fromRGB(170, 170, 175)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 12
    TabBtn.LayoutOrder = order
    TabBtn.Parent = TabBar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = TabBtn

    local Page = Instance.new("ScrollingFrame")
    Page.Name = tabName .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(70, 68, 80)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Parent = PageContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)
    PageLayout.Parent = Page

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 4)
    PagePadding.PaddingLeft = UDim.new(0, 2)
    PagePadding.PaddingRight = UDim.new(0, 4)
    PagePadding.Parent = Page

    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 12)
    end)

    TabButtons[tabName] = TabBtn
    Pages[tabName] = Page

    TabBtn.MouseButton1Click:Connect(function()
        for name, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = GalaxyBtnBg
            btn.TextColor3 = Color3.fromRGB(170, 170, 175)
        end
        for name, pg in pairs(Pages) do pg.Visible = false end
        TabBtn.BackgroundColor3 = GalaxyColor
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Page.Visible = true
    end)
end

local function CreateEmptyButton(tabName, order)
    local targetPage = Pages[tabName]
    if not targetPage then return end

    local RowFrame = Instance.new("Frame")
    RowFrame.Size = UDim2.new(1, 0, 0, 40)
    RowFrame.BackgroundColor3 = GalaxyTabBg
    RowFrame.BorderSizePixel = 0
    RowFrame.LayoutOrder = order
    RowFrame.Parent = targetPage

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 5)
    RowCorner.Parent = RowFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.Text = "1"
    Label.TextColor3 = Color3.fromRGB(235, 235, 240)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = RowFrame

    local ClickButton = Instance.new("TextButton")
    ClickButton.Size = UDim2.new(0, 85, 0, 26)
    ClickButton.Position = UDim2.new(1, -98, 0.5, -13)
    ClickButton.BackgroundColor3 = GalaxyBtnBg
    ClickButton.Text = "1"
    ClickButton.TextColor3 = Color3.fromRGB(200, 200, 205)
    ClickButton.Font = Enum.Font.GothamBold
    ClickButton.TextSize = 12
    ClickButton.Parent = RowFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = ClickButton
end

CreateTab("🌵 Main", 1)
CreateTab("🌱 Farming", 2)
CreateTab("👁️ Visuals", 3)
CreateTab("⚙️ Settings", 4)

for i = 1, 5 do CreateEmptyButton("🌵 Main", i) end
for i = 1, 4 do CreateEmptyButton("🌱 Farming", i) end
for i = 1, 4 do CreateEmptyButton("👁️ Visuals", i) end
for i = 1, 3 do CreateEmptyButton("⚙️ Settings", i) end

if TabButtons["🌵 Main"] then
    TabButtons["🌵 Main"].BackgroundColor3 = GalaxyColor
    TabButtons["🌵 Main"].TextColor3 = Color3.fromRGB(255, 255, 255)
    Pages["🌵 Main"].Visible = true
end
print("[ANIME LEAGUE] 星空星轨稳定版 UI 加载完毕！")
