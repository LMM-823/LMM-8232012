-- [[ 🌚刘某某脚本🌝 V3.7 | 核心功能修复 | 确认UI回归 | 纯净排版版 ]]

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- 状态容器
local _G_LMM_88 = { 
    v_0x1 = false, -- 透视
    v_0x2 = false, -- 穿墙
    v_0x3 = false, -- 速度
    v_0x4 = false, -- 飞行
    v_val_1 = 50,  -- 速度值
    v_val_2 = 50   -- 飞行值
}
local _RGB_CORE = { Color = Color3.new(1,0,0) }

-- RGB 边缘发光驱动
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

local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V37"

-- ==================== 🛠️ 启动确认 UI ====================
local _ConfirmBG = Instance.new("Frame", _S)
_ConfirmBG.Size = UDim2.new(1, 0, 1, 0); _ConfirmBG.BackgroundColor3 = Color3.new(0, 0, 0); _ConfirmBG.BackgroundTransparency = 0.4
local _ConfirmBox = Instance.new("Frame", _ConfirmBG)
_ConfirmBox.Size = UDim2.new(0, 300, 0, 150); _ConfirmBox.Position = UDim2.new(0.5, -150, 0.5, -75); _ConfirmBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", _ConfirmBox)
local _ConfirmStroke = Instance.new("UIStroke", _ConfirmBox); _ConfirmStroke.Thickness = 2; _ConfirmStroke.Color = Color3.fromRGB(100, 100, 100)

local _ConfirmTitle = Instance.new("TextLabel", _ConfirmBox)
_ConfirmTitle.Size = UDim2.new(1, 0, 0, 50); _ConfirmTitle.Text = "欢迎使用 🌚刘某某脚本🌝"; _ConfirmTitle.TextColor3 = Color3.new(1, 1, 1); _ConfirmTitle.Font = "GothamBold"; _ConfirmTitle.TextSize = 16; _ConfirmTitle.BackgroundTransparency = 1

local _ConfirmBtn = Instance.new("TextButton", _ConfirmBox)
_ConfirmBtn.Size = UDim2.new(0, 120, 0, 40); _ConfirmBtn.Position = UDim2.new(0.5, -60, 0.6, 0); _ConfirmBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); _ConfirmBtn.Text = "确认进入"; _ConfirmBtn.TextColor3 = Color3.new(1, 1, 1); _ConfirmBtn.Font = "GothamBold"; _ConfirmBtn.TextSize = 14
Instance.new("UICorner", _ConfirmBtn)
Instance.new("UIStroke", _ConfirmBtn).Color = Color3.fromRGB(80, 80, 80)

-- ==================== 🛠️ 主 UI 构建 ====================
local _M = Instance.new("Frame", _S)
_M.Size = UDim2.new(0, 520, 0, 520); _M.Position = UDim2.new(0.02, 0, 0.25, 0)
_M.BackgroundColor3 = Color3.fromRGB(15, 15, 15); _M.BorderSizePixel = 0
_M.ClipsDescendants = true; _M.Visible = false -- 初始隐藏，等确认后再显示
Instance.new("UICorner", _M)

local _Glow = Instance.new("UIStroke", _M); _Glow.Thickness = 3; _Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 55); _TB.BackgroundTransparency = 1; _TB.Active = true
local _Title = Instance.new("TextLabel", _TB)
_Title.Size = UDim2.new(1, 0, 1, 0); _Title.Text = "🌚刘某某脚本🌝"; _Title.Font = "GothamBold"; _Title.TextSize = 20; _Title.TextColor3 = Color3.new(1, 1, 1); _Title.BackgroundTransparency = 1

local _Container = Instance.new("Frame", _M)
_Container.Size = UDim2.new(1, -20, 1, -70); _Container.Position = UDim2.new(0, 10, 0, 60); _Container.BackgroundTransparency = 1

local _Sidebar = Instance.new("Frame", _Container)
_Sidebar.Size = UDim2.new(0, 130, 1, 0); _Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", _Sidebar).CornerRadius = UDim.new(0, 5)
local _SLL = Instance.new("UIListLayout", _Sidebar); _SLL.Padding = UDim.new(0, 12); _SLL.HorizontalAlignment = "Center"; _SLL.VerticalAlignment = "Top"

local function _CreateSBtn(name)
    local b = Instance.new("TextButton", _Sidebar); b.Size = UDim2.new(0, 120, 0, 50); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 14; b.TextColor3 = Color3.new(1,1,1); b.TextWrapped = true; Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.5; s.Color = Color3.fromRGB(60,60,60); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return b, s
end

local _MainArea = Instance.new("Frame", _Container)
_MainArea.Size = UDim2.new(1, -140, 1, 0); _MainArea.Position = UDim2.new(0, 140, 0, 0); _MainArea.BackgroundTransparency = 1

local function _NewPage()
    local f = Instance.new("ScrollingFrame", _MainArea); f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.ScrollBarThickness = 5; f.AutomaticCanvasSize = Enum.AutomaticSize.Y; f.Visible = false; f.Active = true
    local l = Instance.new("UIListLayout", f); l.Padding = UDim.new(0, 15); l.HorizontalAlignment = "Center"; l.SortOrder = "LayoutOrder"
    return f
end

local _Page1 = _NewPage()
local _Page2 = _NewPage()
local _Page3 = _NewPage()
local _Page4 = _NewPage()
_Page1.Visible = true

local _SBtn1, _ = _CreateSBtn("基本功能")
local _SBtn2, _ = _CreateSBtn("不用钥匙脚本库")
local _SBtn3, _ = _CreateSBtn("需要钥匙脚本库")
local _SBtn4, _ = _CreateSBtn("介绍以及更新")

local function _Show(p) 
    _Page1.Visible = (p == _Page1); _Page2.Visible = (p == _Page2); 
    _Page3.Visible = (p == _Page3); _Page4.Visible = (p == _Page4) 
end
_SBtn1.MouseButton1Click:Connect(function() _Show(_Page1) end)
_SBtn2.MouseButton1Click:Connect(function() _Show(_Page2) end)
_SBtn3.MouseButton1Click:Connect(function() _Show(_Page3) end)
_SBtn4.MouseButton1Click:Connect(function() _Show(_Page4) end)

-- 确认按钮逻辑
_ConfirmBtn.MouseButton1Click:Connect(function()
    _ConfirmBG:Destroy()
    _M.Visible = true
end)

-- ==================== 1. 基本功能 ====================
local function _CreateT(name, key, order, parent)
    local b = Instance.new("TextButton", parent); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 55); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 15; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.8; s.Color = Color3.fromRGB(60, 60, 60); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local i = Instance.new("Frame", b); i.Size = UDim2.new(0, 6, 0.6, 0); i.Position = UDim2.new(0, 10, 0.2, 0); i.BackgroundColor3 = Color3.fromRGB(200, 0, 0); i.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() _G_LMM_88[key] = not _G_LMM_88[key]; i.BackgroundColor3 = _G_LMM_88[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 0, 0) end)
end

local function _CreateInput(txt, key, order, parent)
    local i = Instance.new("TextBox", parent); i.LayoutOrder = order; i.Size = UDim2.new(0.9, 0, 0, 40); i.BackgroundColor3 = Color3.fromRGB(25, 25, 25); i.Text = txt..": 50"; i.TextColor3 = Color3.new(1,1,1); i.TextSize = 14; Instance.new("UICorner", i)
    Instance.new("UIStroke", i).Color = Color3.fromRGB(60, 60, 60)
    i.FocusLost:Connect(function() _G_LMM_88[key] = tonumber(i.Text:match("%d+")) or 50; i.Text = txt..": ".._G_LMM_88[key] end)
end

_CreateInput("行走速度", "v_val_1", 1, _Page1)
_CreateInput("飞行速度", "v_val_2", 2, _Page1)
_CreateT("内置透视", "v_0x1", 3, _Page1)
_CreateT("内置穿墙", "v_0x2", 4, _Page1)
_CreateT("内置速度开关", "v_0x3", 5, _Page1)
_CreateT("内置飞行开关", "v_0x4", 6, _Page1)


-- ==================== 2. 不用钥匙脚本库 ====================
local _SearchBar2 = Instance.new("TextBox", _Page2); _SearchBar2.LayoutOrder = 1; _SearchBar2.Size = UDim2.new(0.9, 0, 0, 45); _SearchBar2.BackgroundColor3 = Color3.fromRGB(40, 40, 40); _SearchBar2.Text = ""; _SearchBar2.PlaceholderText = "🔍 搜索免密脚本..."; _SearchBar2.TextColor3 = Color3.new(1,1,1); _SearchBar2.TextSize = 14; Instance.new("UICorner", _SearchBar2)
Instance.new("UIStroke", _SearchBar2).Color = Color3.fromRGB(80, 80, 80)

local function _CreateS2(name, url, order)
    local b = Instance.new("TextButton", _Page2); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 55); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Text = name; b.Font = "GothamBold"; b.TextSize = 14; b.TextColor3 = Color3.new(1, 1, 1); b.Name = "S_"..name; Instance.new("UICorner", b)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(60, 60, 60)
    b.MouseButton1Click:Connect(function() loadstring(game:HttpGet(url))() end)
end

_SearchBar2:GetPropertyChangedSignal("Text"):Connect(function()
    local q = _SearchBar2.Text:lower()
    for _, c in pairs(_Page2:GetChildren()) do if c:IsA("TextButton") and c.Name:sub(1,2) == "S_" then c.Visible = (q=="" or c.Text:lower():find(q)) end end
end)

_CreateS2("AIMBOT (自瞄)", "https://rawscripts.net/raw/Universal-Script-Aimbot-Mobile-34677", 10)
_CreateS2("Infinite Yield (万能)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 11)
_CreateS2("Rivals 无钥匙版", "https://raw.githubusercontent.com/idkmsnscriptronlox/Shadow-/refs/heads/main/Shadow", 12)
_CreateS2("Owl Hub (极简稳定版)", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt", 13)
-- 【补回丢失的按钮】
_CreateS2("Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source", 14)
_CreateS2("自动连点器 (刘某某)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 15) -- 请在此处替换为你真实的连点器链接


-- ==================== 3. 需要钥匙脚本库 ====================
local _SearchBar3 = Instance.new("TextBox", _Page3); _SearchBar3.LayoutOrder = 1; _SearchBar3.Size = UDim2.new(0.9, 0, 0, 45); _SearchBar3.BackgroundColor3 = Color3.fromRGB(40, 40, 40); _SearchBar3.Text = ""; _SearchBar3.PlaceholderText = "🔍 搜索带密脚本..."; _SearchBar3.TextColor3 = Color3.new(1,1,1); _SearchBar3.TextSize = 14; Instance.new("UICorner", _SearchBar3)
Instance.new("UIStroke", _SearchBar3).Color = Color3.fromRGB(80, 80, 80)


-- ==================== 4. 介绍以及更新 ====================
local function _CreateInfo(txt, order)
    local l = Instance.new("TextLabel", _Page4); l.LayoutOrder = order; l.Size = UDim2.new(0.9, 0, 0, 40); l.BackgroundColor3 = Color3.fromRGB(25,25,25); l.Text = txt; l.TextColor3 = Color3.new(0.9,0.9,0.9); l.Font = "GothamBold"; l.TextSize = 15; Instance.new("UICorner", l)
    Instance.new("UIStroke", l).Color = Color3.fromRGB(50, 50, 50)
end
_CreateInfo("作者：🌚刘某某🌝", 1)
_CreateInfo("版本：V3.7 (核心逻辑修复版)", 2)
_CreateInfo("修复：透视、飞行、穿墙全部恢复", 3)

-- 【这里加回了蓝色的 JOIN DISCORD 按钮】
local _DiscordBtn = Instance.new("TextButton", _Page4)
_DiscordBtn.LayoutOrder = 99
_DiscordBtn.Size = UDim2.new(0.9, 0, 0, 55)
_DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- 纯正 Discord 蓝
_DiscordBtn.Text = "🔗 JOIN DISCORD"
_DiscordBtn.Font = "GothamBold"
_DiscordBtn.TextSize = 20
_DiscordBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", _DiscordBtn)
_DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/cjpezEZub")
    _DiscordBtn.Text = "已复制链接!"
    task.wait(1.5)
    _DiscordBtn.Text = "🔗 JOIN DISCORD"
end)


-- ==================== 窗口控制 & 最小化修复 ====================
local function _Ctrl(t, x, c, f)
    local b = Instance.new("TextButton", _TB); b.Size = UDim2.new(0, 32, 0, 32); b.Position = UDim2.new(1, x, 0.5, -16); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.MouseButton1Click:Connect(f)
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

-- ==================== ⚙️ 核心功能引擎 (完全恢复) ====================

-- [ESP 透视文件夹]
local _ESP_Folder = _CG:FindFirstChild("LMM_ESP_FOLDER") or Instance.new("Folder", _CG)
_ESP_Folder.Name = "LMM_ESP_FOLDER"

-- [物理刷新：穿墙]
_RS.Stepped:Connect(function()
    if _G_LMM_88.v_0x2 and _LP.Character then
        for _, p in pairs(_LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- [渲染刷新：ESP、飞行、速度、外框发光]
local _FlyVelocity = nil

_RS.RenderStepped:Connect(function()
    _Glow.Color = _RGB_CORE.Color -- 边缘发光
    
    local char = _LP.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        local hum = char.Humanoid
        local hrp = char.HumanoidRootPart
        
        -- 速度
        hum.WalkSpeed = _G_LMM_88.v_0x3 and _G_LMM_88.v_val_1 or 16
        
        -- 飞行逻辑
        if _G_LMM_88.v_0x4 then
            if not _FlyVelocity or _FlyVelocity.Parent ~= hrp then
                if _FlyVelocity then _FlyVelocity:Destroy() end
                _FlyVelocity = Instance.new("BodyVelocity")
                _FlyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                _FlyVelocity.Parent = hrp
            end
            if hum.MoveDirection.Magnitude > 0 then
                _FlyVelocity.Velocity = _Cam.CFrame.LookVector * _G_LMM_88.v_val_2
            else
                _FlyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        else
            if _FlyVelocity then _FlyVelocity:Destroy(); _FlyVelocity = nil end
        end
    end
    
    -- 透视逻辑
    _ESP_Folder:ClearAllChildren()
    if _G_LMM_88.v_0x1 then
        for _, p in pairs(_P:GetPlayers()) do
            if p ~= _LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hl = Instance.new("Highlight", _ESP_Folder)
                hl.Adornee = p.Character
                hl.FillColor = Color3.new(1, 0, 0)
                hl.FillTransparency = 0.5
                hl.OutlineColor = Color3.new(1, 1, 1)
            end
        end
    end
end)
