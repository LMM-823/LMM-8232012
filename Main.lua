
-- [[ 🌚刘某某脚本 V3.9.0 | Main.lua - UI 界面与主入口 ]]

-- 自动请求 GitHub Raw 加载 Core 模块
local Core = loadstring(game:HttpGet("https://raw.githubusercontent.com/LMM-823/LMM-8232012/main/Core.lua"))()

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _TS = game:GetService("TweenService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera
local _G_LMM_88 = getgenv()._G_LMM_88

local function Tween(obj, props, time, style, dir)
    Core.Tween(obj, props, time, style, dir)
end

if _CG:FindFirstChild("LMM_Final_V37") then _CG.LMM_Final_V37:Destroy() end
local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V37"
_S.ResetOnSpawn = false

-- ==================== 高端加载动画界面 ====================
local _LoadGui = Instance.new("Frame", _S)
_LoadGui.Size = UDim2.new(0, 320, 0, 110); _LoadGui.Position = UDim2.new(0.5, -160, 0.45, -55)
_LoadGui.BackgroundColor3 = Color3.fromRGB(12, 12, 20); _LoadGui.BackgroundTransparency = 0.05; _LoadGui.BorderSizePixel = 0
Instance.new("UICorner", _LoadGui).CornerRadius = UDim.new(0, 16)

local _LoadStroke = Instance.new("UIStroke", _LoadGui); _LoadStroke.Thickness = 2; _LoadStroke.Color = Color3.fromRGB(99, 102, 241)
local _LoadGradient = Instance.new("UIGradient", _LoadStroke)
_LoadGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(99, 102, 241)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(168, 85, 247)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(59, 130, 246))
})

local _LoadText = Instance.new("TextLabel", _LoadGui)
_LoadText.Size = UDim2.new(1, 0, 1, 0); _LoadText.BackgroundTransparency = 1
_LoadText.Text = "✨ 刘某某脚本 V3.9.0 加载中..."; _LoadText.TextColor3 = Color3.fromRGB(245, 245, 247); _LoadText.Font = Enum.Font.GothamBold; _LoadText.TextSize = 15

local loadingTween = _TS:Create(_LoadGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
loadingTween:Play()

-- ==================== 主界面容器 ====================
local _M = Instance.new("Frame", _S)
_M.Size = UDim2.new(0, 580, 0, 380); _M.Position = UDim2.new(0.5, -290, 0.5, -190)
_M.BackgroundColor3 = Color3.fromRGB(11, 11, 18); _M.BackgroundTransparency = 0.06; _M.BorderSizePixel = 0; _M.Visible = false
_M.ClipsDescendants = false
Instance.new("UICorner", _M).CornerRadius = UDim.new(0, 18)

local _Glow = Instance.new("UIStroke", _M); _Glow.Thickness = 1.6
local _GlowGradient = Instance.new("UIGradient", _Glow)
_GlowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(99, 102, 241)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(168, 85, 247)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(59, 130, 246))
})

local _Shadow = Instance.new("ImageLabel", _M)
_Shadow.Size = UDim2.new(1, 90, 1, 90); _Shadow.Position = UDim2.new(0, -45, 0, -45)
_Shadow.BackgroundTransparency = 1; _Shadow.Image = "rbxassetid://6014261993"
_Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0); _Shadow.ImageTransparency = 0.35
_Shadow.ScaleType = Enum.ScaleType.Slice; _Shadow.SliceCenter = Rect.new(49, 49, 450, 450); _Shadow.ZIndex = -1

local _BgImage = Instance.new("ImageLabel", _M)
_BgImage.Size = UDim2.new(1, 0, 1, 0); _BgImage.BackgroundTransparency = 1
_BgImage.Image = "rbxassetid://14392415174"; _BgImage.ImageTransparency = 0.92
_BgImage.ScaleType = Enum.ScaleType.Crop; _BgImage.ZIndex = 0
Instance.new("UICorner", _BgImage).CornerRadius = UDim.new(0, 18)

task.spawn(function()
    task.wait(1.8)
    loadingTween:Cancel()
    Tween(_LoadGui, {BackgroundTransparency = 1, Size = UDim2.new(0, 300, 0, 100)}, 0.4)
    Tween(_LoadText, {TextTransparency = 1}, 0.4)
    Tween(_LoadStroke, {Transparency = 1}, 0.4)
    task.wait(0.3)
    _LoadGui:Destroy()
    _M.Visible = true
    _M.Size = UDim2.new(0, 520, 0, 340)
    Tween(_M, {Size = UDim2.new(0, 580, 0, 380)}, 0.5, Enum.EasingStyle.Back)
end)

-- 标题栏
local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 50); _TB.BackgroundTransparency = 1; _TB.Active = true; _TB.ZIndex = 2
local _Title = Instance.new("TextLabel", _TB)
_Title.Size = UDim2.new(1, -150, 1, 0); _Title.Position = UDim2.new(0, 20, 0, 0); _Title.Text = "🌚 刘某某脚本 <font color='rgb(129, 140, 248)'>V3.9.0</font>"; _Title.RichText = true; _Title.Font = Enum.Font.GothamBold; _Title.TextSize = 16; _Title.TextColor3 = Color3.fromRGB(255, 255, 255); _Title.BackgroundTransparency = 1; _Title.TextXAlignment = Enum.TextXAlignment.Left; _Title.ZIndex = 2

-- 顶部分隔线
local _HeaderLine = Instance.new("Frame", _M)
_HeaderLine.Size = UDim2.new(1, -30, 0, 1); _HeaderLine.Position = UDim2.new(0, 15, 0, 50)
_HeaderLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255); _HeaderLine.BackgroundTransparency = 0.92; _HeaderLine.BorderSizePixel = 0; _HeaderLine.ZIndex = 2

-- 侧边栏
local _Sidebar = Instance.new("Frame", _M)
_Sidebar.Size = UDim2.new(0, 150, 1, -65); _Sidebar.Position = UDim2.new(0, 12, 0, 58); _Sidebar.BackgroundTransparency = 1; _Sidebar.ZIndex = 2
local _SideLayout = Instance.new("UIListLayout", _Sidebar)
_SideLayout.Padding = UDim.new(0, 6); _SideLayout.HorizontalAlignment = "Center"; _SideLayout.SortOrder = "LayoutOrder"

-- 侧边栏与内容区分割线
local _SplitLine = Instance.new("Frame", _M)
_SplitLine.Size = UDim2.new(0, 1, 1, -65); _SplitLine.Position = UDim2.new(0, 168, 0, 58)
_SplitLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255); _SplitLine.BackgroundTransparency = 0.94; _SplitLine.BorderSizePixel = 0; _SplitLine.ZIndex = 2

-- 内容页面容器
local _ContentContainer = Instance.new("Frame", _M)
_ContentContainer.Size = UDim2.new(1, -182, 1, -65); _ContentContainer.Position = UDim2.new(0, 176, 0, 58); _ContentContainer.BackgroundTransparency = 1; _ContentContainer.ZIndex = 2

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

local _Page1 = _CreatePage(1); local _Page2 = _CreatePage(2); local _Page3 = _CreatePage(3); local _Page4 = _CreatePage(4)
local _Tabs = {}

local function _CreateTabBtn(name, order, targetPage)
    local b = Instance.new("TextButton", _Sidebar)
    b.LayoutOrder = order; b.Size = UDim2.new(1, 0, 0, 36)
    b.BackgroundColor3 = (order == 1) and Color3.fromRGB(28, 28, 44) or Color3.fromRGB(16, 16, 26)
    b.BackgroundTransparency = (order == 1) and 0.15 or 0.6
    b.Text = "   " .. name; b.Font = Enum.Font.GothamMedium; b.TextSize = 13
    b.TextColor3 = (order == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 170)
    b.TextXAlignment = Enum.TextXAlignment.Left; b.ZIndex = 2; b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    local indicator = Instance.new("Frame", b)
    indicator.Size = UDim2.new(0, 3, 0.5, 0); indicator.Position = UDim2.new(0, 0, 0.25, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(129, 140, 248); indicator.BorderSizePixel = 0
    indicator.BackgroundTransparency = (order == 1) and 0 or 1
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    _Tabs[b] = {page = targetPage, indicator = indicator, order = order}
    
    b.MouseEnter:Connect(function()
        if _Tabs[b].page.Visible then return end
        Tween(b, {BackgroundColor3 = Color3.fromRGB(24, 24, 38), BackgroundTransparency = 0.3, TextColor3 = Color3.fromRGB(220, 220, 240)}, 0.2)
    end)
    b.MouseLeave:Connect(function()
        if _Tabs[b].page.Visible then return end
        Tween(b, {BackgroundColor3 = Color3.fromRGB(16, 16, 26), BackgroundTransparency = 0.6, TextColor3 = Color3.fromRGB(150, 150, 170)}, 0.2)
    end)
    b.MouseButton1Click:Connect(function()
        for btn, data in pairs(_Tabs) do
            data.page.Visible = (btn == b)
            if btn == b then
                Tween(btn, {BackgroundColor3 = Color3.fromRGB(28, 28, 44), BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                Tween(data.indicator, {BackgroundTransparency = 0, Size = UDim2.new(0, 3, 0.65, 0), Position = UDim2.new(0, 0, 0.175, 0)}, 0.2)
            else
                Tween(btn, {BackgroundColor3 = Color3.fromRGB(16, 16, 26), BackgroundTransparency = 0.6, TextColor3 = Color3.fromRGB(150, 150, 170)}, 0.2)
                Tween(data.indicator, {BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0.5, 0), Position = UDim2.new(0, 0, 0.25, 0)}, 0.2)
            end
        end
    end)
end

_CreateTabBtn("🏠 主功能", 1, _Page1)
_CreateTabBtn("⚡ 脚本合集", 2, _Page2)
_CreateTabBtn("📜 更新日志", 3, _Page3)
_CreateTabBtn("⚙️ 设定中心", 4, _Page4)

-- 个人头像展示卡
local _AvatarContainer = Instance.new("Frame", _Sidebar)
_AvatarContainer.LayoutOrder = 5; _AvatarContainer.Size = UDim2.new(1, 0, 0, 82); _AvatarContainer.BackgroundTransparency = 1; _AvatarContainer.ZIndex = 2

local _AvatarImg = Instance.new("ImageLabel", _AvatarContainer)
_AvatarImg.Size = UDim2.new(0, 74, 0, 74); _AvatarImg.Position = UDim2.new(0.5, -37, 0, 2)
_AvatarImg.BackgroundColor3 = Color3.fromRGB(15, 15, 22); _AvatarImg.BackgroundTransparency = 0.2; _AvatarImg.BorderSizePixel = 0
_AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. _LP.UserId .. "&w=150&h=150"; _AvatarImg.ZIndex = 2
Instance.new("UICorner", _AvatarImg).CornerRadius = UDim.new(0, 14)

local _AvatarStroke = Instance.new("UIStroke", _AvatarImg); _AvatarStroke.Thickness = 1.5
local _AvatarStrokeGrad = Instance.new("UIGradient", _AvatarStroke)
_AvatarStrokeGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(99, 102, 241)), ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 85, 247))})

local _AvatarTextFrame = Instance.new("Frame", _AvatarImg)
_AvatarTextFrame.Size = UDim2.new(1, 0, 0, 20); _AvatarTextFrame.Position = UDim2.new(0, 0, 1, -20); _AvatarTextFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 14); _AvatarTextFrame.BackgroundTransparency = 0.25; _AvatarTextFrame.BorderSizePixel = 0; _AvatarTextFrame.ZIndex = 3
Instance.new("UICorner", _AvatarTextFrame).CornerRadius = UDim.new(0, 8)

local _AvatarText = Instance.new("TextLabel", _AvatarTextFrame)
_AvatarText.Size = UDim2.new(1, 0, 1, 0); _AvatarText.BackgroundTransparency = 1
_AvatarText.Text = _LP.Name; _AvatarText.TextColor3 = Color3.fromRGB(240, 240, 250); _AvatarText.Font = Enum.Font.GothamBold; _AvatarText.TextSize = 10; _AvatarText.ZIndex = 4

-- FPS看板
local _StatsContainer = Instance.new("Frame", _TB)
_StatsContainer.Size = UDim2.new(0, 160, 0, 26); _StatsContainer.Position = UDim2.new(1, -285, 0.5, -13)
_StatsContainer.BackgroundColor3 = Color3.fromRGB(14, 14, 22); _StatsContainer.BackgroundTransparency = 0.2; _StatsContainer.ZIndex = 2
Instance.new("UICorner", _StatsContainer).CornerRadius = UDim.new(0, 8)
local _StatsStroke = Instance.new("UIStroke", _StatsContainer); _StatsStroke.Thickness = 1; _StatsStroke.Color = Color3.fromRGB(45, 45, 65)

local _StatsDot = Instance.new("Frame", _StatsContainer)
_StatsDot.Size = UDim2.new(0, 6, 0, 6); _StatsDot.Position = UDim2.new(0, 8, 0.5, -3)
_StatsDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94); _StatsDot.ZIndex = 3
Instance.new("UICorner", _StatsDot).CornerRadius = UDim.new(1, 0)

local _StatsText = Instance.new("TextLabel", _StatsContainer)
_StatsText.Size = UDim2.new(1, -18, 1, 0); _StatsText.Position = UDim2.new(0, 18, 0, 0); _StatsText.BackgroundTransparency = 1
_StatsText.Font = Enum.Font.GothamBold; _StatsText.TextSize = 10; _StatsText.TextColor3 = Color3.fromRGB(200, 200, 220); _StatsText.ZIndex = 3

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
    local f = Instance.new("Frame", targetPage); f.LayoutOrder = order; f.Size = UDim2.new(0.98, 0, 0, 34); f.BackgroundTransparency = 1; f.ZIndex = 2
    local layout = Instance.new("UIListLayout", f); layout.FillDirection = "Horizontal"; layout.HorizontalAlignment = "Center"; layout.Padding = UDim.new(0, 8)
    local colors = {{Color3.fromRGB(99, 102, 241), "蓝"}, {Color3.fromRGB(239, 68, 68), "红"}, {Color3.fromRGB(255, 255, 255), "白"}, {Color3.fromRGB(50, 50, 60), "黑"}, {Color3.fromRGB(34, 197, 94), "绿"}}
    for _, info in pairs(colors) do
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 44, 0, 26); b.BackgroundColor3 = info[1]; b.Text = ""; b.ZIndex = 2; b.AutoButtonColor = false; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", b); s.Thickness = 2; s.Color = Color3.fromRGB(255,255,255); s.Enabled = false
        b.MouseEnter:Connect(function() Tween(b, {Size = UDim2.new(0, 48, 0, 30)}, 0.15) end)
        b.MouseLeave:Connect(function() Tween(b, {Size = UDim2.new(0, 44, 0, 26)}, 0.15) end)
        b.MouseButton1Click:Connect(function() _G_LMM_88[key] = info[1]; for _, c in pairs(f:GetChildren()) do if c:IsA("TextButton") then c.UIStroke.Enabled = false end end; s.Enabled = true end)
    end
end

local function _CreateT(targetPage, name, key, order)
    local b = Instance.new("TextButton", targetPage); b.LayoutOrder = order; b.Size = UDim2.new(0.98, 0, 0, 42); b.BackgroundColor3 = Color3.fromRGB(18, 18, 28); b.BackgroundTransparency = 0.25; b.Text = "   " .. name; b.Font = Enum.Font.GothamMedium; b.TextSize = 13; b.TextColor3 = Color3.fromRGB(230, 230, 240); b.TextXAlignment = Enum.TextXAlignment.Left; b.ZIndex = 2; b.AutoButtonColor = false; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", b); s.Thickness = 1; s.Color = Color3.fromRGB(38, 38, 55)
    
    local track = Instance.new("Frame", b); track.Size = UDim2.new(0, 40, 0, 22); track.Position = UDim2.new(1, -52, 0.5, -11); track.BackgroundColor3 = Color3.fromRGB(30, 30, 44); track.ZIndex = 2; Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", track); knob.Size = UDim2.new(0, 16, 0, 16); knob.Position = UDim2.new(0, 3, 0.5, -8); knob.BackgroundColor3 = Color3.fromRGB(180, 180, 200); knob.ZIndex = 3; Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(25, 25, 40), BackgroundTransparency = 0.1}, 0.2); Tween(s, {Color = Color3.fromRGB(99, 102, 241)}, 0.2) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(18, 18, 28), BackgroundTransparency = 0.25}, 0.2); Tween(s, {Color = Color3.fromRGB(38, 38, 55)}, 0.2) end)
    b.MouseButton1Click:Connect(function() 
        _G_LMM_88[key] = not _G_LMM_88[key]
        local state = _G_LMM_88[key]
        
        if key == "v_freeze" and not state then
            pcall(function()
                local lChar = _LP.Character
                if lChar and lChar:FindFirstChild("HumanoidRootPart") then
                    lChar.HumanoidRootPart.Anchored = false
                end
            end)
        end

        Tween(track, {BackgroundColor3 = state and Color3.fromRGB(99, 102, 241) or Color3.fromRGB(30, 30, 44)}, 0.3)
        Tween(knob, {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 200)
        }, 0.3, Enum.EasingStyle.Back)
    end)
end

local function _CreateS(targetPage, name, url, order)
    local b = Instance.new("TextButton", targetPage); b.LayoutOrder = order; b.Size = UDim2.new(0.98, 0, 0, 42); b.BackgroundColor3 = Color3.fromRGB(18, 18, 28); b.BackgroundTransparency = 0.25; b.Text = "   " .. name; b.Font = Enum.Font.GothamMedium; b.TextSize = 13; b.TextColor3 = Color3.fromRGB(240, 240, 250); b.TextXAlignment = Enum.TextXAlignment.Left; b.ZIndex = 2; b.AutoButtonColor = false; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", b); s.Thickness = 1; s.Color = Color3.fromRGB(38, 38, 55)

    b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(28, 28, 44), BackgroundTransparency = 0.1}, 0.2); Tween(s, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(18, 18, 28), BackgroundTransparency = 0.25}, 0.2); Tween(s, {Color = Color3.fromRGB(38, 38, 55)}, 0.2) end)
    b.MouseButton1Click:Connect(function()
        task.spawn(function() loadstring(game:HttpGet(url))() end)
    end)
end

local function _DecorateInput(input)
    input.MouseEnter:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
    input.MouseLeave:Connect(function() if not input:IsFocused() then Tween(input.UIStroke, {Color = Color3.fromRGB(38, 38, 55)}, 0.2) end end)
    input.Focused:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(99, 102, 241)}, 0.2) end)
    input.FocusLost:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(38, 38, 55)}, 0.2) end)
end

-- Page 1: 主功能
local _In1 = Instance.new("TextBox", _Page1); _In1.LayoutOrder = 1; _In1.Size = UDim2.new(0.98, 0, 0, 40); _In1.BackgroundColor3 = Color3.fromRGB(16, 16, 26); _In1.BackgroundTransparency = 0.25; _In1.Text = "  行走速度: 50"; _In1.TextColor3 = Color3.fromRGB(240, 240, 250); _In1.Font = Enum.Font.GothamMedium; _In1.TextSize = 13; _In1.TextXAlignment = Enum.TextXAlignment.Left; _In1.ZIndex = 2; Instance.new("UICorner", _In1).CornerRadius = UDim.new(0, 10)
local _In1S = Instance.new("UIStroke", _In1); _In1S.Thickness = 1; _In1S.Color = Color3.fromRGB(38, 38, 55); _DecorateInput(_In1)
_In1.FocusLost:Connect(function() _G_LMM_88.v_val_1 = tonumber(_In1.Text:match("%d+")) or 50; _In1.Text = "  行走速度: ".._G_LMM_88.v_val_1 end)

local _In2 = Instance.new("TextBox", _Page1); _In2.LayoutOrder = 2; _In2.Size = UDim2.new(0.98, 0, 0, 40); _In2.BackgroundColor3 = Color3.fromRGB(16, 16, 26); _In2.BackgroundTransparency = 0.25; _In2.Text = "  飞行速度: 50"; _In2.TextColor3 = Color3.fromRGB(240, 240, 250); _In2.Font = Enum.Font.GothamMedium; _In2.TextSize = 13; _In2.TextXAlignment = Enum.TextXAlignment.Left; _In2.ZIndex = 2; Instance.new("UICorner", _In2).CornerRadius = UDim.new(0, 10)
local _In2S = Instance.new("UIStroke", _In2); _In2S.Thickness = 1; _In2S.Color = Color3.fromRGB(38, 38, 55); _DecorateInput(_In2)
_In2.FocusLost:Connect(function() _G_LMM_88.v_val_2 = tonumber(_In2.Text:match("%d+")) or 50; _In2.Text = "  飞行速度: ".._G_LMM_88.v_val_2 end)

_CreateT(_Page1, "冰冻 (让自己固定)", "v_freeze", 3)
_CreateT(_Page1, "无限跳 (Infinite Jump)", "v_infjump", 4)
_CreateT(_Page1, "内置穿墙 (NOCLIP)", "v_0x2", 5)
_CreateT(_Page1, "内置速度开关", "v_0x3", 6)
_CreateT(_Page1, "内置飞行开关 (FLY)", "v_0x4", 7)
_CreateT(_Page1, "内置透视 (ESP)", "v_0x1", 8); _CreateColorBar(_Page1, "c_esp", 9)
_CreateT(_Page1, "内置ESP射线", "v_esp_line", 10); _CreateColorBar(_Page1, "c_line", 11)
_CreateT(_Page1, "内置ESP方框", "v_esp_box", 12); _CreateColorBar(_Page1, "c_box", 13)

-- Page 2: 脚本合集
local _SearchBox = Instance.new("TextBox", _Page2)
_SearchBox.LayoutOrder = 1; _SearchBox.Size = UDim2.new(0.98, 0, 0, 40); _SearchBox.BackgroundColor3 = Color3.fromRGB(16, 16, 26); _SearchBox.BackgroundTransparency = 0.25
_SearchBox.PlaceholderText = "🔍 搜索精彩脚本..."; _SearchBox.Text = ""; _SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
_SearchBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 150); _SearchBox.Font = Enum.Font.GothamMedium; _SearchBox.TextSize = 13; _SearchBox.ZIndex = 2
Instance.new("UICorner", _SearchBox).CornerRadius = UDim.new(0, 10)
local _SearchStroke = Instance.new("UIStroke", _SearchBox); _SearchStroke.Thickness = 1; _SearchStroke.Color = Color3.fromRGB(38, 38, 55)
_DecorateInput(_SearchBox)

_SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = _SearchBox.Text:lower()
    for _, child in pairs(_Page2:GetChildren()) do
        if child:IsA("TextButton") and child ~= _SearchBox then
            child.Visible = (query == "" or child.Text:lower():find(query) ~= nil)
        end
    end
end)

_CreateS(_Page2, "mm2 no key", "https://raw.githubusercontent.com/kaisudlnw-png/robloxmm2autofarm/refs/heads/main/autofarmmm2", 2)
_CreateS(_Page2, "AIMBOT (自瞄)", "https://rawscripts.net/raw/Universal-Script-Aimbot-Mobile-34677", 3)
_CreateS(_Page2, "RIVALS NO KEY", "https://raw.githubusercontent.com/idkmsnscriptronlox/Shadow-/refs/heads/main/Shadow", 4)
_CreateS(_Page2, "Infinite Yield (万能脚本)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 5)
_CreateS(_Page2, "Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source", 6)
_CreateS(_Page2, "Owl Hub (极简稳定版)", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt", 7)

local _ACBtn = Instance.new("TextButton", _Page2); _ACBtn.LayoutOrder = 8; _ACBtn.Size = UDim2.new(0.98, 0, 0, 42); _ACBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 28); _ACBtn.BackgroundTransparency = 0.25; _ACBtn.Text = "   ⚡ 自动连点器（刘某某）"; _ACBtn.Font = Enum.Font.GothamMedium; _ACBtn.TextSize = 13; _ACBtn.TextColor3 = Color3.fromRGB(240, 240, 250); _ACBtn.TextXAlignment = Enum.TextXAlignment.Left; _ACBtn.ZIndex = 2; _ACBtn.AutoButtonColor = false; Instance.new("UICorner", _ACBtn).CornerRadius = UDim.new(0, 10)
local _ACS = Instance.new("UIStroke", _ACBtn); _ACS.Thickness = 1; _ACS.Color = Color3.fromRGB(38, 38, 55)
_ACBtn.MouseEnter:Connect(function() Tween(_ACBtn, {BackgroundColor3 = Color3.fromRGB(28, 28, 44)}, 0.2); Tween(_ACS, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
_ACBtn.MouseLeave:Connect(function() Tween(_ACBtn, {BackgroundColor3 = Color3.fromRGB(18, 18, 28)}, 0.2); Tween(_ACS, {Color = Color3.fromRGB(38, 38, 55)}, 0.2) end)
_ACBtn.MouseButton1Click:Connect(function()
    loadstring([[
        local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
        local MainFrame = Instance.new("Frame", ScreenGui)
        local Title = Instance.new("TextLabel", MainFrame)
        local ToggleBtn = Instance.new("TextButton", MainFrame)
        local SpeedInput = Instance.new("TextBox", MainFrame)
        local MainStroke = Instance.new("UIStroke", MainFrame)
        MainFrame.Size = UDim2.new(0, 220, 0, 160); MainFrame.Position = UDim2.new(0.5, -110, 0.4, -90); MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18); MainFrame.BackgroundTransparency = 0.1; MainFrame.Active = true; MainFrame.Draggable = true; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
        MainStroke.Thickness = 1.4; MainStroke.Color = Color3.fromRGB(99, 102, 241)
        Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 14, 0, 8); Title.Size = UDim2.new(1, -40, 0, 30); Title.Font = Enum.Font.GothamBold; Title.Text = "⚡ 自动连点器"; Title.TextColor3 = Color3.fromRGB(240,240,250); Title.TextSize = 14
        SpeedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30); SpeedInput.Position = UDim2.new(0.1, 0, 0.32, 0); SpeedInput.Size = UDim2.new(0.8, 0, 0, 34); SpeedInput.Text = "0.05"; SpeedInput.TextColor3 = Color3.fromRGB(240,240,250); Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0, 8)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(99, 102, 241); ToggleBtn.Position = UDim2.new(0.1, 0, 0.62, 0); ToggleBtn.Size = UDim2.new(0.8, 0, 0, 38); ToggleBtn.Text = "开启连点"; ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255); ToggleBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
        local clicking = false; local vim = game:GetService("VirtualInputManager")
        ToggleBtn.MouseButton1Click:Connect(function() clicking = not clicking; if clicking then ToggleBtn.Text = "停止连点"; ToggleBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68); task.spawn(function() while clicking do vim:SendMouseButtonEvent(0,0,0,true,game,0); vim:SendMouseButtonEvent(0,0,0,false,game,0); task.wait(tonumber(SpeedInput.Text) or 0.05) end end) else ToggleBtn.Text = "开启连点"; ToggleBtn.BackgroundColor3 = Color3.fromRGB(99, 102, 241) end end)
        local Close = Instance.new("TextButton", MainFrame); Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 8); Close.Text = "×"; Close.TextColor3 = Color3.fromRGB(200,200,210); Close.BackgroundTransparency = 1; Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    ]])()
end)

local _DCB = Instance.new("TextButton", _Page2); _DCB.LayoutOrder = 9; _DCB.Size = UDim2.new(0.98, 0, 0, 42); _DCB.BackgroundColor3 = Color3.fromRGB(88, 101, 242); _DCB.Text = "🔗 JOIN DISCORD COMMUNITY"; _DCB.TextColor3 = Color3.fromRGB(255, 255, 255); _DCB.Font = Enum.Font.GothamBold; _DCB.TextSize = 13; _DCB.ZIndex = 2; _DCB.AutoButtonColor = false; Instance.new("UICorner", _DCB).CornerRadius = UDim.new(0, 10)
_DCB.MouseEnter:Connect(function() Tween(_DCB, {BackgroundColor3 = Color3.fromRGB(108, 121, 255)}, 0.2) end)
_DCB.MouseLeave:Connect(function() Tween(_DCB, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}, 0.2) end)
_DCB.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/cjpezEZub") end)

-- Page 3: 更新日志
local function _CreateLogEntry(version, date, desc, order)
    local f = Instance.new("Frame", _Page3)
    f.LayoutOrder = order; f.Size = UDim2.new(0.98, 0, 0, 0); f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = Color3.fromRGB(16, 16, 26); f.BackgroundTransparency = 0.25; f.ZIndex = 2
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", f); stroke.Thickness = 1; stroke.Color = Color3.fromRGB(38, 38, 55)
    
    local pad = Instance.new("UIPadding", f)
    pad.PaddingTop = UDim.new(0, 10); pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 14); pad.PaddingRight = UDim.new(0, 14)
    
    local layout = Instance.new("UIListLayout", f)
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 4)

    local t = Instance.new("TextLabel", f)
    t.LayoutOrder = 1; t.Size = UDim2.new(1, 0, 0, 22)
    t.BackgroundTransparency = 1; t.Text = "<font color='rgb(129,140,248)'>" .. version .. "</font> <font color='rgb(130,130,150)'>- " .. date .. "</font>"
    t.RichText = true; t.TextColor3 = Color3.fromRGB(255, 255, 255); t.Font = Enum.Font.GothamBold; t.TextSize = 13; t.TextXAlignment = Enum.TextXAlignment.Left; t.ZIndex = 2
    
    local d = Instance.new("TextLabel", f)
    d.LayoutOrder = 2; d.Size = UDim2.new(1, 0, 0, 0); d.AutomaticSize = Enum.AutomaticSize.Y
    d.BackgroundTransparency = 1; d.Text = desc; d.TextColor3 = Color3.fromRGB(170, 170, 185)
    d.Font = Enum.Font.GothamMedium; d.TextSize = 12; d.TextXAlignment = Enum.TextXAlignment.Left; d.TextWrapped = true; d.ZIndex = 2

    f.MouseEnter:Connect(function() Tween(stroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.25) end)
    f.MouseLeave:Connect(function() Tween(stroke, {Color = Color3.fromRGB(38, 38, 55)}, 0.25) end)
end

_CreateLogEntry("V3.9.0", "2026-08-31", "【重磅UI升级】重构滚动引擎，解决更新日志与页面滑动阻尼问题；升级全界面高定深色拟态特效与丝滑交互。", 1)
_CreateLogEntry("V3.8.3", "2026-03-30", "修复了头像比例变形并重构更新日志滚动视图，完美支持上下滑动。", 2)
_CreateLogEntry("V3.8.2", "2026-03-30", "主功能面板新增‘冰冻（角色锚定固定）’与‘无限跳’功能开关，提升跑图与对战体验。", 3)
_CreateLogEntry("V3.8.1", "2026-03-30", "彻底修复了悬浮球与最小化折叠按钮的状态逻辑，确保点击后可以完美还原展开。", 4)
_CreateLogEntry("V3.8.0", "2026-03-25", "测试更新日志滚动模板，修复滑动体验。", 5)

-- Page 4: 设定
local _FpsInput = Instance.new("TextBox", _Page4)
_FpsInput.LayoutOrder = 1; _FpsInput.Size = UDim2.new(0.98, 0, 0, 40); _FpsInput.BackgroundColor3 = Color3.fromRGB(16, 16, 26); _FpsInput.BackgroundTransparency = 0.25
_FpsInput.Text = "  设置FPS解锁 (15-240): 60"; _FpsInput.TextColor3 = Color3.fromRGB(240, 240, 250); _FpsInput.Font = Enum.Font.GothamMedium; _FpsInput.TextSize = 13; _FpsInput.TextXAlignment = Enum.TextXAlignment.Left; _FpsInput.ZIndex = 2
Instance.new("UICorner", _FpsInput).CornerRadius = UDim.new(0, 10)
local _FpsStroke = Instance.new("UIStroke", _FpsInput); _FpsStroke.Thickness = 1; _FpsStroke.Color = Color3.fromRGB(38, 38, 55)
_DecorateInput(_FpsInput)

_FpsInput.FocusLost:Connect(function()
    local val = tonumber(_FpsInput.Text:match("%d+")) or 60
    if val < 15 then val = 15 end if val > 240 then val = 240 end
    _FpsInput.Text = "  设置FPS解锁 (15-240): " .. val
    pcall(function() setfpscap(val) end)
end)

local _BgmContainer = Instance.new("Frame", _Page4)
_BgmContainer.LayoutOrder = 2; _BgmContainer.Size = UDim2.new(0.98, 0, 0, 85); _BgmContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 26); _BgmContainer.BackgroundTransparency = 0.25; _BgmContainer.ZIndex = 2
Instance.new("UICorner", _BgmContainer).CornerRadius = UDim.new(0, 10)
local _BgmStroke = Instance.new("UIStroke", _BgmContainer); _BgmStroke.Thickness = 1; _BgmStroke.Color = Color3.fromRGB(38, 38, 55)

local _BgmTitle = Instance.new("TextLabel", _BgmContainer)
_BgmTitle.Size = UDim2.new(1, -20, 0, 25); _BgmTitle.Position = UDim2.new(0, 10, 0, 6)
_BgmTitle.BackgroundTransparency = 1; _BgmTitle.Text = "🎵 云端背景音乐播放器 (BGM)"; _BgmTitle.TextColor3 = Color3.fromRGB(240, 240, 250); _BgmTitle.Font = Enum.Font.GothamBold; _BgmTitle.TextSize = 12; _BgmTitle.TextXAlignment = Enum.TextXAlignment.Left; _BgmTitle.ZIndex = 3

local _BgmInput = Instance.new("TextBox", _BgmContainer)
_BgmInput.Size = UDim2.new(0.65, 0, 0, 36); _BgmInput.Position = UDim2.new(0, 10, 0, 38)
_BgmInput.BackgroundColor3 = Color3.fromRGB(12, 12, 18); _BgmInput.BackgroundTransparency = 0.2
_BgmInput.Text = "rbxassetid://1843158679"; _BgmInput.TextColor3 = Color3.fromRGB(220, 220, 235); _BgmInput.Font = Enum.Font.GothamMedium; _BgmInput.TextSize = 11; _BgmInput.ZIndex = 3
Instance.new("UICorner", _BgmInput).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", _BgmInput).Thickness = 1
local _BgmToggle = Instance.new("TextButton", _BgmContainer)
_BgmToggle.Size = UDim2.new(0.3, 0, 0, 36); _BgmToggle.Position = UDim2.new(0.68, 0, 0, 38)
_BgmToggle.BackgroundColor3 = Color3.fromRGB(99, 102, 241); _BgmToggle.Text = "播放音乐"; _BgmToggle.TextColor3 = Color3.fromRGB(255, 255, 255); _BgmToggle.Font = Enum.Font.GothamBold; _BgmToggle.TextSize = 12; _BgmToggle.ZIndex = 3
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
    else
        pcall(function() soundObj:Stop() end)
        _BgmToggle.Text = "播放音乐"
        _BgmToggle.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
    end
end)

local _FpsBoostRealBtn = Instance.new("TextButton", _Page4)
_FpsBoostRealBtn.LayoutOrder = 3; _FpsBoostRealBtn.Size = UDim2.new(0.98, 0, 0, 40); _FpsBoostRealBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 26); _FpsBoostRealBtn.BackgroundTransparency = 0.25
_FpsBoostRealBtn.Text = "   ⚡ 开启 FPS Boost (极致性能优化)"; _FpsBoostRealBtn.TextColor3 = Color3.fromRGB(240, 240, 250); _FpsBoostRealBtn.Font = Enum.Font.GothamMedium; _FpsBoostRealBtn.TextSize = 13; _FpsBoostRealBtn.TextXAlignment = Enum.TextXAlignment.Left; _FpsBoostRealBtn.ZIndex = 2; _FpsBoostRealBtn.AutoButtonColor = false
Instance.new("UICorner", _FpsBoostRealBtn).CornerRadius = UDim.new(0, 10)
local _FpsBoostRealStroke = Instance.new("UIStroke", _FpsBoostRealBtn); _FpsBoostRealStroke.Thickness = 1; _FpsBoostRealStroke.Color = Color3.fromRGB(38, 38, 55)

_FpsBoostRealBtn.MouseEnter:Connect(function() Tween(_FpsBoostRealBtn, {BackgroundColor3 = Color3.fromRGB(26, 26, 38)}, 0.2); Tween(_FpsBoostRealStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
_FpsBoostRealBtn.MouseLeave:Connect(function() Tween(_FpsBoostRealBtn, {BackgroundColor3 = Color3.fromRGB(16, 16, 26)}, 0.2); Tween(_FpsBoostRealStroke, {Color = Color3.fromRGB(38, 38, 55)}, 0.2) end)
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
    _FpsBoostRealBtn.Text = "   ⚡ FPS Boost 优化已完美生效！"
    task.wait(1.5)
    _FpsBoostRealBtn.Text = "   ⚡ 开启 FPS Boost (极致性能优化)"
end)

local _PingBoostBtn = Instance.new("TextButton", _Page4)
_PingBoostBtn.LayoutOrder = 4; _PingBoostBtn.Size = UDim2.new(0.98, 0, 0, 40); _PingBoostBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 26); _PingBoostBtn.BackgroundTransparency = 0.25
_PingBoostBtn.Text = "   🌐 开启网络低延迟优化 (Ping Boost)"; _PingBoostBtn.TextColor3 = Color3.fromRGB(240, 240, 250); _PingBoostBtn.Font = Enum.Font.GothamMedium; _PingBoostBtn.TextSize = 13; _PingBoostBtn.TextXAlignment = Enum.TextXAlignment.Left; _PingBoostBtn.ZIndex = 2; _PingBoostBtn.AutoButtonColor = false
Instance.new("UICorner", _PingBoostBtn).CornerRadius = UDim.new(0, 10)
local _PingBoostStroke = Instance.new("UIStroke", _PingBoostBtn); _PingBoostStroke.Thickness = 1; _PingBoostStroke.Color = Color3.fromRGB(38, 38, 55)

_PingBoostBtn.MouseEnter:Connect(function() Tween(_PingBoostBtn, {BackgroundColor3 = Color3.fromRGB(26, 26, 38)}, 0.2); Tween(_PingBoostStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
_PingBoostBtn.MouseLeave:Connect(function() Tween(_PingBoostBtn, {BackgroundColor3 = Color3.fromRGB(16, 16, 26)}, 0.2); Tween(_PingBoostStroke, {Color = Color3.fromRGB(38, 38, 55)}, 0.2) end)

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
    _PingBoostBtn.Text = "   🌐 低延迟同步优化已生效！"
    task.wait(1.5)
    _PingBoostBtn.Text = "   🌐 开启网络低延迟优化 (Ping Boost)"
end)

local _AfkBtn = Instance.new("TextButton", _Page4)
_AfkBtn.LayoutOrder = 5; _AfkBtn.Size = UDim2.new(0.98, 0, 0, 40); _AfkBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 26); _AfkBtn.BackgroundTransparency = 0.25
_AfkBtn.Text = "   💤 开启挂机AFK (防踢保护)"; _AfkBtn.TextColor3 = Color3.fromRGB(240, 240, 250); _AfkBtn.Font = Enum.Font.GothamMedium; _AfkBtn.TextSize = 13; _AfkBtn.TextXAlignment = Enum.TextXAlignment.Left; _AfkBtn.ZIndex = 2; _AfkBtn.AutoButtonColor = false
Instance.new("UICorner", _AfkBtn).CornerRadius = UDim.new(0, 10)
local _AfkStroke = Instance.new("UIStroke", _AfkBtn); _AfkStroke.Thickness = 1; _AfkStroke.Color = Color3.fromRGB(38, 38, 55)

_AfkBtn.MouseEnter:Connect(function() Tween(_AfkBtn, {BackgroundColor3 = Color3.fromRGB(26, 26, 38)}, 0.2); Tween(_AfkStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
_AfkBtn.MouseLeave:Connect(function() Tween(_AfkBtn, {BackgroundColor3 = Color3.fromRGB(16, 16, 26)}, 0.2); Tween(_AfkStroke, {Color = Color3.fromRGB(38, 38, 55)}, 0.2) end)

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
        _AfkBtn.Text = "   💤 挂机AFK防踢保护已开启！"
        Tween(_AfkBtn, {BackgroundColor3 = Color3.fromRGB(34, 197, 94)}, 0.3)
    else
        pcall(function()
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
        end)
        _AfkBtn.Text = "   💤 开启挂机AFK (防踢保护)"
        Tween(_AfkBtn, {BackgroundColor3 = Color3.fromRGB(16, 16, 26)}, 0.3)
    end
end)

-- Fullbright 按钮
local _FullbrightBtn = Instance.new("TextButton", _Page4)
_FullbrightBtn.LayoutOrder = 6; _FullbrightBtn.Size = UDim2.new(0.98, 0, 0, 40); _FullbrightBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 26); _FullbrightBtn.BackgroundTransparency = 0.25
_FullbrightBtn.Text = "   ☀️ 开启 Fullbright (全局高亮)"; _FullbrightBtn.TextColor3 = Color3.fromRGB(240, 240, 250); _FullbrightBtn.Font = Enum.Font.GothamMedium; _FullbrightBtn.TextSize = 13; _FullbrightBtn.TextXAlignment = Enum.TextXAlignment.Left; _FullbrightBtn.ZIndex = 2; _FullbrightBtn.AutoButtonColor = false
Instance.new("UICorner", _FullbrightBtn).CornerRadius = UDim.new(0, 10)
local _FullbrightStroke = Instance.new("UIStroke", _FullbrightBtn); _FullbrightStroke.Thickness = 1; _FullbrightStroke.Color = Color3.fromRGB(38, 38, 55)

_FullbrightBtn.MouseEnter:Connect(function() Tween(_FullbrightBtn, {BackgroundColor3 = Color3.fromRGB(26, 26, 38)}, 0.2); Tween(_FullbrightStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
_FullbrightBtn.MouseLeave:Connect(function() Tween(_FullbrightBtn, {BackgroundColor3 = Color3.fromRGB(16, 16, 26)}, 0.2); Tween(_FullbrightStroke, {Color = Color3.fromRGB(38, 38, 55)}, 0.2) end)

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
        _FullbrightBtn.Text = "   ☀️ Fullbright (全局高亮) 已开启！"
        Tween(_FullbrightBtn, {BackgroundColor3 = Color3.fromRGB(34, 197, 94)}, 0.3)
    else
        if fullbrightConn then
            fullbrightConn:Disconnect()
            fullbrightConn = nil
        end
        _FullbrightBtn.Text = "   ☀️ 开启 Fullbright (全局高亮)"
        Tween(_FullbrightBtn, {BackgroundColor3 = Color3.fromRGB(16, 16, 26)}, 0.3)
    end
end)

local function _Ctrl(t, x, c, hoverC, f)
    local b = Instance.new("TextButton", _TB); b.Size = UDim2.new(0, 26, 0, 26); b.Position = UDim2.new(1, x, 0.5, -13); b.Text = t; b.BackgroundColor3 = c; b.BackgroundTransparency = 0.15; b.TextColor3 = Color3.fromRGB(240,240,250); b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.ZIndex = 3; b.AutoButtonColor = false; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = hoverC}, 0.2) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = c}, 0.2) end)
    b.MouseButton1Click:Connect(f)
end

-- 关闭按钮
_Ctrl("×", -40, Color3.fromRGB(239, 68, 68), Color3.fromRGB(255, 90, 90), function() 
    pcall(function() _LP.Character.HumanoidRootPart.Anchored = false end)
    Tween(_M, {Size = UDim2.new(0, 520, 0, 340), BackgroundTransparency = 1}, 0.3)
    for _, v in pairs(_M:GetDescendants()) do if v:IsA("UIStroke") or v:IsA("ImageLabel") or v:IsA("TextLabel") or v:IsA("TextButton") then Tween(v, {Transparency = 1}, 0.3) end end
    task.wait(0.3); _S:Destroy() 
end)

local isMinimized = false

-- 最小化折叠按钮（—）
_Ctrl("—", -74, Color3.fromRGB(45, 45, 65), Color3.fromRGB(70, 70, 90), function() 
    isMinimized = not isMinimized
    _Sidebar.Visible = not isMinimized
    _ContentContainer.Visible = not isMinimized
    _HeaderLine.Visible = not isMinimized
    _SplitLine.Visible = not isMinimized
    Tween(_M, {Size = isMinimized and UDim2.new(0, 580, 0, 50) or UDim2.new(0, 580, 0, 380)}, 0.4, Enum.EasingStyle.Quart)
end)

-- ==================== 悬浮球（Float Ball） ====================
local _Ball = Instance.new("TextButton", _S)
_Ball.Size = UDim2.new(0, 48, 0, 48)
_Ball.Position = UDim2.new(0, 30, 0.4, 0)
_Ball.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
_Ball.BackgroundTransparency = 0.15
_Ball.Text = "🌚"
_Ball.TextSize = 22
_Ball.Visible = false
_Ball.ZIndex = 10
_Ball.AutoButtonColor = false
Instance.new("UICorner", _Ball).CornerRadius = UDim.new(1, 0)

local _BallStroke = Instance.new("UIStroke", _Ball)
_BallStroke.Thickness = 2
_BallStroke.Color = Color3.fromRGB(99, 102, 241)
local _BallGradient = Instance.new("UIGradient", _BallStroke)
_BallGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(99, 102, 241)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(168, 85, 247)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(59, 130, 246))
})

local ballTween = _TS:Create(_BallGradient, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
ballTween:Play()

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

-- 点击 [+] 号最小化成悬浮球
_Ctrl("+", -108, Color3.fromRGB(99, 102, 241), Color3.fromRGB(129, 140, 248), function()
    _Ball.Position = _M.Position
    _M.Visible = false
    _Ball.Visible = true
    _Ball.Size = UDim2.new(0, 0, 0, 0)
    Tween(_Ball, {Size = UDim2.new(0, 48, 0, 48)}, 0.4, Enum.EasingStyle.Back)
end)

-- 点击悬浮球展开
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
    _Title.Visible = true
    _M.Size = UDim2.new(0, 0, 0, 0)
    Tween(_M, {Size = UDim2.new(0, 580, 0, 380)}, 0.4, Enum.EasingStyle.Back)
end)

-- 主界面拖动逻辑
local _drag, _dStart, _sPos
_TB.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = true; _dStart = i.Position; _sPos = _M.Position end end)
_UIS.InputChanged:Connect(function(i) if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - _dStart; _M.Position = UDim2.new(_sPos.X.Scale, _sPos.X.Offset + d.X, _sPos.Y.Scale, _sPos.Y.Offset + d.Y) end end)
_UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = false end end)