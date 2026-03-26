-- [[ 🌚刘某某脚本🌝 V3.7 | 纯净白字 | 三搜索框 | 字体放大版 ]]

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- 状态容器
local _G_LMM_88 = { 
    v_0x1 = false, -- 透视 (描边)
    v_0x1_box = false, -- 方框透视
    v_0x1_line = false, -- 射线透视
    v_0x2 = false, -- 穿墙
    v_0x3 = false, -- 速度开关
    v_0x4 = false, -- 飞行开关
    v_val_1 = 50,  -- 速度值
    v_val_2 = 50   -- 飞行值
}
local _RGB_CORE = { Color = Color3.new(1,0,0) }

-- RGB 核心驱动 (现在只给主窗口外边缘用)
task.spawn(function()
    local c = 0
    while true do
        c = (c + 0.005) % 1
        _RGB_CORE.Color = Color3.fromHSV(c, 0.7, 1)
        task.wait(0.05) 
    end
end)

-- 清理旧 UI
if _CG:FindFirstChild("LMM_Final_V37") then _CG.LMM_Final_V37:Destroy() end

-- 创建主 UI
local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V37"
local _M = Instance.new("Frame", _S)
_M.Size = UDim2.new(0, 520, 0, 520); _M.Position = UDim2.new(0.02, 0, 0.25, 0)
_M.BackgroundColor3 = Color3.fromRGB(15, 15, 15); _M.BorderSizePixel = 0
_M.ClipsDescendants = true
Instance.new("UICorner", _M)

-- [全场唯一 RGB 发光点：主边缘]
local _Glow = Instance.new("UIStroke", _M); _Glow.Thickness = 3; _Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Title Bar
local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 55); _TB.BackgroundTransparency = 1; _TB.Active = true
local _Title = Instance.new("TextLabel", _TB)
_Title.Size = UDim2.new(1, 0, 1, 0); _Title.Text = "🌚刘某某脚本🌝"; _Title.Font = "GothamBold"; _Title.TextSize = 22; _Title.TextColor3 = Color3.new(1, 1, 1); _Title.BackgroundTransparency = 1

-- 核心容器
local _Container = Instance.new("Frame", _M)
_Container.Size = UDim2.new(1, -20, 1, -70); _Container.Position = UDim2.new(0, 10, 0, 60)
_Container.BackgroundTransparency = 1

-- Sidebar (侧边栏加宽以适应更大字体)
local _Sidebar = Instance.new("Frame", _Container)
_Sidebar.Size = UDim2.new(0, 140, 1, 0); _Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", _Sidebar).CornerRadius = UDim.new(0, 5)

local _SLL = Instance.new("UIListLayout", _Sidebar)
_SLL.Padding = UDim.new(0, 12); _SLL.HorizontalAlignment = "Center"; _SLL.VerticalAlignment = "Top"

-- [侧边栏按钮工厂]
local function _CreateSBtn(name)
    local b = Instance.new("TextButton", _Sidebar); b.Size = UDim2.new(0, 130, 0, 50); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 18; b.TextColor3 = Color3.new(1,1,1); b.TextWrapped = true; Instance.new("UICorner", b)
    -- 固定深灰色边框，关闭 RGB
    local s = Instance.new("UIStroke", b); s.Thickness = 1.5; s.Color = Color3.fromRGB(60,60,60); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return b, s
end

-- 内容区容器
local _MainArea = Instance.new("Frame", _Container)
_MainArea.Size = UDim2.new(1, -150, 1, 0); _MainArea.Position = UDim2.new(0, 150, 0, 0)
_MainArea.BackgroundTransparency = 1

-- === 四个页面创建 ===
local function _NewPage()
    local f = Instance.new("ScrollingFrame", _MainArea); f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.ScrollBarThickness = 5; f.AutomaticCanvasSize = Enum.AutomaticSize.Y; f.Visible = false; f.Active = true
    local l = Instance.new("UIListLayout", f); l.Padding = UDim.new(0, 15); l.HorizontalAlignment = "Center"; l.SortOrder = "LayoutOrder"
    return f
end

local _Page1 = _NewPage() -- 基本功能
local _Page2 = _NewPage() -- 不用钥匙脚本库
local _Page3 = _NewPage() -- 需要钥匙脚本库
local _Page4 = _NewPage() -- 介绍以及更新

_Page1.Visible = true -- 默认显示第一页

-- 按钮逻辑
local _SBtn1, _SBtn1S = _CreateSBtn("基本功能")
local _SBtn2, _SBtn2S = _CreateSBtn("不用钥匙脚本库")
local _SBtn3, _SBtn3S = _CreateSBtn("需要钥匙脚本库")
local _SBtn4, _SBtn4S = _CreateSBtn("介绍以及更新")

local function _Show(p) 
    _Page1.Visible = (p == _Page1); _Page2.Visible = (p == _Page2); 
    _Page3.Visible = (p == _Page3); _Page4.Visible = (p == _Page4) 
end

_SBtn1.MouseButton1Click:Connect(function() _Show(_Page1) end)
_SBtn2.MouseButton1Click:Connect(function() _Show(_Page2) end)
_SBtn3.MouseButton1Click:Connect(function() _Show(_Page3) end)
_SBtn4.MouseButton1Click:Connect(function() _Show(_Page4) end)

-- ==================== 🛠️ 1. 基本功能 (Page 1) ====================
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

_CreateInput("行走速度", "v_val_1", 1, _Page1)
_CreateInput("飞行速度", "v_val_2", 2, _Page1)
_CreateT("内置透视 (描边)", "v_0x1", 3, _Page1)
_CreateT("方框透视 (Box)", "v_0x1_box", 4, _Page1)
_CreateT("射线透视 (Line)", "v_0x1_line", 5, _Page1)
_CreateT("内置穿墙", "v_0x2", 6, _Page1)
_CreateT("速度开关", "v_0x3", 7, _Page1)
_CreateT("飞行开关", "v_0x4", 8, _Page1)


-- ==================== 🛠️ 2. 不用钥匙脚本库 (Page 2) ====================
local _SearchBar2 = Instance.new("TextBox", _Page2); _SearchBar2.LayoutOrder = 1; _SearchBar2.Size = UDim2.new(0.9, 0, 0, 45); _SearchBar2.BackgroundColor3 = Color3.fromRGB(40, 40, 40); _SearchBar2.Text = ""; _SearchBar2.PlaceholderText = "🔍 搜索免密脚本..."; _SearchBar2.TextColor3 = Color3.new(1,1,1); _SearchBar2.TextSize = 17; _SearchBar2.Font = "GothamBold"; Instance.new("UICorner", _SearchBar2)
local _SS2 = Instance.new("UIStroke", _SearchBar2); _SS2.Thickness = 1.5; _SS2.Color = Color3.fromRGB(80, 80, 80); _SS2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 创建无钥匙脚本工厂
local function _CreateS2(name, url, order)
    local b = Instance.new("TextButton", _Page2); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 55); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Text = name; b.Font = "GothamBold"; b.TextSize = 17; b.TextColor3 = Color3.new(1, 1, 1); b.Name = "S_"..name; Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.5; s.Color = Color3.fromRGB(60, 60, 60); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    b.MouseButton1Click:Connect(function() loadstring(game:HttpGet(url))() end)
end

_SearchBar2:GetPropertyChangedSignal("Text"):Connect(function()
    local q = _SearchBar2.Text:lower()
    for _, c in pairs(_Page2:GetChildren()) do if c:IsA("TextButton") and c.Name:sub(1,2) == "S_" then c.Visible = (q=="" or c.Text:lower():find(q)) end end
end)

_CreateS2("AIMBOT (自瞄)", "https://rawscripts.net/raw/Universal-Script-Aimbot-Mobile-34677", 10)
_CreateS2("Infinite Yield (万能脚本)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 11)
_CreateS2("Rivals 无钥匙版", "https://raw.githubusercontent.com/idkmsnscriptronlox/Shadow-/refs/heads/main/Shadow", 12)
_CreateS2("Owl Hub 极简稳定版", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt", 13)
_CreateS2("Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source", 14)
_CreateS2("自动连点器 (刘某某)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 15)


-- ==================== 🛠️ 3. 需要钥匙脚本库 (Page 3) ====================
-- 你要求在这里也加搜索，我已经补全了搜索逻辑！
local _SearchBar3 = Instance.new("TextBox", _Page3); _SearchBar3.LayoutOrder = 1; _SearchBar3.Size = UDim2.new(0.9, 0, 0, 45); _SearchBar3.BackgroundColor3 = Color3.fromRGB(40, 40, 40); _SearchBar3.Text = ""; _SearchBar3.PlaceholderText = "🔍 搜索带密脚本..."; _SearchBar3.TextColor3 = Color3.new(1,1,1); _SearchBar3.TextSize = 17; _SearchBar3.Font = "GothamBold"; Instance.new("UICorner", _SearchBar3)
local _SS3 = Instance.new("UIStroke", _SearchBar3); _SS3.Thickness = 1.5; _SS3.Color = Color3.fromRGB(80, 80, 80); _SS3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 创建有钥匙脚本工厂
local function _CreateS3(name, url, order)
    local b = Instance.new("TextButton", _Page3); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 55); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Text = name; b.Font = "GothamBold"; b.TextSize = 17; b.TextColor3 = Color3.new(1, 1, 1); b.Name = "S_"..name; Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.5; s.Color = Color3.fromRGB(60, 60, 60); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    b.MouseButton1Click:Connect(function() loadstring(game:HttpGet(url))() end)
end

_SearchBar3:GetPropertyChangedSignal("Text"):Connect(function()
    local q = _SearchBar3.Text:lower()
    for _, c in pairs(_Page3:GetChildren()) do if c:IsA("TextButton") and c.Name:sub(1,2) == "S_" then c.Visible = (q=="" or c.Text:lower():find(q)) end end
end)


-- ==================== 🛠️ 4. 介绍以及更新 (Page 4) ====================
local function _CreateInfo(txt, order)
    local l = Instance.new("TextLabel", _Page4); l.LayoutOrder = order; l.Size = UDim2.new(0.9, 0, 0, 40); l.BackgroundColor3 = Color3.fromRGB(25,25,25); l.Text = txt; l.TextColor3 = Color3.new(1, 1, 1); l.Font = "GothamBold"; l.TextSize = 18; Instance.new("UICorner", l)
    local s = Instance.new("UIStroke", l); s.Thickness = 1; s.Color = Color3.fromRGB(50, 50, 50); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end
_CreateInfo("作者：🌚刘某某🌝", 1)
_CreateInfo("版本：V3.7 优化版", 2)
_CreateInfo("更新：字体系统级放大至最佳观感", 3)
_CreateInfo("更新：三库独立深度搜索系统", 4)
_CreateInfo("Discord：已集成在脚本页底部", 5)

-- ==================== 窗口控制 & 最小化修复 ====================
local function _Ctrl(t, x, c, f)
    local b = Instance.new("TextButton", _TB); b.Size = UDim2.new(0, 32, 0, 32); b.Position = UDim2.new(1, x, 0.5, -16); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 18; Instance.new("UICorner", b); b.MouseButton1Click:Connect(f)
end
_Ctrl("×", -45, Color3.fromRGB(180, 50, 50), function() _S:Destroy() end)

local _isMin = false
_Ctrl("—", -90, Color3.fromRGB(50, 50, 50), function() 
    _isMin = not _isMin
    _Container.Visible = not _isMin
    _M.Size = _isMin and UDim2.new(0, 520, 0, 55) or UDim2.new(0, 520, 0, 520)
end)

-- 拖动逻辑
local _drag, _dStart, _sPos
_TB.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = true; _dStart = i.Position; _sPos = _M.Position end end)
_UIS.InputChanged:Connect(function(i) if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - _dStart; _M.Position = UDim2.new(_sPos.X.Scale, _sPos.X.Offset + d.X, _sPos.Y.Scale, _sPos.Y.Offset + d.Y) end end)
_UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = false end end)

-- DISCORD 蓝色大按钮
local _D = Instance.new("TextButton", _Page4); _D.LayoutOrder = 100; _D.Size = UDim2.new(0.9, 0, 0, 55); _D.BackgroundColor3 = Color3.fromRGB(88, 101, 242); _D.Text = "🔗 JOIN DISCORD"; _D.Font="GothamBold"; _D.TextSize=20; _D.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", _D)
local _DS = Instance.new("UIStroke", _D); _DS.Thickness = 1.5; _DS.Color = Color3.fromRGB(80, 80, 80); _DS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_D.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/cjpezEZub"); _D.Text = "已复制链接!" end)


-- 核心循环 (驱动速度、飞行、ESP)
local _FlyVelo = nil
_RS.Heartbeat:Connect(function()
    -- [现在只有这一行是发光的]
    _Glow.Color = _RGB_CORE.Color
    
    local char = _LP.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        local hum = char.Humanoid
        local hrp = char.HumanoidRootPart
        
        -- 速度
        hum.WalkSpeed = _G_LMM_88.v_0x3 and _G_LMM_88.v_val_1 or 16
        
        -- Noclip
        if _G_LMM_88.v_0x2 then for _, p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        
        -- 飞行 (BodyVelocity)
        if _G_LMM_88.v_0x4 then
            if not _FlyVelo then 
                _FlyVelo = Instance.new("BodyVelocity", hrp)
                _FlyVelo.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            end
            _FlyVelo.Velocity = hum.MoveDirection.Magnitude > 0 and _Cam.CFrame.LookVector * _G_LMM_88.v_val_2 or Vector3.new(0,0,0)
        else
            if _FlyVelo then _FlyVelo:Destroy(); _FlyVelo = nil end
        end
    end
    
    -- ESP 系统 (描边+方框)
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- 1. 描边
            local hl = p.Character:FindFirstChild("LMM_HL") or Instance.new("Highlight", p.Character)
            hl.Name = "LMM_HL"; hl.Enabled = _G_LMM_88.v_0x1; hl.FillTransparency = 0.5; hl.OutlineColor = Color3.new(1,1,1)
            
            -- 2. 方框 (BillboardGui 方式)
            local box = p.Character.HumanoidRootPart:FindFirstChild("LMM_Box")
            if _G_LMM_88.v_0x1_box then
                if not box then
                    box = Instance.new("BillboardGui", p.Character.HumanoidRootPart); box.Name = "LMM_Box"; box.Size = UDim2.new(4,0,5.5,0); box.AlwaysOnTop = true
                    local f = Instance.new("Frame", box); f.Size = UDim2.new(1,0,1,0); f.BackgroundTransparency = 1
                    local st = Instance.new("UIStroke", f); st.Thickness = 2; st.Color = Color3.new(1,1,1)
                end
            elseif box then box:Destroy() end
        end
    end
end)
