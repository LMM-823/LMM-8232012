-- [[ 🌚刘某某脚本🌝 V4.2 | Core ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Core = {}

Core.State = nil

-- =========================
-- 无限跳
-- =========================

UserInputService.JumpRequest:Connect(function()
    if not Core.State then
        return
    end

    if Core.State.v_infjump then
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- =========================
-- 飞行组件
-- =========================

local BodyGyro = Instance.new("BodyGyro")
local BodyVelocity = Instance.new("BodyVelocity")

BodyGyro.P = 9e4
BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

-- =========================
-- 主运行
-- =========================

RunService.Heartbeat:Connect(function()
    local State = Core.State

    if not State then
        return
    end

    local Character = LocalPlayer.Character
    if not Character then
        return
    end

    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not RootPart or not Humanoid then
        return
    end

    -- 速度
    if State.v_0x3 then
        Humanoid.WalkSpeed = State.v_val_1
    else
        Humanoid.WalkSpeed = 16
    end

    -- Freeze
    if State.v_freeze then
        RootPart.Anchored = true
    else
        RootPart.Anchored = false
    end

    -- Noclip
    if State.v_0x2 then
        for _, Part in ipairs(Character:GetChildren()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = false
            end
        end
    end

    -- Fly
    if State.v_0x4 then
        BodyGyro.Parent = RootPart
        BodyVelocity.Parent = RootPart

        BodyGyro.CFrame = Camera.CFrame

        if Humanoid.MoveDirection.Magnitude > 0 then
            BodyVelocity.Velocity =
                Camera.CFrame.LookVector * State.v_val_2
        else
            BodyVelocity.Velocity = Vector3.zero
        end
    else
        BodyGyro.Parent = nil
        BodyVelocity.Parent = nil
    end

    -- =========================
    -- ESP
    -- =========================

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Target = Player.Character
            local TargetRoot =
                Target and Target:FindFirstChild("HumanoidRootPart")

            if Target and TargetRoot then

                -- Highlight
                if State.v_0x1 then
                    local Highlight =
                        Target:FindFirstChild("LMM_ESP")

                    if not Highlight then
                        Highlight = Instance.new("Highlight")
                        Highlight.Name = "LMM_ESP"
                        Highlight.Parent = Target
                    end

                    Highlight.FillColor = State.c_esp
                    Highlight.Enabled = true

                else
                    local Highlight =
                        Target:FindFirstChild("LMM_ESP")

                    if Highlight then
                        Highlight:Destroy()
                    end
                end

                -- ESP Box
                if State.v_esp_box then
                    local Box =
                        Target:FindFirstChild("LMM_BOX")

                    if not Box then
                        Box = Instance.new("BillboardGui")
                        Box.Name = "LMM_BOX"
                        Box.AlwaysOnTop = true
                        Box.Size = UDim2.new(4.5, 0, 6, 0)
                        Box.Adornee = TargetRoot
                        Box.Parent = Target

                        local Frame = Instance.new("Frame")
                        Frame.Size = UDim2.new(1, 0, 1, 0)
                        Frame.BackgroundTransparency = 1
                        Frame.Parent = Box

                        local Stroke = Instance.new("UIStroke")
                        Stroke.Name = "S"
                        Stroke.Thickness = 1.5
                        Stroke.Parent = Frame
                    end

                    Box.Frame.S.Color = State.c_box
                    Box.Enabled = true

                else
                    local Box =
                        Target:FindFirstChild("LMM_BOX")

                    if Box then
                        Box:Destroy()
                    end
                end

                -- ESP Line
                local Beam =
                    TargetRoot:FindFirstChild("LMM_LINE_FIX")

                if State.v_esp_line then
                    if not Beam then
                        local LocalRoot =
                            Character:FindFirstChild("HumanoidRootPart")

                        if LocalRoot then
                            Beam = Instance.new("Beam")
                            Beam.Name = "LMM_LINE_FIX"

                            local A0 =
                                LocalRoot:FindFirstChild("LMM_A0")

                            if not A0 then
                                A0 = Instance.new("Attachment")
                                A0.Name = "LMM_A0"
                                A0.Parent = LocalRoot
                            end

                            local A1 = Instance.new("Attachment")
                            A1.Parent = TargetRoot

                            Beam.Attachment0 = A0
                            Beam.Attachment1 = A1
                            Beam.Width0 = 0.08
                            Beam.Width1 = 0.08
                            Beam.FaceCamera = true
                            Beam.Parent = TargetRoot
                        end
                    end

                    if Beam then
                        Beam.Color =
                            ColorSequence.new(State.c_line)
                    end

                elseif Beam then
                    Beam:Destroy()
                end
            end
        end
    end
end)

return Core