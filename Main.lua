-- [[ 1. GitHub 界面框架：Main.lua (已完美修复拖拽视角与缩小按钮) ]]
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- 清理旧 UI
if CoreGui:FindFirstChild("AnimeLeagueUI") then
    CoreGui:FindFirstChild("AnimeLeagueUI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimeLeagueUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 缓存本地玩家控制模块 (用于彻底锁视角)
local LocalPlayer = Players.LocalPlayer
local PlayerModule
local success, err = pcall(function()
    PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
end)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(23, 21, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 9)
MainCorner.Parent = MainFrame

-- 创建一个悬浮小球（初始隐藏）
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(114, 70, 196)
ToggleBtn.Text = "AL"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 16
ToggleBtn.Visible = false
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 25)
BtnCorner.Parent = ToggleBtn

-- 悬浮球的点击事件 (显示主框架，隐藏自己)
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleBtn.Visible = false
end)

-- 优化后的防断触拖拽 + 彻底锁定角色/视角移动
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        -- 当开始拖动 UI 时，禁用游戏视角控制，防止角色和屏幕跟着转动
        if PlayerModule and PlayerModule.GetControls then
            pcall(function() PlayerModule:GetControls():Disable() end)
        end
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then 
                dragging = false 
                -- 放开手指时，恢复游戏视角和角色控制
                if PlayerModule and PlayerModule.GetControls then
                    pcall(function() PlayerModule:GetControls():Enable() end)
                end
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

-- 【新加】右侧打叉按钮 (×)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
CloseBtn.TextSize = 26
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- 【新加】打叉左边的缩小按钮 (—)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -76, 0.5, -16)  -- 正好排在关闭按钮的左边
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Parent = TopBar

-- 缩小按钮点击事件 (隐藏主框架，显示左侧小悬浮球)
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
end)

local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -32, 0, 38)
TabBar.Position = UDim2.new(0, 16, 0, 42)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 28, 36)
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
    TabBtn.BackgroundColor3 = Color3.fromRGB(38, 36, 44)
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
            btn.BackgroundColor3 = Color3.fromRGB(38, 36, 44)
            btn.TextColor3 = Color3.fromRGB(170, 170, 175)
        end
        for name, pg in pairs(Pages) do pg.Visible = false end
        TabBtn.BackgroundColor3 = Color3.fromRGB(114, 70, 196)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Page.Visible = true
    end)
end

local function CreateEmptyButton(tabName, order)
    local targetPage = Pages[tabName]
    if not targetPage then return end

    local RowFrame = Instance.new("Frame")
    RowFrame.Size = UDim2.new(1, 0, 0, 40)
    RowFrame.BackgroundColor3 = Color3.fromRGB(30, 28, 36)
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
    ClickButton.BackgroundColor3 = Color3.fromRGB(48, 45, 56)
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
    TabButtons["🌵 Main"].BackgroundColor3 = Color3.fromRGB(114, 70, 196)
    TabButtons["🌵 Main"].TextColor3 = Color3.fromRGB(255, 255, 255)
    Pages["🌵 Main"].Visible = true
end
print("[ANIME LEAGUE] 云端新版 UI 已经全部加载完毕！")
