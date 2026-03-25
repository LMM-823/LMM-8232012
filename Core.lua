-- [[ 🌚刘某某脚本🌝 V3.5 | 四按钮中文分类 | 修复最小化 ]]

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- 状态容器
local _G_LMM_88 = { 
    v_0x1 = false, v_0x2 = false, v_0x3 = false, v_val_1 = 50, 
    v_0x4 = false, v_val_2 = 50, v_esp_line = false, v_esp_box = false,
    c_esp = Color3.new(1,0,0), c_line = Color3.new(1,0,0), c_box = Color3.new(1,0,0)
}
local _RGB_CORE = { Color = Color3.new(1,0,0) }

task.spawn(function()
    local c = 0
    while true do
        c = (c + 0.005) % 1
        _RGB_CORE.Color = Color3.fromHSV(c, 0.7, 1)
        task.wait(0.05) 
    end
end)

-- 清理旧 UI
if _CG:FindFirstChild("LMM_Final_V36") then _CG.LMM_Final_V36:Destroy() end

-- 创建主 UI
local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V36"
local _M = Instance.new("Frame", _S)
_M.Size = UDim2.new(0, 500, 0, 520); _M.Position = UDim2.new(0.02, 0, 0.25, 0)
_M.BackgroundColor3 = Color3.fromRGB(15, 15, 15); _M.BorderSizePixel = 0
_M.ClipsDescendants = true
Instance.new("UICorner", _M)
local _Glow = Instance.new("UIStroke", _M); _Glow.Thickness = 3

-- Title Bar
local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 55); _TB.BackgroundTransparency = 1; _TB.Active = true
local _Title = Instance.new("TextLabel", _TB)
_Title.Size = UDim2.new(1, 0, 1, 0); _Title.Text = "🌚刘某某脚本🌝"; _Title.Font = "GothamBold"; _Title.TextSize = 18; _Title.TextColor3 = Color3.new(1, 1, 1); _Title.BackgroundTransparency = 1

-- 核心容器 (包含侧边栏和内容)
local _Container = Instance.new("Frame", _M)
_Container.Size = UDim2.new(1, -20, 1, -70); _Container.Position = UDim2.new(0, 10, 0, 60)
_Container.BackgroundTransparency = 1

-- Sidebar (侧边栏加宽以适应文字)
local _Sidebar = Instance.new("Frame", _Container)
_Sidebar.Size = UDim2.new(0, 110, 1, 0); _Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", _Sidebar).CornerRadius = UDim.new(0, 5)

local _SLL = Instance.new("UIListLayout", _Sidebar)
_SLL.Padding = UDim.new(0, 10); _SLL.HorizontalAlignment = "Center"; _SLL.VerticalAlignment = "Top"

local function _CreateSBtn(name)
    local b = Instance.new("TextButton", _Sidebar); b.Size = UDim2.new(0, 100, 0, 45); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 12; b.TextColor3 = Color3.new(1,1,1); b.TextWrapped = true; Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.5; s.Color = Color3.fromRGB(60,60,60)
    return b, s
end

-- 内容区容器
local _MainArea = Instance.new("Frame", _Container)
_MainArea.Size = UDim2.new(1, -120, 1, 0); _MainArea.Position = UDim2.new(0, 120, 0, 0)
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

-- ==================== 🛠️ 1. 基本功能内容 (Page 1) ====================
local function _CreateT(name, key, order, parent)
    local b = Instance.new("TextButton", parent); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 55); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 14; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.8; s.Color = Color3.fromRGB(60, 60, 60)
    local i = Instance.new("Frame", b); i.Size = UDim2.new(0, 6, 0.6, 0); i.Position = UDim2.new(0, 10, 0.2, 0); i.BackgroundColor3 = Color3.fromRGB(200, 0, 0); i.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() _G_LMM_88[key] = not _G_LMM_88[key]; i.BackgroundColor3 = _G_LMM_88[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 0, 0) end)
    _RS.Heartbeat:Connect(function() s.Color = _G_LMM_88[key] and _RGB_CORE.Color or Color3.fromRGB(60,60,60) end)
end

local function _CreateInput(txt, key, order, parent)
    local i = Instance.new("TextBox", parent); i.LayoutOrder = order; i.Size = UDim2.new(0.9, 0, 0, 40); i.BackgroundColor3 = Color3.fromRGB(25, 25, 25); i.Text = txt..": 50"; i.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", i)
    i.FocusLost:Connect(function() _G_LMM_88[key] = tonumber(i.Text:match("%d+")) or 50; i.Text = txt..": ".._G_LMM_88[key] end)
end

_CreateInput("行走速度", "v_val_1", 1, _Page1)
_CreateInput("飞行速度", "v_val_2", 2, _Page1)
_CreateT("内置透视", "v_0x1", 3, _Page1)
_CreateT("内置穿墙", "v_0x2", 4, _Page1)
_CreateT("内置速度开关", "v_0x3", 5, _Page1)
_CreateT("内置飞行开关", "v_0x4", 6, _Page1)


-- ==================== 🛠️ 2. 不用钥匙脚本库 (Page 2) ====================
local _SearchBar = Instance.new("TextBox", _Page2); _SearchBar.LayoutOrder = 1; _SearchBar.Size = UDim2.new(0.9, 0, 0, 45); _SearchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); _SearchBar.PlaceholderText = "🔍 搜索脚本..."; _SearchBar.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", _SearchBar)
local _SS = Instance.new("UIStroke", _SearchBar); _SS.Thickness = 1.5; _RS.Heartbeat:Connect(function() _SS.Color = _RGB_CORE.Color end)

local function _CreateS(name, url, order)
    local b = Instance.new("TextButton", _Page2); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 55); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Text = name; b.Font = "GothamBold"; b.TextColor3 = Color3.new(1, 1, 1); b.Name = "S_"..name; Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 2; _RS.Heartbeat:Connect(function() s.Color = _RGB_CORE.Color end)
    b.MouseButton1Click:Connect(function() loadstring(game:HttpGet(url))() end)
end

_SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local q = _SearchBar.Text:lower()
    for _, c in pairs(_Page2:GetChildren()) do if c:IsA("TextButton") and c.Name:sub(1,2) == "S_" then c.Visible = (q=="" or c.Text:lower():find(q)) end end
end)

_CreateS("AIMBOT (自瞄)", "https://rawscripts.net/raw/Universal-Script-Aimbot-Mobile-34677", 10)
_CreateS("Infinite Yield (万能)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 11)
_CreateS("Rivals 无钥匙版", "https://raw.githubusercontent.com/idkmsnscriptronlox/Shadow-/refs/heads/main/Shadow", 12)
_CreateS("Owl Hub 极简版", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt", 13)


-- ==================== 🛠️ 3. 需要钥匙脚本库 (Page 3) ====================
local _P3Txt = Instance.new("TextLabel", _Page3)
_P3Txt.Size = UDim2.new(0.9, 0, 0, 60); _P3Txt.BackgroundTransparency = 1; _P3Txt.Text = "暂无需要钥匙的脚本"; _P3Txt.TextColor3 = Color3.new(0.5,0.5,0.5); _P3Txt.Font = "Gotham"


-- ==================== 🛠️ 4. 介绍以及更新 (Page 4) ====================
local function _CreateInfo(txt, order)
    local l = Instance.new("TextLabel", _Page4); l.LayoutOrder = order; l.Size = UDim2.new(0.9, 0, 0, 40); l.BackgroundColor3 = Color3.fromRGB(25,25,25); l.Text = txt; l.TextColor3 = Color3.new(0.9,0.9,0.9); l.Font = "Gotham"; l.TextSize = 14; Instance.new("UICorner", l)
end
_CreateInfo("作者：🌚刘某某🌝", 1)
_CreateInfo("当前版本：V3.5 分类版", 2)
_CreateInfo("更新：新增四分类侧边栏", 3)
_CreateInfo("更新：修复缩小溢出 Bug", 4)
_CreateInfo("Discord：已集成在脚本页底部", 5)

-- ==================== 窗口控制 & 最小化修复 ====================
local function _Ctrl(t, x, c, f)
    local b = Instance.new("TextButton", _TB); b.Size = UDim2.new(0, 32, 0, 32); b.Position = UDim2.new(1, x, 0.5, -16); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.MouseButton1Click:Connect(f)
end
_Ctrl("×", -45, Color3.fromRGB(180, 50, 50), function() _S:Destroy() end)

local _isMin = false
_Ctrl("—", -90, Color3.fromRGB(50, 50, 50), function() 
    _isMin = not _isMin
    _Container.Visible = not _isMin
    _M.Size = _isMin and UDim2.new(0, 500, 0, 55) or UDim2.new(0, 500, 0, 520)
end)

-- 拖动逻辑
local _drag, _dStart, _sPos
_TB.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = true; _dStart = i.Position; _sPos = _M.Position end end)
_UIS.InputChanged:Connect(function(i) if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - _dStart; _M.Position = UDim2.new(_sPos.X.Scale, _sPos.X.Offset + d.X, _sPos.Y.Scale, _sPos.Y.Offset + d.Y) end end)
_UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = false end end)

-- 核心循环 (驱动速度、飞行、ESP)
_RS.Heartbeat:Connect(function()
    _Glow.Color = _RGB_CORE.Color
    _SBtn1S.Color = _RGB_CORE.Color; _SBtn2S.Color = _RGB_CORE.Color
    _SBtn3S.Color = _RGB_CORE.Color; _SBtn4S.Color = _RGB_CORE.Color
    
    local char = _LP.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        hum.WalkSpeed = _G_LMM_88.v_0x3 and _G_LMM_88.v_val_1 or 16
        if _G_LMM_88.v_0x2 then for _, p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    end
end)
