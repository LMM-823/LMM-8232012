-- [[ 🌚刘某某脚本🌝 V4.3 - Core.lua (核心与底层逻辑) ]]

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _TS = game:GetService("TweenService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- ==================== 状态容器 ====================
local _G_LMM_88 = {
    v_0x1 = false,
    v_0x2 = false,
    v_0x3 = false,
    v_val_1 = 50,

    v_0x4 = false,
    v_val_2 = 50,

    v_esp_line = false,
    v_esp_box = false,

    v_freeze = false,
    v_infjump = false,

    c_esp = Color3.new(1,0,0),
    c_line = Color3.new(1,0,0),
    c_box = Color3.new(1,0,0)
}

-- ==================== Tween 动画 ====================
local function Tween(obj, props, time, style, dir)
    if not obj then return end
    pcall(function()
        _TS:Create(
            obj,
            TweenInfo.new(
                time or 0.25,
                style or Enum.EasingStyle.Quart,
                dir or Enum.EasingDirection.Out
            ),
            props
        ):Play()
    end)
end

-- ==================== 输入框特效 ====================
local function _DecorateInput(input)
    input.MouseEnter:Connect(function()
        local stroke = input:FindFirstChildOfClass("UIStroke")
        if stroke then Tween(stroke, { Color = Color3.fromRGB(129,140,248) }, 0.2) end
    end)
    input.MouseLeave:Connect(function()
        if not input:IsFocused() then
            local stroke = input:FindFirstChildOfClass("UIStroke")
            if stroke then Tween(stroke, { Color = Color3.fromRGB(38,38,55) }, 0.2) end
        end
    end)
    input.Focused:Connect(function()
        local stroke = input:FindFirstChildOfClass("UIStroke")
        if stroke then Tween(stroke, { Color = Color3.fromRGB(99,102,241) }, 0.2) end
    end)
    input.FocusLost:Connect(function()
        local stroke = input:FindFirstChildOfClass("UIStroke")
        if stroke then Tween(stroke, { Color = Color3.fromRGB(38,38,55) }, 0.2) end
    end)
end

-- ==================== 物理与底层监听 ====================
local _BG = Instance.new("BodyGyro")
local _BV = Instance.new("BodyVelocity")
_BG.P = 9e4
_BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
_BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

-- 无限跳
_UIS.JumpRequest:Connect(function()
    if not _G_LMM_88.v_infjump then return end
    local char = _LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
end)

-- 心跳循环 (速度、冰冻、穿墙、飞行、ESP)
_RS.Heartbeat:Connect(function()
    local char = _LP.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")

        if hrp and hum then
            hum.WalkSpeed = _G_LMM_88.v_0x3 and _G_LMM_88.v_val_1 or 16
            hrp.Anchored = _G_LMM_88.v_freeze

            if _G_LMM_88.v_0x2 then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end

            if _G_LMM_88.v_0x4 then
                _BG.Parent = hrp
                _BV.Parent = hrp
                _BG.CFrame = _Cam.CFrame
                if hum.MoveDirection.Magnitude > 0 then
                    _BV.Velocity = _Cam.CFrame.LookVector * _G_LMM_88.v_val_2
                else
                    _BV.Velocity = Vector3.zero
                end
            else
                _BG.Parent = nil
                _BV.Parent = nil
            end
        end
    end

    -- ESP 循环
    for _, player in ipairs(_P:GetPlayers()) do
        if player ~= _LP then
            local tChar = player.Character
            if tChar then
                local tHrp = tChar:FindFirstChild("HumanoidRootPart")
                if tHrp then
                    -- 高亮
                    if _G_LMM_88.v_0x1 then
                        local hl = tChar:FindFirstChild("LMM_ESP")
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "LMM_ESP"
                            hl.Parent = tChar
                        end
                        hl.FillColor = _G_LMM_88.c_esp
                        hl.Enabled = true
                    else
                        local hl = tChar:FindFirstChild("LMM_ESP")
                        if hl then hl:Destroy() end
                    end

                    -- 方框
                    if _G_LMM_88.v_esp_box then
                        local bb = tChar:FindFirstChild("LMM_BOX")
                        if not bb then
                            bb = Instance.new("BillboardGui")
                            bb.Name = "LMM_BOX"
                            bb.Parent = tChar
                            bb.AlwaysOnTop = true
                            bb.Size = UDim2.new(4.5, 0, 6, 0)
                            bb.Adornee = tHrp
                            local f = Instance.new("Frame")
                            f.Name = "Frame"
                            f.Parent = bb
                            f.Size = UDim2.new(1, 0, 1, 0)
                            f.BackgroundTransparency = 1
                            local st = Instance.new("UIStroke")
                            st.Name = "S"
                            st.Parent = f
                            st.Thickness = 1.5
                        end
                        local frame = bb:FindFirstChild("Frame")
                        local st = frame and frame:FindFirstChild("S")
                        if st then st.Color = _G_LMM_88.c_box end
                        bb.Enabled = true
                    else
                        local bb = tChar:FindFirstChild("LMM_BOX")
                        if bb then bb:Destroy() end
                    end

                    -- 射线
                    local beam = tHrp:FindFirstChild("LMM_LINE_FIX")
                    if _G_LMM_88.v_esp_line then
                        if not beam then
                            local localChar = _LP.Character
                            local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
                            if localHrp then
                                beam = Instance.new("Beam")
                                beam.Name = "LMM_LINE_FIX"
                                beam.Parent = tHrp
                                local a0 = localHrp:FindFirstChild("LMM_A0")
                                if not a0 then
                                    a0 = Instance.new("Attachment")
                                    a0.Name = "LMM_A0"
                                    a0.Parent = localHrp
                                end
                                local a1 = Instance.new("Attachment")
                                a1.Name = "LMM_A1"
                                a1.Parent = tHrp
                                beam.Attachment0 = a0
                                beam.Attachment1 = a1
                                beam.Width0 = 0.08
                                beam.Width1 = 0.08
                                beam.FaceCamera = true
                            end
                        end
                        if beam then beam.Color = ColorSequence.new(_G_LMM_88.c_line) end
                    elseif beam then
                        beam:Destroy()
                    end
                end
            end
        end
    end
end)

-- 返回给 Main 使用的共享表
return {
    Data = _G_LMM_88,
    Tween = Tween,
    DecorateInput = _DecorateInput
}
