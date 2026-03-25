-- [[ 🌚刘某某脚本🌝 V3.2 | 动态选项卡系统 (Tab System) | 保持防封逻辑 ]]

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- 状态容器 (保持 V2.9 防封版逻辑)
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

if _CG:FindFirstChild("LMM_Final_V36") then _CG.LMM_Final_V36:Destroy() end
local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V36"
local _M = Instance.new("Frame", _S)
_M.Size = UDim2.new(0, 460, 0, 520); _M.Position = UDim2.new(0.02, 0, 0.25, 0)
_M.BackgroundColor3 = Color3.fromRGB(15, 15, 15); _M.BorderSizePixel = 0
Instance.new("UICorner", _M)
local _Glow = Instance.new("UIStroke", _M); _Glow.Thickness = 3

-- Title Bar (保持原样)
local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 55); _TB.BackgroundTransparency = 1; _TB.Active = true
local _Title = Instance.new("TextLabel", _TB)
_Title.Size = UDim2.new(1, 0, 1, 0); _Title.Text = "🌚刘某某脚本🌝"; _Title.Font = "GothamBold"; _Title.TextSize = 18; _Title.TextColor3 = Color3.new(1, 1, 1); _Title.BackgroundTransparency = 1

local _Container = Instance.new("Frame", _M)
_Container.Size = UDim2.new(1, -20, 1, -70); _Container.Position = UDim2.new(0, 10, 0, 60)
_Container.BackgroundTransparency = 1

-- ==================== [V3.1 Sidebar setup] ====================
local _Sidebar = Instance.new("Frame", _Container)
_Sidebar.Size = UDim2.new(0, 60, 1, 0); _Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", _Sidebar).CornerRadius = UDim.new(0, 5)

-- V3.1 Sidebar Layout (垂直对齐 Center)
-- local _SLL = Instance.new("UIListLayout", _Sidebar)
-- _SLL.Padding = UDim.new(0, 15); _SLL.HorizontalAlignment = "Center"; _SLL.VerticalAlignment = "Center"

-- ==================== 🛠️ [修改：V3.2 移动按钮向上] ====================
-- 1. 核心侧边栏布局：改为顶部排列 (VerticalAlignment = Top)
local _SLL = Instance.new("UIListLayout", _Sidebar)
_SLL.Padding = UDim.new(0, 15); _SLL.HorizontalAlignment = "Center"; _SLL.VerticalAlignment = "Top"

-- 2. 侧边栏按钮工厂函数 (增强：加入 targetTab 参数)
local function _CreateSBtn(name)
    local b = Instance.new("TextButton", _Sidebar); b.Size = UDim2.new(0, 50, 0, 50); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 16; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.5; s.Color = Color3.fromRGB(60,60,60)
    return b, s
end

-- ==================== 🛠️ [新增加] V3.2 动态选项卡切换逻辑 ====================
-- 3. 主内容区核心容器 (parent for all tabs)
local _MainArea = Instance.new("Frame", _Container)
_MainArea.Size = UDim2.new(1, -70, 1, 0); _MainArea.Position = UDim2.new(0, 70, 0, 0)
_MainArea.BackgroundTransparency = 1

-- 4. 选项卡 1：主页 (TabMain) - 存放所有原有脚本和功能
local _TabMain = Instance.new("ScrollingFrame", _MainArea) -- 原来的 ScrollingFrame
_TabMain.Size = UDim2.new(1, 0, 1, 0)
_TabMain.BackgroundTransparency = 1; _TabMain.BorderSizePixel = 0; _TabMain.ScrollBarThickness = 5
_TabMain.AutomaticCanvasSize = Enum.AutomaticSize.Y
_TabMain.CanvasSize = UDim2.new(0, 0, 1.25, 0)
_TabMain.Active = true; _TabMain.Visible = true

local _MainList = Instance.new("UIListLayout", _TabMain)
_MainList.Padding = UDim.new(0, 15); _MainList.HorizontalAlignment = "Center"; _MainList.SortOrder = "LayoutOrder"

-- 5. 选项卡 2：设置 (TabSet) - 目前占位
local _TabSet = Instance.new("ScrollingFrame", _MainArea)
_TabSet.Size = UDim2.new(1, 0, 1, 0)
_TabSet.BackgroundTransparency = 1; _TabSet.BorderSizePixel = 0; _TabSet.ScrollBarThickness = 5
_TabSet.AutomaticCanvasSize = Enum.AutomaticSize.Y
_TabSet.CanvasSize = UDim2.new(0, 0, 1.25, 0)
_TabSet.Active = true; _TabSet.Visible = false -- 默认隐藏

local _SetList = Instance.new("UIListLayout", _TabSet)
_SetList.Padding = UDim.new(0, 15); _SetList.HorizontalAlignment = "Center"; _SetList.SortOrder = "LayoutOrder"

-- [选项卡 2 占位内容]
local _PlaceholderT2 = Instance.new("TextLabel", _TabSet)
_PlaceholderT2.Size = UDim2.new(0.88, 0, 0, 60); _PlaceholderT2.BackgroundTransparency = 1; _PlaceholderT2.Text = "[Btn2 设置页 (占位)]"; _PlaceholderT2.TextColor3 = Color3.new(0.4, 0.4, 0.4); _PlaceholderT2.Font = "Gotham"; _PlaceholderT2.TextSize = 14; Instance.new("UICorner", _PlaceholderT2)

-- 6. 选项卡 3：ESP 设置 (TabEsp) - 目前占位
local _TabEsp = Instance.new("ScrollingFrame", _MainArea)
_TabEsp.Size = UDim2.new(1, 0, 1, 0)
_TabEsp.BackgroundTransparency = 1; _TabEsp.BorderSizePixel = 0; _TabEsp.ScrollBarThickness = 5
_TabEsp.AutomaticCanvasSize = Enum.AutomaticSize.Y
_TabEsp.CanvasSize = UDim2.new(0, 0, 1.25, 0)
_TabEsp.Active = true; _TabEsp.Visible = false -- 默认隐藏

local _EspList = Instance.new("UIListLayout", _TabEsp)
_EspList.Padding = UDim.new(0, 15); _EspList.HorizontalAlignment = "Center"; _EspList.SortOrder = "LayoutOrder"

-- [选项卡 3 占位内容]
local _PlaceholderT3 = Instance.new("TextLabel", _TabEsp)
_PlaceholderT3.Size = UDim2.new(0.88, 0, 0, 60); _PlaceholderT3.BackgroundTransparency = 1; _PlaceholderT3.Text = "[Btn3 ESP 设置页 (占位)]"; _PlaceholderT3.TextColor3 = Color3.new(0.4, 0.4, 0.4); _PlaceholderT3.Font = "Gotham"; _PlaceholderT3.TextSize = 14; Instance.new("UICorner", _PlaceholderT3)


-- 7. 动态切换核心逻辑
local _Tabs = { _TabMain, _TabSet, _TabEsp } -- 管理所有选项卡

local function _ShowTab(tabToShow)
    for _, tab in pairs(_Tabs) do
        tab.Visible = (tab == tabToShow) -- 仅让指定的 Visible = true
    end
end

-- ==================== V3.2 创建侧边栏按钮 (增强点击逻辑) ====================
local _SBtn1, _SBtn1S = _CreateSBtn("Btn1")
_SBtn1.MouseButton1Click:Connect(function() _ShowTab(_TabMain) end) -- 点击切换到主页

local _SBtn2, _SBtn2S = _CreateSBtn("Btn2")
_SBtn2.MouseButton1Click:Connect(function() _ShowTab(_TabSet) end) -- 点击切换到设置页

local _SBtn3, _SBtn3S = _CreateSBtn("Btn3")
_SBtn3.MouseButton1Click:Connect(function() _ShowTab(_TabEsp) end) -- 点击切换到 ESP 页

-- 为了让所有旧代码（_CreateT, _CreateS等）能精准套用，我将原 V3.1 的滚动区容器重命名
local _SF = _TabMain -- 重定向！所有旧内容都会被 parent 到 _TabMain 里


-- ==================== [保持原样] 全局确认弹窗 UI ====================
local _ConfirmFrame = Instance.new("Frame", _S)
_ConfirmFrame.Size = UDim2.new(0, 260, 0, 140); _ConfirmFrame.Position = UDim2.new(0.5, -130, 0.5, -70)
_ConfirmFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); _ConfirmFrame.Visible = false; _ConfirmFrame.ZIndex = 10
Instance.new("UICorner", _ConfirmFrame)
local _ConfirmStroke = Instance.new("UIStroke", _ConfirmFrame); _ConfirmStroke.Thickness = 2
_RS.Heartbeat:Connect(function() _ConfirmStroke.Color = _RGB_CORE.Color end)

local _ConfirmTitle = Instance.new("TextLabel", _ConfirmFrame)
_ConfirmTitle.Size = UDim2.new(1, 0, 0, 40); _ConfirmTitle.BackgroundTransparency = 1; _ConfirmTitle.Text = "确认执行此脚本？"; _ConfirmTitle.TextColor3 = Color3.new(1,1,1); _ConfirmTitle.Font = "GothamBold"; _ConfirmTitle.TextSize = 16; _ConfirmTitle.ZIndex = 10

local _ConfirmName = Instance.new("TextLabel", _ConfirmFrame)
_ConfirmName.Size = UDim2.new(1, -20, 0, 40); _ConfirmName.Position = UDim2.new(0, 10, 0, 35)
_ConfirmName.BackgroundTransparency = 1; _ConfirmName.TextColor3 = Color3.fromRGB(200, 200, 200); _ConfirmName.Font = "Gotham"; _ConfirmName.TextSize = 14; _ConfirmName.TextWrapped = true; _ConfirmName.ZIndex = 10

local _BtnYes = Instance.new("TextButton", _ConfirmFrame)
_BtnYes.Size = UDim2.new(0, 100, 0, 35); _BtnYes.Position = UDim2.new(0, 20, 0, 85); _BtnYes.BackgroundColor3 = Color3.fromRGB(0, 150, 50); _BtnYes.Text = "执行"; _BtnYes.TextColor3 = Color3.new(1,1,1); _BtnYes.Font = "GothamBold"; _BtnYes.ZIndex = 10; Instance.new("UICorner", _BtnYes)

local _BtnNo = Instance.new("TextButton", _ConfirmFrame)
_BtnNo.Size = UDim2.new(0, 100, 0, 35); _BtnNo.Position = UDim2.new(1, -120, 0, 85); _BtnNo.BackgroundColor3 = Color3.fromRGB(150, 0, 0); _BtnNo.Text = "取消"; _BtnNo.TextColor3 = Color3.new(1,1,1); _BtnNo.Font = "GothamBold"; _BtnNo.ZIndex = 10; Instance.new("UICorner", _BtnNo)

local _CurrentAction = nil
_BtnYes.MouseButton1Click:Connect(function() 
    if _CurrentAction then 
        -- 防封优化：增加随机点击延迟 (保持原样)
        task.wait(math.random(15, 45) / 100)
        task.spawn(_CurrentAction) 
    end; 
    _ConfirmFrame.Visible = false 
end)
_BtnNo.MouseButton1Click:Connect(function() _ConfirmFrame.Visible = false end)

-- [工厂函数 保持原样]
local function _CreateColorBar(key, order)
    local f = Instance.new("Frame", _SF); f.LayoutOrder = order; f.Size = UDim2.new(0.88, 0, 0, 35); f.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", f); layout.FillDirection = "Horizontal"; layout.HorizontalAlignment = "Center"; layout.Padding = UDim.new(0, 10)
    local colors = {{Color3.fromRGB(0, 150, 255), "蓝"}, {Color3.fromRGB(255, 0, 0), "红"}, {Color3.fromRGB(255, 255, 255), "白"}, {Color3.fromRGB(0, 0, 0), "黑"}, {Color3.fromRGB(0, 255, 100), "绿"}}
    for _, info in pairs(colors) do
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 55, 0, 28); b.BackgroundColor3 = info[1]; b.Text = ""; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        local s = Instance.new("UIStroke", b); s.Thickness = 1.5; s.Color = Color3.new(1,1,1); s.Enabled = false
        b.MouseButton1Click:Connect(function() _G_LMM_88[key] = info[1]; for _, c in pairs(f:GetChildren()) do if c:IsA("TextButton") then c.UIStroke.Enabled = false end end; s.Enabled = true end)
    end
end

local function _CreateT(name, key, order)
    local b = Instance.new("TextButton", _SF); b.LayoutOrder = order; b.Size = UDim2.new(0.88, 0, 0, 60); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = name; b.Font = "GothamBold"; b.TextSize = 14; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Thickness = 1.8; s.Color = Color3.fromRGB(60, 60, 60)
    local i = Instance.new("Frame", b); i.Size = UDim2.new(0, 6, 0.6, 0); i.Position = UDim2.new(0, 12, 0.2, 0); i.BackgroundColor3 = Color3.fromRGB(200, 0, 0); i.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() _G_LMM_88[key] = not _G_LMM_88[key]; i.BackgroundColor3 = _G_LMM_88[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 0, 0) end)
    _RS.Heartbeat:Connect(function() s.Color = _G_LMM_88[key] and _RGB_CORE.Color or Color3.fromRGB(60,60,60) end)
end

local function _CreateS(name, url, order)
    local b = Instance.new("TextButton", _SF); b.LayoutOrder = order; b.Size = UDim2.new(0.88, 0, 0, 60); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Text = name; b.Font = "GothamBold"; b.TextSize = 14; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    b.Name = "ScriptBtn_" .. name 
    local s = Instance.new("UIStroke", b); s.Thickness = 2.2; 
    b.MouseButton1Click:Connect(function() 
        _ConfirmName.Text = "[" .. name .. "]"
        _CurrentAction = function() loadstring(game:HttpGet(url))() end
        _ConfirmFrame.Visible = true
    end)
    _RS.Heartbeat:Connect(function() s.Color = _RGB_CORE.Color end)
end

-- ==================== [保持原样] 顺位布局集成 (防封安全阈值) ====================
local _In1 = Instance.new("TextBox", _SF); _In1.LayoutOrder = 1; _In1.Size = UDim2.new(0.88, 0, 0, 45); _In1.BackgroundColor3 = Color3.fromRGB(25, 25, 25); _In1.Text = "行走速度: 50"; _In1.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", _In1)
_In1.FocusLost:Connect(function() 
    local rawVal = tonumber(_In1.Text:match("%d+")) or 50
    _G_LMM_88.v_val_1 = math.clamp(rawVal, 16, 110) 
    _In1.Text = "行走速度: ".._G_LMM_88.v_val_1 
end)

local _In2 = Instance.new("TextBox", _SF); _In2.LayoutOrder = 2; _In2.Size = UDim2.new(0.88, 0, 0, 45); _In2.BackgroundColor3 = Color3.fromRGB(25, 25, 25); _In2.Text = "飞行速度: 50"; _In2.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", _In2)
_In2.FocusLost:Connect(function() 
    local rawVal = tonumber(_In2.Text:match("%d+")) or 50
    _G_LMM_88.v_val_2 = math.clamp(rawVal, 0, 220) 
    _In2.Text = "飞行速度: ".._G_LMM_88.v_val_2 
end)

_CreateT("内置透视 (ESP)", "v_0x1", 3); _CreateColorBar("c_esp", 4)
_CreateT("内置ESP射线", "v_esp_line", 5); _CreateColorBar("c_line", 6)
_CreateT("内置ESP方框", "v_esp_box", 7); _CreateColorBar("c_box", 8)
_CreateT("内置穿墙 (NOCLIP)", "v_0x2", 9)
_CreateT("内置速度开关", "v_0x3", 10)
_CreateT("内置飞行开关 (FLY)", "v_0x4", 11)

-- ==================== [保持原样] 搜索栏 ====================
local _SearchBar = Instance.new("TextBox", _SF); _SearchBar.LayoutOrder = 12; _SearchBar.Size = UDim2.new(0.88, 0, 0, 45); _SearchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); _SearchBar.Text = ""; _SearchBar.PlaceholderText = "🔍 搜索脚本..."; _SearchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 150); _SearchBar.TextColor3 = Color3.new(1,1,1); _SearchBar.Font = "GothamBold"; _SearchBar.TextSize = 14; Instance.new("UICorner", _SearchBar)
local _SearchS = Instance.new("UIStroke", _SearchBar); _SearchS.Thickness = 1.5; _RS.Heartbeat:Connect(function() _SearchS.Color = _RGB_CORE.Color end)
_SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(_SearchBar.Text)
    -- 注意：搜索逻辑现在需作用于 _TabMain (也就是 _SF)
    for _, c in pairs(_SF:GetChildren()) do
        if c:IsA("TextButton") and string.match(c.Name, "^ScriptBtn_") then
            c.Visible = (q == "" or string.find(string.lower(c.Text), q) ~= nil)
        end
    end
end)

-- 脚本列表 (保持原样)
_CreateS("AIMBOT", "https://rawscripts.net/raw/Universal-Script-Aimbot-Mobile-34677", 13)
_CreateS("RIVALS NO KEY", "https://raw.githubusercontent.com/idkmsnscriptronlox/Shadow-/refs/heads/main/Shadow", 14)
_CreateS("Infinite Yield (万能脚本)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 15)
_CreateS("Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source", 16)
_CreateS("Owl Hub (极简稳定版)", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt", 17)

-- 【自动连点器 保持原样】
local _ACBtn = Instance.new("TextButton", _SF); _ACBtn.LayoutOrder = 18; _ACBtn.Size = UDim2.new(0.88, 0, 0, 60); _ACBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); _ACBtn.Text = "自动连点器（刘某某）"; _ACBtn.Font = "GothamBold"; _ACBtn.TextSize = 14; _ACBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", _ACBtn)
_ACBtn.Name = "ScriptBtn_自动连点器" 
local _ACS = Instance.new("UIStroke", _ACBtn); _ACS.Thickness = 2; _RS.Heartbeat:Connect(function() _ACS.Color = _RGB_CORE.Color end)
_ACBtn.MouseButton1Click:Connect(function()
    _ConfirmName.Text = "[自动连点器（刘某某）]"
    _CurrentAction = function()
        loadstring([[
            local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
            local MainFrame = Instance.new("Frame", ScreenGui)
            local Title = Instance.new("TextLabel", MainFrame)
            local ToggleBtn = Instance.new("TextButton", MainFrame)
            local SpeedInput = Instance.new("TextBox", MainFrame)
            local MainStroke = Instance.new("UIStroke", MainFrame)
            MainFrame.Size = UDim2.new(0, 200, 0, 160); MainFrame.Position = UDim2.new(0.5, -100, 0.4, -90); MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); MainFrame.Active = true; MainFrame.Draggable = true; Instance.new("UICorner", MainFrame)
            MainStroke.Thickness = 2; MainStroke.ApplyStrokeMode = "Border"
            Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 10, 0, 5); Title.Size = UDim2.new(1, -40, 0, 35); Title.Font = "GothamBold"; Title.Text = "自动连点器 1.2"; Title.TextColor3 = Color3.new(1,1,1); Title.TextSize = 16
            SpeedInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35); SpeedInput.Position = UDim2.new(0.1, 0, 0.3, 5); SpeedInput.Size = UDim2.new(0.8, 0, 0, 35); SpeedInput.Text = "0.05"; SpeedInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SpeedInput)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); ToggleBtn.Position = UDim2.new(0.1, 0, 0.6, 5); ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40); ToggleBtn.Text = "开启连点"; ToggleBtn.TextColor3 = Color3.new(1,1,1); ToggleBtn.Font = "GothamBold"; Instance.new("UICorner", ToggleBtn)
            local clicking = false; local vim = game:GetService("VirtualInputManager")
            ToggleBtn.MouseButton1Click:Connect(function() 
                clicking = not clicking; 
                if clicking then 
                    ToggleBtn.Text = "停止连点"; ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); 
                    task.spawn(function() 
                        while clicking do 
                            vim:SendMouseButtonEvent(0,0,0,true,game,0); 
                            vim:SendMouseButtonEvent(0,0,0,false,game,0); 
                            local waitTime = tonumber(SpeedInput.Text) or 0.05
                            task.wait(waitTime + (math.random(-10, 10)/1000)) 
                        end 
                    end) 
                else ToggleBtn.Text = "开启连点"; ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) end 
            end)
            local Close = Instance.new("TextButton", MainFrame); Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 5); Close.Text = "×"; Close.TextColor3 = Color3.new(1,1,1); Close.BackgroundTransparency = 1; Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
            task.spawn(function() while true do for i = 0, 1, 0.01 do MainStroke.Color = Color3.fromHSV(i, 0.8, 1); task.wait(0.03) end end end)
        ]])()
    end
    _ConfirmFrame.Visible = true
end)

-- 【末尾固定位 保持原样】
local _PH1 = Instance.new("TextButton", _SF); _PH1.LayoutOrder = 19; _PH1.Size = UDim2.new(0.88, 0, 0, 60); _PH1.BackgroundColor3 = Color3.fromRGB(20, 20, 20); _PH1.Text = "等待新脚本填入..."; _PH1.TextColor3 = Color3.new(0.4, 0.4, 0.4); Instance.new("UICorner", _PH1)
local _DCB = Instance.new("TextButton", _SF); _DCB.LayoutOrder = 20; _DCB.Size = UDim2.new(0.88, 0, 0, 60); _DCB.BackgroundColor3 = Color3.fromRGB(88, 101, 242); _DCB.Text = "🔗 JOIN DISCORD 🔗"; _DCB.TextColor3 = Color3.new(1, 1, 1); _DCB.TextScaled = true; Instance.new("UICorner", _DCB)
_DCB.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/cjpezEZub") end)
local _PH2 = Instance.new("TextButton", _SF); _PH2.LayoutOrder = 21; _PH2.Size = UDim2.new(0.88, 0, 0, 60); _PH2.BackgroundColor3 = Color3.fromRGB(20, 20, 20); _PH2.Text = "即将推出..."; _PH2.TextColor3 = Color3.new(0.4, 0.4, 0.4); Instance.new("UICorner", _PH2)
local _Ex = Instance.new("Frame", _SF); _Ex.LayoutOrder = 99; _Ex.Size = UDim2.new(1, 0, 0, 220); _Ex.BackgroundTransparency = 1

-- ==================== [保持原样] 核心驱动 (透视/飞行/速度) ====================
local _BG = Instance.new("BodyGyro"); local _BV = Instance.new("BodyVelocity")
_BG.P = 9e4; _BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); _BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

_RS.Heartbeat:Connect(function()
    _Glow.Color = _RGB_CORE.Color
    -- V3.2 侧边栏按钮同步彩色 (保持高亮)
    _SBtn1S.Color = _RGB_CORE.Color
    _SBtn2S.Color = _RGB_CORE.Color
    _SBtn3S.Color = _RGB_CORE.Color

    local lChar = _LP.Character
    if lChar and lChar:FindFirstChild("HumanoidRootPart") then
        local lHrp = lChar.HumanoidRootPart; local hum = lChar:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = _G_LMM_88.v_0x3 and _G_LMM_88.v_val_1 or 16
            if _G_LMM_88.v_0x2 then for _, p in pairs(lChar:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end end
            if _G_LMM_88.v_0x4 then
                _BG.Parent = lHrp; _BV.Parent = lHrp; _BG.CFrame = _Cam.CFrame
                _BV.Velocity = hum.MoveDirection.Magnitude > 0 and _Cam.CFrame.LookVector * _G_LMM_88.v_val_2 or Vector3.zero
            else _BG.Parent = nil; _BV.Parent = nil end
        end
    end
    -- ESP 处理
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local tChar = p.Character; local tHrp = tChar.HumanoidRootPart
            if _G_LMM_88.v_0x1 then
                local hl = tChar:FindFirstChild("LMM_ESP") or Instance.new("Highlight", tChar); hl.Name = "LMM_ESP"; hl.FillColor = _G_LMM_88.c_esp; hl.Enabled = true
            elseif tChar:FindFirstChild("LMM_ESP") then tChar.LMM_ESP:Destroy() end
            if _G_LMM_88.v_esp_box then
                local bb = tChar:FindFirstChild("LMM_BOX") or Instance.new("BillboardGui", tChar)
                if bb.Name ~= "LMM_BOX" then bb.Name = "LMM_BOX"; bb.AlwaysOnTop = true; bb.Size = UDim2.new(4.5, 0, 6, 0); bb.Adornee = tHrp; local f = Instance.new("Frame", bb); f.Size = UDim2.new(1,0,1,0); f.BackgroundTransparency = 1; local st = Instance.new("UIStroke", f); st.Name = "S"; st.Thickness = 2 end
                bb.Frame.S.Color = _G_LMM_88.c_box; bb.Enabled = true
            elseif tChar:FindFirstChild("LMM_BOX") then tChar.LMM_BOX:Destroy() end
            local beam = tHrp:FindFirstChild("LMM_LINE_FIX")
            if _G_LMM_88.v_esp_line then
                if not beam and lChar and lChar:FindFirstChild("HumanoidRootPart") then
                    beam = Instance.new("Beam", tHrp); beam.Name = "LMM_LINE_FIX"
                    local a0 = lChar.HumanoidRootPart:FindFirstChild("LMM_A0") or Instance.new("Attachment", lChar.HumanoidRootPart); a0.Name = "LMM_A0"
                    beam.Attachment0 = a0; beam.Attachment1 = Instance.new("Attachment", tHrp); beam.Width0 = 0.1; beam.Width1 = 0.1; beam.FaceCamera = true
                end
                if beam then beam.Color = ColorSequence.new(_G_LMM_88.c_line) end
            elseif beam then beam:Destroy() end
        end
    end
end)

-- [窗口/拖动 保持原样]
local function _Ctrl(t, x, c, f)
    local b = Instance.new("TextButton", _TB); b.Size = UDim2.new(0, 32, 0, 32); b.Position = UDim2.new(1, x, 0.5, -16); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.MouseButton1Click:Connect(f)
end
_Ctrl("×", -45, Color3.fromRGB(180, 50, 50), function() _S:Destroy() end)
_Ctrl("—", -90, Color3.fromRGB(50, 50, 50), function() 
    for _, tab in pairs(_Tabs) do tab.Visible = not tab.Visible end -- 同时控制所有选项卡显示
    _M.Size = _TabMain.Visible and UDim2.new(0, 460, 0, 520) or UDim2.new(0, 460, 0, 55)
end)

local _drag, _dStart, _sPos
_TB.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = true; _dStart = i.Position; _sPos = _M.Position end end)
_UIS.InputChanged:Connect(function(i) if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - _dStart; _M.Position = UDim2.new(_sPos.X.Scale, _sPos.X.Offset + d.X, _sPos.Y.Scale, _sPos.Y.Offset + d.Y) end end)
_UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = false end end)
