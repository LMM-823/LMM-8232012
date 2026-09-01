-- [[ 🌚刘某某脚本 V3.9.0 | Core.lua - 核心逻辑模块 ]]

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _UIS = game:GetService("UserInputService")
local _TS = game:GetService("TweenService")
local _CG = game:GetService("CoreGui")
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
    _TS:Create(obj, TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

-- [[ 新增：二次确认弹窗 UI ]]
function Core.ShowConfirm(scriptName, onConfirm)
    local sg = _CG:FindFirstChild("LMM_ConfirmUI") or Instance.new("ScreenGui")
    sg.Name = "LMM_ConfirmUI"
    sg.ResetOnSpawn = false
    pcall(function() sg.Parent = _CG end)
    if not sg.Parent then sg.Parent = _LP:WaitForChild("PlayerGui") end

    if sg:FindFirstChild("Mask") then sg.Mask:Destroy() end

    local mask = Instance.new("Frame", sg)
    mask.Name = "Mask"
    mask.Size = UDim2.new(1, 0, 1, 0)
    mask.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mask.BackgroundTransparency = 1
    mask.ZIndex = 999999

    local box = Instance.new("Frame", mask)
    box.Size = UDim2.new(0, 280, 0, 150)
    box.Position = UDim2.new(0.5, 0, 0.5, 0)
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    box.BorderSizePixel = 0
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", box)
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1.5

    local title = Instance.new("TextLabel", box)
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundTransparency = 1
    title.Text = "🌚 确认开启脚本"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 15
    title.Font = Enum.Font.SourceSansBold

    local desc = Instance.new("TextLabel", box)
    desc.Size = UDim2.new(1, -20, 0, 45)
    desc.Position = UDim2.new(0, 10, 0, 35)
    desc.BackgroundTransparency = 1
    desc.Text = "是否确定加载并运行：\n[" .. tostring(scriptName or "第三方脚本") .. "] ？"
    desc.TextColor3 = Color3.fromRGB(180, 180, 190)
    desc.TextSize = 13
    desc.TextWrapped = true
    desc.Font = Enum.Font.SourceSans

    local btnYes = Instance.new("TextButton", box)
    btnYes.Size = UDim2.new(0.38, 0, 0, 30)
    btnYes.Position = UDim2.new(0.1, 0, 1, -40)
    btnYes.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    btnYes.Text = "确定"
    btnYes.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnYes.Font = Enum.Font.SourceSansBold
    btnYes.TextSize = 14
    Instance.new("UICorner", btnYes).CornerRadius = UDim.new(0, 5)

    local btnNo = Instance.new("TextButton", box)
    btnNo.Size = UDim2.new(0.38, 0, 0, 30)
    btnNo.Position = UDim2.new(0.52, 0, 1, -40)
    btnNo.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btnNo.Text = "取消"
    btnNo.TextColor3 = Color3.fromRGB(200, 200, 200)
    btnNo.Font = Enum.Font.SourceSans
    btnNo.TextSize = 14
    Instance.new("UICorner", btnNo).CornerRadius = UDim.new(0, 5)

    Core.Tween(mask, {BackgroundTransparency = 0.5}, 0.2)

    btnYes.MouseButton1Click:Connect(function()
        Core.Tween(mask, {BackgroundTransparency = 1}, 0.15)
        task.delay(0.15, function()
            mask:Destroy()
            if onConfirm then onConfirm() end
        end)
    end)

    btnNo.MouseButton1Click:Connect(function()
        Core.Tween(mask, {BackgroundTransparency = 1}, 0.15)
        task.delay(0.15, function()
            mask:Destroy()
        end)
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
