-- [[ 刘某某脚本 V4.2.50 (beta) | 顶部胶囊半透明 + 加载动画仅保留一个音效 ]]

local function _LMM_BOOT()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    local _P = game:GetService("Players")
    local _RS = game:GetService("RunService")
    local _CG = game:GetService("CoreGui")
    local _UIS = game:GetService("UserInputService")
    local _TS = game:GetService("TweenService")
    local _MP = game:GetService("MarketplaceService")
    local _Lighting = game:GetService("Lighting")
    local _SS = game:GetService("SoundService")

    local _LP = _P.LocalPlayer
    while not _LP do
        task.wait(0.1)
        _LP = _P.LocalPlayer
    end
    local _Cam = workspace.CurrentCamera

    local _G_LMM_88 = { 
        v_0x1 = false, v_0x2 = false, v_0x3 = false, v_val_1 = 50, 
        v_0x4 = false, v_val_2 = 50, v_esp_line = false, v_esp_box = false,
        v_freeze = false, v_infjump = false,
        c_esp = Color3.fromRGB(99, 102, 241), c_line = Color3.fromRGB(99, 102, 241), c_box = Color3.fromRGB(99, 102, 241)
    }

    local function Tween(obj, props, time, style, dir)
        if not obj then return end
        _TS:Create(obj, TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
    end

    local function ApplyAccentGradient(parent, c1, c2, rot)
        local g = Instance.new("UIGradient", parent)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1 or Color3.fromRGB(129, 140, 248)),
            ColorSequenceKeypoint.new(1, c2 or Color3.fromRGB(192, 132, 252))
        })
        g.Rotation = rot or 35
        return g
    end

    local function WaitExact(seconds)
        local deadline = os.clock() + seconds
        while os.clock() < deadline do
            task.wait(0.05)
        end
    end

    -- ==================== 音效播放系统 ====================
    local SoundIds = {
        open = "rbxassetid://6026984224",
        click = "rbxassetid://6895079853",
        close = "rbxassetid://421058925"
    }

    local function PlaySound(soundType)
        pcall(function()
            local id = SoundIds[soundType] or SoundIds.click
            local s = Instance.new("Sound")
            s.SoundId = id
            s.Volume = (soundType == "open") and 0.75 or 0.55
            s.PlayOnRemove = false
            s.Parent = _SS
            s:Play()
            s.Ended:Connect(function()
                s:Destroy()
            end)
            task.delay(3, function()
                if s and s.Parent then
                    s:Destroy()
                end
            end)
        end)
    end

    if _CG:FindFirstChild("LMM_Final_V400") then _CG.LMM_Final_V400:Destroy() end
    local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V400"
    _S.ResetOnSpawn = false
    _S.DisplayOrder = 9999
    _S.IgnoreGuiInset = true

    -- ==================== 右下角通知管理 ====================
    local activeNotifications = {}

    local function UpdateNotificationPositions()
        for i, cardData in ipairs(activeNotifications) do
            local targetY = -92 - ((i - 1) * 82)
            Tween(cardData.Card, {Position = UDim2.new(1, -284, 1, targetY)}, 0.3)
        end
    end

    local function ShowNotification(title, desc, duration)
        local totalTime = duration or 3.0
        local notifGui = Instance.new("ScreenGui", _CG)
        notifGui.Name = "LMM_Notification"
        notifGui.ResetOnSpawn = false
        notifGui.DisplayOrder = 2147483647
        notifGui.IgnoreGuiInset = true

        local card = Instance.new("Frame", notifGui)
        card.Size = UDim2.new(0, 270, 0, 72)
        card.Position = UDim2.new(1, 290, 1, -92)
        card.BackgroundColor3 = Color3.fromRGB(14, 15, 25)
        card.BackgroundTransparency = 0.06
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.ZIndex = 10000000
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Thickness = 1.25
        cardStroke.Color = Color3.fromRGB(129, 140, 248)
        cardStroke.Transparency = 0.36
        ApplyAccentGradient(cardStroke)

        local accentBar = Instance.new("Frame", card)
        accentBar.Size = UDim2.new(0, 3.5, 0, 40)
        accentBar.Position = UDim2.new(0, 10, 0, 12)
        accentBar.BackgroundColor3 = Color3.fromRGB(129, 140, 248)
        accentBar.BorderSizePixel = 0
        accentBar.ZIndex = 10000001
        Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)
        ApplyAccentGradient(accentBar, Color3.fromRGB(129, 140, 248), Color3.fromRGB(192, 132, 252), 90)

        local titleLbl = Instance.new("TextLabel", card)
        titleLbl.Size = UDim2.new(1, -82, 0, 20)
        titleLbl.Position = UDim2.new(0, 22, 0, 10)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = title
        titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 13
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.ZIndex = 10000001

        local timerBadge = Instance.new("TextLabel", card)
        timerBadge.Size = UDim2.new(0, 46, 0, 19)
        timerBadge.Position = UDim2.new(1, -56, 0, 11)
        timerBadge.BackgroundColor3 = Color3.fromRGB(30, 33, 56)
        timerBadge.BackgroundTransparency = 0.15
        timerBadge.Text = string.format("%.1fs", totalTime)
        timerBadge.TextColor3 = Color3.fromRGB(196, 181, 253)
        timerBadge.Font = Enum.Font.GothamBold
        timerBadge.TextSize = 10.5
        timerBadge.ZIndex = 10000002
        Instance.new("UICorner", timerBadge).CornerRadius = UDim.new(0, 6)

        local descLbl = Instance.new("TextLabel", card)
        descLbl.Size = UDim2.new(1, -32, 0, 20)
        descLbl.Position = UDim2.new(0, 22, 0, 33)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = desc
        descLbl.TextColor3 = Color3.fromRGB(185, 190, 220)
        descLbl.Font = Enum.Font.GothamMedium
        descLbl.TextSize = 11
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.TextTruncate = Enum.TextTruncate.AtEnd
        descLbl.ZIndex = 10000001

        local progressTrack = Instance.new("Frame", card)
        progressTrack.Size = UDim2.new(1, 0, 0, 3.5)
        progressTrack.Position = UDim2.new(0, 0, 1, -3.5)
        progressTrack.BackgroundColor3 = Color3.fromRGB(28, 30, 48)
        progressTrack.BorderSizePixel = 0
        progressTrack.ZIndex = 10000001

        local progressFill = Instance.new("Frame", progressTrack)
        progressFill.Size = UDim2.new(1, 0, 1, 0)
        progressFill.Position = UDim2.new(0, 0, 0, 0)
        progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        progressFill.BorderSizePixel = 0
        progressFill.ZIndex = 10000002
        ApplyAccentGradient(progressFill, Color3.fromRGB(99, 102, 241), Color3.fromRGB(192, 132, 252), 0)

        local notifData = {Card = card, Gui = notifGui}
        table.insert(activeNotifications, 1, notifData)
        UpdateNotificationPositions()

        Tween(progressFill, {Size = UDim2.new(0, 0, 1, 0)}, totalTime, Enum.EasingStyle.Linear)

        task.spawn(function()
            local startClock = os.clock()
            while true do
                local elapsed = os.clock() - startClock
                local remain = math.max(0, totalTime - elapsed)
                if timerBadge and timerBadge.Parent then
                    timerBadge.Text = string.format("%.1fs", remain)
                    if remain <= 0.8 then
                        timerBadge.TextColor3 = Color3.fromRGB(251, 113, 133)
                    end
                end
                if remain <= 0 then
                    break
                end
                task.wait(0.05)
            end

            for idx, item in ipairs(activeNotifications) do
                if item == notifData then
                    table.remove(activeNotifications, idx)
                    break
                end
            end
            UpdateNotificationPositions()
            Tween(card, {Position = UDim2.new(1, 290, 1, card.Position.Y.Offset)}, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.28)
            pcall(function() notifGui:Destroy() end)
        end)
    end

    -- ==================== 初始加载界面（动画1） ====================
    local blurEffect = Instance.new("BlurEffect", _Lighting)
    blurEffect.Size = 18

    local _LoadGui = Instance.new("Frame", _S)
    _LoadGui.Size = UDim2.new(2, 0, 2, 0)
    _LoadGui.Position = UDim2.new(-0.5, 0, -0.5, 0)
    _LoadGui.BackgroundColor3 = Color3.fromRGB(8, 9, 15)
    _LoadGui.BackgroundTransparency = 0.28
    _LoadGui.BorderSizePixel = 0
    _LoadGui.ZIndex = 999999

    local _CenterCard = Instance.new("Frame", _LoadGui)
    _CenterCard.Size = UDim2.new(0, 420, 0, 178)
    _CenterCard.Position = UDim2.new(0.5, -210, 0.5, -89)
    _CenterCard.BackgroundColor3 = Color3.fromRGB(13, 14, 24)
    _CenterCard.BackgroundTransparency = 0.05
    _CenterCard.BorderSizePixel = 0
    _CenterCard.ClipsDescendants = true
    _CenterCard.ZIndex = 1000000
    Instance.new("UICorner", _CenterCard).CornerRadius = UDim.new(0, 22)

    local _CenterStroke = Instance.new("UIStroke", _CenterCard)
    _CenterStroke.Thickness = 1.6
    _CenterStroke.Color = Color3.fromRGB(255, 255, 255)
    _CenterStroke.Transparency = 0.22
    ApplyAccentGradient(_CenterStroke)

    local _LoadText = Instance.new("TextLabel", _CenterCard)
    _LoadText.Size = UDim2.new(1, -32, 0, 28)
    _LoadText.Position = UDim2.new(0, 16, 0, 24)
    _LoadText.BackgroundTransparency = 1
    _LoadText.Text = "刘某某脚本 V4.2.50 (beta)"
    _LoadText.TextColor3 = Color3.fromRGB(255, 255, 255)
    _LoadText.Font = Enum.Font.GothamBold
    _LoadText.TextSize = 17
    _LoadText.TextXAlignment = Enum.TextXAlignment.Center
    _LoadText.ZIndex = 1000001

    local _LoadSubText = Instance.new("TextLabel", _CenterCard)
    _LoadSubText.Size = UDim2.new(1, -32, 0, 18)
    _LoadSubText.Position = UDim2.new(0, 16, 0, 52)
    _LoadSubText.BackgroundTransparency = 1
    _LoadSubText.Text = "正在初始化组件与界面资源..."
    _LoadSubText.TextColor3 = Color3.fromRGB(165, 174, 224)
    _LoadSubText.Font = Enum.Font.GothamMedium
    _LoadSubText.TextSize = 11.5
    _LoadSubText.TextXAlignment = Enum.TextXAlignment.Center
    _LoadSubText.ZIndex = 1000001

    local _BarBg = Instance.new("Frame", _CenterCard)
    _BarBg.Size = UDim2.new(0.84, 0, 0, 11)
    _BarBg.Position = UDim2.new(0.08, 0, 0, 88)
    _BarBg.BackgroundColor3 = Color3.fromRGB(22, 24, 40)
    _BarBg.BorderSizePixel = 0
    _BarBg.ClipsDescendants = true
    _BarBg.ZIndex = 1000001
    Instance.new("UICorner", _BarBg).CornerRadius = UDim.new(1, 0)
    local _BarBgStroke = Instance.new("UIStroke", _BarBg)
    _BarBgStroke.Thickness = 1
    _BarBgStroke.Color = Color3.fromRGB(95, 102, 155)
    _BarBgStroke.Transparency = 0.55

    local _BarFill = Instance.new("Frame", _BarBg)
    _BarFill.Size = UDim2.new(0, 0, 1, 0)
    _BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _BarFill.BorderSizePixel = 0
    _BarFill.ClipsDescendants = true
    _BarFill.ZIndex = 1000002
    Instance.new("UICorner", _BarFill).CornerRadius = UDim.new(1, 0)
    ApplyAccentGradient(_BarFill, Color3.fromRGB(99, 102, 241), Color3.fromRGB(192, 132, 252), 0)

    local _BarShine = Instance.new("Frame", _BarFill)
    _BarShine.Size = UDim2.new(0, 36, 1, 0)
    _BarShine.Position = UDim2.new(-0.2, 0, 0, 0)
    _BarShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _BarShine.BackgroundTransparency = 0.65
    _BarShine.BorderSizePixel = 0
    _BarShine.ZIndex = 1000003
    Instance.new("UICorner", _BarShine).CornerRadius = UDim.new(1, 0)

    local _PercentText = Instance.new("TextLabel", _CenterCard)
    _PercentText.Size = UDim2.new(1, 0, 0, 24)
    _PercentText.Position = UDim2.new(0, 0, 0, 118)
    _PercentText.BackgroundTransparency = 1
    _PercentText.Text = "0%"
    _PercentText.TextColor3 = Color3.fromRGB(196, 202, 240)
    _PercentText.Font = Enum.Font.GothamBold
    _PercentText.TextSize = 12.5
    _PercentText.TextXAlignment = Enum.TextXAlignment.Center
    _PercentText.ZIndex = 1000001

    -- ==================== 主界面容器（背景更清晰可见） ====================
    local _M = Instance.new("Frame", _S)
    _M.Size = UDim2.new(0, 628, 0, 410); _M.Position = UDim2.new(0.5, -314, 0.5, -205)
    _M.BackgroundColor3 = Color3.fromRGB(14, 16, 28); _M.BackgroundTransparency = 0.56; _M.BorderSizePixel = 0; _M.Visible = false
    _M.ClipsDescendants = true
    Instance.new("UICorner", _M).CornerRadius = UDim.new(0, 22)

    local _MainStroke = Instance.new("UIStroke", _M)
    _MainStroke.Thickness = 2.4
    _MainStroke.Color = Color3.fromRGB(255, 255, 255)
    _MainStroke.Transparency = 0.06
    _MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local _MainBorderGrad = Instance.new("UIGradient", _MainStroke)
    _MainBorderGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(99, 102, 241)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(217, 70, 239)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(56, 189, 248)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(99, 102, 241))
    })
    _MainBorderGrad.Rotation = 0

    local _BgImage = Instance.new("ImageLabel", _M)
    _BgImage.Size = UDim2.new(1, 0, 1, 0); _BgImage.BackgroundTransparency = 1; _BgImage.BorderSizePixel = 0
    _BgImage.Image = "rbxassetid://5430597512"; _BgImage.ImageTransparency = 0; _BgImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
    _BgImage.ScaleType = Enum.ScaleType.Crop; _BgImage.ZIndex = 0
    Instance.new("UICorner", _BgImage).CornerRadius = UDim.new(0, 22)

    local _PanelShade = Instance.new("Frame", _M)
    _PanelShade.Size = UDim2.new(1, 0, 1, 0)
    _PanelShade.Position = UDim2.new(0, 0, 0, 0)
    _PanelShade.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _PanelShade.BackgroundTransparency = 0.72
    _PanelShade.BorderSizePixel = 0
    _PanelShade.ZIndex = 1
    Instance.new("UICorner", _PanelShade).CornerRadius = UDim.new(0, 22)
    local _ShadeGrad = Instance.new("UIGradient", _PanelShade)
    _ShadeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 28, 52)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(16, 18, 34)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(36, 22, 58))
    })
    _ShadeGrad.Rotation = 135

    -- ==================== 顶部中央可拖动胶囊开关（透明一半 + 明亮渐变流动） ====================
    local _TopCapsule = Instance.new("TextButton", _S)
    _TopCapsule.Name = "LMM_Top_Toggle_Capsule"
    _TopCapsule.Size = UDim2.new(0, 214, 0, 35)
    _TopCapsule.Position = UDim2.new(0.5, -107, 0, 12)
    _TopCapsule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _TopCapsule.BackgroundTransparency = 0.5
    _TopCapsule.BorderSizePixel = 0
    _TopCapsule.Text = ""
    _TopCapsule.AutoButtonColor = false
    _TopCapsule.Visible = false
    _TopCapsule.ZIndex = 50
    Instance.new("UICorner", _TopCapsule).CornerRadius = UDim.new(1, 0)

    local _TopCapBgGrad = Instance.new("UIGradient", _TopCapsule)
    _TopCapBgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(99, 102, 241)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(236, 72, 153)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(34, 211, 238))
    })
    _TopCapBgGrad.Rotation = 0

    local _TopCapStroke = Instance.new("UIStroke", _TopCapsule)
    _TopCapStroke.Thickness = 2.0
    _TopCapStroke.Color = Color3.fromRGB(255, 255, 255)
    _TopCapStroke.Transparency = 0.04

    local _TopCapBorderGrad = Instance.new("UIGradient", _TopCapStroke)
    _TopCapBorderGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(165, 180, 252)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(244, 114, 182)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(103, 232, 249)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(165, 180, 252))
    })
    _TopCapBorderGrad.Rotation = 0

    task.spawn(function()
        local rot = 0
        while _S and _S.Parent do
            rot = (rot + 2.6) % 360
            if _MainBorderGrad and _MainBorderGrad.Parent then
                _MainBorderGrad.Rotation = rot
            end
            if _TopCapBorderGrad and _TopCapBorderGrad.Parent then
                _TopCapBorderGrad.Rotation = rot
            end
            if _TopCapBgGrad and _TopCapBgGrad.Parent then
                _TopCapBgGrad.Rotation = (rot * 0.85) % 360
            end
            task.wait(0.025)
        end
    end)

    local _TopCapIcon = Instance.new("Frame", _TopCapsule)
    _TopCapIcon.Size = UDim2.new(0, 23, 0, 23)
    _TopCapIcon.Position = UDim2.new(0, 6, 0.5, -11.5)
    _TopCapIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _TopCapIcon.BorderSizePixel = 0
    _TopCapIcon.ZIndex = 51
    Instance.new("UICorner", _TopCapIcon).CornerRadius = UDim.new(0, 8)
    ApplyAccentGradient(_TopCapIcon, Color3.fromRGB(129, 140, 248), Color3.fromRGB(244, 114, 182), 45)

    local _TopCapLetter = Instance.new("TextLabel", _TopCapIcon)
    _TopCapLetter.Size = UDim2.new(1, 0, 1, 0)
    _TopCapLetter.BackgroundTransparency = 1
    _TopCapLetter.Text = "L"
    _TopCapLetter.TextColor3 = Color3.fromRGB(255, 255, 255)
    _TopCapLetter.Font = Enum.Font.GothamBold
    _TopCapLetter.TextSize = 12.5
    _TopCapLetter.ZIndex = 52

    local _TopCapText = Instance.new("TextLabel", _TopCapsule)
    _TopCapText.Size = UDim2.new(1, -36, 1, 0)
    _TopCapText.Position = UDim2.new(0, 34, 0, 0)
    _TopCapText.BackgroundTransparency = 1
    _TopCapText.Text = "FPS:60 | Ping:0 | 0M"
    _TopCapText.TextColor3 = Color3.fromRGB(255, 255, 255)
    _TopCapText.TextStrokeColor3 = Color3.fromRGB(15, 18, 42)
    _TopCapText.TextStrokeTransparency = 0.35
    _TopCapText.Font = Enum.Font.GothamBold
    _TopCapText.TextSize = 10.5
    _TopCapText.TextXAlignment = Enum.TextXAlignment.Left
    _TopCapText.ZIndex = 51

    task.spawn(function()
        local lastUpdate = 0
        local frameCount = 0
        local fps = 60
        _RS.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            if tick() - lastUpdate >= 0.5 then
                fps = math.floor(frameCount / (tick() - lastUpdate))
                frameCount = 0
                lastUpdate = tick()
            end
            pcall(function()
                local ping = math.floor(_LP:GetNetworkPing() * 1000 + 0.5)
                local mem = math.floor(collectgarbage("count") / 1024)
                _TopCapText.Text = string.format("FPS:%d | Ping:%d | %dM", fps, ping, mem)
            end)
        end)
    end)

    local normalHeight = 410
    local _Sidebar, _ContentContainer, _HeaderLine, _SplitLine, _Resizer, _Title

    local function ToggleMainUI()
        local isOpen = _M.Visible
        if isOpen then
            _M.Visible = false
        else
            if _Sidebar then _Sidebar.Visible = true end
            if _ContentContainer then _ContentContainer.Visible = true end
            if _HeaderLine then _HeaderLine.Visible = true end
            if _SplitLine then _SplitLine.Visible = true end
            if _BgImage then _BgImage.Visible = true end
            if _PanelShade then _PanelShade.Visible = true end
            if _Resizer then _Resizer.Visible = true end
            if _Title then _Title.Visible = true end
            _M.Visible = true
            _M.Size = UDim2.new(0, 565, 0, 369)
            Tween(_M, {Size = UDim2.new(0, 628, 0, normalHeight)}, 0.32, Enum.EasingStyle.Back)
        end
    end

    local capDragging, capDragStart, capStartPos, capMoved = false, nil, nil, false
    _TopCapsule.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            capDragging = true
            capMoved = false
            capDragStart = i.Position
            capStartPos = _TopCapsule.Position
        end
    end)
    _UIS.InputChanged:Connect(function(i)
        if capDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - capDragStart
            if delta.Magnitude > 5 then
                capMoved = true
            end
            _TopCapsule.Position = UDim2.new(capStartPos.X.Scale, capStartPos.X.Offset + delta.X, capStartPos.Y.Scale, capStartPos.Y.Offset + delta.Y)
        end
    end)
    _UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            capDragging = false
        end
    end)
    _TopCapsule.MouseEnter:Connect(function()
        Tween(_TopCapsule, {BackgroundTransparency = 0.38}, 0.15)
        Tween(_TopCapStroke, {Thickness = 2.3, Transparency = 0.0}, 0.15)
    end)
    _TopCapsule.MouseLeave:Connect(function()
        Tween(_TopCapsule, {BackgroundTransparency = 0.5}, 0.15)
        Tween(_TopCapStroke, {Thickness = 2.0, Transparency = 0.04}, 0.15)
    end)
    _TopCapsule.MouseButton1Click:Connect(function()
        if capMoved then return end
        PlaySound("click")
        ToggleMainUI()
    end)

    -- ==================== 双加载动画流程（仅动画1结束时播放一次音效） ====================
    task.spawn(function()
        local shineRunning = true
        task.spawn(function()
            while shineRunning and _BarShine and _BarShine.Parent do
                _BarShine.Position = UDim2.new(-0.25, 0, 0, 0)
                Tween(_BarShine, {Position = UDim2.new(1.1, 0, 0, 0)}, 0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(0.95)
            end
        end)

        for i = 1, 100 do
            _BarFill.Size = UDim2.new(i / 100, 0, 1, 0)
            _PercentText.Text = i .. "%"
            if i == 35 then
                _LoadSubText.Text = "正在加载主题与动画引擎..."
            elseif i == 75 then
                _LoadSubText.Text = "正在准备欢迎过场..."
            elseif i == 100 then
                _LoadSubText.Text = "加载成功!"
            end
            task.wait(0.012)
        end

        PlaySound("open")
        WaitExact(3.0)
        shineRunning = false

        Tween(_CenterCard, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(_LoadGui, {BackgroundTransparency = 1}, 0.25)
        task.wait(0.25)
        _LoadGui:Destroy()

        local introGui = Instance.new("ScreenGui", _CG)
        introGui.Name = "LMM_Intro_Splash"
        introGui.ResetOnSpawn = false
        introGui.DisplayOrder = 2147483645
        introGui.IgnoreGuiInset = true

        local badgeSize = 56
        local popupW = 194
        local gap = 10
        local totalW = badgeSize + gap + popupW
        local centerX = -math.floor(totalW / 2)

        local introGroup = Instance.new("Frame", introGui)
        introGroup.Size = UDim2.new(0, totalW, 0, badgeSize)
        introGroup.Position = UDim2.new(0.5, -math.floor(badgeSize / 2), 1, 75)
        introGroup.BackgroundTransparency = 1
        introGroup.ZIndex = 10

        local splashGlow = Instance.new("Frame", introGroup)
        splashGlow.Size = UDim2.new(0, badgeSize + 10, 0, badgeSize + 10)
        splashGlow.Position = UDim2.new(0, -5, 0, -5)
        splashGlow.BackgroundColor3 = Color3.fromRGB(129, 140, 248)
        splashGlow.BackgroundTransparency = 0.72
        splashGlow.BorderSizePixel = 0
        splashGlow.ZIndex = 11
        Instance.new("UICorner", splashGlow).CornerRadius = UDim.new(0, 17)
        ApplyAccentGradient(splashGlow, Color3.fromRGB(99, 102, 241), Color3.fromRGB(192, 132, 252), 45)

        local splashBadge = Instance.new("Frame", introGroup)
        splashBadge.Size = UDim2.new(0, badgeSize, 0, badgeSize)
        splashBadge.Position = UDim2.new(0, 0, 0, 0)
        splashBadge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        splashBadge.BorderSizePixel = 0
        splashBadge.ZIndex = 12
        Instance.new("UICorner", splashBadge).CornerRadius = UDim.new(0, 14)
        ApplyAccentGradient(splashBadge, Color3.fromRGB(99, 102, 241), Color3.fromRGB(192, 132, 252), 45)

        local splashBadgeStroke = Instance.new("UIStroke", splashBadge)
        splashBadgeStroke.Thickness = 1.5
        splashBadgeStroke.Color = Color3.fromRGB(255, 255, 255)
        splashBadgeStroke.Transparency = 0.2

        local splashLetter = Instance.new("TextLabel", splashBadge)
        splashLetter.Size = UDim2.new(1, 0, 1, 0)
        splashLetter.BackgroundTransparency = 1
        splashLetter.Text = "L"
        splashLetter.TextColor3 = Color3.fromRGB(255, 255, 255)
        splashLetter.Font = Enum.Font.GothamBold
        splashLetter.TextSize = 27
        splashLetter.ZIndex = 13

        local popupClip = Instance.new("Frame", introGroup)
        popupClip.Size = UDim2.new(0, popupW, 0, badgeSize)
        popupClip.Position = UDim2.new(0, badgeSize + gap, 0, 0)
        popupClip.BackgroundTransparency = 1
        popupClip.ClipsDescendants = true
        popupClip.ZIndex = 11

        local popupCard = Instance.new("Frame", popupClip)
        popupCard.Size = UDim2.new(1, 0, 1, 0)
        popupCard.Position = UDim2.new(-1, 0, 0, 0)
        popupCard.BackgroundColor3 = Color3.fromRGB(15, 17, 29)
        popupCard.BackgroundTransparency = 0.08
        popupCard.BorderSizePixel = 0
        popupCard.ZIndex = 11
        Instance.new("UICorner", popupCard).CornerRadius = UDim.new(0, 14)

        local popupStroke = Instance.new("UIStroke", popupCard)
        popupStroke.Thickness = 1.4
        popupStroke.Color = Color3.fromRGB(255, 255, 255)
        popupStroke.Transparency = 0.24
        ApplyAccentGradient(popupStroke, Color3.fromRGB(129, 140, 248), Color3.fromRGB(192, 132, 252), 35)

        local popupAccent = Instance.new("Frame", popupCard)
        popupAccent.Size = UDim2.new(0, 4, 0, 28)
        popupAccent.Position = UDim2.new(0, 11, 0.5, -14)
        popupAccent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        popupAccent.BorderSizePixel = 0
        popupAccent.ZIndex = 12
        Instance.new("UICorner", popupAccent).CornerRadius = UDim.new(1, 0)
        ApplyAccentGradient(popupAccent, Color3.fromRGB(129, 140, 248), Color3.fromRGB(192, 132, 252), 90)

        local popupLabel = Instance.new("TextLabel", popupCard)
        popupLabel.Size = UDim2.new(1, -24, 1, 0)
        popupLabel.Position = UDim2.new(0, 21, 0, 0)
        popupLabel.BackgroundTransparency = 1
        popupLabel.Text = "刘某某脚本by you"
        popupLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        popupLabel.Font = Enum.Font.GothamBold
        popupLabel.TextSize = 15
        popupLabel.TextXAlignment = Enum.TextXAlignment.Left
        popupLabel.ZIndex = 12

        Tween(introGroup, {Position = UDim2.new(0.5, -math.floor(badgeSize / 2), 0.5, -math.floor(badgeSize / 2))}, 0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        task.wait(0.45)

        Tween(introGroup, {Position = UDim2.new(0.5, centerX, 0.5, -math.floor(badgeSize / 2))}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        Tween(popupCard, {Position = UDim2.new(0, 0, 0, 0)}, 0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        WaitExact(3.0)

        Tween(popupCard, {Position = UDim2.new(-1, 0, 0, 0), BackgroundTransparency = 1}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        Tween(splashBadge, {BackgroundTransparency = 1}, 0.28)
        Tween(splashGlow, {BackgroundTransparency = 1}, 0.28)
        Tween(splashLetter, {TextTransparency = 1}, 0.28)
        Tween(blurEffect, {Size = 0}, 0.3)
        task.wait(0.3)
        pcall(function() introGui:Destroy() end)
        pcall(function() blurEffect:Destroy() end)

        _M.Visible = true
        _M.Size = UDim2.new(0, 565, 0, 369)
        Tween(_M, {Size = UDim2.new(0, 628, 0, 410)}, 0.38, Enum.EasingStyle.Back)
        _TopCapsule.Visible = true

        ShowNotification("刘某某脚本", "刘某某脚本开启完毕", 3.0)
    end)

    local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 56); _TB.BackgroundTransparency = 1; _TB.Active = true; _TB.ZIndex = 2
    
    local _BrandBadge = Instance.new("Frame", _TB)
    _BrandBadge.Size = UDim2.new(0, 32, 0, 32)
    _BrandBadge.Position = UDim2.new(0, 12, 0.5, -16)
    _BrandBadge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _BrandBadge.BorderSizePixel = 0
    _BrandBadge.ZIndex = 3
    Instance.new("UICorner", _BrandBadge).CornerRadius = UDim.new(0, 10)
    ApplyAccentGradient(_BrandBadge, Color3.fromRGB(99, 102, 241), Color3.fromRGB(192, 132, 252), 45)

    local _BrandLetter = Instance.new("TextLabel", _BrandBadge)
    _BrandLetter.Size = UDim2.new(1, 0, 1, 0)
    _BrandLetter.BackgroundTransparency = 1
    _BrandLetter.Text = "L"
    _BrandLetter.TextColor3 = Color3.fromRGB(255, 255, 255)
    _BrandLetter.Font = Enum.Font.GothamBold
    _BrandLetter.TextSize = 16
    _BrandLetter.ZIndex = 4

    local titleX = 50
    local titleFont = Enum.Font.GothamBold
    local titleSize = 17
    local titleStr = "刘某某脚本"
    local measuredTitleW = math.ceil(game:GetService("TextService"):GetTextSize(titleStr, titleSize, titleFont, Vector2.new(400, 56)).X)

    _Title = Instance.new("TextLabel", _TB)
    _Title.Size = UDim2.new(0, measuredTitleW + 2, 1, 0)
    _Title.Position = UDim2.new(0, titleX, 0, 0)
    _Title.Text = titleStr
    _Title.Font = titleFont
    _Title.TextSize = titleSize
    _Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    _Title.TextStrokeColor3 = Color3.fromRGB(8, 10, 22)
    _Title.TextStrokeTransparency = 0.35
    _Title.BackgroundTransparency = 1
    _Title.TextXAlignment = Enum.TextXAlignment.Left
    _Title.ZIndex = 3

    local verX = titleX + measuredTitleW + 5
    local verW = 64
    local _VerPill = Instance.new("TextLabel", _TB)
    _VerPill.Size = UDim2.new(0, verW, 0, 22)
    _VerPill.Position = UDim2.new(0, verX, 0.5, -11)
    _VerPill.BackgroundColor3 = Color3.fromRGB(18, 21, 38)
    _VerPill.BackgroundTransparency = 0
    _VerPill.BorderSizePixel = 0
    _VerPill.Text = "V4.2.50"
    _VerPill.TextColor3 = Color3.fromRGB(255, 255, 255)
    _VerPill.TextStrokeColor3 = Color3.fromRGB(5, 7, 16)
    _VerPill.TextStrokeTransparency = 0.25
    _VerPill.Font = Enum.Font.GothamBold
    _VerPill.TextSize = 11.5
    _VerPill.ZIndex = 4
    Instance.new("UICorner", _VerPill).CornerRadius = UDim.new(0, 7)
    local _VerStroke = Instance.new("UIStroke", _VerPill)
    _VerStroke.Thickness = 1.2
    _VerStroke.Color = Color3.fromRGB(129, 140, 248)
    _VerStroke.Transparency = 0.25

    local betaX = verX + verW + 5
    local betaW = 44
    local _BetaPill = Instance.new("TextLabel", _TB)
    _BetaPill.Size = UDim2.new(0, betaW, 0, 22)
    _BetaPill.Position = UDim2.new(0, betaX, 0.5, -11)
    _BetaPill.BackgroundColor3 = Color3.fromRGB(28, 32, 58)
    _BetaPill.BackgroundTransparency = 0
    _BetaPill.BorderSizePixel = 0
    _BetaPill.Text = "BETA"
    _BetaPill.TextColor3 = Color3.fromRGB(240, 244, 255)
    _BetaPill.TextStrokeColor3 = Color3.fromRGB(5, 7, 16)
    _BetaPill.TextStrokeTransparency = 0.2
    _BetaPill.Font = Enum.Font.GothamBold
    _BetaPill.TextSize = 11
    _BetaPill.ZIndex = 4
    Instance.new("UICorner", _BetaPill).CornerRadius = UDim.new(0, 7)
    local _BetaStroke = Instance.new("UIStroke", _BetaPill)
    _BetaStroke.Thickness = 1.2
    _BetaStroke.Color = Color3.fromRGB(148, 163, 255)
    _BetaStroke.Transparency = 0.35

    _HeaderLine = Instance.new("Frame", _M)
    _HeaderLine.Size = UDim2.new(1, -28, 0, 1); _HeaderLine.Position = UDim2.new(0, 14, 0, 56)
    _HeaderLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255); _HeaderLine.BackgroundTransparency = 0.78; _HeaderLine.BorderSizePixel = 0; _HeaderLine.ZIndex = 2

    _Sidebar = Instance.new("Frame", _M)
    _Sidebar.Size = UDim2.new(0, 158, 1, -70); _Sidebar.Position = UDim2.new(0, 12, 0, 64); _Sidebar.BackgroundTransparency = 1; _Sidebar.ZIndex = 2
    local _SideLayout = Instance.new("UIListLayout", _Sidebar)
    _SideLayout.Padding = UDim.new(0, 6); _SideLayout.HorizontalAlignment = "Center"; _SideLayout.SortOrder = "LayoutOrder"

    _SplitLine = Instance.new("Frame", _M)
    _SplitLine.Size = UDim2.new(0, 1, 1, -70); _SplitLine.Position = UDim2.new(0, 177, 0, 64)
    _SplitLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255); _SplitLine.BackgroundTransparency = 0.82; _SplitLine.BorderSizePixel = 0; _SplitLine.ZIndex = 2

    _ContentContainer = Instance.new("Frame", _M)
    _ContentContainer.Size = UDim2.new(1, -192, 1, -70); _ContentContainer.Position = UDim2.new(0, 185, 0, 64); _ContentContainer.BackgroundTransparency = 1; _ContentContainer.ZIndex = 2
    _ContentContainer.ClipsDescendants = true

    local function _CreatePage(order)
        local p = Instance.new("ScrollingFrame", _ContentContainer)
        p.Size = UDim2.new(1, 0, 1, 0); p.Position = UDim2.new(0, 0, 0, 0)
        p.BackgroundTransparency = 1; p.BorderSizePixel = 0; p.ScrollBarThickness = 4
        p.ScrollBarImageColor3 = Color3.fromRGB(165, 180, 252); p.ScrollBarImageTransparency = 0.2
        p.Active = true; p.ScrollingDirection = Enum.ScrollingDirection.Y
        p.AutomaticCanvasSize = Enum.AutomaticSize.Y
        p.CanvasSize = UDim2.new(0, 0, 0, 0)
        p.Visible = (order == 1); p.ZIndex = 2

        local l = Instance.new("UIListLayout", p)
        l.Padding = UDim.new(0, 8); l.HorizontalAlignment = Enum.HorizontalAlignment.Center; l.SortOrder = Enum.SortOrder.LayoutOrder
        
        local pad = Instance.new("UIPadding", p)
        pad.PaddingRight = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 12); pad.PaddingTop = UDim.new(0, 2)
        return p
    end

    local _Page1 = _CreatePage(1); local _Page2 = _CreatePage(2); local _Page5 = _CreatePage(3); local _Page6 = _CreatePage(4); local _Page3 = _CreatePage(5); local _Page4 = _CreatePage(6)
    local _Tabs = {}

    local function _CreateTabBtn(name, order, targetPage)
        local b = Instance.new("TextButton", _Sidebar)
        b.LayoutOrder = order; b.Size = UDim2.new(1, 0, 0, 36)
        b.BackgroundColor3 = (order == 1) and Color3.fromRGB(58, 62, 112) or Color3.fromRGB(16, 18, 32)
        b.BackgroundTransparency = (order == 1) and 0.24 or 0.62
        b.Text = "    " .. name; b.Font = Enum.Font.GothamBold; b.TextSize = 11.5
        b.TextColor3 = (order == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(202, 208, 240)
        b.TextXAlignment = Enum.TextXAlignment.Left; b.ZIndex = 2; b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 11)
        
        local bStroke = Instance.new("UIStroke", b)
        bStroke.Thickness = 1.05
        bStroke.Color = Color3.fromRGB(129, 140, 248)
        bStroke.Transparency = (order == 1) and 0.25 or 0.72

        local indicator = Instance.new("Frame", b)
        indicator.Size = UDim2.new(0, 3.5, 0.58, 0); indicator.Position = UDim2.new(0, 2, 0.21, 0)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255); indicator.BorderSizePixel = 0
        indicator.BackgroundTransparency = (order == 1) and 0 or 1
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
        ApplyAccentGradient(indicator, Color3.fromRGB(129, 140, 248), Color3.fromRGB(217, 70, 239), 90)

        _Tabs[b] = {page = targetPage, indicator = indicator, stroke = bStroke, order = order}
        
        b.MouseEnter:Connect(function()
            if _Tabs[b].page.Visible then return end
            Tween(b, {BackgroundColor3 = Color3.fromRGB(32, 35, 62), BackgroundTransparency = 0.4, TextColor3 = Color3.fromRGB(242, 245, 255)}, 0.2)
            Tween(bStroke, {Transparency = 0.45}, 0.2)
        end)
        b.MouseLeave:Connect(function()
            if _Tabs[b].page.Visible then return end
            Tween(b, {BackgroundColor3 = Color3.fromRGB(16, 18, 32), BackgroundTransparency = 0.62, TextColor3 = Color3.fromRGB(202, 208, 240)}, 0.2)
            Tween(bStroke, {Transparency = 0.72}, 0.2)
        end)
        b.MouseButton1Click:Connect(function()
            PlaySound("click")
            for btn, data in pairs(_Tabs) do
                data.page.Visible = (btn == b)
                if btn == b then
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(58, 62, 112), BackgroundTransparency = 0.24, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                    Tween(data.stroke, {Transparency = 0.25}, 0.2)
                    Tween(data.indicator, {BackgroundTransparency = 0, Size = UDim2.new(0, 3.5, 0.62, 0), Position = UDim2.new(0, 2, 0.19, 0)}, 0.2)
                else
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(16, 18, 32), BackgroundTransparency = 0.62, TextColor3 = Color3.fromRGB(202, 208, 240)}, 0.2)
                    Tween(data.stroke, {Transparency = 0.72}, 0.2)
                    Tween(data.indicator, {BackgroundTransparency = 1, Size = UDim2.new(0, 3.5, 0.45, 0), Position = UDim2.new(0, 2, 0.275, 0)}, 0.2)
                end
            end
        end)
    end

    _CreateTabBtn("账号", 1, _Page1)
    _CreateTabBtn("脚本合集(keyless)", 2, _Page2)
    _CreateTabBtn("脚本合集(key)", 3, _Page5)
    _CreateTabBtn("LMM script", 4, _Page6)
    _CreateTabBtn("更新日志", 5, _Page3)
    _CreateTabBtn("设定中心", 6, _Page4)

    -- ==================== 通用确认弹窗 ====================
    local function _OpenConfirmDialog(titleMsg, subMsg, confirmText, onConfirm)
        local topScreen = Instance.new("ScreenGui", _CG)
        topScreen.Name = "LMM_Ultimate_Top_Overlay"
        topScreen.ResetOnSpawn = false
        topScreen.DisplayOrder = 2147483647
        topScreen.IgnoreGuiInset = true

        local bgBlocker = Instance.new("TextButton", topScreen)
        bgBlocker.Size = UDim2.new(1, 0, 1, 0)
        bgBlocker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bgBlocker.BackgroundTransparency = 0.55
        bgBlocker.Text = ""
        bgBlocker.AutoButtonColor = false
        bgBlocker.ZIndex = 999999

        local alertOverlay = Instance.new("Frame", topScreen)
        alertOverlay.Size = UDim2.new(1, 0, 1, 0)
        alertOverlay.BackgroundTransparency = 1
        alertOverlay.ZIndex = 1000000
        
        local alertBox = Instance.new("Frame", alertOverlay)
        alertBox.Size = UDim2.new(0, 0, 0, 0)
        alertBox.Position = UDim2.new(0.5, 0, 0.5, 0)
        alertBox.BackgroundColor3 = Color3.fromRGB(15, 16, 26)
        alertBox.BackgroundTransparency = 0.06
        alertBox.ZIndex = 1000001
        alertBox.ClipsDescendants = true
        Instance.new("UICorner", alertBox).CornerRadius = UDim.new(0, 18)

        local boxStroke = Instance.new("UIStroke", alertBox)
        boxStroke.Thickness = 1.4
        boxStroke.Color = Color3.fromRGB(255, 255, 255)
        boxStroke.Transparency = 0.35
        ApplyAccentGradient(boxStroke)

        Tween(alertBox, {Size = UDim2.new(0, 360, 0, 168), Position = UDim2.new(0.5, -180, 0.5, -84)}, 0.35, Enum.EasingStyle.Back)

        local alertText = Instance.new("TextLabel", alertBox)
        alertText.Size = UDim2.new(1, -32, 0, 74); alertText.Position = UDim2.new(0, 16, 0, 20); alertText.BackgroundTransparency = 1; alertText.ZIndex = 1000002
        alertText.Text = titleMsg .. "\n" .. subMsg
        alertText.TextColor3 = Color3.fromRGB(255, 255, 255); alertText.Font = Enum.Font.GothamBold; alertText.TextSize = 14; alertText.TextWrapped = true

        local yesBtn = Instance.new("TextButton", alertBox)
        yesBtn.Size = UDim2.new(0, 150, 0, 38); yesBtn.Position = UDim2.new(0.055, 0, 0.65, 0); yesBtn.BackgroundColor3 = Color3.fromRGB(99, 102, 241); yesBtn.BackgroundTransparency = 0.08; yesBtn.Text = confirmText or "确认"; yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255); yesBtn.Font = Enum.Font.GothamBold; yesBtn.TextSize = 13; yesBtn.ZIndex = 1000002
        yesBtn.AutoButtonColor = false
        Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 11)

        local noBtn = Instance.new("TextButton", alertBox)
        noBtn.Size = UDim2.new(0, 150, 0, 38); noBtn.Position = UDim2.new(0.525, 0, 0.65, 0); noBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 44); noBtn.BackgroundTransparency = 0.12; noBtn.Text = "取消"; noBtn.TextColor3 = Color3.fromRGB(190, 194, 225); noBtn.Font = Enum.Font.GothamBold; noBtn.TextSize = 13; noBtn.ZIndex = 1000002
        noBtn.AutoButtonColor = false
        Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 11)

        yesBtn.MouseEnter:Connect(function() Tween(yesBtn, {BackgroundColor3 = Color3.fromRGB(122, 125, 255)}, 0.2) end)
        yesBtn.MouseLeave:Connect(function() Tween(yesBtn, {BackgroundColor3 = Color3.fromRGB(99, 102, 241)}, 0.2) end)
        noBtn.MouseEnter:Connect(function() Tween(noBtn, {BackgroundColor3 = Color3.fromRGB(38, 40, 62)}, 0.2) end)
        noBtn.MouseLeave:Connect(function() Tween(noBtn, {BackgroundColor3 = Color3.fromRGB(26, 28, 44)}, 0.2) end)

        local function closeDialog(callback)
            Tween(alertBox, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.25)
            topScreen:Destroy()
            if callback then callback() end
        end

        yesBtn.MouseButton1Click:Connect(function()
            PlaySound("click")
            closeDialog(function()
                if onConfirm then onConfirm() end
            end)
        end)

        noBtn.MouseButton1Click:Connect(function()
            PlaySound("click")
            closeDialog()
        end)
    end

    -- ==================== “账号”页面：玩家信息与当前游戏 ====================
    local _DataCard = Instance.new("Frame", _Page1)
    _DataCard.LayoutOrder = 1
    _DataCard.Size = UDim2.new(0.98, 0, 0, 124)
    _DataCard.BackgroundColor3 = Color3.fromRGB(15, 17, 30)
    _DataCard.BackgroundTransparency = 0.44
    _DataCard.ZIndex = 2
    Instance.new("UICorner", _DataCard).CornerRadius = UDim.new(0, 15)
    local _DataStroke = Instance.new("UIStroke", _DataCard)
    _DataStroke.Thickness = 1.2
    _DataStroke.Color = Color3.fromRGB(129, 140, 248)
    _DataStroke.Transparency = 0.32

    local _AvatarRing = Instance.new("Frame", _DataCard)
    _AvatarRing.Size = UDim2.new(0, 82, 0, 82)
    _AvatarRing.Position = UDim2.new(0, 14, 0.5, -41)
    _AvatarRing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _AvatarRing.BorderSizePixel = 0
    _AvatarRing.ZIndex = 3
    Instance.new("UICorner", _AvatarRing).CornerRadius = UDim.new(1, 0)
    ApplyAccentGradient(_AvatarRing)

    local _AvatarImg = Instance.new("ImageLabel", _AvatarRing)
    _AvatarImg.Size = UDim2.new(1, -4, 1, -4)
    _AvatarImg.Position = UDim2.new(0, 2, 0, 2)
    _AvatarImg.BackgroundColor3 = Color3.fromRGB(22, 22, 36)
    _AvatarImg.ZIndex = 4
    Instance.new("UICorner", _AvatarImg).CornerRadius = UDim.new(1, 0)
    pcall(function()
        local content = _P:GetUserThumbnailAsync(_LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        _AvatarImg.Image = content
    end)

    local _NameLabel = Instance.new("TextLabel", _DataCard)
    _NameLabel.Size = UDim2.new(1, -114, 0, 22)
    _NameLabel.Position = UDim2.new(0, 110, 0, 17)
    _NameLabel.BackgroundTransparency = 1
    _NameLabel.Text = "玩家: " .. _LP.DisplayName .. " (@" .. _LP.Name .. ")"
    _NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    _NameLabel.Font = Enum.Font.GothamBold
    _NameLabel.TextSize = 13.5
    _NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    _NameLabel.ZIndex = 3

    local _RobuxLabel = Instance.new("TextLabel", _DataCard)
    _RobuxLabel.Size = UDim2.new(1, -114, 0, 20)
    _RobuxLabel.Position = UDim2.new(0, 110, 0, 46)
    _RobuxLabel.BackgroundTransparency = 1
    _RobuxLabel.Text = "Robux 余额: 获取中..."
    _RobuxLabel.TextColor3 = Color3.fromRGB(165, 180, 252)
    _RobuxLabel.Font = Enum.Font.GothamBold
    _RobuxLabel.TextSize = 12
    _RobuxLabel.TextXAlignment = Enum.TextXAlignment.Left
    _RobuxLabel.ZIndex = 3

    task.spawn(function()
        local success, result = pcall(function()
            return game:GetService("MarketplaceService"):GetRobuxBalance()
        end)
        if success and result then
            _RobuxLabel.Text = "Robux 余额: R$ " .. tostring(result)
        else
            _RobuxLabel.Text = "Robux 余额: R$ (受API限制/未登录)"
        end
    end)

    local _ServerLabel = Instance.new("TextLabel", _DataCard)
    _ServerLabel.Size = UDim2.new(1, -114, 0, 20)
    _ServerLabel.Position = UDim2.new(0, 110, 0, 73)
    _ServerLabel.BackgroundTransparency = 1
    _ServerLabel.Text = "服务器人数: 正在统计..."
    _ServerLabel.TextColor3 = Color3.fromRGB(204, 210, 240)
    _ServerLabel.Font = Enum.Font.GothamMedium
    _ServerLabel.TextSize = 12
    _ServerLabel.TextXAlignment = Enum.TextXAlignment.Left
    _ServerLabel.ZIndex = 3

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                _ServerLabel.Text = string.format("服务器人数: %d / %d 人", #_P:GetPlayers(), _P.MaxPlayers)
            end)
        end
    end)

    local _GameCard = Instance.new("Frame", _Page1)
    _GameCard.LayoutOrder = 2
    _GameCard.Size = UDim2.new(0.98, 0, 0, 80)
    _GameCard.BackgroundColor3 = Color3.fromRGB(15, 17, 30)
    _GameCard.BackgroundTransparency = 0.44
    _GameCard.ZIndex = 2
    Instance.new("UICorner", _GameCard).CornerRadius = UDim.new(0, 15)
    local _GameCardStroke = Instance.new("UIStroke", _GameCard)
    _GameCardStroke.Thickness = 1.2
    _GameCardStroke.Color = Color3.fromRGB(129, 140, 248)
    _GameCardStroke.Transparency = 0.32

    local _GameIconImg = Instance.new("ImageLabel", _GameCard)
    _GameIconImg.Size = UDim2.new(0, 52, 0, 52)
    _GameIconImg.Position = UDim2.new(0, 14, 0.5, -26)
    _GameIconImg.BackgroundColor3 = Color3.fromRGB(24, 26, 42)
    _GameIconImg.ZIndex = 3
    Instance.new("UICorner", _GameIconImg).CornerRadius = UDim.new(0, 12)

    local _GameTitleLabel = Instance.new("TextLabel", _GameCard)
    _GameTitleLabel.Size = UDim2.new(1, -84, 0, 21)
    _GameTitleLabel.Position = UDim2.new(0, 78, 0, 16)
    _GameTitleLabel.BackgroundTransparency = 1
    _GameTitleLabel.Text = "当前游戏: 获取中..."
    _GameTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    _GameTitleLabel.Font = Enum.Font.GothamBold
    _GameTitleLabel.TextSize = 13
    _GameTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    _GameTitleLabel.ZIndex = 3

    local _GameIdLabel = Instance.new("TextLabel", _GameCard)
    _GameIdLabel.Size = UDim2.new(1, -84, 0, 19)
    _GameIdLabel.Position = UDim2.new(0, 78, 0, 42)
    _GameIdLabel.BackgroundTransparency = 1
    _GameIdLabel.Text = "PlaceId: " .. game.PlaceId
    _GameIdLabel.TextColor3 = Color3.fromRGB(204, 210, 240)
    _GameIdLabel.Font = Enum.Font.GothamMedium
    _GameIdLabel.TextSize = 11.5
    _GameIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    _GameIdLabel.ZIndex = 3

    task.spawn(function()
        pcall(function()
            local info = _MP:GetProductInfo(game.PlaceId)
            if info and info.Name then
                _GameTitleLabel.Text = "当前游戏: " .. info.Name
            end
            if info and info.IconImageAssetId and info.IconImageAssetId ~= 0 then
                _GameIconImg.Image = "rbxassetid://" .. tostring(info.IconImageAssetId)
            else
                _GameIconImg.Image = "rbxassetid://6023426915"
            end
        end)
    end)

    local function _ExecuteScriptUrl(name, url)
        ShowNotification("正在开启中...", name, 2.5)
        task.spawn(function()
            local success = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if success then
                PlaySound("open")
                ShowNotification("开启成功", name .. " 已成功运行！", 3.0)
            else
                ShowNotification("开启失败", "网络异常或链接失效", 3.0)
            end
        end)
    end

    local function _PromptScriptConfirm(name, url)
        _OpenConfirmDialog("确定要开启此脚本吗？", name, "确认开启", function()
            _ExecuteScriptUrl(name, url)
        end)
    end

    local function _CreateS(targetPage, name, url, order)
        local row = Instance.new("Frame", targetPage)
        row.Name = "ScriptRow"
        row.LayoutOrder = order
        row.Size = UDim2.new(0.98, 0, 0, 42)
        row.BackgroundColor3 = Color3.fromRGB(15, 17, 30)
        row.BackgroundTransparency = 0.44
        row.ZIndex = 2
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
        local s = Instance.new("UIStroke", row); s.Thickness = 1; s.Color = Color3.fromRGB(110, 120, 180); s.Transparency = 0.32

        local mainBtn = Instance.new("TextButton", row)
        mainBtn.Name = "MainBtn"
        mainBtn.Size = UDim2.new(1, -152, 1, 0)
        mainBtn.Position = UDim2.new(0, 0, 0, 0)
        mainBtn.BackgroundTransparency = 1
        mainBtn.Text = "   " .. name
        mainBtn.Font = Enum.Font.GothamMedium
        mainBtn.TextSize = 13
        mainBtn.TextColor3 = Color3.fromRGB(245, 247, 255)
        mainBtn.TextXAlignment = Enum.TextXAlignment.Left
        mainBtn.ZIndex = 3
        mainBtn.AutoButtonColor = false

        local copyBtn = Instance.new("TextButton", row)
        copyBtn.Name = "CopyBtn"
        copyBtn.Size = UDim2.new(0, 62, 0, 28)
        copyBtn.Position = UDim2.new(1, -144, 0.5, -14)
        copyBtn.BackgroundColor3 = Color3.fromRGB(32, 35, 58)
        copyBtn.BackgroundTransparency = 0.14
        copyBtn.Text = "Copy"
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.TextSize = 11
        copyBtn.TextColor3 = Color3.fromRGB(220, 226, 252)
        copyBtn.ZIndex = 3
        copyBtn.AutoButtonColor = false
        Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)

        local execBtn = Instance.new("TextButton", row)
        execBtn.Name = "ExecuteBtn"
        execBtn.Size = UDim2.new(0, 70, 0, 28)
        execBtn.Position = UDim2.new(1, -76, 0.5, -14)
        execBtn.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
        execBtn.BackgroundTransparency = 0.1
        execBtn.Text = "Execute"
        execBtn.Font = Enum.Font.GothamBold
        execBtn.TextSize = 11
        execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        execBtn.ZIndex = 3
        execBtn.AutoButtonColor = false
        Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 8)

        row.MouseEnter:Connect(function()
            Tween(row, {BackgroundColor3 = Color3.fromRGB(28, 31, 56), BackgroundTransparency = 0.25}, 0.2)
            Tween(s, {Color = Color3.fromRGB(165, 180, 252), Transparency = 0.1}, 0.2)
        end)
        row.MouseLeave:Connect(function()
            Tween(row, {BackgroundColor3 = Color3.fromRGB(15, 17, 30), BackgroundTransparency = 0.44}, 0.2)
            Tween(s, {Color = Color3.fromRGB(110, 120, 180), Transparency = 0.32}, 0.2)
        end)

        copyBtn.MouseEnter:Connect(function() Tween(copyBtn, {BackgroundColor3 = Color3.fromRGB(52, 56, 88), BackgroundTransparency = 0.06}, 0.15) end)
        copyBtn.MouseLeave:Connect(function() Tween(copyBtn, {BackgroundColor3 = Color3.fromRGB(32, 35, 58), BackgroundTransparency = 0.14}, 0.15) end)

        execBtn.MouseEnter:Connect(function() Tween(execBtn, {BackgroundColor3 = Color3.fromRGB(129, 140, 248), BackgroundTransparency = 0.04}, 0.15) end)
        execBtn.MouseLeave:Connect(function() Tween(execBtn, {BackgroundColor3 = Color3.fromRGB(99, 102, 241), BackgroundTransparency = 0.1}, 0.15) end)

        mainBtn.MouseButton1Click:Connect(function()
            PlaySound("click")
            _PromptScriptConfirm(name, url)
        end)

        copyBtn.MouseButton1Click:Connect(function()
            PlaySound("click")
            pcall(function()
                setclipboard('loadstring(game:HttpGet("' .. url .. '"))()')
            end)
            ShowNotification("已复制脚本", name .. " 代码已复制到剪贴板", 2.5)
        end)

        execBtn.MouseButton1Click:Connect(function()
            PlaySound("click")
            _PromptScriptConfirm(name, url)
        end)
    end

    local function _CreateLMMButton(targetPage, name, url, order)
        local row = Instance.new("Frame", targetPage)
        row.Name = "ScriptRow"
        row.LayoutOrder = order
        row.Size = UDim2.new(0.98, 0, 0, 42)
        row.BackgroundColor3 = Color3.fromRGB(15, 17, 30)
        row.BackgroundTransparency = 0.44
        row.ZIndex = 2
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
        local s = Instance.new("UIStroke", row); s.Thickness = 1; s.Color = Color3.fromRGB(110, 120, 180); s.Transparency = 0.32

        local mainBtn = Instance.new("TextButton", row)
        mainBtn.Name = "MainBtn"
        mainBtn.Size = UDim2.new(1, -86, 1, 0)
        mainBtn.Position = UDim2.new(0, 0, 0, 0)
        mainBtn.BackgroundTransparency = 1
        mainBtn.Text = "   " .. name
        mainBtn.Font = Enum.Font.GothamMedium
        mainBtn.TextSize = 13
        mainBtn.TextColor3 = Color3.fromRGB(245, 247, 255)
        mainBtn.TextXAlignment = Enum.TextXAlignment.Left
        mainBtn.ZIndex = 3
        mainBtn.AutoButtonColor = false

        local execBtn = Instance.new("TextButton", row)
        execBtn.Name = "ExecuteBtn"
        execBtn.Size = UDim2.new(0, 72, 0, 28)
        execBtn.Position = UDim2.new(1, -80, 0.5, -14)
        execBtn.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
        execBtn.BackgroundTransparency = 0.1
        execBtn.Text = "Execute"
        execBtn.Font = Enum.Font.GothamBold
        execBtn.TextSize = 11
        execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        execBtn.ZIndex = 3
        execBtn.AutoButtonColor = false
        Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 8)

        row.MouseEnter:Connect(function()
            Tween(row, {BackgroundColor3 = Color3.fromRGB(28, 31, 56), BackgroundTransparency = 0.25}, 0.2)
            Tween(s, {Color = Color3.fromRGB(165, 180, 252), Transparency = 0.1}, 0.2)
        end)
        row.MouseLeave:Connect(function()
            Tween(row, {BackgroundColor3 = Color3.fromRGB(15, 17, 30), BackgroundTransparency = 0.44}, 0.2)
            Tween(s, {Color = Color3.fromRGB(110, 120, 180), Transparency = 0.32}, 0.2)
        end)

        execBtn.MouseEnter:Connect(function() Tween(execBtn, {BackgroundColor3 = Color3.fromRGB(129, 140, 248), BackgroundTransparency = 0.04}, 0.15) end)
        execBtn.MouseLeave:Connect(function() Tween(execBtn, {BackgroundColor3 = Color3.fromRGB(99, 102, 241), BackgroundTransparency = 0.1}, 0.15) end)

        mainBtn.MouseButton1Click:Connect(function()
            PlaySound("click")
            _PromptScriptConfirm(name, url)
        end)

        execBtn.MouseButton1Click:Connect(function()
            PlaySound("click")
            _PromptScriptConfirm(name, url)
        end)
    end

    local function _DecorateInput(input)
        input.MouseEnter:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(129, 140, 248), Transparency = 0.15}, 0.2) end)
        input.MouseLeave:Connect(function() if not input:IsFocused() then Tween(input.UIStroke, {Color = Color3.fromRGB(110, 120, 180), Transparency = 0.32}, 0.2) end end)
        input.Focused:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(192, 132, 252), Transparency = 0.08}, 0.2) end)
        input.FocusLost:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(110, 120, 180), Transparency = 0.32}, 0.2) end)
    end

    local _SearchBox = Instance.new("TextBox", _Page2)
    _SearchBox.LayoutOrder = 1; _SearchBox.Size = UDim2.new(0.98, 0, 0, 38); _SearchBox.BackgroundColor3 = Color3.fromRGB(15, 17, 30); _SearchBox.BackgroundTransparency = 0.44
    _SearchBox.PlaceholderText = "搜索 keyless 脚本..."; _SearchBox.Text = ""; _SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    _SearchBox.PlaceholderColor3 = Color3.fromRGB(182, 188, 222); _SearchBox.Font = Enum.Font.GothamMedium; _SearchBox.TextSize = 13; _SearchBox.ZIndex = 2
    Instance.new("UICorner", _SearchBox).CornerRadius = UDim.new(0, 12)
    local _SearchStroke = Instance.new("UIStroke", _SearchBox); _SearchStroke.Thickness = 1; _SearchStroke.Color = Color3.fromRGB(110, 120, 180); _SearchStroke.Transparency = 0.32
    _DecorateInput(_SearchBox)

    _SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = _SearchBox.Text:lower()
        for _, child in pairs(_Page2:GetChildren()) do
            if child:IsA("Frame") and child.Name == "ScriptRow" then
                local mainBtn = child:FindFirstChild("MainBtn")
                local labelText = mainBtn and mainBtn.Text:lower() or ""
                child.Visible = (query == "" or labelText:find(query) ~= nil)
            end
        end
    end)

    _CreateS(_Page2, "Redz (Blox Fruits)", "https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Redz/v3.luau", 2)
    _CreateS(_Page2, "AIMBOT", "https://rawscripts.net/raw/Universal-Script-Aimbot-Mobile-34677", 3)
    _CreateS(_Page2, "Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 4)
    _CreateS(_Page2, "Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source", 5)
    _CreateS(_Page2, "Owl Hub", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt", 6)
    _CreateS(_Page2, "steal an egg", "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua", 7)
    _CreateS(_Page2, "VR7", "https://scriptblox.com/raw/Universal-Script-VR7-45290", 8)
    _CreateS(_Page2, "Universal hub", "https://scriptblox.com/raw/Universal-Script-Universal-Hub-Lite-226350", 9)
    _CreateS(_Page2, "KDV3", "https://scriptblox.com/raw/UP-Just-a-baseplate.-WORKING-KDV3-MODDED-227082", 10)
    _CreateS(_Page2, "Molyn hub", "https://scriptblox.com/raw/Universal-Script-MOLYN-DEVELOPMENT-201480", 11)
    _CreateS(_Page2, "CanHub v2", "https://scriptblox.com/raw/Universal-Script-CanHub-V2-200-GAMES-KEYLESS-241714", 12)
    _CreateS(_Page2, "Sp3arparvus", "https://scriptblox.com/raw/Universal-Script-Sp3arParvus-239746", 13)
    _CreateS(_Page2, "Emote libary", "https://vexroscripts.com.tr/vexroemotes.luau", 14)
    _CreateS(_Page2, "Celestial", "https://raw.githubusercontent.com/marianaxx2c-glitch/ceewww/refs/heads/main/xxx", 15)
    _CreateS(_Page2, "Slap battles/fly", "https://scriptblox.com/raw/UPDATE-Slap-Battles-OP-ARBIX-HUB-SLAP-AURA-AND-MUCH-MORE-227489", 16)

    local _SearchBox2 = Instance.new("TextBox", _Page5)
    _SearchBox2.LayoutOrder = 1; _SearchBox2.Size = UDim2.new(0.98, 0, 0, 38); _SearchBox2.BackgroundColor3 = Color3.fromRGB(15, 17, 30); _SearchBox2.BackgroundTransparency = 0.44
    _SearchBox2.PlaceholderText = "搜索 key 脚本..."; _SearchBox2.Text = ""; _SearchBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
    _SearchBox2.PlaceholderColor3 = Color3.fromRGB(182, 188, 222); _SearchBox2.Font = Enum.Font.GothamMedium; _SearchBox2.TextSize = 13; _SearchBox2.ZIndex = 2
    Instance.new("UICorner", _SearchBox2).CornerRadius = UDim.new(0, 12)
    local _SearchStroke2 = Instance.new("UIStroke", _SearchBox2); _SearchStroke2.Thickness = 1; _SearchStroke2.Color = Color3.fromRGB(110, 120, 180); _SearchStroke2.Transparency = 0.32
    _DecorateInput(_SearchBox2)

    _SearchBox2:GetPropertyChangedSignal("Text"):Connect(function()
        local query = _SearchBox2.Text:lower()
        for _, child in pairs(_Page5:GetChildren()) do
            if child:IsA("Frame") and child.Name == "ScriptRow" then
                local mainBtn = child:FindFirstChild("MainBtn")
                local labelText = mainBtn and mainBtn.Text:lower() or ""
                child.Visible = (query == "" or labelText:find(query) ~= nil)
            end
        end
    end)

    _CreateS(_Page5, "Blade Ball", "https://raw.githubusercontent.com/joshhhie/rise/refs/heads/main/loader.lua", 2)
    _CreateS(_Page5, "Moondiety", "https://scriptblox.com/raw/Universal-Script-MOONDIETY-UNIVERSAL-KEYLESS-233999", 3)
    _CreateS(_Page5, "King hub", "https://scriptblox.com/raw/Universal-Script-King-Hub-91820", 4)

    local _SearchBox3 = Instance.new("TextBox", _Page6)
    _SearchBox3.LayoutOrder = 1; _SearchBox3.Size = UDim2.new(0.98, 0, 0, 38); _SearchBox3.BackgroundColor3 = Color3.fromRGB(15, 17, 30); _SearchBox3.BackgroundTransparency = 0.44
    _SearchBox3.PlaceholderText = "搜索我的专属脚本..."; _SearchBox3.Text = ""; _SearchBox3.TextColor3 = Color3.fromRGB(255, 255, 255)
    _SearchBox3.PlaceholderColor3 = Color3.fromRGB(182, 188, 222); _SearchBox3.Font = Enum.Font.GothamMedium; _SearchBox3.TextSize = 13; _SearchBox3.ZIndex = 2
    Instance.new("UICorner", _SearchBox3).CornerRadius = UDim.new(0, 12)
    local _SearchStroke3 = Instance.new("UIStroke", _SearchBox3); _SearchStroke3.Thickness = 1; _SearchStroke3.Color = Color3.fromRGB(110, 120, 180); _SearchStroke3.Transparency = 0.32
    _DecorateInput(_SearchBox3)

    _SearchBox3:GetPropertyChangedSignal("Text"):Connect(function()
        local query = _SearchBox3.Text:lower()
        for _, child in pairs(_Page6:GetChildren()) do
            if child:IsA("Frame") and child.Name == "ScriptRow" then
                local mainBtn = child:FindFirstChild("MainBtn")
                local labelText = mainBtn and mainBtn.Text:lower() or ""
                child.Visible = (query == "" or labelText:find(query) ~= nil)
            end
        end
    end)

    _CreateLMMButton(_Page6, "LMM normal script", "https://raw.githubusercontent.com/LMM-823/LMM-normal/main/main.lua?v=999", 2)
    _CreateLMMButton(_Page6, "LMM fps", "https://raw.githubusercontent.com/LMM-823/LMM-fps/main/main.lua?v=999", 3)
    _CreateLMMButton(_Page6, "LMM MM2", "https://raw.githubusercontent.com/LMM-823/LMM-mm2/main/main.lua?v=999", 4)
    _CreateLMMButton(_Page6, "LMM VIEW", "https://raw.githubusercontent.com/LMM-823/LMM-VIEW/main/Main.lua?v=999", 5)

    local function _CreateLogEntry(version, date, desc, order)
        local f = Instance.new("Frame", _Page3)
        f.LayoutOrder = order; f.Size = UDim2.new(0.98, 0, 0, 0); f.AutomaticSize = Enum.AutomaticSize.Y
        f.BackgroundColor3 = Color3.fromRGB(15, 17, 30); f.BackgroundTransparency = 0.44; f.ZIndex = 2
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
        
        local stroke = Instance.new("UIStroke", f); stroke.Thickness = 1; stroke.Color = Color3.fromRGB(110, 120, 180); stroke.Transparency = 0.32
        
        local pad = Instance.new("UIPadding", f)
        pad.PaddingTop = UDim.new(0, 9); pad.PaddingBottom = UDim.new(0, 9)
        pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12)
        
        local layout = Instance.new("UIListLayout", f)
        layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 3)

        local t = Instance.new("TextLabel", f)
        t.LayoutOrder = 1; t.Size = UDim2.new(1, 0, 0, 20)
        t.BackgroundTransparency = 1; t.Text = version .. " - " .. date
        t.TextColor3 = Color3.fromRGB(165, 180, 252); t.Font = Enum.Font.GothamBold; t.TextSize = 13; t.TextXAlignment = Enum.TextXAlignment.Left; t.ZIndex = 2
        
        local d = Instance.new("TextLabel", f)
        d.LayoutOrder = 2; d.Size = UDim2.new(1, 0, 0, 0); d.AutomaticSize = Enum.AutomaticSize.Y
        d.BackgroundTransparency = 1; d.Text = desc; d.TextColor3 = Color3.fromRGB(220, 226, 248)
        d.Font = Enum.Font.GothamMedium; d.TextSize = 12; d.TextXAlignment = Enum.TextXAlignment.Left; d.TextWrapped = true; d.ZIndex = 2

        f.MouseEnter:Connect(function() Tween(stroke, {Color = Color3.fromRGB(165, 180, 252), Transparency = 0.1}, 0.25) end)
        f.MouseLeave:Connect(function() Tween(stroke, {Color = Color3.fromRGB(110, 120, 180), Transparency = 0.32}, 0.25) end)
    end

    _CreateLogEntry("V4.2.50", "2026-11-20", "【顶部胶囊半透明 + 加载动画仅留一个音效】顶部胶囊设为50%半透明；启动双加载动画精简为只播放一次音效。", 1)
    _CreateLogEntry("V4.2.49", "2026-11-20", "【顶部胶囊渐变提亮 + 主UI背景更清晰】调亮顶部胶囊渐变色并加快流动；降低主面板遮罩浓度，让主UI背景图更清晰可见。", 2)
    _CreateLogEntry("V4.2.48", "2026-11-20", "【删 -/+ 按钮 + 顶部胶囊渐变流动 + 整体UI美化】移除顶栏 - 和 + 按钮；顶部胶囊加入渐变色与流动动画；优化主面板渐变遮罩与卡片层次。", 3)

    local _FpsInput = Instance.new("TextBox", _Page4)
    _FpsInput.LayoutOrder = 1; _FpsInput.Size = UDim2.new(0.98, 0, 0, 40); _FpsInput.BackgroundColor3 = Color3.fromRGB(15, 17, 30); _FpsInput.BackgroundTransparency = 0.44
    _FpsInput.Text = "   设置FPS解锁 15到240: 60"; _FpsInput.TextColor3 = Color3.fromRGB(245, 247, 255); _FpsInput.Font = Enum.Font.GothamMedium; _FpsInput.TextSize = 13; _FpsInput.TextXAlignment = Enum.TextXAlignment.Left; _FpsInput.ZIndex = 2
    Instance.new("UICorner", _FpsInput).CornerRadius = UDim.new(0, 12)
    local _FpsStroke = Instance.new("UIStroke", _FpsInput); _FpsStroke.Thickness = 1; _FpsStroke.Color = Color3.fromRGB(110, 120, 180); _FpsStroke.Transparency = 0.32
    _DecorateInput(_FpsInput)

    _FpsInput.FocusLost:Connect(function()
        PlaySound("click")
        local val = tonumber(_FpsInput.Text:match("%d+")) or 60
        if val < 15 then val = 15 end if val > 240 then val = 240 end
        _FpsInput.Text = "   设置FPS解锁 15到240: " .. val
        pcall(function() setfpscap(val) end)
        ShowNotification("FPS 设置已更新", "当前上限已锁定为 " .. val, 2.8)
    end)

    local function _CreateSettingToggleRow(order, titleText, onToggle)
        local row = Instance.new("Frame", _Page4)
        row.LayoutOrder = order
        row.Size = UDim2.new(0.98, 0, 0, 40)
        row.BackgroundColor3 = Color3.fromRGB(15, 17, 30)
        row.BackgroundTransparency = 0.44
        row.ZIndex = 2
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
        local stroke = Instance.new("UIStroke", row)
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(110, 120, 180)
        stroke.Transparency = 0.32

        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(1, -78, 1, 0)
        label.Position = UDim2.new(0, 14, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = titleText
        label.TextColor3 = Color3.fromRGB(245, 247, 255)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 3

        local switchBtn = Instance.new("TextButton", row)
        switchBtn.Size = UDim2.new(0, 50, 0, 24)
        switchBtn.Position = UDim2.new(1, -62, 0.5, -12)
        switchBtn.BackgroundColor3 = Color3.fromRGB(36, 39, 64)
        switchBtn.BackgroundTransparency = 0.1
        switchBtn.Text = ""
        switchBtn.AutoButtonColor = false
        switchBtn.ZIndex = 3
        Instance.new("UICorner", switchBtn).CornerRadius = UDim.new(1, 0)
        local swStroke = Instance.new("UIStroke", switchBtn)
        swStroke.Thickness = 1
        swStroke.Color = Color3.fromRGB(115, 124, 180)

        local knob = Instance.new("Frame", switchBtn)
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(0, 3, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(225, 228, 250)
        knob.BorderSizePixel = 0
        knob.ZIndex = 4
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local hitBtn = Instance.new("TextButton", row)
        hitBtn.Size = UDim2.new(1, -70, 1, 0)
        hitBtn.Position = UDim2.new(0, 0, 0, 0)
        hitBtn.BackgroundTransparency = 1
        hitBtn.Text = ""
        hitBtn.AutoButtonColor = false
        hitBtn.ZIndex = 3

        local state = false
        local function setVisual(active)
            state = active
            if active then
                Tween(switchBtn, {BackgroundColor3 = Color3.fromRGB(34, 197, 94), BackgroundTransparency = 0.08}, 0.2)
                Tween(knob, {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                Tween(stroke, {Color = Color3.fromRGB(34, 197, 94), Transparency = 0.2}, 0.2)
            else
                Tween(switchBtn, {BackgroundColor3 = Color3.fromRGB(36, 39, 64), BackgroundTransparency = 0.1}, 0.2)
                Tween(knob, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(225, 228, 250)}, 0.2)
                Tween(stroke, {Color = Color3.fromRGB(110, 120, 180), Transparency = 0.32}, 0.2)
            end
        end

        row.MouseEnter:Connect(function()
            if not state then
                Tween(row, {BackgroundColor3 = Color3.fromRGB(28, 31, 56), BackgroundTransparency = 0.25}, 0.2)
                Tween(stroke, {Color = Color3.fromRGB(165, 180, 252), Transparency = 0.1}, 0.2)
            end
        end)
        row.MouseLeave:Connect(function()
            if not state then
                Tween(row, {BackgroundColor3 = Color3.fromRGB(15, 17, 30), BackgroundTransparency = 0.44}, 0.2)
                Tween(stroke, {Color = Color3.fromRGB(110, 120, 180), Transparency = 0.32}, 0.2)
            end
        end)

        local function trigger()
            PlaySound("click")
            local nextState = not state
            setVisual(nextState)
            if onToggle then
                onToggle(nextState)
            end
        end

        switchBtn.MouseButton1Click:Connect(trigger)
        hitBtn.MouseButton1Click:Connect(trigger)

        return {
            Row = row,
            SetState = setVisual,
            GetState = function() return state end
        }
    end

    local afkConnection = nil
    _CreateSettingToggleRow(2, "挂机AFK 防踢保护", function(enabled)
        if enabled then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                afkConnection = _LP.Idled:Connect(function()
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end)
            end)
            ShowNotification("挂机防踢保护已开启", "系统将自动模拟操作防止被服务器踢出", 3.0)
        else
            pcall(function()
                if afkConnection then
                    afkConnection:Disconnect()
                    afkConnection = nil
                end
            end)
            ShowNotification("挂机防踢保护已关闭", "已恢复正常检测", 2.5)
        end
    end)

    local fullbrightConn = nil
    local fullbrightActive = false
    local fulldarkConn = nil
    local fulldarkActive = false
    local hiddenSkies = {}
    local darkSkyObj = nil

    local fullbrightCtrl
    local fulldarkCtrl
    local fullscreenBlackCtrl

    local function StopFullbright()
        fullbrightActive = false
        if fullbrightConn then
            fullbrightConn:Disconnect()
            fullbrightConn = nil
        end
        if fullbrightCtrl then
            fullbrightCtrl.SetState(false)
        end
    end

    local function RestoreSkies()
        if darkSkyObj and darkSkyObj.Parent then
            darkSkyObj:Destroy()
        end
        darkSkyObj = nil
        for _, sk in ipairs(hiddenSkies) do
            pcall(function()
                if sk and sk.Parent == nil then
                    sk.Parent = _Lighting
                end
            end)
        end
        hiddenSkies = {}
    end

    local function ApplyBlackSkyOnly()
        pcall(function()
            _Lighting.ClockTime = 0
            hiddenSkies = {}
            for _, child in ipairs(_Lighting:GetChildren()) do
                if child:IsA("Sky") and child.Name ~= "LMM_BlackSky" then
                    table.insert(hiddenSkies, child)
                    child.Parent = nil
                end
            end
            if not darkSkyObj or not darkSkyObj.Parent then
                darkSkyObj = Instance.new("Sky")
                darkSkyObj.Name = "LMM_BlackSky"
                darkSkyObj.SkyboxBk = "rbxassetid://1012887"
                darkSkyObj.SkyboxDn = "rbxassetid://1012887"
                darkSkyObj.SkyboxFt = "rbxassetid://1012887"
                darkSkyObj.SkyboxLf = "rbxassetid://1012887"
                darkSkyObj.SkyboxRt = "rbxassetid://1012887"
                darkSkyObj.SkyboxUp = "rbxassetid://1012887"
                darkSkyObj.SunTextureId = ""
                darkSkyObj.MoonTextureId = ""
                darkSkyObj.CelestialBodiesShown = false
                darkSkyObj.StarCount = 0
                darkSkyObj.Parent = _Lighting
            end
        end)
    end

    local function StopFulldark()
        fulldarkActive = false
        if fulldarkConn then
            fulldarkConn:Disconnect()
            fulldarkConn = nil
        end
        RestoreSkies()
        if fulldarkCtrl then
            fulldarkCtrl.SetState(false)
        end
    end

    fullbrightCtrl = _CreateSettingToggleRow(3, "Fullbright 全局高亮", function(enabled)
        if enabled then
            if fulldarkActive then StopFulldark() end
            fullbrightActive = true
            pcall(function()
                _Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                _Lighting.Brightness = 2
                _Lighting.ClockTime = 14
                _Lighting.FogEnd = 786432
                _Lighting.GlobalShadows = false
                _Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            end)
            fullbrightConn = _RS.RenderStepped:Connect(function()
                if fullbrightActive then
                    pcall(function()
                        _Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                        _Lighting.Brightness = 2
                        _Lighting.ClockTime = 14
                        _Lighting.FogEnd = 786432
                        _Lighting.GlobalShadows = false
                        _Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                    end)
                end
            end)
            ShowNotification("全局高亮已开启", "游戏视野已完全明亮化", 2.8)
        else
            StopFullbright()
            ShowNotification("全局高亮已关闭", "已恢复默认光照环境", 2.5)
        end
    end)

    fulldarkCtrl = _CreateSettingToggleRow(4, "Fulldark 天空变黑", function(enabled)
        if enabled then
            if fullbrightActive then StopFullbright() end
            fulldarkActive = true
            ApplyBlackSkyOnly()
            fulldarkConn = _RS.RenderStepped:Connect(function()
                if fulldarkActive then
                    pcall(function()
                        _Lighting.ClockTime = 0
                        if darkSkyObj and darkSkyObj.Parent ~= _Lighting then
                            darkSkyObj.Parent = _Lighting
                        end
                    end)
                end
            end)
            ShowNotification("天空变黑已开启", "仅将天空设为纯黑，不影响场景亮度", 2.8)
        else
            StopFulldark()
            ShowNotification("天空变黑已关闭", "已恢复原有天空", 2.5)
        end
    end)

    local blackScreenGui = nil

    local function HideFullscreenBlack()
        if blackScreenGui then
            blackScreenGui:Destroy()
            blackScreenGui = nil
        end
        if fullscreenBlackCtrl and fullscreenBlackCtrl.GetState() then
            fullscreenBlackCtrl.SetState(false)
        end
    end

    local function ShowFullscreenBlack()
        if blackScreenGui then
            blackScreenGui:Destroy()
            blackScreenGui = nil
        end
        blackScreenGui = Instance.new("ScreenGui", _CG)
        blackScreenGui.Name = "LMM_Fullscreen_Black"
        blackScreenGui.ResetOnSpawn = false
        blackScreenGui.DisplayOrder = 2147483646
        blackScreenGui.IgnoreGuiInset = true

        local blackBg = Instance.new("TextButton", blackScreenGui)
        blackBg.Size = UDim2.new(1, 0, 1, 0)
        blackBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        blackBg.BackgroundTransparency = 0
        blackBg.BorderSizePixel = 0
        blackBg.Text = ""
        blackBg.AutoButtonColor = false
        blackBg.ZIndex = 100

        local cancelBlackBtn = Instance.new("TextButton", blackScreenGui)
        cancelBlackBtn.Size = UDim2.new(0, 165, 0, 46)
        cancelBlackBtn.Position = UDim2.new(0.5, -82.5, 0.5, -23)
        cancelBlackBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 38)
        cancelBlackBtn.BackgroundTransparency = 0.08
        cancelBlackBtn.Text = "取消黑屏"
        cancelBlackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        cancelBlackBtn.Font = Enum.Font.GothamBold
        cancelBlackBtn.TextSize = 14
        cancelBlackBtn.ZIndex = 105
        cancelBlackBtn.AutoButtonColor = false
        Instance.new("UICorner", cancelBlackBtn).CornerRadius = UDim.new(0, 14)
        local cStroke = Instance.new("UIStroke", cancelBlackBtn)
        cStroke.Thickness = 1.4
        cStroke.Color = Color3.fromRGB(255, 255, 255)
        ApplyAccentGradient(cStroke)

        cancelBlackBtn.MouseEnter:Connect(function()
            Tween(cancelBlackBtn, {BackgroundColor3 = Color3.fromRGB(79, 70, 229)}, 0.15)
        end)
        cancelBlackBtn.MouseLeave:Connect(function()
            Tween(cancelBlackBtn, {BackgroundColor3 = Color3.fromRGB(22, 24, 38)}, 0.15)
        end)
        cancelBlackBtn.MouseButton1Click:Connect(function()
            PlaySound("click")
            HideFullscreenBlack()
            ShowNotification("全屏黑已关闭", "已恢复正常屏幕显示", 2.5)
        end)
    end

    fullscreenBlackCtrl = _CreateSettingToggleRow(5, "全屏黑", function(enabled)
        if enabled then
            ShowFullscreenBlack()
            ShowNotification("全屏黑已开启", "点击屏幕中央“取消黑屏”可关闭", 3.0)
        else
            HideFullscreenBlack()
            ShowNotification("全屏黑已关闭", "已恢复正常屏幕显示", 2.5)
        end
    end)

    local _DCB = Instance.new("TextButton", _Page4); _DCB.LayoutOrder = 6; _DCB.Size = UDim2.new(0.98, 0, 0, 42); _DCB.BackgroundColor3 = Color3.fromRGB(88, 101, 242); _DCB.BackgroundTransparency = 0.14; _DCB.Text = "JOIN DISCORD COMMUNITY"; _DCB.TextColor3 = Color3.fromRGB(255, 255, 255); _DCB.Font = Enum.Font.GothamBold; _DCB.TextSize = 13; _DCB.ZIndex = 2; _DCB.AutoButtonColor = false; Instance.new("UICorner", _DCB).CornerRadius = UDim.new(0, 12)
    local _DCBStroke = Instance.new("UIStroke", _DCB); _DCBStroke.Thickness = 1.1; _DCBStroke.Color = Color3.fromRGB(165, 180, 252)
    _DCB.MouseEnter:Connect(function() Tween(_DCB, {BackgroundColor3 = Color3.fromRGB(108, 121, 255), BackgroundTransparency = 0.06}, 0.2) end)
    _DCB.MouseLeave:Connect(function() Tween(_DCB, {BackgroundColor3 = Color3.fromRGB(88, 101, 242), BackgroundTransparency = 0.14}, 0.2) end)
    _DCB.MouseButton1Click:Connect(function() 
        PlaySound("click")
        setclipboard("https://discord.gg/ATbXDtNWE") 
        ShowNotification("Discord 链接已复制", "快去分享给好友加入社区吧", 3.0)
    end)

    _UIS.JumpRequest:Connect(function()
        if _G_LMM_88.v_infjump then
            local lChar = _LP.Character
            if lChar and lChar:FindFirstChildOfClass("Humanoid") then
                lChar:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    local _BG = Instance.new("BodyGyro"); local _BV = Instance.new("BodyVelocity")
    _BG.P = 9e4; _BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); _BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    local frozenPosition = nil

    -- ==================== 核心功能循环驱动 ====================
    _RS.Heartbeat:Connect(function()
        local lChar = _LP.Character
        if lChar and lChar:FindFirstChild("HumanoidRootPart") then
            local lHrp = lChar.HumanoidRootPart; local hum = lChar:FindFirstChildOfClass("Humanoid")
            if hum then
                if _G_LMM_88.v_0x3 then
                    pcall(function()
                        hum.WalkSpeed = _G_LMM_88.v_val_1
                    end)
                end
                
                if _G_LMM_88.v_freeze then
                    if not frozenPosition then
                        frozenPosition = lHrp.CFrame
                    end
                    lHrp.CFrame = frozenPosition
                    lHrp.Anchored = true
                    lHrp.AssemblyLinearVelocity = Vector3.zero
                    lHrp.AssemblyAngularVelocity = Vector3.zero
                    pcall(function()
                        hum.PlatformStand = true
                    end)
                else
                    if frozenPosition then
                        frozenPosition = nil
                        lHrp.Anchored = false
                        pcall(function()
                            hum.PlatformStand = false
                        end)
                    end
                end

                if _G_LMM_88.v_0x2 then 
                    for _, p in pairs(lChar:GetChildren()) do 
                        if p:IsA("BasePart") then p.CanCollide = false end 
                    end 
                end

                if _G_LMM_88.v_0x4 then
                    _BG.Parent = lHrp; _BV.Parent = lHrp; _BG.CFrame = _Cam.CFrame
                    _BV.Velocity = hum.MoveDirection.Magnitude > 0 and _Cam.CFrame.LookVector * _G_LMM_88.v_val_2 or Vector3.zero
                else 
                    _BG.Parent = nil; _BV.Parent = nil 
                end
            end
        end

        for _, p in pairs(_P:GetPlayers()) do
            if p ~= _LP then
                local tChar = p.Character
                if tChar and tChar:FindFirstChild("Humanoid") and tChar.Humanoid.Health > 0 then
                    local tHrp = tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Head")
                    
                    if _G_LMM_88.v_0x1 then
                        local hl = tChar:FindFirstChild("LMM_ESP")
                        if not hl then
                            hl = Instance.new("Highlight", tChar)
                            hl.Name = "LMM_ESP"
                        end
                        hl.Adornee = tChar
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.FillTransparency = 0.3
                        hl.OutlineTransparency = 0
                        hl.FillColor = _G_LMM_88.c_esp
                        hl.OutlineColor = _G_LMM_88.c_esp
                        hl.Enabled = true
                    else
                        local hl = tChar:FindFirstChild("LMM_ESP")
                        if hl then hl:Destroy() end
                    end

                    if _G_LMM_88.v_esp_box and tHrp then
                        local bb = tChar:FindFirstChild("LMM_BOX")
                        if not bb then
                            bb = Instance.new("BillboardGui", tChar)
                            bb.Name = "LMM_BOX"
                            bb.AlwaysOnTop = true
                            bb.Size = UDim2.new(4, 0, 5.5, 0)
                            local f = Instance.new("Frame", bb)
                            f.Size = UDim2.new(1, 0, 1, 0)
                            f.BackgroundTransparency = 1
                            local st = Instance.new("UIStroke", f)
                            st.Name = "S"
                            st.Thickness = 2
                        end
                        bb.Adornee = tHrp
                        if bb:FindFirstChild("Frame") and bb.Frame:FindFirstChild("S") then 
                            bb.Frame.S.Color = _G_LMM_88.c_box 
                        end
                        bb.Enabled = true
                    else
                        local bb = tChar:FindFirstChild("LMM_BOX")
                        if bb then bb:Destroy() end
                    end

                    if _G_LMM_88.v_esp_line and tHrp then
                        local beam = tHrp:FindFirstChild("LMM_LINE_FIX")
                        if not beam and lChar and lChar:FindFirstChild("HumanoidRootPart") then
                            beam = Instance.new("Beam", tHrp)
                            beam.Name = "LMM_LINE_FIX"
                            local a0 = lChar.HumanoidRootPart:FindFirstChild("LMM_A0") or Instance.new("Attachment", lChar.HumanoidRootPart)
                            a0.Name = "LMM_A0"
                            beam.Attachment0 = a0
                            beam.Attachment1 = Instance.new("Attachment", tHrp)
                            beam.Width0 = 0.1
                            beam.Width1 = 0.1
                            beam.FaceCamera = true
                        end
                        if beam then beam.Color = ColorSequence.new(_G_LMM_88.c_line) end
                    else
                        if tHrp then
                            local beam = tHrp:FindFirstChild("LMM_LINE_FIX")
                            if beam then beam:Destroy() end
                        end
                    end
                else
                    if tChar then
                        local hl = tChar:FindFirstChild("LMM_ESP")
                        if hl then hl:Destroy() end
                        local bb = tChar:FindFirstChild("LMM_BOX")
                        if bb then bb:Destroy() end
                    end
                end
            end
        end
    end)

    -- 右上角关闭按钮 X
    local function _Ctrl(t, x, c, hoverC, f, fontObj, textPx, soundType)
        local sz = 34
        local b = Instance.new("TextButton", _TB)
        b.Size = UDim2.new(0, sz, 0, sz)
        b.Position = UDim2.new(1, x, 0.5, -math.floor(sz / 2))
        b.Text = t
        b.BackgroundColor3 = c
        b.BackgroundTransparency = 0.2
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = fontObj or Enum.Font.Gotham
        b.TextSize = textPx or 15
        b.ZIndex = 3
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        
        local bStroke = Instance.new("UIStroke", b)
        bStroke.Thickness = 1
        bStroke.Color = Color3.fromRGB(255, 255, 255)
        bStroke.Transparency = 0.45
        
        b.MouseEnter:Connect(function() 
            Tween(b, {BackgroundColor3 = hoverC, BackgroundTransparency = 0.06}, 0.2) 
            Tween(bStroke, {Transparency = 0.15}, 0.2) 
        end)
        b.MouseLeave:Connect(function() 
            Tween(b, {BackgroundColor3 = c, BackgroundTransparency = 0.2}, 0.2) 
            Tween(bStroke, {Transparency = 0.45}, 0.2) 
        end)
        b.MouseButton1Click:Connect(function()
            PlaySound(soundType or "click")
            f()
        end)
    end

    _Ctrl("X", -46, Color3.fromRGB(239, 68, 68), Color3.fromRGB(255, 90, 90), function() 
        _OpenConfirmDialog("确定要退出此脚本吗？", "刘某某脚本 V4.2.50 (beta)", "确认退出", function()
            PlaySound("close")
            HideFullscreenBlack()
            _TopCapsule.Visible = false
            pcall(function() _LP.Character.HumanoidRootPart.Anchored = false end)
            Tween(_M, {Size = UDim2.new(0, 565, 0, 369), BackgroundTransparency = 1}, 0.3)
            for _, v in pairs(_M:GetDescendants()) do if v:IsA("UIStroke") or v:IsA("ImageLabel") or v:IsA("TextLabel") or v:IsA("TextButton") then Tween(v, {Transparency = 1}, 0.3) end end
            task.wait(0.3); _S:Destroy()
        end)
    end, Enum.Font.GothamBold, 20, "click")

    -- 右下角 ◢ 拖动缩放手柄
    _Resizer = Instance.new("TextButton", _M)
    _Resizer.Size = UDim2.new(0, 26, 0, 26)
    _Resizer.Position = UDim2.new(1, -26, 1, -26)
    _Resizer.BackgroundTransparency = 1
    _Resizer.Text = "◢"
    _Resizer.TextColor3 = Color3.fromRGB(165, 175, 220)
    _Resizer.TextSize = 15
    _Resizer.Font = Enum.Font.GothamBold
    _Resizer.ZIndex = 5

    local resizing = false
    local resizeStart, startSize
    _Resizer.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = i.Position
            startSize = _M.AbsoluteSize
        end
    end)
    _UIS.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - resizeStart
            _M.Size = UDim2.new(0, math.clamp(startSize.X + delta.X, 460, 840), 0, math.clamp(startSize.Y + delta.Y, 340, 640))
        end
    end)
    _UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    local _drag, _dStart, _sPos
    _TB.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = true; _dStart = i.Position; _sPos = _M.Position end end)
    _UIS.InputChanged:Connect(function(i) if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - _dStart; _M.Position = UDim2.new(_sPos.X.Scale, _sPos.X.Offset + d.X, _sPos.Y.Scale, _sPos.Y.Offset + d.Y) end end)
    _UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = false end end)
end

_LMM_BOOT()
