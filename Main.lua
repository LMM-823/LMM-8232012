-- [[ 刘某某脚本 V4.1.9 (beta) | ESP 透视强力穿透修复版 ]]

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _TS = game:GetService("TweenService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

local _G_LMM_88 = { 
    v_0x1 = false, v_0x2 = false, v_0x3 = false, v_val_1 = 50, 
    v_0x4 = false, v_val_2 = 50, v_esp_line = false, v_esp_box = false,
    v_freeze = false, v_infjump = false,
    c_esp = Color3.fromRGB(99, 102, 241), c_line = Color3.fromRGB(99, 102, 241), c_box = Color3.fromRGB(99, 102, 241)
}

local function Tween(obj, props, time, style, dir)
    if not obj then return end
    _TS:Create(obj, TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

if _CG:FindFirstChild("LMM_Final_V400") then _CG.LMM_Final_V400:Destroy() end
local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V400"
_S.ResetOnSpawn = false
_S.DisplayOrder = 9999

-- ==================== 右下角通知管理（往上依次堆叠） ====================
local activeNotifications = {}

local function UpdateNotificationPositions()
    for i, cardData in ipairs(activeNotifications) do
        local targetY = -85 - ((i - 1) * 75)
        Tween(cardData.Card, {Position = UDim2.new(1, -275, 1, targetY)}, 0.3)
    end
end

local function ShowNotification(title, desc)
    local notifGui = Instance.new("ScreenGui", _CG)
    notifGui.Name = "LMM_Notification"
    notifGui.ResetOnSpawn = false
    notifGui.DisplayOrder = 2147483647
    notifGui.IgnoreGuiInset = true

    local card = Instance.new("Frame", notifGui)
    card.Size = UDim2.new(0, 260, 0, 65)
    card.Position = UDim2.new(1, 280, 1, -85)
    card.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
    card.BackgroundTransparency = 0.25
    card.BorderSizePixel = 0
    card.ZIndex = 10000000
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.Size = UDim2.new(1, -20, 0, 24)
    titleLbl.Position = UDim2.new(0, 12, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 10000001

    local descLbl = Instance.new("TextLabel", card)
    descLbl.Size = UDim2.new(1, -20, 0, 20)
    descLbl.Position = UDim2.new(0, 12, 0, 34)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = desc
    descLbl.TextColor3 = Color3.fromRGB(170, 170, 195)
    descLbl.Font = Enum.Font.GothamMedium
    descLbl.TextSize = 11
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.ZIndex = 10000001

    local notifData = {Card = card, Gui = notifGui}
    table.insert(activeNotifications, 1, notifData)
    UpdateNotificationPositions()

    task.spawn(function()
        task.wait(2.5)
        for idx, item in ipairs(activeNotifications) do
            if item == notifData then
                table.remove(activeNotifications, idx)
                break
            end
        end
        UpdateNotificationPositions()
        Tween(card, {Position = UDim2.new(1, 280, 1, card.Position.Y.Offset)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        notifGui:Destroy()
    end)
end

-- ==================== 开场加载动画 ====================
local _LoadGui = Instance.new("Frame", _S)
_LoadGui.Size = UDim2.new(0, 320, 0, 100); _LoadGui.Position = UDim2.new(0.5, -160, 0.45, -50)
_LoadGui.BackgroundColor3 = Color3.fromRGB(12, 12, 20); _LoadGui.BackgroundTransparency = 0.15; _LoadGui.BorderSizePixel = 0; _LoadGui.ZIndex = 10
Instance.new("UICorner", _LoadGui).CornerRadius = UDim.new(0, 16)

local _BarBg = Instance.new("Frame", _LoadGui)
_BarBg.Size = UDim2.new(0.85, 0, 0, 6); _BarBg.Position = UDim2.new(0.075, 0, 0.7, 0)
_BarBg.BackgroundColor3 = Color3.fromRGB(25, 25, 40); _BarBg.BorderSizePixel = 0; _BarBg.ZIndex = 11
Instance.new("UICorner", _BarBg).CornerRadius = UDim.new(1, 0)

local _BarFill = Instance.new("Frame", _BarBg)
_BarFill.Size = UDim2.new(0, 0, 1, 0); _BarFill.BackgroundColor3 = Color3.fromRGB(129, 140, 248); _BarFill.BorderSizePixel = 0; _BarFill.ZIndex = 12
Instance.new("UICorner", _BarFill).CornerRadius = UDim.new(1, 0)

local _LoadText = Instance.new("TextLabel", _LoadGui)
_LoadText.Size = UDim2.new(1, 0, 0, 30); _LoadText.Position = UDim2.new(0, 0, 0.25, -15); _LoadText.BackgroundTransparency = 1; _LoadText.ZIndex = 11
_LoadText.Text = "刘某某脚本 V4.1.9 加载中..."; _LoadText.TextColor3 = Color3.fromRGB(245, 245, 247); _LoadText.Font = Enum.Font.GothamBold; _LoadText.TextSize = 14

Tween(_BarFill, {Size = UDim2.new(1, 0, 1, 0)}, 1.4, Enum.EasingStyle.Quart)

-- ==================== 主界面容器 ====================
local _M = Instance.new("Frame", _S)
_M.Size = UDim2.new(0, 580, 0, 380); _M.Position = UDim2.new(0.5, -290, 0.5, -190)
_M.BackgroundColor3 = Color3.fromRGB(9, 9, 15); _M.BackgroundTransparency = 0.35; _M.BorderSizePixel = 0; _M.Visible = false
_M.ClipsDescendants = true
Instance.new("UICorner", _M).CornerRadius = UDim.new(0, 18)

local _Shadow = Instance.new("ImageLabel", _M)
_Shadow.Size = UDim2.new(1, 100, 1, 100); _Shadow.Position = UDim2.new(0, -50, 0, -50)
_Shadow.BackgroundTransparency = 1; _Shadow.Image = "rbxassetid://6014261993"
_Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0); _Shadow.ImageTransparency = 0.4
_Shadow.ScaleType = Enum.ScaleType.Slice; _Shadow.SliceCenter = Rect.new(49, 49, 450, 450); _Shadow.ZIndex = -1

local _BgImage = Instance.new("ImageLabel", _M)
_BgImage.Size = UDim2.new(1, 0, 1, 0); _BgImage.BackgroundTransparency = 1
_BgImage.Image = "rbxassetid://5430597512"; _BgImage.ImageTransparency = 0.15
_BgImage.ScaleType = Enum.ScaleType.Crop; _BgImage.ZIndex = 0
Instance.new("UICorner", _BgImage).CornerRadius = UDim.new(0, 18)

task.spawn(function()
    task.wait(1.5)
    Tween(_LoadGui, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.45, 0), BackgroundTransparency = 1}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    Tween(_LoadText, {TextTransparency = 1}, 0.25)
    Tween(_BarBg, {BackgroundTransparency = 1}, 0.25)
    Tween(_BarFill, {BackgroundTransparency = 1}, 0.25)
    task.wait(0.35)
    _LoadGui:Destroy()
    
    _M.Visible = true
    _M.Size = UDim2.new(0, 520, 0, 340)
    Tween(_M, {Size = UDim2.new(0, 580, 0, 380)}, 0.4, Enum.EasingStyle.Back)
end)

local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 50); _TB.BackgroundTransparency = 1; _TB.Active = true; _TB.ZIndex = 2
local _Title = Instance.new("TextLabel", _TB)
_Title.Size = UDim2.new(1, -150, 1, 0); _Title.Position = UDim2.new(0, 20, 0, 0); _Title.Text = "刘某某脚本 <font color='rgb(129, 140, 248)'>V4.1.9 (beta)</font>"; _Title.RichText = true; _Title.Font = Enum.Font.GothamBold; _Title.TextSize = 15; _Title.TextColor3 = Color3.fromRGB(255, 255, 255); _Title.BackgroundTransparency = 1; _Title.TextXAlignment = Enum.TextXAlignment.Left; _Title.ZIndex = 2

local _HeaderLine = Instance.new("Frame", _M)
_HeaderLine.Size = UDim2.new(1, -30, 0, 1); _HeaderLine.Position = UDim2.new(0, 15, 0, 50)
_HeaderLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255); _HeaderLine.BackgroundTransparency = 0.90; _HeaderLine.BorderSizePixel = 0; _HeaderLine.ZIndex = 2

local _Sidebar = Instance.new("Frame", _M)
_Sidebar.Size = UDim2.new(0, 150, 1, -65); _Sidebar.Position = UDim2.new(0, 12, 0, 58); _Sidebar.BackgroundTransparency = 1; _Sidebar.ZIndex = 2
local _SideLayout = Instance.new("UIListLayout", _Sidebar)
_SideLayout.Padding = UDim.new(0, 6); _SideLayout.HorizontalAlignment = "Center"; _SideLayout.SortOrder = "LayoutOrder"

local _SplitLine = Instance.new("Frame", _M)
_SplitLine.Size = UDim2.new(0, 1, 1, -65); _SplitLine.Position = UDim2.new(0, 168, 0, 58)
_SplitLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255); _SplitLine.BackgroundTransparency = 0.92; _SplitLine.BorderSizePixel = 0; _SplitLine.ZIndex = 2

local _ContentContainer = Instance.new("Frame", _M)
_ContentContainer.Size = UDim2.new(1, -182, 1, -65); _ContentContainer.Position = UDim2.new(0, 176, 0, 58); _ContentContainer.BackgroundTransparency = 1; _ContentContainer.ZIndex = 2
_ContentContainer.ClipsDescendants = true

local function _CreatePage(order)
    local p = Instance.new("ScrollingFrame", _ContentContainer)
    p.Size = UDim2.new(1, 0, 1, 0); p.Position = UDim2.new(0, 0, 0, 0)
    p.BackgroundTransparency = 1; p.BorderSizePixel = 0; p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = Color3.fromRGB(129, 140, 248); p.ScrollBarImageTransparency = 0.2
    p.Active = true; p.ScrollingDirection = Enum.ScrollingDirection.Y
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.Visible = (order == 1); p.ZIndex = 2

    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0, 8); l.HorizontalAlignment = Enum.HorizontalAlignment.Center; l.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad = Instance.new("UIPadding", p)
    pad.PaddingRight = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 12)
    return p
end

local _Page1 = _CreatePage(1); local _Page2 = _CreatePage(2); local _Page5 = _CreatePage(3); local _Page6 = _CreatePage(4); local _Page3 = _CreatePage(5); local _Page4 = _CreatePage(6)
local _Tabs = {}

local function _CreateTabBtn(name, order, targetPage)
    local b = Instance.new("TextButton", _Sidebar)
    b.LayoutOrder = order; b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = (order == 1) and Color3.fromRGB(30, 30, 48) or Color3.fromRGB(15, 15, 24)
    b.BackgroundTransparency = (order == 1) and 0.35 or 0.75
    b.Text = "   " .. name; b.Font = Enum.Font.GothamMedium; b.TextSize = 11
    b.TextColor3 = (order == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 200)
    b.TextXAlignment = Enum.TextXAlignment.Left; b.ZIndex = 2; b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
    
    local indicator = Instance.new("Frame", b)
    indicator.Size = UDim2.new(0, 3, 0.5, 0); indicator.Position = UDim2.new(0, 0, 0.25, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(129, 140, 248); indicator.BorderSizePixel = 0
    indicator.BackgroundTransparency = (order == 1) and 0 or 1
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    _Tabs[b] = {page = targetPage, indicator = indicator, order = order}
    
    b.MouseEnter:Connect(function()
        if _Tabs[b].page.Visible then return end
        Tween(b, {BackgroundColor3 = Color3.fromRGB(24, 24, 38), BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(220, 220, 240)}, 0.2)
    end)
    b.MouseLeave:Connect(function()
        if _Tabs[b].page.Visible then return end
        Tween(b, {BackgroundColor3 = Color3.fromRGB(15, 15, 24), BackgroundTransparency = 0.75, TextColor3 = Color3.fromRGB(180, 180, 200)}, 0.2)
    end)
    b.MouseButton1Click:Connect(function()
        for btn, data in pairs(_Tabs) do
            data.page.Visible = (btn == b)
            if btn == b then
                Tween(btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 48), BackgroundTransparency = 0.35, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                Tween(data.indicator, {BackgroundTransparency = 0, Size = UDim2.new(0, 3, 0.65, 0), Position = UDim2.new(0, 0, 0.175, 0)}, 0.2)
            else
                Tween(btn, {BackgroundColor3 = Color3.fromRGB(15, 15, 24), BackgroundTransparency = 0.75, TextColor3 = Color3.fromRGB(180, 180, 200)}, 0.2)
                Tween(data.indicator, {BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0.5, 0), Position = UDim2.new(0, 0, 0.25, 0)}, 0.2)
            end
        end
    end)
end

_CreateTabBtn("主功能", 1, _Page1)
_CreateTabBtn("脚本合集(no key)", 2, _Page2)
_CreateTabBtn("脚本合集(need key)", 3, _Page5)
_CreateTabBtn("LMM script", 4, _Page6)
_CreateTabBtn("更新日志", 5, _Page3)
_CreateTabBtn("设定中心", 6, _Page4)

local _StatsContainer = Instance.new("Frame", _TB)
_StatsContainer.Size = UDim2.new(0, 165, 0, 26); _StatsContainer.Position = UDim2.new(1, -290, 0.5, -13)
_StatsContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _StatsContainer.BackgroundTransparency = 0.6; _StatsContainer.ZIndex = 2
Instance.new("UICorner", _StatsContainer).CornerRadius = UDim.new(0, 8)

local _StatsDot = Instance.new("Frame", _StatsContainer)
_StatsDot.Size = UDim2.new(0, 6, 0, 6); _StatsDot.Position = UDim2.new(0, 8, 0.5, -3)
_StatsDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94); _StatsDot.ZIndex = 3
Instance.new("UICorner", _StatsDot).CornerRadius = UDim.new(1, 0)

local _StatsText = Instance.new("TextLabel", _StatsContainer)
_StatsText.Size = UDim2.new(1, -18, 1, 0); _StatsText.Position = UDim2.new(0, 18, 0, 0); _StatsText.BackgroundTransparency = 1
_StatsText.Font = Enum.Font.GothamBold; _StatsText.TextSize = 10; _StatsText.TextColor3 = Color3.fromRGB(240, 240, 250); _StatsText.ZIndex = 3

task.spawn(function()
    local lastUpdate = 0
    local frameCount = 0
    local fps = 60
    _RS.RenderStepped:Connect(function(dt)
        frameCount = frameCount + 1
        if tick() - lastUpdate >= 0.5 then
            fps = math.floor(frameCount / (tick() - lastUpdate))
            frameCount = 0
            lastUpdate = tick()
        end
        pcall(function()
            local ping = math.floor(_LP:GetNetworkPing() * 1000 + 0.5)
            local mem = math.floor(collectgarbage("count") / 1024)
            _StatsText.Text = string.format("FPS: %d  |  Ping: %d  |  Mem: %dM", fps, ping, mem)
        end)
    end)
end)

local function _CreateColorBar(targetPage, key, order)
    local f = Instance.new("Frame", targetPage); f.LayoutOrder = order; f.Size = UDim2.new(0.98, 0, 0, 36); f.BackgroundTransparency = 1; f.ZIndex = 2
    local layout = Instance.new("UIListLayout", f); layout.FillDirection = "Horizontal"; layout.HorizontalAlignment = "Center"; layout.Padding = UDim.new(0, 8)
    local colors = {{Color3.fromRGB(99, 102, 241), "蓝"}, {Color3.fromRGB(239, 68, 68), "红"}, {Color3.fromRGB(255, 255, 255), "白"}, {Color3.fromRGB(40, 40, 50), "黑"}, {Color3.fromRGB(34, 197, 94), "绿"}}
    for _, info in pairs(colors) do
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 44, 0, 26); b.BackgroundColor3 = info[1]; b.BackgroundTransparency = 0.2; b.Text = ""; b.ZIndex = 2; b.AutoButtonColor = false; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", b); s.Thickness = 2; s.Color = Color3.fromRGB(255,255,255); s.Enabled = false
        b.MouseEnter:Connect(function() Tween(b, {Size = UDim2.new(0, 48, 0, 30)}, 0.15) end)
        b.MouseLeave:Connect(function() Tween(b, {Size = UDim2.new(0, 44, 0, 26)}, 0.15) end)
        b.MouseButton1Click:Connect(function() _G_LMM_88[key] = info[1]; for _, c in pairs(f:GetChildren()) do if c:IsA("TextButton") then c.UIStroke.Enabled = false end end; s.Enabled = true end)
    end
end

local function _CreateT(targetPage, name, key, order)
    local b = Instance.new("TextButton", targetPage); b.LayoutOrder = order; b.Size = UDim2.new(0.98, 0, 0, 42); b.BackgroundColor3 = Color3.fromRGB(15, 15, 24); b.BackgroundTransparency = 0.55; b.Text = "   " .. name; b.Font = Enum.Font.GothamMedium; b.TextSize = 13; b.TextColor3 = Color3.fromRGB(230, 230, 245); b.TextXAlignment = Enum.TextXAlignment.Left; b.ZIndex = 2; b.AutoButtonColor = false; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", b); s.Thickness = 1; s.Color = Color3.fromRGB(55, 55, 75)
    
    local track = Instance.new("Frame", b); track.Size = UDim2.new(0, 42, 0, 22); track.Position = UDim2.new(1, -52, 0.5, -11); track.BackgroundColor3 = Color3.fromRGB(24, 24, 36); track.ZIndex = 2; Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", track); knob.Size = UDim2.new(0, 16, 0, 16); knob.Position = UDim2.new(0, 3, 0.5, -8); knob.BackgroundColor3 = Color3.fromRGB(180, 180, 200); knob.ZIndex = 3; Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(24, 24, 38), BackgroundTransparency = 0.35}, 0.2); Tween(s, {Color = Color3.fromRGB(99, 102, 241)}, 0.2) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(15, 15, 24), BackgroundTransparency = 0.55}, 0.2); Tween(s, {Color = Color3.fromRGB(55, 55, 75)}, 0.2) end)
    b.MouseButton1Click:Connect(function() 
        _G_LMM_88[key] = not _G_LMM_88[key]
        local state = _G_LMM_88[key]
        
        if key == "v_0x3" and not state then
            pcall(function()
                local lChar = _LP.Character
                if lChar and lChar:FindFirstChildOfClass("Humanoid") then
                    lChar:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
                end
            end)
        end

        Tween(track, {BackgroundColor3 = state and Color3.fromRGB(99, 102, 241) or Color3.fromRGB(24, 24, 36)}, 0.3)
        Tween(knob, {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 200)
        }, 0.3, Enum.EasingStyle.Back)
    end)
end

local function _CreateS(targetPage, name, url, order)
    local b = Instance.new("TextButton", targetPage); b.LayoutOrder = order; b.Size = UDim2.new(0.98, 0, 0, 42); b.BackgroundColor3 = Color3.fromRGB(15, 15, 24); b.BackgroundTransparency = 0.55; b.Text = "   " .. name; b.Font = Enum.Font.GothamMedium; b.TextSize = 13; b.TextColor3 = Color3.fromRGB(240, 240, 250); b.TextXAlignment = Enum.TextXAlignment.Left; b.ZIndex = 2; b.AutoButtonColor = false; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", b); s.Thickness = 1; s.Color = Color3.fromRGB(55, 55, 75)

    b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(24, 24, 38), BackgroundTransparency = 0.35}, 0.2); Tween(s, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(15, 15, 24), BackgroundTransparency = 0.55}, 0.2); Tween(s, {Color = Color3.fromRGB(55, 55, 75)}, 0.2) end)
    
    b.MouseButton1Click:Connect(function()
        local topScreen = Instance.new("ScreenGui", _CG)
        topScreen.Name = "LMM_Ultimate_Top_Overlay"
        topScreen.ResetOnSpawn = false
        topScreen.DisplayOrder = 2147483647
        topScreen.IgnoreGuiInset = true

        local bgBlocker = Instance.new("TextButton", topScreen)
        bgBlocker.Size = UDim2.new(1, 0, 1, 0)
        bgBlocker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bgBlocker.BackgroundTransparency = 0.6
        bgBlocker.Text = ""
        bgBlocker.AutoButtonColor = false
        bgBlocker.ZIndex = 999999

        local alertOverlay = Instance.new("Frame", topScreen)
        alertOverlay.Size = UDim2.new(1, 0, 1, 0)
        alertOverlay.BackgroundTransparency = 1
        alertOverlay.ZIndex = 1000000
        
        local alertBox = Instance.new("Frame", alertOverlay)
        alertBox.Size = UDim2.new(0, 0, 0, 0)
        alertBox.Position = UDim2.new(0.5, 0, 0.5, 0)
        alertBox.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
        alertBox.BackgroundTransparency = 0.15
        alertBox.ZIndex = 1000001
        alertBox.ClipsDescendants = true
        Instance.new("UICorner", alertBox).CornerRadius = UDim.new(0, 16)

        Tween(alertBox, {Size = UDim2.new(0, 350, 0, 160), Position = UDim2.new(0.5, -175, 0.5, -80)}, 0.35, Enum.EasingStyle.Back)

        local alertText = Instance.new("TextLabel", alertBox)
        alertText.Size = UDim2.new(1, -30, 0, 70); alertText.Position = UDim2.new(0, 15, 0, 20); alertText.BackgroundTransparency = 1; alertText.ZIndex = 1000002
        alertText.Text = "确定要开启此脚本吗？\n<font size='11' color='rgb(170,170,195)'>" .. name .. "</font>"; alertText.RichText = true
        alertText.TextColor3 = Color3.fromRGB(255, 255, 255); alertText.Font = Enum.Font.GothamBold; alertText.TextSize = 14; alertText.TextWrapped = true

        local yesBtn = Instance.new("TextButton", alertBox)
        yesBtn.Size = UDim2.new(0, 145, 0, 36); yesBtn.Position = UDim2.new(0.06, 0, 0.65, 0); yesBtn.BackgroundColor3 = Color3.fromRGB(99, 102, 241); yesBtn.BackgroundTransparency = 0.15; yesBtn.Text = "确认开启"; yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255); yesBtn.Font = Enum.Font.GothamBold; yesBtn.TextSize = 13; yesBtn.ZIndex = 1000002
        yesBtn.AutoButtonColor = false
        Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 10)

        local noBtn = Instance.new("TextButton", alertBox)
        noBtn.Size = UDim2.new(0, 145, 0, 36); noBtn.Position = UDim2.new(0.52, 0, 0.65, 0); noBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 38); noBtn.BackgroundTransparency = 0.2; noBtn.Text = "取消"; noBtn.TextColor3 = Color3.fromRGB(180, 180, 205); noBtn.Font = Enum.Font.GothamBold; noBtn.TextSize = 13; noBtn.ZIndex = 1000002
        noBtn.AutoButtonColor = false
        Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 10)

        yesBtn.MouseEnter:Connect(function() Tween(yesBtn, {BackgroundColor3 = Color3.fromRGB(120, 123, 255)}, 0.2) end)
        yesBtn.MouseLeave:Connect(function() Tween(yesBtn, {BackgroundColor3 = Color3.fromRGB(99, 102, 241)}, 0.2) end)
        noBtn.MouseEnter:Connect(function() Tween(noBtn, {BackgroundColor3 = Color3.fromRGB(36, 36, 54)}, 0.2) end)
        noBtn.MouseLeave:Connect(function() Tween(noBtn, {BackgroundColor3 = Color3.fromRGB(24, 24, 38)}, 0.2) end)

        local function closeDialog(callback)
            Tween(alertBox, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.25)
            topScreen:Destroy()
            if callback then callback() end
        end

        yesBtn.MouseButton1Click:Connect(function()
            closeDialog(function()
                ShowNotification("正在开启中...", name)
                task.spawn(function()
                    local success, err = pcall(function()
                        loadstring(game:HttpGet(url))()
                    end)
                    if success then
                        ShowNotification("开启成功", name .. " 已成功运行！")
                    else
                        ShowNotification("开启失败", "网络异常或链接失效")
                    end
                end)
            end)
        end)

        noBtn.MouseButton1Click:Connect(function()
            closeDialog()
        end)
    end)
end

local function _DecorateInput(input)
    input.MouseEnter:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
    input.MouseLeave:Connect(function() if not input:IsFocused() then Tween(input.UIStroke, {Color = Color3.fromRGB(55, 55, 75)}, 0.2) end end)
    input.Focused:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(99, 102, 241)}, 0.2) end)
    input.FocusLost:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(55, 55, 75)}, 0.2) end)
end

local _In1 = Instance.new("TextBox", _Page1); _In1.LayoutOrder = 1; _In1.Size = UDim2.new(0.98, 0, 0, 40); _In1.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _In1.BackgroundTransparency = 0.55; _In1.Text = "  行走速度: 50"; _In1.TextColor3 = Color3.fromRGB(240, 240, 250); _In1.Font = Enum.Font.GothamMedium; _In1.TextSize = 13; _In1.TextXAlignment = Enum.TextXAlignment.Left; _In1.ZIndex = 2; Instance.new("UICorner", _In1).CornerRadius = UDim.new(0, 10)
local _In1S = Instance.new("UIStroke", _In1); _In1S.Thickness = 1; _In1S.Color = Color3.fromRGB(55, 55, 75); _DecorateInput(_In1)
_In1.FocusLost:Connect(function() _G_LMM_88.v_val_1 = tonumber(_In1.Text:match("%d+")) or 50; _In1.Text = "  行走速度: ".._G_LMM_88.v_val_1 end)

local _In2 = Instance.new("TextBox", _Page1); _In2.LayoutOrder = 2; _In2.Size = UDim2.new(0.98, 0, 0, 40); _In2.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _In2.BackgroundTransparency = 0.55; _In2.Text = "  飞行速度: 50"; _In2.TextColor3 = Color3.fromRGB(240, 240, 250); _In2.Font = Enum.Font.GothamMedium; _In2.TextSize = 13; _In2.TextXAlignment = Enum.TextXAlignment.Left; _In2.ZIndex = 2; Instance.new("UICorner", _In2).CornerRadius = UDim.new(0, 10)
local _In2S = Instance.new("UIStroke", _In2); _In2S.Thickness = 1; _In2S.Color = Color3.fromRGB(55, 55, 75); _DecorateInput(_In2)
_In2.FocusLost:Connect(function() _G_LMM_88.v_val_2 = tonumber(_In2.Text:match("%d+")) or 50; _In2.Text = "  飞行速度: ".._G_LMM_88.v_val_2 end)

_CreateT(_Page1, "冰冻 (让自己固定)", "v_freeze", 3)
_CreateT(_Page1, "无限跳 (Infinite Jump)", "v_infjump", 4)
_CreateT(_Page1, "内置穿墙 (NOCLIP)", "v_0x2", 5)
_CreateT(_Page1, "内置速度开关", "v_0x3", 6)
_CreateT(_Page1, "内置飞行开关 (FLY)", "v_0x4", 7)
_CreateT(_Page1, "内置透视 (ESP)", "v_0x1", 8); _CreateColorBar(_Page1, "c_esp", 9)
_CreateT(_Page1, "内置ESP射线", "v_esp_line", 10); _CreateColorBar(_Page1, "c_line", 11)
_CreateT(_Page1, "内置ESP方框", "v_esp_box", 12); _CreateColorBar(_Page1, "c_box", 13)

local _SearchBox = Instance.new("TextBox", _Page2)
_SearchBox.LayoutOrder = 1; _SearchBox.Size = UDim2.new(0.98, 0, 0, 40); _SearchBox.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _SearchBox.BackgroundTransparency = 0.55
_SearchBox.PlaceholderText = "搜索免卡密脚本..."; _SearchBox.Text = ""; _SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
_SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 175); _SearchBox.Font = Enum.Font.GothamMedium; _SearchBox.TextSize = 13; _SearchBox.ZIndex = 2
Instance.new("UICorner", _SearchBox).CornerRadius = UDim.new(0, 10)
local _SearchStroke = Instance.new("UIStroke", _SearchBox); _SearchStroke.Thickness = 1; _SearchStroke.Color = Color3.fromRGB(55, 55, 75)
_DecorateInput(_SearchBox)

_SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = _SearchBox.Text:lower()
    for _, child in pairs(_Page2:GetChildren()) do
        if child:IsA("TextButton") and child ~= _SearchBox then
            child.Visible = (query == "" or child.Text:lower():find(query) ~= nil)
        end
    end
end)

_CreateS(_Page2, "AIMBOT (自瞄)", "https://rawscripts.net/raw/Universal-Script-Aimbot-Mobile-34677", 2)
_CreateS(_Page2, "Infinite Yield (万能脚本)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 3)
_CreateS(_Page2, "Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source", 4)
_CreateS(_Page2, "Owl Hub (极简稳定版)", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt", 5)
_CreateS(_Page2, "steal an egg", "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua", 6)

local _SearchBox2 = Instance.new("TextBox", _Page5)
_SearchBox2.LayoutOrder = 1; _SearchBox2.Size = UDim2.new(0.98, 0, 0, 40); _SearchBox2.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _SearchBox2.BackgroundTransparency = 0.55
_SearchBox2.PlaceholderText = "搜索需卡密脚本..."; _SearchBox2.Text = ""; _SearchBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
_SearchBox2.PlaceholderColor3 = Color3.fromRGB(150, 150, 175); _SearchBox2.Font = Enum.Font.GothamMedium; _SearchBox2.TextSize = 13; _SearchBox2.ZIndex = 2
Instance.new("UICorner", _SearchBox2).CornerRadius = UDim.new(0, 10)
local _SearchStroke2 = Instance.new("UIStroke", _SearchBox2); _SearchStroke2.Thickness = 1; _SearchStroke2.Color = Color3.fromRGB(55, 55, 75)
_DecorateInput(_SearchBox2)

_SearchBox2:GetPropertyChangedSignal("Text"):Connect(function()
    local query = _SearchBox2.Text:lower()
    for _, child in pairs(_Page5:GetChildren()) do
        if child:IsA("TextButton") and child ~= _SearchBox2 then
            child.Visible = (query == "" or child.Text:lower():find(query) ~= nil)
        end
    end
end)

_CreateS(_Page5, "示例脚本 (需卡密)", "https://example.com/needkey-script", 2)
_CreateS(_Page5, "Blade Ball", "https://raw.githubusercontent.com/joshhhie/rise/refs/heads/main/loader.lua", 3)

local _SearchBox3 = Instance.new("TextBox", _Page6)
_SearchBox3.LayoutOrder = 1; _SearchBox3.Size = UDim2.new(0.98, 0, 0, 40); _SearchBox3.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _SearchBox3.BackgroundTransparency = 0.55
_SearchBox3.PlaceholderText = "搜索我的专属脚本..."; _SearchBox3.Text = ""; _SearchBox3.TextColor3 = Color3.fromRGB(255, 255, 255)
_SearchBox3.PlaceholderColor3 = Color3.fromRGB(150, 150, 175); _SearchBox3.Font = Enum.Font.GothamMedium; _SearchBox3.TextSize = 13; _SearchBox3.ZIndex = 2
Instance.new("UICorner", _SearchBox3).CornerRadius = UDim.new(0, 10)
local _SearchStroke3 = Instance.new("UIStroke", _SearchBox3); _SearchStroke3.Thickness = 1; _SearchStroke3.Color = Color3.fromRGB(55, 55, 75)
_DecorateInput(_SearchBox3)

_SearchBox3:GetPropertyChangedSignal("Text"):Connect(function()
    local query = _SearchBox3.Text:lower()
    for _, child in pairs(_Page6:GetChildren()) do
        if child:IsA("TextButton") and child ~= _SearchBox3 then
            child.Visible = (query == "" or child.Text:lower():find(query) ~= nil)
        end
    end
end)

_CreateS(_Page6, "LMM MM2 (专属挂机农夫版)", "https://raw.githubusercontent.com/LMM-823/LMM-mm2/main/main.lua?v=999", 2)
_CreateS(_Page6, "LMM VIEW", "https://raw.githubusercontent.com/LMM-823/LMM-VIEW/main/Main.lua?v=999", 3)

local function _CreateLogEntry(version, date, desc, order)
    local f = Instance.new("Frame", _Page3)
    f.LayoutOrder = order; f.Size = UDim2.new(0.98, 0, 0, 0); f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = Color3.fromRGB(15, 15, 24); f.BackgroundTransparency = 0.55; f.ZIndex = 2
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", f); stroke.Thickness = 1; stroke.Color = Color3.fromRGB(55, 55, 75)
    
    local pad = Instance.new("UIPadding", f)
    pad.PaddingTop = UDim.new(0, 10); pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 14); pad.PaddingRight = UDim.new(0, 14)
    
    local layout = Instance.new("UIListLayout", f)
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 4)

    local t = Instance.new("TextLabel", f)
    t.LayoutOrder = 1; t.Size = UDim2.new(1, 0, 0, 22)
    t.BackgroundTransparency = 1; t.Text = "<font color='rgb(129,140,248)'>" .. version .. "</font> <font color='rgb(150,150,175)'>- " .. date .. "</font>"
    t.RichText = true; t.TextColor3 = Color3.fromRGB(255, 255, 255); t.Font = Enum.Font.GothamBold; t.TextSize = 13; t.TextXAlignment = Enum.TextXAlignment.Left; t.ZIndex = 2
    
    local d = Instance.new("TextLabel", f)
    d.LayoutOrder = 2; d.Size = UDim2.new(1, 0, 0, 0); d.AutomaticSize = Enum.AutomaticSize.Y
    d.BackgroundTransparency = 1; t.Text = desc; d.TextColor3 = Color3.fromRGB(200, 200, 220)
    d.Font = Enum.Font.GothamMedium; d.TextSize = 12; d.TextXAlignment = Enum.TextXAlignment.Left; d.TextWrapped = true; d.ZIndex = 2

    f.MouseEnter:Connect(function() Tween(stroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.25) end)
    f.MouseLeave:Connect(function() Tween(stroke, {Color = Color3.fromRGB(55, 55, 75)}, 0.25) end)
end

_CreateLogEntry("V4.1.9", "2026-11-13", "【ESP 终极突破】全方位重构透视引擎，绕过复杂游戏层级直接对全身部件进行高亮与方框渲染。", 1)
_CreateLogEntry("V4.1.8", "2026-11-13", "【深度重构】完美修复冰冻只变慢而非定住的问题（加入强制坐标锁死与速度归零）。", 2)
_CreateLogEntry("V4.1.7", "2026-11-13", "【脚本更新】在 LMM script 分类下成功添加并集成了 LMM VIEW 专属脚本。", 3)

local _FpsInput = Instance.new("TextBox", _Page4)
_FpsInput.LayoutOrder = 1; _FpsInput.Size = UDim2.new(0.98, 0, 0, 40); _FpsInput.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _FpsInput.BackgroundTransparency = 0.55
_FpsInput.Text = "  设置FPS解锁 (15-240): 60"; _FpsInput.TextColor3 = Color3.fromRGB(240, 240, 250); _FpsInput.Font = Enum.Font.GothamMedium; _FpsInput.TextSize = 13; _FpsInput.TextXAlignment = Enum.TextXAlignment.Left; _FpsInput.ZIndex = 2
Instance.new("UICorner", _FpsInput).CornerRadius = UDim.new(0, 10)
local _FpsStroke = Instance.new("UIStroke", _FpsInput); _FpsStroke.Thickness = 1; _FpsStroke.Color = Color3.fromRGB(55, 55, 75)
_DecorateInput(_FpsInput)

_FpsInput.FocusLost:Connect(function()
    local val = tonumber(_FpsInput.Text:match("%d+")) or 60
    if val < 15 then val = 15 end if val > 240 then val = 240 end
    _FpsInput.Text = "  设置FPS解锁 (15-240): " .. val
    pcall(function() setfpscap(val) end)
    ShowNotification("FPS 设置已更新", "当前上限已锁定为: " .. val)
end)

local _BgmContainer = Instance.new("Frame", _Page4)
_BgmContainer.LayoutOrder = 2; _BgmContainer.Size = UDim2.new(0.98, 0, 0, 85); _BgmContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _BgmContainer.BackgroundTransparency = 0.55; _BgmContainer.ZIndex = 2
Instance.new("UICorner", _BgmContainer).CornerRadius = UDim.new(0, 10)
local _BgmStroke = Instance.new("UIStroke", _BgmContainer); _BgmStroke.Thickness = 1; _BgmStroke.Color = Color3.fromRGB(55, 55, 75)

local _BgmTitle = Instance.new("TextLabel", _BgmContainer)
_BgmTitle.Size = UDim2.new(1, -20, 0, 25); _BgmTitle.Position = UDim2.new(0, 10, 0, 6)
_BgmTitle.BackgroundTransparency = 1; _BgmTitle.Text = "云端背景音乐播放器 (BGM)"; _BgmTitle.TextColor3 = Color3.fromRGB(240, 240, 250); _BgmTitle.Font = Enum.Font.GothamBold; _BgmTitle.TextSize = 12; _BgmTitle.TextXAlignment = Enum.TextXAlignment.Left; _BgmTitle.ZIndex = 3

local _BgmInput = Instance.new("TextBox", _BgmContainer)
_BgmInput.Size = UDim2.new(0.65, 0, 0, 36); _BgmInput.Position = UDim2.new(0, 10, 0, 38)
_BgmInput.BackgroundColor3 = Color3.fromRGB(12, 12, 18); _BgmInput.BackgroundTransparency = 0.4
_BgmInput.Text = "rbxassetid://1843158679"; _BgmInput.TextColor3 = Color3.fromRGB(220, 220, 235); _BgmInput.Font = Enum.Font.GothamMedium; _BgmInput.TextSize = 11; _BgmInput.ZIndex = 3
Instance.new("UICorner", _BgmInput).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", _BgmInput).Thickness = 1
local _BgmToggle = Instance.new("TextButton", _BgmContainer)
_BgmToggle.Size = UDim2.new(0.3, 0, 0, 36); _BgmToggle.Position = UDim2.new(0.68, 0, 0, 38)
_BgmToggle.BackgroundColor3 = Color3.fromRGB(99, 102, 241); _BgmToggle.BackgroundTransparency = 0.2; _BgmToggle.Text = "播放音乐"; _BgmToggle.TextColor3 = Color3.fromRGB(255, 255, 255); _BgmToggle.Font = Enum.Font.GothamBold; _BgmToggle.TextSize = 12; _BgmToggle.ZIndex = 3
Instance.new("UICorner", _BgmToggle).CornerRadius = UDim.new(0, 8)

local soundObj = Instance.new("Sound", workspace)
soundObj.Volume = 1
soundObj.Looped = true
local isPlayingBgm = false

_BgmToggle.MouseButton1Click:Connect(function()
    isPlayingBgm = not isPlayingBgm
    if isPlayingBgm then
        pcall(function()
            soundObj.SoundId = _BgmInput.Text
            soundObj:Play()
        end)
        _BgmToggle.Text = "停止播放"
        _BgmToggle.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        ShowNotification("BGM 播放器", "背景音乐已开始播放！")
    else
        pcall(function() soundObj:Stop() end)
        _BgmToggle.Text = "播放音乐"
        _BgmToggle.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
        ShowNotification("BGM 播放器", "背景音乐已停止。")
    end
end)

local _FpsBoostRealBtn = Instance.new("TextButton", _Page4)
_FpsBoostRealBtn.LayoutOrder = 3; _FpsBoostRealBtn.Size = UDim2.new(0.98, 0, 0, 40); _FpsBoostRealBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _FpsBoostRealBtn.BackgroundTransparency = 0.55
_FpsBoostRealBtn.Text = "   开启 FPS Boost (极致性能优化)"; _FpsBoostRealBtn.TextColor3 = Color3.fromRGB(240, 240, 250); _FpsBoostRealBtn.Font = Enum.Font.GothamMedium; _FpsBoostRealBtn.TextSize = 13; _FpsBoostRealBtn.TextXAlignment = Enum.TextXAlignment.Left; _FpsBoostRealBtn.ZIndex = 2; _FpsBoostRealBtn.AutoButtonColor = false
Instance.new("UICorner", _FpsBoostRealBtn).CornerRadius = UDim.new(0, 10)
local _FpsBoostRealStroke = Instance.new("UIStroke", _FpsBoostRealBtn); _FpsBoostRealStroke.Thickness = 1; _FpsBoostRealStroke.Color = Color3.fromRGB(55, 55, 75)

_FpsBoostRealBtn.MouseEnter:Connect(function() Tween(_FpsBoostRealBtn, {BackgroundColor3 = Color3.fromRGB(24, 24, 38)}, 0.2); Tween(_FpsBoostRealStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
_FpsBoostRealBtn.MouseLeave:Connect(function() Tween(_FpsBoostRealBtn, {BackgroundColor3 = Color3.fromRGB(15, 15, 24)}, 0.2); Tween(_FpsBoostRealStroke, {Color = Color3.fromRGB(55, 55, 75)}, 0.2) end)
_FpsBoostRealBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false; lighting.FogEnd = 9e9
        for _, v in pairs(lighting:GetChildren()) do if v:IsA("PostEffect") then v.Enabled = false end end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic; v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
        end
    end)
    ShowNotification("FPS Boost 已生效", "已关闭阴影材质并精简画面以大幅提升帧率！")
end)

local _PingBoostBtn = Instance.new("TextButton", _Page4)
_PingBoostBtn.LayoutOrder = 4; _PingBoostBtn.Size = UDim2.new(0.98, 0, 0, 40); _PingBoostBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _PingBoostBtn.BackgroundTransparency = 0.55
_PingBoostBtn.Text = "   开启网络低延迟优化 (Ping Boost)"; _PingBoostBtn.TextColor3 = Color3.fromRGB(240, 240, 250); _PingBoostBtn.Font = Enum.Font.GothamMedium; _PingBoostBtn.TextSize = 13; _PingBoostBtn.TextXAlignment = Enum.TextXAlignment.Left; _PingBoostBtn.ZIndex = 2; _PingBoostBtn.AutoButtonColor = false
Instance.new("UICorner", _PingBoostBtn).CornerRadius = UDim.new(0, 10)
local _PingBoostStroke = Instance.new("UIStroke", _PingBoostBtn); _PingBoostStroke.Thickness = 1; _PingBoostStroke.Color = Color3.fromRGB(55, 55, 75)

_PingBoostBtn.MouseEnter:Connect(function() Tween(_PingBoostBtn, {BackgroundColor3 = Color3.fromRGB(24, 24, 38)}, 0.2); Tween(_PingBoostStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
_PingBoostBtn.MouseLeave:Connect(function() Tween(_PingBoostBtn, {BackgroundColor3 = Color3.fromRGB(15, 15, 24)}, 0.2); Tween(_PingBoostStroke, {Color = Color3.fromRGB(55, 55, 75)}, 0.2) end)

_PingBoostBtn.MouseButton1Click:Connect(function()
    pcall(function()
        settings():GetService("NetworkSettings").IncomingReplicationLag = 0
        if setscriptable then
            setscriptable(settings():GetService("NetworkSettings"), "ReceiveAge", true)
        end
        pcall(function()
            settings():GetService("NetworkSettings").ReceiveAge = 0
        end)
    end)
    ShowNotification("网络低延迟已优化", "服务器数据同步频率已提升！")
end)

local _AfkBtn = Instance.new("TextButton", _Page4)
_AfkBtn.LayoutOrder = 5; _AfkBtn.Size = UDim2.new(0.98, 0, 0, 40); _AfkBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _AfkBtn.BackgroundTransparency = 0.55
_AfkBtn.Text = "   开启挂机AFK (防踢保护)"; _AfkBtn.TextColor3 = Color3.fromRGB(240, 240, 250); _AfkBtn.Font = Enum.Font.GothamMedium; _AfkBtn.TextSize = 13; _AfkBtn.TextXAlignment = Enum.TextXAlignment.Left; _AfkBtn.ZIndex = 2; _AfkBtn.AutoButtonColor = false
Instance.new("UICorner", _AfkBtn).CornerRadius = UDim.new(0, 10)
local _AfkStroke = Instance.new("UIStroke", _AfkBtn); _AfkStroke.Thickness = 1; _AfkStroke.Color = Color3.fromRGB(55, 55, 75)

_AfkBtn.MouseEnter:Connect(function() Tween(_AfkBtn, {BackgroundColor3 = Color3.fromRGB(24, 24, 38)}, 0.2); Tween(_AfkStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
_AfkBtn.MouseLeave:Connect(function() Tween(_AfkBtn, {BackgroundColor3 = Color3.fromRGB(15, 15, 24)}, 0.2); Tween(_AfkStroke, {Color = Color3.fromRGB(55, 55, 75)}, 0.2) end)

local afkConnection = nil
_AfkBtn.MouseButton1Click:Connect(function()
    if not afkConnection then
        pcall(function()
            local vu = game:GetService("VirtualUser")
            afkConnection = _LP.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end)
        Tween(_AfkBtn, {BackgroundColor3 = Color3.fromRGB(34, 197, 94)}, 0.3)
        ShowNotification("挂机防踢保护已开启", "系统将自动模拟操作防止被服务器踢出。")
    else
        pcall(function()
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
        end)
        Tween(_AfkBtn, {BackgroundColor3 = Color3.fromRGB(15, 15, 24), BackgroundTransparency = 0.55}, 0.3)
        ShowNotification("挂机防踢保护已关闭", "已恢复正常检测。")
    end
end)

local _FullbrightBtn = Instance.new("TextButton", _Page4)
_FullbrightBtn.LayoutOrder = 6; _FullbrightBtn.Size = UDim2.new(0.98, 0, 0, 40); _FullbrightBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 24); _FullbrightBtn.BackgroundTransparency = 0.55
_FullbrightBtn.Text = "   开启 Fullbright (全局高亮)"; _FullbrightBtn.TextColor3 = Color3.fromRGB(240, 240, 250); _FullbrightBtn.Font = Enum.Font.GothamMedium; _FullbrightBtn.TextSize = 13; _FullbrightBtn.TextXAlignment = Enum.TextXAlignment.Left; _FullbrightBtn.ZIndex = 2; _FullbrightBtn.AutoButtonColor = false
Instance.new("UICorner", _FullbrightBtn).CornerRadius = UDim.new(0, 10)
local _FullbrightStroke = Instance.new("UIStroke", _FullbrightBtn); _FullbrightStroke.Thickness = 1; _FullbrightStroke.Color = Color3.fromRGB(55, 55, 75)

_FullbrightBtn.MouseEnter:Connect(function() Tween(_FullbrightBtn, {BackgroundColor3 = Color3.fromRGB(24, 24, 38)}, 0.2); Tween(_FullbrightStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
_FullbrightBtn.MouseLeave:Connect(function() Tween(_FullbrightBtn, {BackgroundColor3 = Color3.fromRGB(15, 15, 24)}, 0.2); Tween(_FullbrightStroke, {Color = Color3.fromRGB(55, 55, 75)}, 0.2) end)

local fullbrightConn = nil
local fullbrightActive = false

_FullbrightBtn.MouseButton1Click:Connect(function()
    fullbrightActive = not fullbrightActive
    if fullbrightActive then
        pcall(function()
            local lighting = game:GetService("Lighting")
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 786432
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        end)
        fullbrightConn = _RS.RenderStepped:Connect(function()
            if fullbrightActive then
                pcall(function()
                    local lighting = game:GetService("Lighting")
                    lighting.Ambient = Color3.fromRGB(255, 255, 255)
                    lighting.Brightness = 2
                    lighting.ClockTime = 14
                    lighting.FogEnd = 786432
                    lighting.GlobalShadows = false
                    lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                end)
            end
        end)
        Tween(_FullbrightBtn, {BackgroundColor3 = Color3.fromRGB(34, 197, 94)}, 0.3)
        ShowNotification("全局高亮已开启", "游戏视野已完全明亮化。")
    else
        if fullbrightConn then
            fullbrightConn:Disconnect()
            fullbrightConn = nil
        end
        Tween(_FullbrightBtn, {BackgroundColor3 = Color3.fromRGB(15, 15, 24), BackgroundTransparency = 0.55}, 0.3)
        ShowNotification("全局高亮已关闭", "已恢复默认光照环境。")
    end
end)

local _DCB = Instance.new("TextButton", _Page4); _DCB.LayoutOrder = 7; _DCB.Size = UDim2.new(0.98, 0, 0, 42); _DCB.BackgroundColor3 = Color3.fromRGB(88, 101, 242); _DCB.BackgroundTransparency = 0.45; _DCB.Text = "JOIN DISCORD COMMUNITY"; _DCB.TextColor3 = Color3.fromRGB(255, 255, 255); _DCB.Font = Enum.Font.GothamBold; _DCB.TextSize = 13; _DCB.ZIndex = 2; _DCB.AutoButtonColor = false; Instance.new("UICorner", _DCB).CornerRadius = UDim.new(0, 10)
local _DCBStroke = Instance.new("UIStroke", _DCB); _DCBStroke.Thickness = 1; _DCBStroke.Color = Color3.fromRGB(114, 137, 218)
_DCB.MouseEnter:Connect(function() Tween(_DCB, {BackgroundColor3 = Color3.fromRGB(108, 121, 255), BackgroundTransparency = 0.25}, 0.2) end)
_DCB.MouseLeave:Connect(function() Tween(_DCB, {BackgroundColor3 = Color3.fromRGB(88, 101, 242), BackgroundTransparency = 0.45}, 0.2) end)
_DCB.MouseButton1Click:Connect(function() 
    setclipboard("https://discord.gg/cjpezEZub") 
    ShowNotification("Discord 链接已复制", "快去分享给好友加入社区吧！")
end)

_UIS.JumpRequest:Connect(function()
    if _G_LMM_88.v_infjump then
        local lChar = _LP.Character
        if lChar and lChar:FindFirstChildOfClass("Humanoid") then
            lChar:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local _BG = Instance.new("BodyGyro"); local _BV = Instance.new("BodyVelocity")
_BG.P = 9e4; _BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); _BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

local frozenPosition = nil

-- ==================== 核心功能循环驱动 (ESP 透视全方位突破修复) ====================
_RS.Heartbeat:Connect(function()
    local lChar = _LP.Character
    if lChar and lChar:FindFirstChild("HumanoidRootPart") then
        local lHrp = lChar.HumanoidRootPart; local hum = lChar:FindFirstChildOfClass("Humanoid")
        if hum then
            if _G_LMM_88.v_0x3 then
                pcall(function()
                    hum.WalkSpeed = _G_LMM_88.v_val_1
                end)
            end
            
            if _G_LMM_88.v_freeze then
                if not frozenPosition then
                    frozenPosition = lHrp.CFrame
                end
                lHrp.CFrame = frozenPosition
                lHrp.Anchored = true
                lHrp.AssemblyLinearVelocity = Vector3.zero
                lHrp.AssemblyAngularVelocity = Vector3.zero
                pcall(function()
                    hum.PlatformStand = true
                end)
            else
                if frozenPosition then
                    frozenPosition = nil
                    lHrp.Anchored = false
                    pcall(function()
                        hum.PlatformStand = false
                    end)
                end
            end

            if _G_LMM_88.v_0x2 then 
                for _, p in pairs(lChar:GetChildren()) do 
                    if p:IsA("BasePart") then p.CanCollide = false end 
                end 
            end

            if _G_LMM_88.v_0x4 then
                _BG.Parent = lHrp; _BV.Parent = lHrp; _BG.CFrame = _Cam.CFrame
                _BV.Velocity = hum.MoveDirection.Magnitude > 0 and _Cam.CFrame.LookVector * _G_LMM_88.v_val_2 or Vector3.zero
            else 
                _BG.Parent = nil; _BV.Parent = nil 
            end
        end
    end

    -- 🌟 终极突破 ESP 逻辑：直接绑定到每一个玩家的 Character 根部，确保全游戏模型通用
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP then
            local tChar = p.Character
            if tChar then
                local tHrp = tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Head")
                
                -- 1. 透视高亮 (ESP Highlight)
                if _G_LMM_88.v_0x1 then
                    local hl = tChar:FindFirstChild("LMM_ESP")
                    if not hl then
                        hl = Instance.new("Highlight", tChar)
                        hl.Name = "LMM_ESP"
                        hl.Adornee = tChar
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.FillTransparency = 0.3
                        hl.OutlineTransparency = 0
                    end
                    hl.FillColor = _G_LMM_88.c_esp
                    hl.OutlineColor = _G_LMM_88.c_esp
                    hl.Enabled = true
                else
                    local hl = tChar:FindFirstChild("LMM_ESP")
                    if hl then hl:Destroy() end
                end

                -- 2. ESP 方框 (BillboardGui Box)
                if _G_LMM_88.v_esp_box and tHrp then
                    local bb = tChar:FindFirstChild("LMM_BOX")
                    if not bb then
                        bb = Instance.new("BillboardGui", tChar)
                        bb.Name = "LMM_BOX"
                        bb.AlwaysOnTop = true
                        bb.Size = UDim2.new(4, 0, 5.5, 0)
                        bb.Adornee = tHrp
                        local f = Instance.new("Frame", bb)
                        f.Size = UDim2.new(1, 0, 1, 0)
                        f.BackgroundTransparency = 1
                        local st = Instance.new("UIStroke", f)
                        st.Name = "S"
                        st.Thickness = 2
                    end
                    if bb:FindFirstChild("Frame") and bb.Frame:FindFirstChild("S") then 
                        bb.Frame.S.Color = _G_LMM_88.c_box 
                    end
                    bb.Enabled = true
                else
                    local bb = tChar:FindFirstChild("LMM_BOX")
                    if bb then bb:Destroy() end
                end

                -- 3. ESP 射线 (Beam Line)
                if _G_LMM_88.v_esp_line and tHrp then
                    local beam = tHrp:FindFirstChild("LMM_LINE_FIX")
                    if not beam and lChar and lChar:FindFirstChild("HumanoidRootPart") then
                        beam = Instance.new("Beam", tHrp)
                        beam.Name = "LMM_LINE_FIX"
                        local a0 = lChar.HumanoidRootPart:FindFirstChild("LMM_A0") or Instance.new("Attachment", lChar.HumanoidRootPart)
                        a0.Name = "LMM_A0"
                        beam.Attachment0 = a0
                        beam.Attachment1 = Instance.new("Attachment", tHrp)
                        beam.Width0 = 0.1
                        beam.Width1 = 0.1
                        beam.FaceCamera = true
                    end
                    if beam then beam.Color = ColorSequence.new(_G_LMM_88.c_line) end
                else
                    if tHrp then
                        local beam = tHrp:FindFirstChild("LMM_LINE_FIX")
                        if beam then beam:Destroy() end
                    end
                end
            end
        end
    end
end)

local function _Ctrl(t, x, c, hoverC, f)
    local b = Instance.new("TextButton", _TB); b.Size = UDim2.new(0, 28, 0, 28); b.Position = UDim2.new(1, x, 0.5, -14); b.Text = t; b.BackgroundColor3 = c; b.BackgroundTransparency = 0.35; b.TextColor3 = Color3.fromRGB(240,240,250); b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.ZIndex = 3; b.AutoButtonColor = false; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local bStroke = Instance.new("UIStroke", b); bStroke.Thickness = 1; bStroke.Color = Color3.fromRGB(255, 255, 255); bStroke.Transparency = 0.7
    
    b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = hoverC, BackgroundTransparency = 0.15}, 0.2); Tween(bStroke, {Transparency = 0.3}, 0.2) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = c, BackgroundTransparency = 0.35}, 0.2); Tween(bStroke, {Transparency = 0.7}, 0.2) end)
    b.MouseButton1Click:Connect(f)
end

_Ctrl("×", -42, Color3.fromRGB(239, 68, 68), Color3.fromRGB(255, 90, 90), function() 
    pcall(function() _LP.Character.HumanoidRootPart.Anchored = false end)
    Tween(_M, {Size = UDim2.new(0, 520, 0, 340), BackgroundTransparency = 1}, 0.3)
    for _, v in pairs(_M:GetDescendants()) do if v:IsA("UIStroke") or v:IsA("ImageLabel") or v:IsA("TextLabel") or v:IsA("TextButton") then Tween(v, {Transparency = 1}, 0.3) end end
    task.wait(0.3); _S:Destroy() 
end)

local isMinimized = false

_Ctrl("—", -76, Color3.fromRGB(50, 50, 70), Color3.fromRGB(80, 80, 105), function() 
    isMinimized = not isMinimized
    _Sidebar.Visible = not isMinimized
    _ContentContainer.Visible = not isMinimized
    _HeaderLine.Visible = not isMinimized
    _SplitLine.Visible = not isMinimized
    _BgImage.Visible = not isMinimized
    if _M:FindFirstChild("UIStroke") then _M.UIStroke.Transparency = isMinimized and 1 or 0 end
    Tween(_M, {Size = isMinimized and UDim2.new(0, 580, 0, 50) or UDim2.new(0, 580, 0, 380)}, 0.4, Enum.EasingStyle.Quart)
end)

local _Resizer = Instance.new("TextButton", _M)
_Resizer.Size = UDim2.new(0, 26, 0, 26)
_Resizer.Position = UDim2.new(1, -26, 1, -26)
_Resizer.BackgroundTransparency = 1
_Resizer.Text = "◢"
_Resizer.TextColor3 = Color3.fromRGB(150, 150, 180)
_Resizer.TextSize = 15
_Resizer.Font = Enum.Font.GothamBold
_Resizer.ZIndex = 5

local resizing = false
local resizeStart, startSize
_Resizer.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = i.Position
        startSize = _M.AbsoluteSize
    end
end)
_UIS.InputChanged:Connect(function(i)
    if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - resizeStart
        _M.Size = UDim2.new(0, math.clamp(startSize.X + delta.X, 480, 800), 0, math.clamp(startSize.Y + delta.Y, 320, 600))
    end
end)
_UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

-- 🌟 悬浮球（尖角正方形，大写字母 L）
local _Ball = Instance.new("TextButton", _S)
_Ball.Size = UDim2.new(0, 60, 0, 60)
_Ball.Position = UDim2.new(0, 30, 0.4, 0)
_Ball.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
_Ball.BackgroundTransparency = 0.2
_Ball.Text = "L"
_Ball.TextColor3 = Color3.fromRGB(255, 255, 255)
_Ball.TextSize = 26
_Ball.Font = Enum.Font.GothamBold
_Ball.Visible = false
_Ball.ZIndex = 10
_Ball.AutoButtonColor = false

local bDragging, bDragStart, bStartPos, bMoved = false, nil, nil, false
_Ball.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        bDragging = true; bMoved = false
        bDragStart = i.Position
        bStartPos = _Ball.Position
    end
end)
_UIS.InputChanged:Connect(function(i)
    if bDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - bDragStart
        if delta.Magnitude > 5 then bMoved = true end
        _Ball.Position = UDim2.new(bStartPos.X.Scale, bStartPos.X.Offset + delta.X, bStartPos.Y.Scale, bStartPos.Y.Offset + delta.Y)
    end
end)
_UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        bDragging = false
    end
end)

_Ctrl("+", -110, Color3.fromRGB(99, 102, 241), Color3.fromRGB(129, 140, 248), function()
    _Ball.Position = _M.Position
    _M.Visible = false
    _Ball.Visible = true
    _Ball.Size = UDim2.new(0, 0, 0, 0)
    Tween(_Ball, {Size = UDim2.new(0, 60, 0, 60)}, 0.4, Enum.EasingStyle.Back)
end)

_Ball.MouseButton1Click:Connect(function()
    if bMoved then return end
    isMinimized = false
    _M.Position = _Ball.Position
    _M.Visible = true
    _Ball.Visible = false
    _Sidebar.Visible = true
    _ContentContainer.Visible = true
    _HeaderLine.Visible = true
    _SplitLine.Visible = true
    _BgImage.Visible = true
    _Title.Visible = true
    _M.Size = UDim2.new(0, 0, 0, 0)
    Tween(_M, {Size = UDim2.new(0, 580, 0, 380)}, 0.4, Enum.EasingStyle.Back)
end)

local _drag, _dStart, _sPos
_TB.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = true; _dStart = i.Position; _sPos = _M.Position end end)
_UIS.InputChanged:Connect(function(i) if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - _dStart; _M.Position = UDim2.new(_sPos.X.Scale, _sPos.X.Offset + d.X, _sPos.Y.Scale, _sPos.Y.Offset + d.Y) end end)
_UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = false end end)
