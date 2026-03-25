-- [[ 🌚刘某某脚本🌝 V4.0 | 移除启动确认 | 按钮点击确认 | ESP全功能 ]]

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- 状态容器
local _G_LMM_88 = { 
    v_0x1 = false, -- 描边
    v_0x1_box = false, -- 方框
    v_0x1_line = false, -- 射线
    v_0x2 = false, -- 穿墙
    v_0x3 = false, -- 速度
    v_0x4 = false, -- 飞行
    v_val_1 = 50,  
    v_val_2 = 50   
}
local _RGB_CORE = { Color = Color3.new(1,0,0) }

-- RGB 驱动
task.spawn(function()
    local c = 0
    while true do
        c = (c + 0.005) % 1
        _RGB_CORE.Color = Color3.fromHSV(c, 0.7, 1)
        task.wait(0.05) 
    end
end)

-- 清理旧 UI
if _CG:FindFirstChild("LMM_Final_V40") then _CG.LMM_Final_V40:Destroy() end
local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V40"

-- ==================== 🛠️ 1. 核心确认函数 (点击按钮时触发) ====================
local function _ShowConfirmUI(scriptName, callback)
    local _CBG = Instance.new("Frame", _S)
    _CBG.Size = UDim2.new(1, 0, 1, 0); _CBG.BackgroundColor3 = Color3.new(0, 0, 0); _CBG.BackgroundTransparency = 0.5; _CBG.ZIndex = 50
    
    local _CBox = Instance.new("Frame", _CBG)
    _CBox.Size = UDim2.new(0, 280, 0, 150); _CBox.Position = UDim2.new(0.5, -140, 0.5, -75); _CBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", _CBox); local _s = Instance.new("UIStroke", _CBox); _s.Color = Color3.fromRGB(100, 100, 100); _s.Thickness = 2
    
    local _Txt = Instance.new("TextLabel", _CBox)
    _Txt.Size = UDim2.new(1, 0, 0, 60); _Txt.Text = "确定要运行\n[" .. scriptName .. "] 吗？"; _Txt.TextColor3 = Color3.new(1,1,1); _Txt.Font = "GothamBold"; _Txt.TextSize = 14; _Txt.BackgroundTransparency = 1
    
    local _Yes = Instance.new("TextButton", _CBox); _Yes.Size = UDim2.new(0, 100, 0, 35); _Yes.Position = UDim2.new(0.15, 0, 0.65, 0); _Yes.BackgroundColor3 = Color3.fromRGB(40,40,40); _Yes.Text = "运行"; _Yes.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", _Yes)
    local _No = Instance.new("TextButton", _CBox); _No.Size = UDim2.new(0, 100, 0, 35); _No.Position = UDim2.new(0.55, 0, 0.65, 0); _No.BackgroundColor3 = Color3.fromRGB(40,40,40); _No.Text = "取消"; _No.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", _No)
    
    _Yes.MouseButton1Click:Connect(function() _CBG:Destroy(); callback() end)
    _No.MouseButton1Click:Connect(function() _CBG:Destroy() end)
end

-- ==================== 🛠️ 2. 主 UI 框架 (直接显示) ====================
local _M = Instance.new("Frame", _S)
_M.Size = UDim2.new(0, 520, 0, 520); _M.Position = UDim2.new(0.02, 0, 0.25, 0)
_M.BackgroundColor3 = Color3.fromRGB(15, 15, 15); _M.BorderSizePixel = 0; _M.Visible = true; _M.ClipsDescendants = true
Instance.new("UICorner", _M)
local _Glow = Instance.new("UIStroke", _M); _Glow.Thickness = 3; _Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 55); _TB.BackgroundTransparency = 1; _TB.Active = true
local _Title = Instance.new("TextLabel", _TB); _Title.Size = UDim2.new(1, 0, 1, 0); _Title.Text = "🌚刘某某脚本🌝"; _Title.Font = "GothamBold"; _Title.TextSize = 20; _Title.TextColor3 = Color3.new(1, 1, 1); _Title.BackgroundTransparency = 1

local _Container = Instance.new("Frame", _M); _Container.Size = UDim2.new(1, -20, 1, -70); _Container.Position = UDim2.new(0, 10, 0, 60); _Container.BackgroundTransparency = 1
local _Sidebar = Instance.new("Frame", _Container); _Sidebar.Size = UDim2.new(0, 130, 1, 0); _Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", _Sidebar); local _SLL = Instance.new("UIListLayout", _Sidebar); _SLL.Padding = UDim.new(0, 10); _SLL.HorizontalAlignment = "Center"

local _MainArea = Instance.new("Frame", _Container); _MainArea.Size = UDim2.new(1, -140, 1, 0); _MainArea.Position = UDim2.new(0, 140, 0, 0); _MainArea.BackgroundTransparency = 1

local function _NewPage()
    local f = Instance.new("ScrollingFrame", _MainArea); f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.ScrollBarThickness = 4; f.AutomaticCanvasSize = Enum.AutomaticSize.Y; f.Visible = false
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 12); f.UIListLayout.HorizontalAlignment = "Center"
    return f
end
local _P1, _P2, _P3, _P4 = _NewPage(), _NewPage(), _NewPage(), _NewPage(); _P1.Visible = true

local function _CreateSBtn(name, page)
    local b = Instance.new("TextButton", _Sidebar); b.Size = UDim2.new(0, 120, 0, 45); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 13; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() _P1.Visible=false; _P2.Visible=false; _P3.Visible=false; _P4.Visible=false; page.Visible=true end)
end
_CreateSBtn("基本功能", _P1); _CreateSBtn("不用钥匙库", _P2); _CreateSBtn("需要钥匙库", _P3); _CreateSBtn("介绍以及更新", _P4)

-- ==================== 🛠️ 3. 按钮工厂 (修复逻辑) ====================
local function _CreateT(name, key, order, parent)
    local b = Instance.new("TextButton", parent); b.LayoutOrder = order; b.Size = UDim2.new(0.9, 0, 0, 50); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Text = name; b.Font = "GothamBold"; b.TextSize = 14; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    local i = Instance.new("Frame", b); i.Size = UDim2.new(0, 6, 0.6, 0); i.Position = UDim2.new(0, 8, 0.2, 0); i.BackgroundColor3 = Color3.fromRGB(200, 0, 0); i.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() 
        _G_LMM_88[key] = not _G_LMM_88[key]
        i.BackgroundColor3 = _G_LMM_88[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 0, 0)
    end)
end

_CreateT("描边透视 (Highlight)", "v_0x1", 10, _P1)
_CreateT("方框透视 (Box)", "v_0x1_box", 11, _P1)
_CreateT("射线透视 (Line)", "v_0x1_line", 12, _P1)
_CreateT("内置穿墙", "v_0x2", 13, _P1)
_CreateT("速度开关", "v_0x3", 14, _P1)
_CreateT("飞行开关", "v_0x4", 15, _P1)

-- 免密脚本库按钮 (加入确认 UI)
local function _CreateS(name, url, p)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.9, 0, 0, 50); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.Name = "S_"..name; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() 
        _ShowConfirmUI(name, function() loadstring(game:HttpGet(url))() end) 
    end)
end
_CreateS("Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source", _P2)
_CreateS("自动连点器", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", _P2)

-- ==================== ⚙️ 4. 核心逻辑引擎 (加固版) ====================
local _FlyVelo = nil

_RS.Stepped:Connect(function()
    if _G_LMM_88.v_0x2 and _LP.Character then
        for _, p in pairs(_LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

_RS.RenderStepped:Connect(function()
    _Glow.Color = _RGB_CORE.Color
    if not _LP.Character or not _LP.Character:FindFirstChild("Humanoid") then return end
    
    local hrp = _LP.Character.HumanoidRootPart
    local hum = _LP.Character.Humanoid
    
    -- 速度与飞行逻辑修复
    hum.WalkSpeed = _G_LMM_88.v_0x3 and _G_LMM_88.v_val_1 or 16
    if _G_LMM_88.v_0x4 then
        if not _FlyVelo then 
            _FlyVelo = Instance.new("BodyVelocity", hrp); _FlyVelo.MaxForce = Vector3.new(9e9, 9e9, 9e9) 
        end
        _FlyVelo.Velocity = hum.MoveDirection.Magnitude > 0 and _Cam.CFrame.LookVector * _G_LMM_88.v_val_2 or Vector3.new(0,0,0)
    elseif _FlyVelo then 
        _FlyVelo:Destroy(); _FlyVelo = nil 
    end
    
    -- ESP 系统 (描边+方框)
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- 1. 描边
            local hl = p.Character:FindFirstChild("LMM_HL") or Instance.new("Highlight", p.Character)
            hl.Name = "LMM_HL"; hl.Enabled = _G_LMM_88.v_0x1
            
            -- 2. 方框 (BillboardGui 方式更稳定)
            local box = p.Character.HumanoidRootPart:FindFirstChild("LMM_Box")
            if _G_LMM_88.v_0x1_box then
                if not box then
                    box = Instance.new("BillboardGui", p.Character.HumanoidRootPart); box.Name = "LMM_Box"; box.Size = UDim2.new(4,0,5,0); box.AlwaysOnTop = true
                    local f = Instance.new("Frame", box); f.Size = UDim2.new(1,0,1,0); f.BackgroundTransparency = 1
                    local st = Instance.new("UIStroke", f); st.Thickness = 2; st.Color = Color3.new(1,1,1)
                end
            elseif box then box:Destroy() end
        end
    end
end)

-- 窗口控制按钮 (cite: Saved Information - 替换逻辑在 Page 4)
local function _Ctrl(t, x, c, f)
    local b = Instance.new("TextButton", _TB); b.Size = UDim2.new(0, 30, 0, 30); b.Position = UDim2.new(1, x, 0.5, -15); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.MouseButton1Click:Connect(f)
end
_Ctrl("×", -40, Color3.fromRGB(180, 50, 50), function() _S:Destroy() end)
_Ctrl("—", -80, Color3.fromRGB(60, 60, 60), function() 
    _Container.Visible = not _Container.Visible
    _M.Size = _Container.Visible and UDim2.new(0, 520, 0, 520) or UDim2.new(0, 520, 0, 55)
end)

-- 蓝色按钮 (Page 4)
local _D = Instance.new("TextButton", _P4); _D.Size = UDim2.new(0.9, 0, 0, 55); _D.BackgroundColor3 = Color3.fromRGB(88, 101, 242); _D.Text = "🔗 JOIN DISCORD"; _D.Font="GothamBold"; _D.TextSize=18; _D.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", _D)
_D.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/cjpezEZub"); _D.Text = "已复制链接!" end)
