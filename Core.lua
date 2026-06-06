-- [[ Anime League - Core.lua ]]

local _P = game:GetService("Players")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")

-- 清理旧 UI
if _CG:FindFirstChild("AnimeLeagueUI") then _CG.AnimeLeagueUI:Destroy() end

-- 初始化全局核心表
_G.AnimeLeagueCore = {}

-- 创建主 ScreenGui
local _S = Instance.new("ScreenGui", _CG)
_S.Name = "AnimeLeagueUI"
_S.ResetOnSpawn = false

-- 主框架
local _M = Instance.new("Frame", _S)
_M.Size = UDim2.new(0, 560, 0, 360)
_M.Position = UDim2.new(0.5, -280, 0.5, -180)
_M.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
_M.BorderSizePixel = 0
local _MC = Instance.new("UICorner", _M)
_MC.CornerRadius = UDim.new(0, 10)

-- 边框微光
local _Stroke = Instance.new("UIStroke", _M)
_Stroke.Thickness = 1
_Stroke.Color = Color3.fromRGB(45, 45, 50)
_Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 顶部栏
local _TopBar = Instance.new("Frame", _M)
_TopBar.Size = UDim2.new(1, 0, 0, 40)
_TopBar.BackgroundTransparency = 1

-- 标题
local _Title = Instance.new("TextLabel", _TopBar)
_Title.Size = UDim2.new(0, 200, 1, 0)
_Title.Position = UDim2.new(0, 15, 0, 0)
_Title.Text = "🌵 Anime League"
_Title.Font = "GothamBold"
_Title.TextSize = 16
_Title.TextColor3 = Color3.fromRGB(220, 220, 225)
_Title.TextXAlignment = Enum.TextXAlignment.Left
_Title.BackgroundTransparency = 1

-- 关闭按钮
local _CloseBtn = Instance.new("TextButton", _TopBar)
_CloseBtn.Size = UDim2.new(0, 30, 0, 30)
_CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
_CloseBtn.Text = "✕"
_CloseBtn.Font = "Gotham"
_CloseBtn.TextSize = 14
_CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
_CloseBtn.BackgroundTransparency = 1
_CloseBtn.MouseButton1Click:Connect(function() _S:Destroy() end)

-- 横向 Tab 栏容器
local _TabContainer = Instance.new("Frame", _M)
_TabContainer.Size = UDim2.new(1, -30, 0, 42)
_TabContainer.Position = UDim2.new(0, 15, 0, 40)
_TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
local _TCC = Instance.new("UICorner", _TabContainer)
_TCC.CornerRadius = UDim.new(0, 6)

local _TabLayout = Instance.new("UIListLayout", _TabContainer)
_TabLayout.FillDirection = Enum.FillDirection.Horizontal
_TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
_TabLayout.Padding = UDim.new(0, 5)
_TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- 页面容器
local _PageContainer = Instance.new("Frame", _M)
_PageContainer.Size = UDim2.new(1, -30, 1, -105)
_PageContainer.Position = UDim2.new(0, 15, 0, 92)
_PageContainer.BackgroundTransparency = 1

local _Pages = {}
local _TabButtons = {}

-- [[ 核心公开方法：创建横向分类 ]]
_G.AnimeLeagueCore.CreateTab = function(tabName, order)
    local page = Instance.new("ScrollingFrame", _PageContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    
    local listLayout = Instance.new("UIListLayout", page)
    listLayout.Padding = UDim.new(0, 8)
    listLayout.HorizontalAlignment = "Center"
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    _Pages[tabName] = page

    local btn = Instance.new("TextButton", _TabContainer)
    btn.LayoutOrder = order
    btn.Size = UDim2.new(0, 126, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    btn.Text = tabName
    btn.Font = "GothamBold"
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(140, 140, 150)
    local _BC = Instance.new("UICorner", btn)
    _BC.CornerRadius = UDim.new(0, 5)
    
    _TabButtons[tabName] = btn

    btn.MouseButton1Click:Connect(function()
        for k, p in pairs(_Pages) do p.Visible = (k == tabName) end
        for k, b in pairs(_TabButtons) do 
            if k == tabName then
                b.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                b.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                b.TextColor3 = Color3.fromRGB(140, 140, 150)
            end
        end
    end)
    
    -- 如果是第一个，默认激活
    if order == 1 then
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- [[ 核心公开方法：往指定页面添加空按钮 ]]
_G.AnimeLeagueCore.CreateButton = function(targetTab, order)
    local parentPage = _Pages[targetTab]
    if not parentPage then return end

    local btnFrame = Instance.new("Frame", parentPage)
    btnFrame.LayoutOrder = order
    btnFrame.Size = UDim2.new(1, -4, 0, 42)
    btnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    local _BFC = Instance.new("UICorner", btnFrame)
    _BFC.CornerRadius = UDim.new(0, 6)
    
    -- 名字全部叫 1
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Text = "1"
    label.Font = "GothamMedium"
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(210, 210, 215)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    -- 右侧无功能的外观按钮
    local clickArea = Instance.new("TextButton", btnFrame)
    clickArea.Size = UDim2.new(0, 70, 0, 26)
    clickArea.Position = UDim2.new(1, -82, 0.5, -13)
    clickArea.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
    clickArea.Text = "Button"
    clickArea.Font = "GothamBold"
    clickArea.TextSize = 12
    clickArea.TextColor3 = Color3.fromRGB(180, 180, 185)
    local _CAC = Instance.new("UICorner", clickArea)
    _CAC.CornerRadius = UDim.new(0, 4)
end

-- 拖动逻辑
local _drag, _dStart, _sPos
_TopBar.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
        _drag = true; _dStart = i.Position; _sPos = _M.Position 
    end 
end)
_UIS.InputChanged:Connect(function(i) 
    if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
        local d = i.Position - _dStart
        _M.Position = UDim2.new(_sPos.X.Scale, _sPos.X.Offset + d.X, _sPos.Y.Scale, _sPos.Y.Offset + d.Y) 
    end 
end)
_UIS.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = false end 
end)

print("[Anime League] Core UI 加载成功！")
