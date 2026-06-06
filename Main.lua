-- [[ 1. GitHub 界面框架：Main.lua (终极底层触控死锁视角 + 独立点击热区星空悬浮球) ]]
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- 清理旧 UI
if CoreGui:FindFirstChild("AnimeLeagueUI") then
    CoreGui:FindFirstChild("AnimeLeagueUI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimeLeagueUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- 【暗夜星空宇宙色系】
local GalaxyColor = Color3.fromRGB(83, 58, 172)       -- 星空璀璨蓝紫
local GalaxyDark = Color3.fromRGB(20, 18, 24)         -- 暗夜主色底框
local GalaxyTabBg = Color3.fromRGB(31, 28, 38)        -- 沉浸式标签底框
local GalaxyBtnBg = Color3.fromRGB(41, 37, 51)        -- 按钮底框

-- 临时存储原始相机参数（用于秒恢复）
local origMinDist, origMaxDist = 0.5, 70
if Camera then
    origMinDist = Camera.MinZoomDistance
    origMaxDist = Camera.MaxZoomDistance
end

-- ==========================================
-- 🔒 核心黑科技：移动端视角的绝对防御锁
-- ==========================================
local function LockCameraInPlace()
    if Camera then
        pcall(function()
            -- 暴力将相机的缩放距离锁死在当前的物理距离，系统彻底无法旋转和拉伸
            local currentDist = (Camera.CoordinateFrame.p - Camera.Focus.p).Magnitude
            Camera.MinZoomDistance = currentDist
            Camera.MaxZoomDistance = currentDist
            Camera.CameraType = Enum.CameraType.Scriptable
        end)
    end
end

local function UnlockCamera()
    if Camera then
        pcall(function()
            -- 完美一秒恢复玩家的自由视角
            Camera.CameraType = Enum.CameraType.Custom
            Camera.MinZoomDistance = origMinDist
            Camera.MaxZoomDistance = origMaxDist
        end)
    end
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = GalaxyDark
MainFrame.BorderSizePixel = 0
MainFrame.Active = true -- 拦截UI内部的点击
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 9)
MainCorner.Parent = MainFrame


-- ==========================================
-- 🚀 模块1：完美独立拖拽与点击的【星空悬浮球】
-- ==========================================
local ToggleBtn = Instance.new("Frame") -- 改用Frame做载体，防止Button底层的系统点按手势干扰拖拽
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -26)
ToggleBtn.BackgroundColor3 = GalaxyColor
ToggleBtn.Visible = false
ToggleBtn.Active = true
ToggleBtn.Parent = ScreenGui

local ballCorner = Instance.new("UICorner")
ballCorner.CornerRadius = UDim.new(0, 26)
ballCorner.Parent = ToggleBtn

-- 悬浮球中心的文字
local ballText = Instance.new("TextLabel")
ballText.Size = UDim2.new(1, 0, 1, 0)
ballText.BackgroundTransparency = 1
ballText.Text = "AL"
ballText.TextColor3 = Color3.fromRGB(255, 255, 255)
ballText.Font = Enum.Font.GothamBold
ballText.TextSize = 16
ballText.Parent = ToggleBtn

-- 【核心改进】：在悬浮球最上方覆盖一个专门用来点击的无触控穿透小按钮，点它100%秒回界面
local ClickArea = Instance.new("TextButton")
ClickArea.Size = UDim2.new(1, 0, 1, 0)
ClickArea.BackgroundTransparency = 1
ClickArea.Text = ""
ClickArea.ZIndex = 5 -- 确保在最上层
ClickArea.Parent = ToggleBtn

ClickArea.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleBtn.Visible = false
    UnlockCamera()
end)

-- 悬浮球的底层无视距安全拖拽逻辑
local ballDragging, ballInput, ballStart, ballPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ballDragging = true
        ballStart = input.Position
        ballPos = ToggleBtn.Position
        LockCameraInPlace() -- 手指碰到的瞬间，背景视角彻底死锁
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then 
                ballDragging = false 
                UnlockCamera() -- 放开手指，一秒放回视角
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


-- ==========================================
-- 🚀 模块2：主界面拖拽锁死背景视角逻辑
-- ==========================================
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        LockCameraInPlace() -- 开始拖大面板，视角死锁
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then 
                dragging = false 
                UnlockCamera() -- 拖完放开，视角恢复
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


-- ==========================================
-- 🚀 模块3：UI 顶栏与精确定位的缩放关闭按钮
-- ==========================================
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

-- 精准靠边：右侧关闭按钮 (×)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -16)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(165, 165, 170)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- 精准并排：靠在关闭按钮左侧的缩小按钮 (—)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -82, 0.5, -16)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(165, 165, 170)
MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Parent = TopBar

-- 缩小按钮点击
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
    UnlockCamera()
end)


-- ==========================================
-- 🚀 模块4：页面渲染与选项卡逻辑
-- ==========================================
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
    Page.ScrollBarImageColor3 = Color3.fromRGB(65, 60, 80)
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

print("[ANIME LEAGUE] 移动端绝对物理级防转视角 UI 已全面就绪！")
