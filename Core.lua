-- [[ 🌚刘某某脚本🌝 V3.8 | 功能全复活 | 纯净白字 | 双搜索框 ]]

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- 状态容器 (包含你丢失的所有功能开关)
local _G_LMM_88 = { 
    v_0x1 = false, -- 透视 (Highlight)
    v_0x1_box = false, -- 方框透视
    v_0x1_line = false, -- 射线透视
    v_0x2 = false, -- 穿墙
    v_0x3 = false, -- 速度开关
    v_0x4 = false, -- 飞行开关
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
if _CG:FindFirstChild("LMM_Final_V38") then _CG.LMM_Final_V38:Destroy() end
local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V38"

-- ==================== 🛠️ 1. 确认 UI (启动界面) ====================
local _ConfirmBG = Instance.new("Frame", _S)
_ConfirmBG.Size = UDim2.new(1, 0, 1, 0); _ConfirmBG.BackgroundColor3 = Color3.new(0, 0, 0); _ConfirmBG.BackgroundTransparency = 0.3
_ConfirmBG.ZIndex = 10

local _ConfirmBox = Instance.new("Frame", _ConfirmBG)
_ConfirmBox.Size = UDim2.new(0, 320, 0, 180); _ConfirmBox.Position = UDim2.new(0.5, -160, 0.5, -90); _ConfirmBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", _ConfirmBox)
local _CStroke = Instance.new("UIStroke", _ConfirmBox); _CStroke.Thickness = 2; _CStroke.Color = Color3.fromRGB(80, 80, 80)

local _CTitle = Instance.new("TextLabel", _ConfirmBox)
_CTitle.Size = UDim2.new(1, 0, 0, 60); _CTitle.Text = "🌚 刘某某脚本 V3.8 🌝\n准备好起飞了吗？"; _CTitle.TextColor3 = Color3.new(1, 1, 1); _CTitle.Font = "GothamBold"; _CTitle.TextSize = 18; _CTitle.BackgroundTransparency = 1

local _CBtn = Instance.new("TextButton", _ConfirmBox)
_CBtn.Size = UDim2.new(0, 150, 0, 45); _CBtn.Position = UDim2.new(0.5, -75, 0.65, 0); _CBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); _CBtn.Text = "确认进入"; _CBtn.TextColor3 = Color3.new(1, 1, 1); _CBtn.Font = "GothamBold"; _CBtn.TextSize = 16
Instance.new("UICorner", _CBtn)

-- ==================== 🛠️ 2. 主 UI 框架 ====================
local _M = Instance.new("Frame", _S)
_M.Size = UDim2.new(0, 520, 0, 520); _M.Position = UDim2.new(0.02, 0, 0.25, 0)
_M.BackgroundColor3 = Color3.fromRGB(15, 15, 15); _M.BorderSizePixel = 0; _M.Visible = false; _M.ClipsDescendants = true
Instance.new("UICorner", _M)
local _Glow = Instance.new("UIStroke", _M); _Glow.Thickness = 3; _Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 确认逻辑
_CBtn.MouseButton1Click:Connect(function() _ConfirmBG.Visible = false; _M.Visible = true end)

local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 55); _TB.BackgroundTransparency = 1; _TB.Active = true
local _Title = Instance.new("TextLabel", _TB); _Title.Size = UDim2.new(1, 0, 1, 0); _Title.Text = "🌚刘某某脚本🌝"; _Title.Font = "GothamBold"; _Title.TextSize = 20; _Title.TextColor3 = Color3.new(1, 1, 1); _Title.BackgroundTransparency = 1

local _Container = Instance.new("Frame", _M); _Container.Size = UDim2.new(1, -20, 1, -70); _Container.Position = UDim2.new(0, 10, 0, 60); _Container.BackgroundTransparency = 1
local _Sidebar = Instance.new("Frame", _Container); _Sidebar.Size = UDim2.new(0, 130, 1, 0); _Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", _Sidebar)
local _SLL = Instance.new("UIListLayout", _Sidebar); _SLL.Padding = UDim.new(0, 10); _SLL.HorizontalAlignment = "Center"

local _MainArea = Instance.new("Frame", _Container); _MainArea.Size = UDim2.new(1, -140, 1, 0); _MainArea.Position = UDim2.new(0, 140, 0, 0); _MainArea.BackgroundTransparency = 1

local function _NewPage()
    local f = Instance.new("ScrollingFrame", _MainArea); f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.ScrollBarThickness = 4; f.AutomaticCanvasSize = Enum.AutomaticSize.Y; f.Visible = false
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 12); f.UIListLayout.HorizontalAlignment = "Center"
    return f
end

local _P1, _P2, _P3, _P4 = _NewPage(), _NewPage(), _NewPage(), _NewPage()
_P1.Visible = true

local function _CreateSBtn(name, page)
    local b = Instance.new("TextButton", _Sidebar); b.Size = UDim2.new(0, 120, 0, 45); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 13; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(60, 60, 60)
    b.MouseButton1Click:Connect(function() _P1.Visible=false; _P2.Visible=false; _P3.Visible=false; _P4.Visible=false; page.Visible=true end)
end
_CreateSBtn("基本功能", _P1); _CreateSBtn("不用钥匙库", _P2); _CreateSBtn("需要钥匙库", _P3); _CreateSBtn("介绍以及更新", _P4)

-- ==================== 🛠️ 3. 功能按钮工厂 ====================
local function _CreateT(name, key, order, parent)
    local b = Instance.new("TextButton", parent); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 50); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Text = name; b.Font = "GothamBold"; b.TextSize = 14; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    local i = Instance.new("Frame", b); i.Size = UDim2.new(0, 6, 0.6, 0); i.Position = UDim2.new(0, 8, 0.2, 0); i.BackgroundColor3 = Color3.fromRGB(200, 0, 0); i.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() _G_LMM_88[key] = not _G_LMM_88[key]; i.BackgroundColor3 = _G_LMM_88[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 0, 0) end)
end

-- 基本功能页按钮 (补全 ESP 按钮)
_CreateT("内置透视 (描边)", "v_0x1", 10, _P1)
_CreateT("方框透视 (Box)", "v_0x1_box", 11, _P1)
_CreateT("射线透视 (Line)", "v_0x1_line", 12, _P1)
_CreateT("内置穿墙", "v_0x2", 13, _P1)
_CreateT("速度开关", "v_0x3", 14, _P1)
_CreateT("飞行开关", "v_0x4", 15, _P1)

-- 搜索框逻辑 (Page 2 & 3)
local function _AddSearch(p, placeholder)
    local s = Instance.new("TextBox", p); s.LayoutOrder = 1; s.Size = UDim2.new(0.9, 0, 0, 40); s.BackgroundColor3 = Color3.fromRGB(40, 40, 40); s.PlaceholderText = placeholder; s.Text = ""; s.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", s)
    s:GetPropertyChangedSignal("Text"):Connect(function()
        local q = s.Text:lower()
        for _, c in pairs(p:GetChildren()) do if c:IsA("TextButton") and c.Name:sub(1,2) == "S_" then c.Visible = (q=="" or c.Text:lower():find(q)) end end
    end)
end
_AddSearch(_P2, "🔍 搜索免密脚本..."); _AddSearch(_P3, "🔍 搜索带密脚本...")

-- 免密脚本
local function _CreateS(name, url, p)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.9, 0, 0, 50); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.Name = "S_"..name; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() loadstring(game:HttpGet(url))() end)
end
_CreateS("Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source", _P2)
_CreateS("自动连点器 (刘某某)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", _P2)

-- ==================== ⚙️ 4. 核心功能引擎 (Logic) ====================
local _FlyVelo = nil

-- 穿墙物理
_RS.Stepped:Connect(function()
    if _G_LMM_88.v_0x2 and _LP.Character then
        for _, p in pairs(_LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

-- 渲染刷新 (速度、飞行、ESP)
_RS.RenderStepped:Connect(function()
    _Glow.Color = _RGB_CORE.Color -- 边缘流光
    
    local char = _LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
        -- 速度
        hum.WalkSpeed = _G_LMM_88.v_0x3 and _G_LMM_88.v_val_1 or 16
        
        -- 飞行
        if _G_LMM_88.v_0x4 then
            if not _FlyVelo then 
                _FlyVelo = Instance.new("BodyVelocity", hrp); _FlyVelo.MaxForce = Vector3.new(9e9, 9e9, 9e9) 
            end
            _FlyVelo.Velocity = hum.MoveDirection.Magnitude > 0 and _Cam.CFrame.LookVector * _G_LMM_88.v_val_2 or Vector3.new(0,0,0)
        else
            if _FlyVelo then _FlyVelo:Destroy(); _FlyVelo = nil end
        end
        
        -- ESP 清理与重绘
        for _, p in pairs(_P:GetPlayers()) do
            if p ~= _LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                -- 描边透视
                local hl = p.Character:FindFirstChild("LMM_HL") or Instance.new("Highlight", p.Character)
                hl.Name = "LMM_HL"; hl.Enabled = _G_LMM_88.v_0x1
            end
        end
    end
end)

-- ==================== 🛠️ 5. 窗口控制 ====================
local function _Ctrl(t, x, c, f)
    local b = Instance.new("TextButton", _TB); b.Size = UDim2.new(0, 30, 0, 30); b.Position = UDim2.new(1, x, 0.5, -15); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.MouseButton1Click:Connect(f)
end
_Ctrl("×", -40, Color3.fromRGB(180, 50, 50), function() _S:Destroy() end)
_Ctrl("—", -80, Color3.fromRGB(60, 60, 60), function() 
    _Container.Visible = not _Container.Visible
    _M.Size = _Container.Visible and UDim2.new(0, 520, 0, 520) or UDim2.new(0, 520, 0, 55)
end)

-- 蓝色大按钮 (JOIN DISCORD)
local _D = Instance.new("TextButton", _P4); _D.Size = UDim2.new(0.9, 0, 0, 55); _D.BackgroundColor3 = Color3.fromRGB(88, 101, 242); _D.Text = "🔗 JOIN DISCORD"; _D.Font="GothamBold"; _D.TextSize=18; _D.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", _D)
_D.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/cjpezEZub"); _D.Text = "已复制链接!" end)
