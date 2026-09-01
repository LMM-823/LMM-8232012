-- [[ 🌚刘某某脚本 V3.9.0 | Core.lua - 核心逻辑模块 ]]

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _UIS = game:GetService("UserInputService")
local _TS = game:GetService("TweenService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- 全局状态容器
getgenv()._G_LMM_88 = { 
    v_0x1 = false, v_0x2 = false, v_0x3 = false, v_val_1 = 50, 
    v_0x4 = false, v_val_2 = 50, v_esp_line = false, v_esp_box = false,
    v_freeze = false, v_infjump = false,
    c_esp = Color3.new(1,0,0), c_line = Color3.new(1,0,0), c_box = Color3.new(1,0,0)
}

local Core = {}

-- 动画辅助函数
function Core.Tween(obj, props, time, style, dir)
    if not obj then return end
    local tween = _TS:Create(obj, TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

-- 二次确认弹窗 UI
function Core.ShowConfirm(title, desc, onConfirm)
    local parentGui = _LP:WaitForChild("PlayerGui"):FindFirstChildOfClass("ScreenGui")
    if not parentGui then return end

    -- 背景遮罩
    local mask = Instance.new("Frame")
    mask.Name = "LMM_ConfirmMask"
    mask.Size = UDim2.new(1, 0, 1, 0)
    mask.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mask.BackgroundTransparency = 1
    mask.ZIndex = 999
    mask.Parent = parentGui

    -- 弹窗卡片
    local box = Instance.new("Frame")
    box.Name = "ConfirmBox"
    box.Size = UDim2.new(0, 320, 0, 180)
    box.Position = UDim2.new(0.5, 0, 0.5, 0)
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    box.BorderSizePixel = 0
    box.Parent = mask

    local corner = Instance.new("UICorner", box)
    corner.CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", box)
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1.5

    -- 标题
    local titleLbl = Instance.new("TextLabel", box)
    titleLbl.Size = UDim2.new(1, -20, 0, 30)
    titleLbl.Position = UDim2.new(0, 10, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title or "提示"
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.TextSize = 18
    titleLbl.Font = Enum.Font.SourceSansBold

    -- 内容文本
    local descLbl = Instance.new("TextLabel", box)
    descLbl.Size = UDim2.new(1, -20, 0, 60)
    descLbl.Position = UDim2.new(0, 10, 0, 45)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = desc or "是否确定执行此脚本？"
    descLbl.TextColor3 = Color3.fromRGB(180, 180, 190)
    descLbl.TextSize = 14
    descLbl.TextWrapped = true
    descLbl.Font = Enum.Font.SourceSans

    -- 确认按钮
    local btnYes = Instance.new("TextButton", box)
    btnYes.Size = UDim2.new(0.4, 0, 0, 35)
    btnYes.Position = UDim2.new(0.1, 0, 1, -45)
    btnYes.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    btnYes.Text = "确定"
    btnYes.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnYes.Font = Enum.Font.SourceSansBold
    btnYes.TextSize = 15
    Instance.new("UICorner", btnYes).CornerRadius = UDim.new(0, 6)

    -- 取消按钮
    local btnNo = Instance.new("TextButton", box)
    btnNo.Size = UDim2.new(0.4, 0, 0, 35)
    btnNo.Position = UDim2.new(0.5, 0, 1, -45)
    btnNo.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btnNo.Text = "取消"
    btnNo.TextColor3 = Color3.fromRGB(200, 200, 200)
    btnNo.Font = Enum.Font.SourceSans
    btnNo.TextSize = 15
    Instance.new("UICorner", btnNo).CornerRadius = UDim.new(0, 6)

    -- 入场淡入动画
    Core.Tween(mask, {BackgroundTransparency = 0.5}, 0.2)
    box.Size = UDim2.new(0, 0, 0, 0)
    Core.Tween(box, {Size = UDim2.new(0, 320, 0, 180)}, 0.2, Enum.EasingStyle.Back)

    -- 关闭弹窗动画
    local function closeBox()
        Core.Tween(mask, {BackgroundTransparency = 1}, 0.15)
        Core.Tween(box, {Size = UDim2.new(0, 0, 0, 0)}, 0.15).Completed:Connect(function()
            mask:Destroy()
        end)
    end

    btnYes.MouseButton1Click:Connect(function()
        closeBox()
        if onConfirm then onConfirm() end
    end)

    btnNo.MouseButton1Click:Connect(function()
        closeBox()
    end)
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
