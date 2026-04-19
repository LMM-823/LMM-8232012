-- [[ 🌚刘某某脚本🌝 V3.81 | 内置功能底层优化 | 减少Ban风险 ]]

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- 状态容器
local _G_LMM_88 = { 
    v_0x1 = false, -- 描边透视
    v_0x1_box = false, -- 方框透视
    v_0x1_line = false, -- 射线透视
    v_0x2 = false, -- 穿墙
    v_0x3 = false, -- 速度开关
    v_0x4 = false, -- 飞行开关
    v_val_1 = 50,  -- 速度值
    v_val_2 = 50,  -- 飞行值
    c_esp = Color3.new(1,0,0) 
}
local _RGB_CORE = { Color = Color3.new(1,0,0) }

-- RGB 核心驱动
task.spawn(function()
    local c = 0
    while true do
        c = (c + 0.005) % 1
        _RGB_CORE.Color = Color3.fromHSV(c, 0.7, 1)
        task.wait(0.05) 
    end
end)

-- 清理旧 UI
if _CG:FindFirstChild("LMM_Final_V38") then _CG.LMM_Final_V38:Destroy() end

-- 创建主 UI (保持原版结构)
local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V38"
local _M = Instance.new("Frame", _S)
_M.Size = UDim2.new(0, 520, 0, 520); _M.Position = UDim2.new(0.02, 0, 0.25, 0)
_M.BackgroundColor3 = Color3.fromRGB(15, 15, 15); _M.BorderSizePixel = 0
_M.ClipsDescendants = true; Instance.new("UICorner", _M)
local _Glow = Instance.new("UIStroke", _M); _Glow.Thickness = 3; _Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Title Bar
local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 55); _TB.BackgroundTransparency = 1; _TB.Active = true
local _Title = Instance.new("TextLabel", _TB)
_Title.Size = UDim2.new(1, 0, 1, 0); _Title.Text = "🌚刘某某脚本🌝 (优化版)"; _Title.Font = "GothamBold"; _Title.TextSize = 22; _Title.TextColor3 = Color3.new(1, 1, 1); _Title.BackgroundTransparency = 1

local _Container = Instance.new("Frame", _M); _Container.Size = UDim2.new(1, -20, 1, -70); _Container.Position = UDim2.new(0, 10, 0, 60); _Container.BackgroundTransparency = 1
local _Sidebar = Instance.new("Frame", _Container); _Sidebar.Size = UDim2.new(0, 140, 1, 0); _Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", _Sidebar)
local _SLL = Instance.new("UIListLayout", _Sidebar); _SLL.Padding = UDim.new(0, 12); _SLL.HorizontalAlignment = "Center"

local function _CreateSBtn(name)
    local b = Instance.new("TextButton", _Sidebar); b.Size = UDim2.new(0, 130, 0, 50); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 18; b.TextColor3 = Color3.new(1,1,1); b.TextWrapped = true; Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.5; s.Color = Color3.fromRGB(60,60,60); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return b
end

local _MainArea = Instance.new("Frame", _Container); _MainArea.Size = UDim2.new(1, -150, 1, 0); _MainArea.Position = UDim2.new(0, 150, 0, 0); _MainArea.BackgroundTransparency = 1
local function _NewPage()
    local f = Instance.new("ScrollingFrame", _MainArea); f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.ScrollBarThickness = 5; f.AutomaticCanvasSize = Enum.AutomaticSize.Y; f.Visible = false; f.Active = true
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 15); return f
end

local _Page1 = _NewPage(); local _Page2 = _NewPage(); local _Page3 = _NewPage(); local _Page4 = _NewPage()
_Page1.Visible = true

local _SBtn1 = _CreateSBtn("基本功能"); local _SBtn2 = _CreateSBtn("免密脚本库"); local _SBtn3 = _CreateSBtn("带密脚本库"); local _SBtn4 = _CreateSBtn("脚本说明")
local function _Show(p) _Page1.Visible = (p == _Page1); _Page2.Visible = (p == _Page2); _Page3.Visible = (p == _Page3); _Page4.Visible = (p == _Page4) end
_SBtn1.MouseButton1Click:Connect(function() _Show(_Page1) end)
_SBtn2.MouseButton1Click:Connect(function() _Show(_Page2) end)
_SBtn3.MouseButton1Click:Connect(function() _Show(_Page3) end)
_SBtn4.MouseButton1Click:Connect(function() _Show(_Page4) end)

-- [ 确认弹窗逻辑 ]
local _ConfirmBlocker = Instance.new("Frame", _M); _ConfirmBlocker.Size = UDim2.new(1,0,1,0); _ConfirmBlocker.BackgroundColor3 = Color3.new(0,0,0); _ConfirmBlocker.BackgroundTransparency = 0.6; _ConfirmBlocker.Visible = false; _ConfirmBlocker.ZIndex = 50
local _ConfirmBox = Instance.new("Frame", _ConfirmBlocker); _ConfirmBox.Size = UDim2.new(0.75, 0, 0.35, 0); _ConfirmBox.Position = UDim2.new(0.125, 0, 0.325, 0); _ConfirmBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20); _ConfirmBox.ZIndex = 51; Instance.new("UICorner", _ConfirmBox)
local _CTitle = Instance.new("TextLabel", _ConfirmBox); _CTitle.Size = UDim2.new(1, 0, 0.45, 0); _CTitle.BackgroundTransparency = 1; _CTitle.Text = "确认加载？"; _CTitle.TextColor3 = Color3.new(1,1,1); _CTitle.Font = "GothamBold"; _CTitle.TextSize = 18; _CTitle.ZIndex = 52
local _CBtnYes = Instance.new("TextButton", _ConfirmBox); _CBtnYes.Size = UDim2.new(0.4, 0, 0.35, 0); _CBtnYes.Position = UDim2.new(0.06, 0, 0.5, 0); _CBtnYes.BackgroundColor3 = Color3.fromRGB(30, 100, 30); _CBtnYes.Text = "确认"; _CBtnYes.TextColor3 = Color3.new(1,1,1); _CBtnYes.ZIndex = 52; Instance.new("UICorner", _CBtnYes)
local _CBtnNo = Instance.new("TextButton", _ConfirmBox); _CBtnNo.Size = UDim2.new(0.4, 0, 0.35, 0); _CBtnNo.Position = UDim2.new(0.54, 0, 0.5, 0); _CBtnNo.BackgroundColor3 = Color3.fromRGB(120, 30, 30); _CBtnNo.Text = "取消"; _CBtnNo.TextColor3 = Color3.new(1,1,1); _CBtnNo.ZIndex = 52; Instance.new("UICorner", _CBtnNo)

local _PendingUrl = nil
_CBtnNo.MouseButton1Click:Connect(function() _ConfirmBlocker.Visible = false end)
_CBtnYes.MouseButton1Click:Connect(function() _ConfirmBlocker.Visible = false; if _PendingUrl then loadstring(game:HttpGet(_PendingUrl))() end end)
local function _AskToLoad(name, url) _PendingUrl = url; _CTitle.Text = "加载 ["..name.."] ?"; _ConfirmBlocker.Visible = true end

-- [ 页面功能创建 ]
local function _CreateT(name, key, order, parent)
    local b = Instance.new("TextButton", parent); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 55); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 18; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    local i = Instance.new("Frame", b); i.Size = UDim2.new(0, 6, 0.6, 0); i.Position = UDim2.new(0, 10, 0.2, 0); i.BackgroundColor3 = Color3.fromRGB(200, 0, 0); i.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() _G_LMM_88[key] = not _G_LMM_88[key]; i.BackgroundColor3 = _G_LMM_88[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 0, 0) end)
end

local function _CreateInput(txt, key, order, parent)
    local i = Instance.new("TextBox", parent); i.LayoutOrder = order; i.Size = UDim2.new(0.9, 0, 0, 40); i.BackgroundColor3 = Color3.fromRGB(25, 25, 25); i.Text = txt..": 50"; i.TextColor3 = Color3.new(1,1,1); i.TextSize = 17; i.Font = "GothamBold"; Instance.new("UICorner", i)
    i.FocusLost:Connect(function() _G_LMM_88[key] = math.clamp(tonumber(i.Text:match("%d+")) or 50, 16, 250); i.Text = txt..": ".._G_LMM_88[key] end)
end

-- ESP 色盘 (保持原样)
local _ColorPalette = Instance.new("Frame", _Page1); _ColorPalette.LayoutOrder = 1; _ColorPalette.Size = UDim2.new(0.9, 0, 0, 45); _ColorPalette.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", _ColorPalette)
local _CPL = Instance.new("UIListLayout", _ColorPalette); _CPL.FillDirection = Enum.FillDirection.Horizontal; _CPL.HorizontalAlignment = Enum.HorizontalAlignment.Center; _CPL.VerticalAlignment = Enum.VerticalAlignment.Center; _CPL.Padding = UDim.new(0, 8)
local _ESP_Colors = { Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0.5,1), Color3.new(1,1,0), Color3.new(1,0,1), Color3.new(1,1,1) }
for _, col in ipairs(_ESP_Colors) do
    local cb = Instance.new("TextButton", _ColorPalette); cb.Size = UDim2.new(0, 30, 0, 30); cb.BackgroundColor3 = col; cb.Text = ""; Instance.new("UICorner", cb).CornerRadius = UDim.new(1, 0)
    cb.MouseButton1Click:Connect(function() _G_LMM_88.c_esp = col end)
end

_CreateT("描边透视", "v_0x1", 2, _Page1)
_CreateT("方框透视", "v_0x1_box", 3, _Page1)
_CreateT("射线透视", "v_0x1_line", 4, _Page1)
_CreateInput("行走速度", "v_val_1", 5, _Page1)
_CreateInput("飞行速度", "v_val_2", 6, _Page1)
_CreateT("静默穿墙 (优化)", "v_0x2", 7, _Page1)
_CreateT("速度开关", "v_0x3", 8, _Page1)
_CreateT("飞行开关", "v_0x4", 9, _Page1)

-- 脚本库部分 (省略重复逻辑，保持你代码库里的 URL)
local function _CSB(name, url, order, parent)
    local b = Instance.new("TextButton", parent); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 50); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Text = name; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() _AskToLoad(name, url) end)
end
_CSB("AIMBOT", "https://rawscripts.net/raw/Universal-Script-Aimbot-Mobile-34677", 10, _Page2)
_CSB("Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 11, _Page2)

-- ==================== 🛠️ 核心优化逻辑 (重点在此) ====================

local _FlyVelo = nil
local _ESPLines = {}

-- [ 物理优化 1: 穿墙优化 ]
-- 使用 Stepped 钩子，只对本地玩家 Character 内的 Part 操作，避免破坏游戏地图碰撞导致踢出
_RS.Stepped:Connect(function()
    if _G_LMM_88.v_0x2 and _LP.Character then
        for _, part in ipairs(_LP.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- [ 物理优化 2: 速度与飞行渲染 ]
_RS.RenderStepped:Connect(function()
    _Glow.Color = _RGB_CORE.Color
    local char = _LP.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        local hum = char.Humanoid
        local hrp = char.HumanoidRootPart
        
        -- 速度优化：不再强制每帧改 WalkSpeed，仅在开关打开且值不等于设定值时修改（减少被检测心跳监测频率）
        if _G_LMM_88.v_0x3 then
            if hum.WalkSpeed ~= _G_LMM_88.v_val_1 then
                hum.WalkSpeed = _G_LMM_88.v_val_1
            end
        else
            if hum.WalkSpeed > 16 then hum.WalkSpeed = 16 end
        end
        
        -- 飞行优化：改用低力 BodyVelocity 配合静默浮空，更隐蔽
        if _G_LMM_88.v_0x4 then
            if not _FlyVelo then 
                _FlyVelo = Instance.new("BodyVelocity", hrp)
                _FlyVelo.MaxForce = Vector3.new(1e5, 1e5, 1e5) -- 降低力度，避免被物理检测拉回
            end
            _FlyVelo.Velocity = (hum.MoveDirection.Magnitude > 0) and _Cam.CFrame.LookVector * _G_LMM_88.v_val_2 or Vector3.new(0, 0.1, 0)
        elseif _FlyVelo then
            _FlyVelo:Destroy(); _FlyVelo = nil
        end
    end
    
    -- ESP 系统 (逻辑重构，提高性能防卡顿)
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            
            -- 1. 描边
            local hl = p.Character:FindFirstChild("LMM_HL") or Instance.new("Highlight", p.Character)
            hl.Name = "LMM_HL"; hl.Enabled = _G_LMM_88.v_0x1; hl.FillColor = _G_LMM_88.c_esp
            
            -- 2. 射线 (使用更轻量的绘制检查)
            if _G_LMM_88.v_0x1_line then
                local pos, onScreen = _Cam:WorldToViewportPoint(root.Position)
                if onScreen then
                    if not _ESPLines[p] then _ESPLines[p] = Drawing.new("Line"); _ESPLines[p].Thickness = 1.2 end
                    local line = _ESPLines[p]
                    line.Visible = true; line.Color = _G_LMM_88.c_esp; line.Transparency = 0.8
                    line.From = Vector2.new(_Cam.ViewportSize.X / 2, _Cam.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                else if _ESPLines[p] then _ESPLines[p].Visible = false end end
            elseif _ESPLines[p] then _ESPLines[p].Visible = false end
        end
    end
end)

-- 窗口拖动与控制 (保持原版)
local _drag, _dStart, _sPos
_TB.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = true; _dStart = i.Position; _sPos = _M.Position end end)
_UIS.InputChanged:Connect(function(i) if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - _dStart; _M.Position = UDim2.new(_sPos.X.Scale, _sPos.X.Offset + d.X, _sPos.Y.Scale, _sPos.Y.Offset + d.Y) end end)
_UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = false end end)
