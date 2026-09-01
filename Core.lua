-- [[ 🌚刘某某脚本 V4.0.0 | Core.lua - 核心逻辑模块 ]]
-- ===================================================
-- 📅 更新日期：2026年9月1日
-- 📝 更新日志 (V4.0.0)：
-- 1. [版本更新] 将脚本核心版本由 V3.9.0 正式升级至 V4.0.0。
-- 2. [状态扩展] 在全局状态容器 `_G_LMM_88` 中新增 `c_ui` 颜色属性。
-- 3. [新增功能] 在底部设定模块增加更换 UI 颜色接口 (`Core.SetUIColor`)。
-- ===================================================

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _UIS = game:GetService("UserInputService")
local _TS = game:GetService("TweenService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- 全局状态容器 (已在最下方加入 c_ui 颜色选项)
getgenv()._G_LMM_88 = { 
    v_0x1 = false, v_0x2 = false, v_0x3 = false, v_val_1 = 50, 
    v_0x4 = false, v_val_2 = 50, v_esp_line = false, v_esp_box = false,
    v_freeze = false, v_infjump = false,
    c_esp = Color3.new(1,0,0), c_line = Color3.new(1,0,0), c_box = Color3.new(1,0,0),
    c_ui = Color3.fromRGB(0, 120, 215) -- 【V4.0.0新增】默认 UI 颜色
}

local Core = {}

-- 动画辅助函数
function Core.Tween(obj, props, time, style, dir)
    if not obj then return end
    _TS:Create(obj, TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

-- 【V4.0.0新增】设定界面最下方调用的换 UI 颜色函数
function Core.SetUIColor(newColor)
    if typeof(newColor) == "Color3" then
        getgenv()._G_LMM_88.c_ui = newColor
        if getgenv().LMM_UI_ColorChanged and typeof(getgenv().LMM_UI_ColorChanged) == "function" then
            getgenv().LMM_UI_ColorChanged(newColor)
        end
    end
end

-- 无限跳逻辑监听
_UIS.JumpRequest:Connect(function()
    if getgenv()._G_LMM_88 and getgenv()._G_LMM_88.v_infjump then
        local lChar = _LP.Character
        if lChar and lChar:FindFirstChildOfClass("Humanoid") then
            lChar:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 底层运行驱动 (Speed / Fly / Noclip / Freeze / ESP)
local _BG = Instance.new("BodyGyro")
local _BV = Instance.new("BodyVelocity")
_BG.P = 9e4
_BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
_BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

_RS.Heartbeat:Connect(function()
    local state = getgenv()._G_LMM_88
    if not state then return end

    local lChar = _LP.Character
    if lChar and lChar:FindFirstChild("HumanoidRootPart") then
        local lHrp = lChar.HumanoidRootPart
        local hum = lChar:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = state.v_0x3 and state.v_val_1 or 16
            lHrp.Anchored = state.v_freeze

            if state.v_0x2 then 
                for _, p in pairs(lChar:GetChildren()) do 
                    if p:IsA("BasePart") then p.CanCollide = false end 
                end 
            end

            if state.v_0x4 then
                _BG.Parent = lHrp
                _BV.Parent = lHrp
                _BG.CFrame = _Cam.CFrame
                _BV.Velocity = hum.MoveDirection.Magnitude > 0 and _Cam.CFrame.LookVector * state.v_val_2 or Vector3.zero
            else 
                _BG.Parent = nil
                _BV.Parent = nil 
            end
        end
    end

    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local tChar = p.Character
            local tHrp = tChar.HumanoidRootPart

            -- ESP Highlight
            if state.v_0x1 then
                local hl = tChar:FindFirstChild("LMM_ESP") or Instance.new("Highlight", tChar)
                hl.Name = "LMM_ESP"
                hl.FillColor = state.c_esp
                hl.Enabled = true
            elseif tChar:FindFirstChild("LMM_ESP") then 
                tChar.LMM_ESP:Destroy() 
            end

            -- ESP Box
            if state.v_esp_box then
                local bb = tChar:FindFirstChild("LMM_BOX") or Instance.new("BillboardGui", tChar)
                if bb.Name ~= "LMM_BOX" then 
                    bb.Name = "LMM_BOX"
                    bb.AlwaysOnTop = true
                    bb.Size = UDim2.new(4.5, 0, 6, 0)
                    bb.Adornee = tHrp
                    local f = Instance.new("Frame", bb)
                    f.Size = UDim2.new(1,0,1,0)
                    f.BackgroundTransparency = 1
                    local st = Instance.new("UIStroke", f)
                    st.Name = "S"
                    st.Thickness = 1.5 
                end
                bb.Frame.S.Color = state.c_box
                bb.Enabled = true
            elseif tChar:FindFirstChild("LMM_BOX") then 
                tChar.LMM_BOX:Destroy() 
            end

            -- ESP Line
            local beam = tHrp:FindFirstChild("LMM_LINE_FIX")
            if state.v_esp_line then
                if not beam and lChar and lChar:FindFirstChild("HumanoidRootPart") then
                    beam = Instance.new("Beam", tHrp)
                    beam.Name = "LMM_LINE_FIX"
                    local a0 = lChar.HumanoidRootPart:FindFirstChild("LMM_A0") or Instance.new("Attachment", lChar.HumanoidRootPart)
                    a0.Name = "LMM_A0"
                    beam.Attachment0 = a0
                    beam.Attachment1 = Instance.new("Attachment", tHrp)
                    beam.Width0 = 0.08
                    beam.Width1 = 0.08
                    beam.FaceCamera = true
                end
                if beam then beam.Color = ColorSequence.new(state.c_line) end
            elseif beam then 
                beam:Destroy() 
            end
        end
    end
end)

getgenv().LMM_Core = Core
return Core
