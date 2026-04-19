-- [[ 🌚刘某某脚本🌝 V3.8 | 加载确认框 | ESP色盘 | 射线修复 ]]

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
    c_esp = Color3.new(1,0,0) -- 默认 ESP 颜色 (红色)
}
local _RGB_CORE = { Color = Color3.new(1,0,0) }

-- RGB 核心驱动 (仅限外框)
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

-- 创建主 UI
local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V38"
local _M = Instance.new("Frame", _S)
_M.Size = UDim2.new(0, 520, 0, 520); _M.Position = UDim2.new(0.02, 0, 0.25, 0)
_M.BackgroundColor3 = Color3.fromRGB(15, 15, 15); _M.BorderSizePixel = 0
_M.ClipsDescendants = true
Instance.new("UICorner", _M)

local _Glow = Instance.new("UIStroke", _M); _Glow.Thickness = 3; _Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Title Bar
local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 55); _TB.BackgroundTransparency = 1; _TB.Active = true
local _Title = Instance.new("TextLabel", _TB)
_Title.Size = UDim2.new(1, 0, 1, 0); _Title.Text = "🌚刘某某脚本🌝"; _Title.Font = "GothamBold"; _Title.TextSize = 22; _Title.TextColor3 = Color3.new(1, 1, 1); _Title.BackgroundTransparency = 1

-- 核心容器
local _Container = Instance.new("Frame", _M)
_Container.Size = UDim2.new(1, -20, 1, -70); _Container.Position = UDim2.new(0, 10, 0, 60)
_Container.BackgroundTransparency = 1

-- Sidebar
local _Sidebar = Instance.new("Frame", _Container)
_Sidebar.Size = UDim2.new(0, 140, 1, 0); _Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", _Sidebar).CornerRadius = UDim.new(0, 5)

local _SLL = Instance.new("UIListLayout", _Sidebar)
_SLL.Padding = UDim.new(0, 12); _SLL.HorizontalAlignment = "Center"; _SLL.VerticalAlignment = "Top"

-- [侧边栏按钮工厂]
local function _CreateSBtn(name)
    local b = Instance.new("TextButton", _Sidebar); b.Size = UDim2.new(0, 130, 0, 50); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 18; b.TextColor3 = Color3.new(1,1,1); b.TextWrapped = true; Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.5; s.Color = Color3.fromRGB(60,60,60); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return b, s
end

-- 内容区容器
local _MainArea = Instance.new("Frame", _Container)
_MainArea.Size = UDim2.new(1, -150, 1, 0); _MainArea.Position = UDim2.new(0, 150, 0, 0)
_MainArea.BackgroundTransparency = 1

local function _NewPage()
    local f = Instance.new("ScrollingFrame", _MainArea); f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.ScrollBarThickness = 5; f.AutomaticCanvasSize = Enum.AutomaticSize.Y; f.Visible = false; f.Active = true
    local l = Instance.new("UIListLayout", f); l.Padding = UDim.new(0, 15); l.HorizontalAlignment = "Center"; l.SortOrder = "LayoutOrder"
    return f
end

local _Page1 = _NewPage(); local _Page2 = _NewPage(); local _Page3 = _NewPage(); local _Page4 = _NewPage()
_Page1.Visible = true

local _SBtn1 = _CreateSBtn("基本功能"); local _SBtn2 = _CreateSBtn("不用钥匙脚本库"); local _SBtn3 = _CreateSBtn("需要钥匙脚本库"); local _SBtn4 = _CreateSBtn("介绍以及更新")
local function _Show(p) _Page1.Visible = (p == _Page1); _Page2.Visible = (p == _Page2); _Page3.Visible = (p == _Page3); _Page4.Visible = (p == _Page4) end
_SBtn1.MouseButton1Click:Connect(function() _Show(_Page1) end); _SBtn2.MouseButton1Click:Connect(function() _Show(_Page2) end); _SBtn3.MouseButton1Click:Connect(function() _Show(_Page3) end); _SBtn4.MouseButton1Click:Connect(function() _Show(_Page4) end)

-- ==================== 🛠️ 全局：加载确认弹窗 UI ====================
local _ConfirmBlocker = Instance.new("Frame", _M)
_ConfirmBlocker.Size = UDim2.new(1,0,1,0); _ConfirmBlocker.BackgroundColor3 = Color3.new(0,0,0); _ConfirmBlocker.BackgroundTransparency = 0.6; _ConfirmBlocker.Visible = false; _ConfirmBlocker.ZIndex = 50

local _ConfirmBox = Instance.new("Frame", _ConfirmBlocker)
_ConfirmBox.Size = UDim2.new(0.75, 0, 0.35, 0); _ConfirmBox.Position = UDim2.new(0.125, 0, 0.325, 0); _ConfirmBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20); _ConfirmBox.ZIndex = 51; Instance.new("UICorner", _ConfirmBox)
local _CBS = Instance.new("UIStroke", _ConfirmBox); _CBS.Color = Color3.fromRGB(80,80,80); _CBS.Thickness = 2

local _CTitle = Instance.new("TextLabel", _ConfirmBox)
_CTitle.Size = UDim2.new(1, 0, 0.45, 0); _CTitle.BackgroundTransparency = 1; _CTitle.Text = "确认加载此脚本？"; _CTitle.TextColor3 = Color3.new(1,1,1); _CTitle.Font = "GothamBold"; _CTitle.TextSize = 18; _CTitle.ZIndex = 52

local _CBtnYes = Instance.new("TextButton", _ConfirmBox)
_CBtnYes.Size = UDim2.new(0.4, 0, 0.35, 0); _CBtnYes.Position = UDim2.new(0.06, 0, 0.5, 0); _CBtnYes.BackgroundColor3 = Color3.fromRGB(30, 100, 30); _CBtnYes.Text = "确认"; _CBtnYes.TextColor3 = Color3.new(1,1,1); _CBtnYes.Font = "GothamBold"; _CBtnYes.TextSize = 18; _CBtnYes.ZIndex = 52; Instance.new("UICorner", _CBtnYes)

local _CBtnNo = Instance.new("TextButton", _ConfirmBox)
_CBtnNo.Size = UDim2.new(0.4, 0, 0.35, 0); _CBtnNo.Position = UDim2.new(0.54, 0, 0.5, 0); _CBtnNo.BackgroundColor3 = Color3.fromRGB(120, 30, 30); _CBtnNo.Text = "取消"; _CBtnNo.TextColor3 = Color3.new(1,1,1); _CBtnNo.Font = "GothamBold"; _CBtnNo.TextSize = 18; _CBtnNo.ZIndex = 52; Instance.new("UICorner", _CBtnNo)

local _PendingUrl = nil
_CBtnNo.MouseButton1Click:Connect(function() _ConfirmBlocker.Visible = false end)
_CBtnYes.MouseButton1Click:Connect(function() 
    _ConfirmBlocker.Visible = false
    if _PendingUrl then loadstring(game:HttpGet(_PendingUrl))() end 
end)

local function _AskToLoad(name, url)
    _PendingUrl = url
    _CTitle.Text = "确认加载 ["..name.."] 吗？"
    _ConfirmBlocker.Visible = true
end

-- ==================== 🛠️ 1. 基本功能 & 色盘 (Page 1) ====================
local function _CreateT(name, key, order, parent)
    local b = Instance.new("TextButton", parent); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 55); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 18; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.8; s.Color = Color3.fromRGB(60, 60, 60); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local i = Instance.new("Frame", b); i.Size = UDim2.new(0, 6, 0.6, 0); i.Position = UDim2.new(0, 10, 0.2, 0); i.BackgroundColor3 = Color3.fromRGB(200, 0, 0); i.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() _G_LMM_88[key] = not _G_LMM_88[key]; i.BackgroundColor3 = _G_LMM_88[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 0, 0) end)
end

local function _CreateInput(txt, key, order, parent)
    local i = Instance.new("TextBox", parent); i.LayoutOrder = order; i.Size = UDim2.new(0.9, 0, 0, 40); i.BackgroundColor3 = Color3.fromRGB(25, 25, 25); i.Text = txt..": 50"; i.TextColor3 = Color3.new(1,1,1); i.TextSize = 17; i.Font = "GothamBold"; Instance.new("UICorner", i)
    local s = Instance.new("UIStroke", i); s.Thickness = 1.5; s.Color = Color3.fromRGB(60, 60, 60); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    i.FocusLost:Connect(function() _G_LMM_88[key] = math.clamp(tonumber(i.Text:match("%d+")) or 50, key == "v_val_1" and 16 or 0, key == "v_val_1" and 110 or 220); i.Text = txt..": ".._G_LMM_88[key] end)
end

-- ESP 专属色盘
local _ColorPalette = Instance.new("Frame", _Page1); _ColorPalette.LayoutOrder = 1; _ColorPalette.Size = UDim2.new(0.9, 0, 0, 45); _ColorPalette.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", _ColorPalette)
local _CPS = Instance.new("UIStroke", _ColorPalette); _CPS.Thickness = 1.5; _CPS.Color = Color3.fromRGB(60, 60, 60); _CPS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local _CPL = Instance.new("UIListLayout", _ColorPalette); _CPL.FillDirection = Enum.FillDirection.Horizontal; _CPL.HorizontalAlignment = Enum.HorizontalAlignment.Center; _CPL.VerticalAlignment = Enum.VerticalAlignment.Center; _CPL.Padding = UDim.new(0, 8)

local _ESP_Colors = { Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0.5,1), Color3.new(1,1,0), Color3.new(1,0,1), Color3.new(1,1,1) }
for _, col in ipairs(_ESP_Colors) do
    local cb = Instance.new("TextButton", _ColorPalette); cb.Size = UDim2.new(0, 30, 0, 30); cb.BackgroundColor3 = col; cb.Text = ""; Instance.new("UICorner", cb).CornerRadius = UDim.new(1, 0)
    local cs = Instance.new("UIStroke", cb); cs.Thickness = 2; cs.Color = Color3.fromRGB(80,80,80)
    cb.MouseButton1Click:Connect(function() 
        _G_LMM_88.c_esp = col
        for _, c in pairs(_ColorPalette:GetChildren()) do if c:IsA("TextButton") then c.UIStroke.Color = Color3.fromRGB(80,80,80) end end
        cs.Color = Color3.new(1,1,1) -- 选中状态高亮边框
    end)
end

_CreateT("描边透视 (Highlight)", "v_0x1", 2, _Page1)
_CreateT("方框透视 (Box)", "v_0x1_box", 3, _Page1)
_CreateT("射线透视 (Line)", "v_0x1_line", 4, _Page1)
_CreateInput("行走速度", "v_val_1", 5, _Page1)
_CreateInput("飞行速度", "v_val_2", 6, _Page1)
_CreateT("内置穿墙", "v_0x2", 7, _Page1)
_CreateT("速度开关", "v_0x3", 8, _Page1)
_CreateT("飞行开关", "v_0x4", 9, _Page1)


-- ==================== 🛠️ 2 & 3. 脚本库与搜索 (Page 2 & 3) ====================
local function _SetupLib(page, placeholder)
    local search = Instance.new("TextBox", page); search.LayoutOrder = 1; search.Size = UDim2.new(0.9, 0, 0, 45); search.BackgroundColor3 = Color3.fromRGB(40, 40, 40); search.Text = ""; search.PlaceholderText = placeholder; search.TextColor3 = Color3.new(1,1,1); search.TextSize = 17; search.Font = "GothamBold"; Instance.new("UICorner", search)
    local ss = Instance.new("UIStroke", search); ss.Thickness = 1.5; ss.Color = Color3.fromRGB(80, 80, 80); ss.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    search:GetPropertyChangedSignal("Text"):Connect(function()
        local q = search.Text:lower()
        for _, c in pairs(page:GetChildren()) do if c:IsA("TextButton") and c.Name:sub(1,2) == "S_" then c.Visible = (q=="" or c.Text:lower():find(q)) end end
    end)
end

_SetupLib(_Page2, "🔍 搜索免密脚本...")
_SetupLib(_Page3, "🔍 搜索带密脚本...")

local function _CreateScriptBtn(name, url, order, parent)
    local b = Instance.new("TextButton", parent); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 55); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Text = name; b.Font = "GothamBold"; b.TextSize = 17; b.TextColor3 = Color3.new(1, 1, 1); b.Name = "S_"..name; Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.5; s.Color = Color3.fromRGB(60, 60, 60); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    -- 点击触发确认弹窗
    b.MouseButton1Click:Connect(function() _AskToLoad(name, url) end)
end

_CreateScriptBtn("AIMBOT (自瞄)", "https://rawscripts.net/raw/Universal-Script-Aimbot-Mobile-34677", 10, _Page2)
_CreateScriptBtn("Infinite Yield (万能脚本)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 11, _Page2)
_CreateScriptBtn("Rivals 无钥匙版", "https://raw.githubusercontent.com/idkmsnscriptronlox/Shadow-/refs/heads/main/Shadow", 12, _Page2)
_CreateScriptBtn("Owl Hub 极简稳定版", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt", 13, _Page2)
_CreateScriptBtn("Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source", 14, _Page2)
_CreateScriptBtn("自动连点器 (刘某某)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 15, _Page2)


-- ==================== 🛠️ 4. 介绍以及更新 (Page 4) ====================
local function _CreateInfo(txt, order)
    local l = Instance.new("TextLabel", _Page4); l.LayoutOrder = order; l.Size = UDim2.new(0.9, 0, 0, 40); l.BackgroundColor3 = Color3.fromRGB(25,25,25); l.Text = txt; l.TextColor3 = Color3.new(1, 1, 1); l.Font = "GothamBold"; l.TextSize = 18; Instance.new("UICorner", l)
    local s = Instance.new("UIStroke", l); s.Thickness = 1; s.Color = Color3.fromRGB(50, 50, 50); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end
_CreateInfo("作者：🌚刘某某🌝", 1)
_CreateInfo("版本：V3.8 终极完善版", 2)
_CreateInfo("更新：新增脚本安全加载二次确认", 3)
_CreateInfo("更新：新增 ESP 全局变色色盘系统", 4)
_CreateInfo("更新：修复并重构底层 Drawing 射线", 5)

-- ==================== 窗口控制 ====================
local function _Ctrl(t, x, c, f)
    local b = Instance.new("TextButton", _TB); b.Size = UDim2.new(0, 32, 0, 32); b.Position = UDim2.new(1, x, 0.5, -16); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 18; Instance.new("UICorner", b); b.MouseButton1Click:Connect(f)
end
_Ctrl("×", -45, Color3.fromRGB(180, 50, 50), function() _S:Destroy() end)

local _isMin = false
_Ctrl("—", -90, Color3.fromRGB(50, 50, 50), function() 
    _isMin = not _isMin; _Container.Visible = not _isMin
    _M.Size = _isMin and UDim2.new(0, 520, 0, 55) or UDim2.new(0, 520, 0, 520)
end)

local _drag, _dStart, _sPos
_TB.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = true; _dStart = i.Position; _sPos = _M.Position end end)
_UIS.InputChanged:Connect(function(i) if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - _dStart; _M.Position = UDim2.new(_sPos.X.Scale, _sPos.X.Offset + d.X, _sPos.Y.Scale, _sPos.Y.Offset + d.Y) end end)
_UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = false end end)

-- DISCORD 按钮
local _D = Instance.new("TextButton", _Page4); _D.LayoutOrder = 100; _D.Size = UDim2.new(0.9, 0, 0, 55); _D.BackgroundColor3 = Color3.fromRGB(88, 101, 242); _D.Text = "🔗 JOIN DISCORD"; _D.Font="GothamBold"; _D.TextSize=20; _D.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", _D)
local _DS = Instance.new("UIStroke", _D); _DS.Thickness = 1.5; _DS.Color = Color3.fromRGB(80, 80, 80); _DS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_D.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/cjpezEZub"); _D.Text = "已复制链接!" end)


-- ==================== 核心循环系统 (ESP & 状态) ====================
local _FlyVelo = nil
local _ESPLines = {} -- 存储射线对象

-- 玩家退出时清理射线
_P.PlayerRemoving:Connect(function(p)
    if _ESPLines[p] then _ESPLines[p]:Remove(); _ESPLines[p] = nil end
end)

_RS.RenderStepped:Connect(function()
    _Glow.Color = _RGB_CORE.Color
    
    local char = _LP.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        local hum = char.Humanoid
        local hrp = char.HumanoidRootPart
        
        hum.WalkSpeed = _G_LMM_88.v_0x3 and _G_LMM_88.v_val_1 or 16
        if _G_LMM_88.v_0x2 then for _, p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        
        if _G_LMM_88.v_0x4 then
            if not _FlyVelo then _FlyVelo = Instance.new("BodyVelocity", hrp); _FlyVelo.MaxForce = Vector3.new(9e9, 9e9, 9e9) end
            _FlyVelo.Velocity = hum.MoveDirection.Magnitude > 0 and _Cam.CFrame.LookVector * _G_LMM_88.v_val_2 or Vector3.new(0,0,0)
        else
            if _FlyVelo then _FlyVelo:Destroy(); _FlyVelo = nil end
        end
    end
    
    -- ESP 系统
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- 1. 描边 (同步色盘)
            local hl = p.Character:FindFirstChild("LMM_HL") or Instance.new("Highlight", p.Character)
            hl.Name = "LMM_HL"; hl.Enabled = _G_LMM_88.v_0x1; hl.FillTransparency = 0.5; hl.FillColor = _G_LMM_88.c_esp; hl.OutlineColor = Color3.new(1,1,1)
            
            -- 2. 方框 (同步色盘)
            local box = p.Character.HumanoidRootPart:FindFirstChild("LMM_Box")
            if _G_LMM_88.v_0x1_box then
                if not box then
                    box = Instance.new("BillboardGui", p.Character.HumanoidRootPart); box.Name = "LMM_Box"; box.Size = UDim2.new(4,0,5.5,0); box.AlwaysOnTop = true
                    local f = Instance.new("Frame", box); f.Size = UDim2.new(1,0,1,0); f.BackgroundTransparency = 1; f.Name = "Frame_Box"
                    local st = Instance.new("UIStroke", f); st.Thickness = 2
                end
                if box:FindFirstChild("Frame_Box") and box.Frame_Box:FindFirstChild("UIStroke") then
                    box.Frame_Box.UIStroke.Color = _G_LMM_88.c_esp
                end
            elseif box then box:Destroy() end
            
            -- 3. 射线透视 (Drawing API)
            if _G_LMM_88.v_0x1_line then
                local pos, onScreen = _Cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    if not _ESPLines[p] then 
                        _ESPLines[p] = Drawing.new("Line"); _ESPLines[p].Thickness = 1.5; _ESPLines[p].Transparency = 1 
                    end
                    _ESPLines[p].Visible = true
                    _ESPLines[p].Color = _G_LMM_88.c_esp
                    _ESPLines[p].From = Vector2.new(_Cam.ViewportSize.X / 2, _Cam.ViewportSize.Y) -- 从屏幕正下方出发
                    _ESPLines[p].To = Vector2.new(pos.X, pos.Y)
                else
                    if _ESPLines[p] then _ESPLines[p].Visible = false end
                end
            else
                if _ESPLines[p] then _ESPLines[p].Visible = false end
            end
        else
            if _ESPLines[p] then _ESPLines[p].Visible = false end
        end
    end
end)
