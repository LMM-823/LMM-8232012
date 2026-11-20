-- [[ 刘某某脚本 V4.2.30 (beta) | 重进直接自动启动主界面（非仅弹窗） ]]

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
    local _HS = game:GetService("HttpService")

    local _LP = _P.LocalPlayer
    while not _LP do
        task.wait(0.1)
        _LP = _P.LocalPlayer
    end
    local _Cam = workspace.CurrentCamera

    local ACCOUNT_DATA_FILE = "LMM_Account_AutoStart.json"
    local SELF_SOURCE_CACHE = "LMM_SelfSource.lua"
    local AUTOEXEC_PATHS = {
        "autoexec/LMM_AutoStart.lua",
        "Autoexec/LMM_AutoStart.lua"
    }

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

    -- ==================== 完整源码提取与一进游戏自动启动 ====================
    local function DetectLiveSource()
        local found = nil
        pcall(function()
            if script and script:IsA("LocalScript") and script.Source and #script.Source > 1000 then
                found = script.Source
            end
        end)
        if not found then
            pcall(function()
                if debug and debug.info then
                    local infoSrc = debug.info(1, "s")
                    if type(infoSrc) == "string" and infoSrc:sub(1, 1) == "@" then
                        local path = infoSrc:sub(2)
                        if isfile and isfile(path) then
                            local content = readfile(path)
                            if content and #content > 1000 then
                                found = content
                            end
                        end
                    end
                end
            end)
        end
        return found
    end

    local function GetFullScriptCode()
        local liveSrc = DetectLiveSource()
        if liveSrc then
            pcall(function()
                if writefile then
                    writefile(SELF_SOURCE_CACHE, liveSrc)
                end
            end)
            return liveSrc, true
        end

        local cachedSrc = nil
        pcall(function()
            if isfile and isfile(SELF_SOURCE_CACHE) then
                local content = readfile(SELF_SOURCE_CACHE)
                if content and #content > 1000 then
                    cachedSrc = content
                end
            end
        end)
        if cachedSrc then
            return cachedSrc, true
        end

        return nil, false
    end

    local function BuildDirectAutoRunPayload()
        local fullCode, hasFull = GetFullScriptCode()
        if hasFull and fullCode then
            local wrapper = [[
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait(0.15) until game:GetService("Players").LocalPlayer
]] .. fullCode
            return wrapper, true
        end

        -- 兜底：若当前执行环境无法读取自身源码，则保留状态文件并在重进时尝试读取缓存源码
        local fallbackLoader = [[
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait(0.15) until game:GetService("Players").LocalPlayer
local _Http = game:GetService("HttpService")
local okCfg, rawCfg = pcall(function()
    if isfile and isfile("LMM_Account_AutoStart.json") then
        return readfile("LMM_Account_AutoStart.json")
    end
end)
if okCfg and rawCfg then
    local okJson, cfg = pcall(function() return _Http:JSONDecode(rawCfg) end)
    if okJson and cfg and cfg.enabled == true then
        local okCache, cached = pcall(function()
            if isfile and isfile("LMM_SelfSource.lua") then
                return readfile("LMM_SelfSource.lua")
            end
        end)
        if okCache and cached and #cached > 1000 then
            local fn = loadstring(cached)
            if fn then pcall(fn) end
        end
    end
end
]]
        return fallbackLoader, false
    end

    local function IsAccountCreated()
        local created = false
        pcall(function()
            if isfile and isfile(ACCOUNT_DATA_FILE) then
                local raw = readfile(ACCOUNT_DATA_FILE)
                local data = _HS:JSONDecode(raw)
                if data and data.enabled == true then
                    created = true
                end
            end
        end)
        return created
    end

    local function SaveAccountAutoStart()
        local payload, hasFull = BuildDirectAutoRunPayload()
        local wroteFile = false

        pcall(function()
            if writefile then
                local info = _HS:JSONEncode({
                    enabled = true,
                    scriptName = "刘某某脚本",
                    userId = _LP.UserId,
                    username = _LP.Name,
                    hasFullSource = hasFull,
                    createdAt = os.time()
                })
                writefile(ACCOUNT_DATA_FILE, info)

                if makefolder and isfolder then
                    if not isfolder("autoexec") then pcall(makefolder, "autoexec") end
                end

                for _, path in ipairs(AUTOEXEC_PATHS) do
                    local ok = pcall(writefile, path, payload)
                    if ok then wroteFile = true end
                end
            end
        end)

        pcall(function()
            local qot = queue_on_teleport
                or (syn and syn.queue_on_teleport)
                or (fluxus and fluxus.queue_on_teleport)
                or (getgenv and getgenv().queue_on_teleport)
            if qot then
                qot(payload)
            end
        end)

        return wroteFile, hasFull
    end

    local function RemoveAccountAutoStart()
        pcall(function()
            if isfile and delfile then
                if isfile(ACCOUNT_DATA_FILE) then delfile(ACCOUNT_DATA_FILE) end
                for _, path in ipairs(AUTOEXEC_PATHS) do
                    if isfile(path) then delfile(path) end
                end
            elseif writefile then
                writefile(ACCOUNT_DATA_FILE, '{"enabled":false}')
                for _, path in ipairs(AUTOEXEC_PATHS) do
                    pcall(writefile, path, "-- disabled")
                end
            end
        end)
    end

    task.defer(function()
        DetectLiveSource()
        if IsAccountCreated() then
            SaveAccountAutoStart()
        end
    end)

    if _CG:FindFirstChild("LMM_Final_V400") then _CG.LMM_Final_V400:Destroy() end
    local _S = Instance.new("ScreenGui", _CG); _S.Name = "LMM_Final_V400"
    _S.ResetOnSpawn = false
    _S.DisplayOrder = 9999
    _S.IgnoreGuiInset = true

    -- ==================== 右下角通知管理（气泡堆叠） ====================
    local activeNotifications = {}

    local function UpdateNotificationPositions()
        for i, cardData in ipairs(activeNotifications) do
            local targetY = -85 - ((i - 1) * 76)
            Tween(cardData.Card, {Position = UDim2.new(1, -280, 1, targetY)}, 0.3)
        end
    end

    local function ShowNotification(title, desc)
        local notifGui = Instance.new("ScreenGui", _CG)
        notifGui.Name = "LMM_Notification"
        notifGui.ResetOnSpawn = false
        notifGui.DisplayOrder = 2147483647
        notifGui.IgnoreGuiInset = true

        local card = Instance.new("Frame", notifGui)
        card.Size = UDim2.new(0, 265, 0, 66)
        card.Position = UDim2.new(1, 290, 1, -85)
        card.BackgroundColor3 = Color3.fromRGB(15, 16, 26)
        card.BackgroundTransparency = 0.08
        card.BorderSizePixel = 0
        card.ZIndex = 10000000
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
        
        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Thickness = 1.2
        cardStroke.Color = Color3.fromRGB(129, 140, 248)
        cardStroke.Transparency = 0.45
        ApplyAccentGradient(cardStroke)

        local accentBar = Instance.new("Frame", card)
        accentBar.Size = UDim2.new(0, 3, 0, 36)
        accentBar.Position = UDim2.new(0, 10, 0.5, -18)
        accentBar.BackgroundColor3 = Color3.fromRGB(129, 140, 248)
        accentBar.BorderSizePixel = 0
        accentBar.ZIndex = 10000001
        Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)
        ApplyAccentGradient(accentBar, Color3.fromRGB(129, 140, 248), Color3.fromRGB(192, 132, 252), 90)

        local titleLbl = Instance.new("TextLabel", card)
        titleLbl.Size = UDim2.new(1, -30, 0, 22)
        titleLbl.Position = UDim2.new(0, 22, 0, 11)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = title
        titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 13
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.ZIndex = 10000001

        local descLbl = Instance.new("TextLabel", card)
        descLbl.Size = UDim2.new(1, -30, 0, 20)
        descLbl.Position = UDim2.new(0, 22, 0, 35)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = desc
        descLbl.TextColor3 = Color3.fromRGB(180, 184, 215)
        descLbl.Font = Enum.Font.GothamMedium
        descLbl.TextSize = 11
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.ZIndex = 10000001

        local notifData = {Card = card, Gui = notifGui}
        table.insert(activeNotifications, 1, notifData)
        UpdateNotificationPositions()

        task.spawn(function()
            task.wait(2.8)
            for idx, item in ipairs(activeNotifications) do
                if item == notifData then
                    table.remove(activeNotifications, idx)
                    break
                end
            end
            UpdateNotificationPositions()
            Tween(card, {Position = UDim2.new(1, 290, 1, card.Position.Y.Offset)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.3)
            notifGui:Destroy()
        end)
    end

    -- ==================== 模糊背景加载动画 ====================
    local blurEffect = Instance.new("BlurEffect", _Lighting)
    blurEffect.Size = 18

    local _LoadGui = Instance.new("Frame", _S)
    _LoadGui.Size = UDim2.new(2, 0, 2, 0)
    _LoadGui.Position = UDim2.new(-0.5, 0, -0.5, 0)
    _LoadGui.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
    _LoadGui.BackgroundTransparency = 0.3
    _LoadGui.BorderSizePixel = 0
    _LoadGui.ZIndex = 999999

    local _CenterCard = Instance.new("Frame", _LoadGui)
    _CenterCard.Size = UDim2.new(0, 410, 0, 175)
    _CenterCard.Position = UDim2.new(0.5, -205, 0.5, -87.5)
    _CenterCard.BackgroundColor3 = Color3.fromRGB(14, 15, 24)
    _CenterCard.BackgroundTransparency = 0.06
    _CenterCard.BorderSizePixel = 0
    _CenterCard.ZIndex = 1000000
    Instance.new("UICorner", _CenterCard).CornerRadius = UDim.new(0, 22)
    local _CenterStroke = Instance.new("UIStroke", _CenterCard)
    _CenterStroke.Thickness = 1.6
    _CenterStroke.Color = Color3.fromRGB(255, 255, 255)
    _CenterStroke.Transparency = 0.25
    ApplyAccentGradient(_CenterStroke)

    local _LoadText = Instance.new("TextLabel", _CenterCard)
    _LoadText.Size = UDim2.new(1, 0, 0, 30)
    _LoadText.Position = UDim2.new(0, 0, 0, 28)
    _LoadText.BackgroundTransparency = 1
    _LoadText.Text = "刘某某脚本 V4.2.30 (beta) 加载中..."
    _LoadText.TextColor3 = Color3.fromRGB(255, 255, 255)
    _LoadText.Font = Enum.Font.GothamBold
    _LoadText.TextSize = 16
    _LoadText.TextXAlignment = Enum.TextXAlignment.Center
    _LoadText.ZIndex = 1000001

    local _BarBg = Instance.new("Frame", _CenterCard)
    _BarBg.Size = UDim2.new(0.84, 0, 0, 10)
    _BarBg.Position = UDim2.new(0.08, 0, 0, 80)
    _BarBg.BackgroundColor3 = Color3.fromRGB(24, 26, 42)
    _BarBg.BorderSizePixel = 0
    _BarBg.ZIndex = 1000001
    Instance.new("UICorner", _BarBg).CornerRadius = UDim.new(1, 0)

    local _BarFill = Instance.new("Frame", _BarBg)
    _BarFill.Size = UDim2.new(0, 0, 1, 0)
    _BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _BarFill.BorderSizePixel = 0
    _BarFill.ZIndex = 1000002
    Instance.new("UICorner", _BarFill).CornerRadius = UDim.new(1, 0)
    ApplyAccentGradient(_BarFill, Color3.fromRGB(99, 102, 241), Color3.fromRGB(192, 132, 252), 0)

    local _PercentText = Instance.new("TextLabel", _CenterCard)
    _PercentText.Size = UDim2.new(1, 0, 0, 24)
    _PercentText.Position = UDim2.new(0, 0, 0, 108)
    _PercentText.BackgroundTransparency = 1
    _PercentText.Text = "0%"
    _PercentText.TextColor3 = Color3.fromRGB(185, 190, 225)
    _PercentText.Font = Enum.Font.GothamBold
    _PercentText.TextSize = 12
    _PercentText.TextXAlignment = Enum.TextXAlignment.Center
    _PercentText.ZIndex = 1000001

    task.spawn(function()
        for i = 1, 100 do
            _BarFill.Size = UDim2.new(i / 100, 0, 1, 0)
            _PercentText.Text = i .. "%"
            task.wait(0.015)
        end
    end)

    -- ==================== 主界面容器（严格圆角裁剪，无直角露出） ====================
    local _M = Instance.new("Frame", _S)
    _M.Size = UDim2.new(0, 595, 0, 390); _M.Position = UDim2.new(0.5, -297.5, 0.5, -195)
    _M.BackgroundColor3 = Color3.fromRGB(11, 12, 20); _M.BackgroundTransparency = 0.22; _M.BorderSizePixel = 0; _M.Visible = false
    _M.ClipsDescendants = true
    Instance.new("UICorner", _M).CornerRadius = UDim.new(0, 20)

    local _MainStroke = Instance.new("UIStroke", _M)
    _MainStroke.Thickness = 1.4
    _MainStroke.Color = Color3.fromRGB(255, 255, 255)
    _MainStroke.Transparency = 0.45
    ApplyAccentGradient(_MainStroke, Color3.fromRGB(129, 140, 248), Color3.fromRGB(168, 85, 247), 45)

    local _BgImage = Instance.new("ImageLabel", _M)
    _BgImage.Size = UDim2.new(1, 0, 1, 0); _BgImage.BackgroundTransparency = 1; _BgImage.BorderSizePixel = 0
    _BgImage.Image = "rbxassetid://5430597512"; _BgImage.ImageTransparency = 0.22
    _BgImage.ScaleType = Enum.ScaleType.Crop; _BgImage.ZIndex = 0
    Instance.new("UICorner", _BgImage).CornerRadius = UDim.new(0, 20)

    local _TopGlow = Instance.new("Frame", _M)
    _TopGlow.Size = UDim2.new(1, 0, 0, 54)
    _TopGlow.Position = UDim2.new(0, 0, 0, 0)
    _TopGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _TopGlow.BackgroundTransparency = 0.94
    _TopGlow.BorderSizePixel = 0
    _TopGlow.ZIndex = 1
    Instance.new("UICorner", _TopGlow).CornerRadius = UDim.new(0, 20)
    ApplyAccentGradient(_TopGlow, Color3.fromRGB(99, 102, 241), Color3.fromRGB(15, 15, 25), 90)

    task.spawn(function()
        task.wait(1.75)
        Tween(_CenterCard, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(_LoadGui, {BackgroundTransparency = 1}, 0.35)
        Tween(blurEffect, {Size = 0}, 0.35)
        task.wait(0.35)
        _LoadGui:Destroy()
        pcall(function() blurEffect:Destroy() end)
        
        _M.Visible = true
        _M.Size = UDim2.new(0, 535, 0, 350)
        Tween(_M, {Size = UDim2.new(0, 595, 0, 390)}, 0.4, Enum.EasingStyle.Back)
        
        PlaySound("open")
        ShowNotification("刘某某脚本", "刘某某脚本开启完毕")
    end)

    local _TB = Instance.new("Frame", _M); _TB.Size = UDim2.new(1, 0, 0, 54); _TB.BackgroundTransparency = 1; _TB.Active = true; _TB.ZIndex = 2
    
    local _BrandBadge = Instance.new("Frame", _TB)
    _BrandBadge.Size = UDim2.new(0, 28, 0, 28)
    _BrandBadge.Position = UDim2.new(0, 16, 0.5, -14)
    _BrandBadge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _BrandBadge.BorderSizePixel = 0
    _BrandBadge.ZIndex = 3
    Instance.new("UICorner", _BrandBadge).CornerRadius = UDim.new(0, 9)
    ApplyAccentGradient(_BrandBadge, Color3.fromRGB(99, 102, 241), Color3.fromRGB(168, 85, 247), 45)

    local _BrandLetter = Instance.new("TextLabel", _BrandBadge)
    _BrandLetter.Size = UDim2.new(1, 0, 1, 0)
    _BrandLetter.BackgroundTransparency = 1
    _BrandLetter.Text = "L"
    _BrandLetter.TextColor3 = Color3.fromRGB(255, 255, 255)
    _BrandLetter.Font = Enum.Font.GothamBold
    _BrandLetter.TextSize = 15
    _BrandLetter.ZIndex = 4

    local _Title = Instance.new("TextLabel", _TB)
    _Title.Size = UDim2.new(1, -185, 1, 0); _Title.Position = UDim2.new(0, 52, 0, 0); _Title.Text = "刘某某脚本 V4.2.30 <font size='11' color='rgb(165, 180, 252)'>beta</font>"; _Title.RichText = true; _Title.Font = Enum.Font.GothamBold; _Title.TextSize = 14.5; _Title.TextColor3 = Color3.fromRGB(255, 255, 255); _Title.BackgroundTransparency = 1; _Title.TextXAlignment = Enum.TextXAlignment.Left; _Title.ZIndex = 2

    local _HeaderLine = Instance.new("Frame", _M)
    _HeaderLine.Size = UDim2.new(1, -28, 0, 1); _HeaderLine.Position = UDim2.new(0, 14, 0, 54)
    _HeaderLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255); _HeaderLine.BackgroundTransparency = 0.88; _HeaderLine.BorderSizePixel = 0; _HeaderLine.ZIndex = 2

    local _Sidebar = Instance.new("Frame", _M)
    _Sidebar.Size = UDim2.new(0, 152, 1, -68); _Sidebar.Position = UDim2.new(0, 12, 0, 62); _Sidebar.BackgroundTransparency = 1; _Sidebar.ZIndex = 2
    local _SideLayout = Instance.new("UIListLayout", _Sidebar)
    _SideLayout.Padding = UDim.new(0, 7); _SideLayout.HorizontalAlignment = "Center"; _SideLayout.SortOrder = "LayoutOrder"

    local _SplitLine = Instance.new("Frame", _M)
    _SplitLine.Size = UDim2.new(0, 1, 1, -68); _SplitLine.Position = UDim2.new(0, 171, 0, 62)
    _SplitLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255); _SplitLine.BackgroundTransparency = 0.90; _SplitLine.BorderSizePixel = 0; _SplitLine.ZIndex = 2

    local _ContentContainer = Instance.new("Frame", _M)
    _ContentContainer.Size = UDim2.new(1, -186, 1, -68); _ContentContainer.Position = UDim2.new(0, 179, 0, 62); _ContentContainer.BackgroundTransparency = 1; _ContentContainer.ZIndex = 2
    _ContentContainer.ClipsDescendants = true

    local function _CreatePage(order)
        local p = Instance.new("ScrollingFrame", _ContentContainer)
        p.Size = UDim2.new(1, 0, 1, 0); p.Position = UDim2.new(0, 0, 0, 0)
        p.BackgroundTransparency = 1; p.BorderSizePixel = 0; p.ScrollBarThickness = 4
        p.ScrollBarImageColor3 = Color3.fromRGB(129, 140, 248); p.ScrollBarImageTransparency = 0.15
        p.Active = true; p.ScrollingDirection = Enum.ScrollingDirection.Y
        p.AutomaticCanvasSize = Enum.AutomaticSize.Y
        p.CanvasSize = UDim2.new(0, 0, 0, 0)
        p.Visible = (order == 1); p.ZIndex = 2

        local l = Instance.new("UIListLayout", p)
        l.Padding = UDim.new(0, 9); l.HorizontalAlignment = Enum.HorizontalAlignment.Center; l.SortOrder = Enum.SortOrder.LayoutOrder
        
        local pad = Instance.new("UIPadding", p)
        pad.PaddingRight = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 14); pad.PaddingTop = UDim.new(0, 2)
        return p
    end

    local _Page1 = _CreatePage(1); local _Page2 = _CreatePage(2); local _Page5 = _CreatePage(3); local _Page6 = _CreatePage(4); local _Page3 = _CreatePage(5); local _Page4 = _CreatePage(6)
    local _Tabs = {}

    local function _CreateTabBtn(name, order, targetPage)
        local b = Instance.new("TextButton", _Sidebar)
        b.LayoutOrder = order; b.Size = UDim2.new(1, 0, 0, 35)
        b.BackgroundColor3 = (order == 1) and Color3.fromRGB(36, 39, 66) or Color3.fromRGB(17, 18, 30)
        b.BackgroundTransparency = (order == 1) and 0.25 or 0.72
        b.Text = "    " .. name; b.Font = Enum.Font.GothamBold; b.TextSize = 11.5
        b.TextColor3 = (order == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(175, 180, 210)
        b.TextXAlignment = Enum.TextXAlignment.Left; b.ZIndex = 2; b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 11)
        
        local bStroke = Instance.new("UIStroke", b)
        bStroke.Thickness = 1
        bStroke.Color = Color3.fromRGB(129, 140, 248)
        bStroke.Transparency = (order == 1) and 0.45 or 0.92

        local indicator = Instance.new("Frame", b)
        indicator.Size = UDim2.new(0, 3.5, 0.58, 0); indicator.Position = UDim2.new(0, 2, 0.21, 0)
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255); indicator.BorderSizePixel = 0
        indicator.BackgroundTransparency = (order == 1) and 0 or 1
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
        ApplyAccentGradient(indicator, Color3.fromRGB(129, 140, 248), Color3.fromRGB(192, 132, 252), 90)

        _Tabs[b] = {page = targetPage, indicator = indicator, stroke = bStroke, order = order}
        
        b.MouseEnter:Connect(function()
            if _Tabs[b].page.Visible then return end
            Tween(b, {BackgroundColor3 = Color3.fromRGB(26, 28, 46), BackgroundTransparency = 0.45, TextColor3 = Color3.fromRGB(230, 234, 255)}, 0.2)
            Tween(bStroke, {Transparency = 0.7}, 0.2)
        end)
        b.MouseLeave:Connect(function()
            if _Tabs[b].page.Visible then return end
            Tween(b, {BackgroundColor3 = Color3.fromRGB(17, 18, 30), BackgroundTransparency = 0.72, TextColor3 = Color3.fromRGB(175, 180, 210)}, 0.2)
            Tween(bStroke, {Transparency = 0.92}, 0.2)
        end)
        b.MouseButton1Click:Connect(function()
            PlaySound("click")
            for btn, data in pairs(_Tabs) do
                data.page.Visible = (btn == b)
                if btn == b then
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(36, 39, 66), BackgroundTransparency = 0.25, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                    Tween(data.stroke, {Transparency = 0.45}, 0.2)
                    Tween(data.indicator, {BackgroundTransparency = 0, Size = UDim2.new(0, 3.5, 0.62, 0), Position = UDim2.new(0, 2, 0.19, 0)}, 0.2)
                else
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(17, 18, 30), BackgroundTransparency = 0.72, TextColor3 = Color3.fromRGB(175, 180, 210)}, 0.2)
                    Tween(data.stroke, {Transparency = 0.92}, 0.2)
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
        alertText.Text = titleMsg .. "\n<font size='11' color='rgb(180,185,215)'>" .. subMsg .. "</font>"; alertText.RichText = true
        alertText.TextColor3 = Color3.fromRGB(255, 255, 255); alertText.Font = Enum.Font.GothamBold; alertText.TextSize = 14.5; alertText.TextWrapped = true

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

    -- ==================== “账号”页面：玩家信息、当前游戏与自动启动管理 ====================
    local _DataCard = Instance.new("Frame", _Page1)
    _DataCard.LayoutOrder = 1
    _DataCard.Size = UDim2.new(0.98, 0, 0, 126)
    _DataCard.BackgroundColor3 = Color3.fromRGB(16, 17, 28)
    _DataCard.BackgroundTransparency = 0.42
    _DataCard.ZIndex = 2
    Instance.new("UICorner", _DataCard).CornerRadius = UDim.new(0, 14)
    local _DataStroke = Instance.new("UIStroke", _DataCard)
    _DataStroke.Thickness = 1
    _DataStroke.Color = Color3.fromRGB(70, 75, 110)

    local _AvatarRing = Instance.new("Frame", _DataCard)
    _AvatarRing.Size = UDim2.new(0, 84, 0, 84)
    _AvatarRing.Position = UDim2.new(0, 14, 0.5, -42)
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
    _NameLabel.Size = UDim2.new(1, -116, 0, 24)
    _NameLabel.Position = UDim2.new(0, 112, 0, 18)
    _NameLabel.BackgroundTransparency = 1
    _NameLabel.Text = "玩家: " .. _LP.DisplayName .. " (@" .. _LP.Name .. ")"
    _NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    _NameLabel.Font = Enum.Font.GothamBold
    _NameLabel.TextSize = 13.5
    _NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    _NameLabel.ZIndex = 3

    local _RobuxLabel = Instance.new("TextLabel", _DataCard)
    _RobuxLabel.Size = UDim2.new(1, -116, 0, 22)
    _RobuxLabel.Position = UDim2.new(0, 112, 0, 48)
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
    _ServerLabel.Size = UDim2.new(1, -116, 0, 22)
    _ServerLabel.Position = UDim2.new(0, 112, 0, 76)
    _ServerLabel.BackgroundTransparency = 1
    _ServerLabel.Text = "服务器人数: 正在统计..."
    _ServerLabel.TextColor3 = Color3.fromRGB(180, 185, 215)
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
    _GameCard.Size = UDim2.new(0.98, 0, 0, 82)
    _GameCard.BackgroundColor3 = Color3.fromRGB(16, 17, 28)
    _GameCard.BackgroundTransparency = 0.42
    _GameCard.ZIndex = 2
    Instance.new("UICorner", _GameCard).CornerRadius = UDim.new(0, 14)
    local _GameCardStroke = Instance.new("UIStroke", _GameCard)
    _GameCardStroke.Thickness = 1
    _GameCardStroke.Color = Color3.fromRGB(70, 75, 110)

    local _GameIconImg = Instance.new("ImageLabel", _GameCard)
    _GameIconImg.Size = UDim2.new(0, 54, 0, 54)
    _GameIconImg.Position = UDim2.new(0, 14, 0.5, -27)
    _GameIconImg.BackgroundColor3 = Color3.fromRGB(24, 26, 42)
    _GameIconImg.ZIndex = 3
    Instance.new("UICorner", _GameIconImg).CornerRadius = UDim.new(0, 12)

    local _GameTitleLabel = Instance.new("TextLabel", _GameCard)
    _GameTitleLabel.Size = UDim2.new(1, -86, 0, 22)
    _GameTitleLabel.Position = UDim2.new(0, 80, 0, 18)
    _GameTitleLabel.BackgroundTransparency = 1
    _GameTitleLabel.Text = "当前游戏: 获取中..."
    _GameTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    _GameTitleLabel.Font = Enum.Font.GothamBold
    _GameTitleLabel.TextSize = 13
    _GameTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    _GameTitleLabel.ZIndex = 3

    local _GameIdLabel = Instance.new("TextLabel", _GameCard)
    _GameIdLabel.Size = UDim2.new(1, -86, 0, 20)
    _GameIdLabel.Position = UDim2.new(0, 80, 0, 44)
    _GameIdLabel.BackgroundTransparency = 1
    _GameIdLabel.Text = "PlaceId: " .. game.PlaceId
    _GameIdLabel.TextColor3 = Color3.fromRGB(180, 185, 215)
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

    local _CreateAccBtn = Instance.new("TextButton", _Page1)
    _CreateAccBtn.LayoutOrder = 3
    _CreateAccBtn.Size = UDim2.new(0.98, 0, 0, 52)
    _CreateAccBtn.BackgroundColor3 = Color3.fromRGB(16, 17, 28)
    _CreateAccBtn.BackgroundTransparency = 0.42
    _CreateAccBtn.Text = ""
    _CreateAccBtn.ZIndex = 2
    _CreateAccBtn.AutoButtonColor = false
    Instance.new("UICorner", _CreateAccBtn).CornerRadius = UDim.new(0, 14)
    local _CreateAccStroke = Instance.new("UIStroke", _CreateAccBtn)
    _CreateAccStroke.Thickness = 1
    _CreateAccStroke.Color = IsAccountCreated() and Color3.fromRGB(34, 197, 94) or Color3.fromRGB(70, 75, 110)

    local _CreateAccIcon = Instance.new("Frame", _CreateAccBtn)
    _CreateAccIcon.Size = UDim2.new(0, 32, 0, 32)
    _CreateAccIcon.Position = UDim2.new(0, 12, 0.5, -16)
    _CreateAccIcon.BackgroundColor3 = IsAccountCreated() and Color3.fromRGB(22, 101, 52) or Color3.fromRGB(49, 46, 129)
    _CreateAccIcon.BackgroundTransparency = 0.25
    _CreateAccIcon.BorderSizePixel = 0
    _CreateAccIcon.ZIndex = 3
    Instance.new("UICorner", _CreateAccIcon).CornerRadius = UDim.new(0, 9)

    local _CreateAccIconTxt = Instance.new("TextLabel", _CreateAccIcon)
    _CreateAccIconTxt.Size = UDim2.new(1, 0, 1, 0)
    _CreateAccIconTxt.BackgroundTransparency = 1
    _CreateAccIconTxt.Text = "＋"
    _CreateAccIconTxt.TextColor3 = IsAccountCreated() and Color3.fromRGB(74, 222, 128) or Color3.fromRGB(165, 180, 252)
    _CreateAccIconTxt.Font = Enum.Font.Gotham
    _CreateAccIconTxt.TextSize = 17
    _CreateAccIconTxt.ZIndex = 4

    local _CreateAccLabel = Instance.new("TextLabel", _CreateAccBtn)
    _CreateAccLabel.Size = UDim2.new(1, -155, 0, 20)
    _CreateAccLabel.Position = UDim2.new(0, 54, 0, 8)
    _CreateAccLabel.BackgroundTransparency = 1
    _CreateAccLabel.Text = "创建账号"
    _CreateAccLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    _CreateAccLabel.Font = Enum.Font.GothamBold
    _CreateAccLabel.TextSize = 13
    _CreateAccLabel.TextXAlignment = Enum.TextXAlignment.Left
    _CreateAccLabel.ZIndex = 3

    local _CreateAccSub = Instance.new("TextLabel", _CreateAccBtn)
    _CreateAccSub.Size = UDim2.new(1, -155, 0, 16)
    _CreateAccSub.Position = UDim2.new(0, 54, 0, 28)
    _CreateAccSub.BackgroundTransparency = 1
    _CreateAccSub.Text = "一进游戏自动开启主界面（需开启 Auto Execute）"
    _CreateAccSub.TextColor3 = Color3.fromRGB(165, 170, 200)
    _CreateAccSub.Font = Enum.Font.GothamMedium
    _CreateAccSub.TextSize = 10.5
    _CreateAccSub.TextXAlignment = Enum.TextXAlignment.Left
    _CreateAccSub.ZIndex = 3

    local _CreateAccTag = Instance.new("TextLabel", _CreateAccBtn)
    _CreateAccTag.Size = UDim2.new(0, 84, 0, 26)
    _CreateAccTag.Position = UDim2.new(1, -96, 0.5, -13)
    _CreateAccTag.BackgroundColor3 = IsAccountCreated() and Color3.fromRGB(20, 83, 45) or Color3.fromRGB(36, 39, 66)
    _CreateAccTag.BackgroundTransparency = 0.2
    _CreateAccTag.Text = IsAccountCreated() and "已开启自启" or "点击创建"
    _CreateAccTag.TextColor3 = IsAccountCreated() and Color3.fromRGB(74, 222, 128) or Color3.fromRGB(190, 196, 240)
    _CreateAccTag.Font = Enum.Font.GothamBold
    _CreateAccTag.TextSize = 11
    _CreateAccTag.ZIndex = 3
    Instance.new("UICorner", _CreateAccTag).CornerRadius = UDim.new(0, 8)

    local _DeleteAccBtn = Instance.new("TextButton", _Page1)
    _DeleteAccBtn.LayoutOrder = 4
    _DeleteAccBtn.Size = UDim2.new(0.98, 0, 0, 52)
    _DeleteAccBtn.BackgroundColor3 = Color3.fromRGB(16, 17, 28)
    _DeleteAccBtn.BackgroundTransparency = 0.42
    _DeleteAccBtn.Text = ""
    _DeleteAccBtn.ZIndex = 2
    _DeleteAccBtn.AutoButtonColor = false
    Instance.new("UICorner", _DeleteAccBtn).CornerRadius = UDim.new(0, 14)
    local _DeleteAccStroke = Instance.new("UIStroke", _DeleteAccBtn)
    _DeleteAccStroke.Thickness = 1
    _DeleteAccStroke.Color = Color3.fromRGB(70, 75, 110)

    local _DeleteAccIcon = Instance.new("Frame", _DeleteAccBtn)
    _DeleteAccIcon.Size = UDim2.new(0, 32, 0, 32)
    _DeleteAccIcon.Position = UDim2.new(0, 12, 0.5, -16)
    _DeleteAccIcon.BackgroundColor3 = Color3.fromRGB(127, 29, 29)
    _DeleteAccIcon.BackgroundTransparency = 0.3
    _DeleteAccIcon.BorderSizePixel = 0
    _DeleteAccIcon.ZIndex = 3
    Instance.new("UICorner", _DeleteAccIcon).CornerRadius = UDim.new(0, 9)

    local _DeleteAccIconTxt = Instance.new("TextLabel", _DeleteAccIcon)
    _DeleteAccIconTxt.Size = UDim2.new(1, 0, 1, 0)
    _DeleteAccIconTxt.BackgroundTransparency = 1
    _DeleteAccIconTxt.Text = "X"
    _DeleteAccIconTxt.TextColor3 = Color3.fromRGB(248, 113, 113)
    _DeleteAccIconTxt.Font = Enum.Font.GothamBold
    _DeleteAccIconTxt.TextSize = 16
    _DeleteAccIconTxt.ZIndex = 4

    local _DeleteAccLabel = Instance.new("TextLabel", _DeleteAccBtn)
    _DeleteAccLabel.Size = UDim2.new(1, -155, 0, 20)
    _DeleteAccLabel.Position = UDim2.new(0, 54, 0, 8)
    _DeleteAccLabel.BackgroundTransparency = 1
    _DeleteAccLabel.Text = "删除账号"
    _DeleteAccLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    _DeleteAccLabel.Font = Enum.Font.GothamBold
    _DeleteAccLabel.TextSize = 13
    _DeleteAccLabel.TextXAlignment = Enum.TextXAlignment.Left
    _DeleteAccLabel.ZIndex = 3

    local _DeleteAccSub = Instance.new("TextLabel", _DeleteAccBtn)
    _DeleteAccSub.Size = UDim2.new(1, -155, 0, 16)
    _DeleteAccSub.Position = UDim2.new(0, 54, 0, 28)
    _DeleteAccSub.BackgroundTransparency = 1
    _DeleteAccSub.Text = "清除本地自动启动配置，下次进游戏不再自动运行"
    _DeleteAccSub.TextColor3 = Color3.fromRGB(165, 170, 200)
    _DeleteAccSub.Font = Enum.Font.GothamMedium
    _DeleteAccSub.TextSize = 10.5
    _DeleteAccSub.TextXAlignment = Enum.TextXAlignment.Left
    _DeleteAccSub.ZIndex = 3

    local _DeleteAccTag = Instance.new("TextLabel", _DeleteAccBtn)
    _DeleteAccTag.Size = UDim2.new(0, 84, 0, 26)
    _DeleteAccTag.Position = UDim2.new(1, -96, 0.5, -13)
    _DeleteAccTag.BackgroundColor3 = Color3.fromRGB(69, 26, 26)
    _DeleteAccTag.BackgroundTransparency = 0.25
    _DeleteAccTag.Text = "取消自启"
    _DeleteAccTag.TextColor3 = Color3.fromRGB(252, 165, 165)
    _DeleteAccTag.Font = Enum.Font.GothamBold
    _DeleteAccTag.TextSize = 11
    _DeleteAccTag.ZIndex = 3
    Instance.new("UICorner", _DeleteAccTag).CornerRadius = UDim.new(0, 8)

    _CreateAccBtn.MouseEnter:Connect(function()
        Tween(_CreateAccBtn, {BackgroundColor3 = Color3.fromRGB(26, 28, 46), BackgroundTransparency = 0.25}, 0.2)
        Tween(_CreateAccStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2)
    end)
    _CreateAccBtn.MouseLeave:Connect(function()
        Tween(_CreateAccBtn, {BackgroundColor3 = Color3.fromRGB(16, 17, 28), BackgroundTransparency = 0.42}, 0.2)
        Tween(_CreateAccStroke, {Color = IsAccountCreated() and Color3.fromRGB(34, 197, 94) or Color3.fromRGB(70, 75, 110)}, 0.2)
    end)

    _DeleteAccBtn.MouseEnter:Connect(function()
        Tween(_DeleteAccBtn, {BackgroundColor3 = Color3.fromRGB(26, 28, 46), BackgroundTransparency = 0.25}, 0.2)
        Tween(_DeleteAccStroke, {Color = Color3.fromRGB(239, 68, 68)}, 0.2)
    end)
    _DeleteAccBtn.MouseLeave:Connect(function()
        Tween(_DeleteAccBtn, {BackgroundColor3 = Color3.fromRGB(16, 17, 28), BackgroundTransparency = 0.42}, 0.2)
        Tween(_DeleteAccStroke, {Color = Color3.fromRGB(70, 75, 110)}, 0.2)
    end)

    _CreateAccBtn.MouseButton1Click:Connect(function()
        PlaySound("click")
        local wroteFile, hasFull = SaveAccountAutoStart()
        _CreateAccTag.Text = "已开启自启"
        _CreateAccTag.BackgroundColor3 = Color3.fromRGB(20, 83, 45)
        _CreateAccTag.TextColor3 = Color3.fromRGB(74, 222, 128)
        _CreateAccIcon.BackgroundColor3 = Color3.fromRGB(22, 101, 52)
        _CreateAccIconTxt.TextColor3 = Color3.fromRGB(74, 222, 128)
        _CreateAccStroke.Color = Color3.fromRGB(34, 197, 94)

        if wroteFile and hasFull then
            ShowNotification("账号创建成功", "已写入完整主界面自启，重进将直接弹出 UI")
        elseif wroteFile then
            ShowNotification("账号已创建", "请从脚本列表运行本脚本，重进即可自动弹出 UI")
        else
            ShowNotification("账号已绑定", "已开启重进自动启动，请确认 Auto Execute 已开")
        end
    end)

    _DeleteAccBtn.MouseButton1Click:Connect(function()
        PlaySound("click")
        _OpenConfirmDialog("确定要删除账号吗？", "删除后进入游戏将不再自动启动刘某某脚本", "确认删除", function()
            RemoveAccountAutoStart()
            _CreateAccTag.Text = "点击创建"
            _CreateAccTag.BackgroundColor3 = Color3.fromRGB(36, 39, 66)
            _CreateAccTag.TextColor3 = Color3.fromRGB(190, 196, 240)
            _CreateAccIcon.BackgroundColor3 = Color3.fromRGB(49, 46, 129)
            _CreateAccIconTxt.TextColor3 = Color3.fromRGB(165, 180, 252)
            _CreateAccStroke.Color = Color3.fromRGB(70, 75, 110)
            ShowNotification("账号已删除", "已取消进入游戏自动启动刘某某脚本")
        end)
    end)

    local _StatsContainer = Instance.new("Frame", _TB)
    _StatsContainer.Size = UDim2.new(0, 172, 0, 28)
    _StatsContainer.Position = UDim2.new(1, -335, 0.5, -14)
    _StatsContainer.BackgroundColor3 = Color3.fromRGB(18, 20, 34)
    _StatsContainer.BackgroundTransparency = 0.35
    _StatsContainer.ZIndex = 2
    Instance.new("UICorner", _StatsContainer).CornerRadius = UDim.new(0, 9)
    local _StatsStroke = Instance.new("UIStroke", _StatsContainer)
    _StatsStroke.Thickness = 1
    _StatsStroke.Color = Color3.fromRGB(75, 80, 118)

    local _StatsDot = Instance.new("Frame", _StatsContainer)
    _StatsDot.Size = UDim2.new(0, 6, 0, 6); _StatsDot.Position = UDim2.new(0, 9, 0.5, -3)
    _StatsDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94); _StatsDot.ZIndex = 3
    Instance.new("UICorner", _StatsDot).CornerRadius = UDim.new(1, 0)

    local _StatsText = Instance.new("TextLabel", _StatsContainer)
    _StatsText.Size = UDim2.new(1, -20, 1, 0); _StatsText.Position = UDim2.new(0, 20, 0, 0); _StatsText.BackgroundTransparency = 1
    _StatsText.Font = Enum.Font.GothamBold; _StatsText.TextSize = 10; _StatsText.TextColor3 = Color3.fromRGB(235, 238, 255); _StatsText.ZIndex = 3

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
                _StatsText.Text = string.format("FPS: %d  |  Ping: %d  |  Mem: %dM", fps, ping, mem)
            end)
        end)
    end)

    local function _ExecuteScriptUrl(name, url)
        ShowNotification("正在开启中...", name)
        task.spawn(function()
            local success = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if success then
                PlaySound("open")
                ShowNotification("开启成功", name .. " 已成功运行！")
            else
                ShowNotification("开启失败", "网络异常或链接失效")
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
        row.Size = UDim2.new(0.98, 0, 0, 44)
        row.BackgroundColor3 = Color3.fromRGB(16, 17, 28)
        row.BackgroundTransparency = 0.42
        row.ZIndex = 2
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
        local s = Instance.new("UIStroke", row); s.Thickness = 1; s.Color = Color3.fromRGB(68, 72, 105)

        local mainBtn = Instance.new("TextButton", row)
        mainBtn.Name = "MainBtn"
        mainBtn.Size = UDim2.new(1, -152, 1, 0)
        mainBtn.Position = UDim2.new(0, 0, 0, 0)
        mainBtn.BackgroundTransparency = 1
        mainBtn.Text = "   " .. name
        mainBtn.Font = Enum.Font.GothamMedium
        mainBtn.TextSize = 13
        mainBtn.TextColor3 = Color3.fromRGB(242, 244, 255)
        mainBtn.TextXAlignment = Enum.TextXAlignment.Left
        mainBtn.ZIndex = 3
        mainBtn.AutoButtonColor = false

        local copyBtn = Instance.new("TextButton", row)
        copyBtn.Name = "CopyBtn"
        copyBtn.Size = UDim2.new(0, 62, 0, 28)
        copyBtn.Position = UDim2.new(1, -144, 0.5, -14)
        copyBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 56)
        copyBtn.BackgroundTransparency = 0.2
        copyBtn.Text = "Copy"
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.TextSize = 11
        copyBtn.TextColor3 = Color3.fromRGB(215, 220, 250)
        copyBtn.ZIndex = 3
        copyBtn.AutoButtonColor = false
        Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)

        local execBtn = Instance.new("TextButton", row)
        execBtn.Name = "ExecuteBtn"
        execBtn.Size = UDim2.new(0, 70, 0, 28)
        execBtn.Position = UDim2.new(1, -76, 0.5, -14)
        execBtn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
        execBtn.BackgroundTransparency = 0.25
        execBtn.Text = "Execute"
        execBtn.Font = Enum.Font.GothamBold
        execBtn.TextSize = 11
        execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        execBtn.ZIndex = 3
        execBtn.AutoButtonColor = false
        Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 8)

        row.MouseEnter:Connect(function()
            Tween(row, {BackgroundColor3 = Color3.fromRGB(25, 27, 45), BackgroundTransparency = 0.25}, 0.2)
            Tween(s, {Color = Color3.fromRGB(129, 140, 248)}, 0.2)
        end)
        row.MouseLeave:Connect(function()
            Tween(row, {BackgroundColor3 = Color3.fromRGB(16, 17, 28), BackgroundTransparency = 0.42}, 0.2)
            Tween(s, {Color = Color3.fromRGB(68, 72, 105)}, 0.2)
        end)

        copyBtn.MouseEnter:Connect(function() Tween(copyBtn, {BackgroundColor3 = Color3.fromRGB(52, 56, 88), BackgroundTransparency = 0.08}, 0.15) end)
        copyBtn.MouseLeave:Connect(function() Tween(copyBtn, {BackgroundColor3 = Color3.fromRGB(32, 34, 56), BackgroundTransparency = 0.2}, 0.15) end)

        execBtn.MouseEnter:Connect(function() Tween(execBtn, {BackgroundColor3 = Color3.fromRGB(99, 102, 241), BackgroundTransparency = 0.08}, 0.15) end)
        execBtn.MouseLeave:Connect(function() Tween(execBtn, {BackgroundColor3 = Color3.fromRGB(79, 70, 229), BackgroundTransparency = 0.25}, 0.15) end)

        mainBtn.MouseButton1Click:Connect(function()
            PlaySound("click")
            _PromptScriptConfirm(name, url)
        end)

        copyBtn.MouseButton1Click:Connect(function()
            PlaySound("click")
            pcall(function()
                setclipboard('loadstring(game:HttpGet("' .. url .. '"))()')
            end)
            ShowNotification("已复制脚本", name .. " 代码已复制到剪贴板")
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
        row.Size = UDim2.new(0.98, 0, 0, 44)
        row.BackgroundColor3 = Color3.fromRGB(16, 17, 28)
        row.BackgroundTransparency = 0.42
        row.ZIndex = 2
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
        local s = Instance.new("UIStroke", row); s.Thickness = 1; s.Color = Color3.fromRGB(68, 72, 105)

        local mainBtn = Instance.new("TextButton", row)
        mainBtn.Name = "MainBtn"
        mainBtn.Size = UDim2.new(1, -86, 1, 0)
        mainBtn.Position = UDim2.new(0, 0, 0, 0)
        mainBtn.BackgroundTransparency = 1
        mainBtn.Text = "   " .. name
        mainBtn.Font = Enum.Font.GothamMedium
        mainBtn.TextSize = 13
        mainBtn.TextColor3 = Color3.fromRGB(242, 244, 255)
        mainBtn.TextXAlignment = Enum.TextXAlignment.Left
        mainBtn.ZIndex = 3
        mainBtn.AutoButtonColor = false

        local execBtn = Instance.new("TextButton", row)
        execBtn.Name = "ExecuteBtn"
        execBtn.Size = UDim2.new(0, 72, 0, 28)
        execBtn.Position = UDim2.new(1, -80, 0.5, -14)
        execBtn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
        execBtn.BackgroundTransparency = 0.25
        execBtn.Text = "Execute"
        execBtn.Font = Enum.Font.GothamBold
        execBtn.TextSize = 11
        execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        execBtn.ZIndex = 3
        execBtn.AutoButtonColor = false
        Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 8)

        row.MouseEnter:Connect(function()
            Tween(row, {BackgroundColor3 = Color3.fromRGB(25, 27, 45), BackgroundTransparency = 0.25}, 0.2)
            Tween(s, {Color = Color3.fromRGB(129, 140, 248)}, 0.2)
        end)
        row.MouseLeave:Connect(function()
            Tween(row, {BackgroundColor3 = Color3.fromRGB(16, 17, 28), BackgroundTransparency = 0.42}, 0.2)
            Tween(s, {Color = Color3.fromRGB(68, 72, 105)}, 0.2)
        end)

        execBtn.MouseEnter:Connect(function() Tween(execBtn, {BackgroundColor3 = Color3.fromRGB(99, 102, 241), BackgroundTransparency = 0.08}, 0.15) end)
        execBtn.MouseLeave:Connect(function() Tween(execBtn, {BackgroundColor3 = Color3.fromRGB(79, 70, 229), BackgroundTransparency = 0.25}, 0.15) end)

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
        input.MouseEnter:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2) end)
        input.MouseLeave:Connect(function() if not input:IsFocused() then Tween(input.UIStroke, {Color = Color3.fromRGB(68, 72, 105)}, 0.2) end end)
        input.Focused:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(165, 180, 252)}, 0.2) end)
        input.FocusLost:Connect(function() Tween(input.UIStroke, {Color = Color3.fromRGB(68, 72, 105)}, 0.2) end)
    end

    local _SearchBox = Instance.new("TextBox", _Page2)
    _SearchBox.LayoutOrder = 1; _SearchBox.Size = UDim2.new(0.98, 0, 0, 40); _SearchBox.BackgroundColor3 = Color3.fromRGB(16, 17, 28); _SearchBox.BackgroundTransparency = 0.42
    _SearchBox.PlaceholderText = "搜索 keyless 脚本..."; _SearchBox.Text = ""; _SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    _SearchBox.PlaceholderColor3 = Color3.fromRGB(155, 160, 190); _SearchBox.Font = Enum.Font.GothamMedium; _SearchBox.TextSize = 13; _SearchBox.ZIndex = 2
    Instance.new("UICorner", _SearchBox).CornerRadius = UDim.new(0, 12)
    local _SearchStroke = Instance.new("UIStroke", _SearchBox); _SearchStroke.Thickness = 1; _SearchStroke.Color = Color3.fromRGB(68, 72, 105)
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
    _SearchBox2.LayoutOrder = 1; _SearchBox2.Size = UDim2.new(0.98, 0, 0, 40); _SearchBox2.BackgroundColor3 = Color3.fromRGB(16, 17, 28); _SearchBox2.BackgroundTransparency = 0.42
    _SearchBox2.PlaceholderText = "搜索 key 脚本..."; _SearchBox2.Text = ""; _SearchBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
    _SearchBox2.PlaceholderColor3 = Color3.fromRGB(155, 160, 190); _SearchBox2.Font = Enum.Font.GothamMedium; _SearchBox2.TextSize = 13; _SearchBox2.ZIndex = 2
    Instance.new("UICorner", _SearchBox2).CornerRadius = UDim.new(0, 12)
    local _SearchStroke2 = Instance.new("UIStroke", _SearchBox2); _SearchStroke2.Thickness = 1; _SearchStroke2.Color = Color3.fromRGB(68, 72, 105)
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
    _SearchBox3.LayoutOrder = 1; _SearchBox3.Size = UDim2.new(0.98, 0, 0, 40); _SearchBox3.BackgroundColor3 = Color3.fromRGB(16, 17, 28); _SearchBox3.BackgroundTransparency = 0.42
    _SearchBox3.PlaceholderText = "搜索我的专属脚本..."; _SearchBox3.Text = ""; _SearchBox3.TextColor3 = Color3.fromRGB(255, 255, 255)
    _SearchBox3.PlaceholderColor3 = Color3.fromRGB(155, 160, 190); _SearchBox3.Font = Enum.Font.GothamMedium; _SearchBox3.TextSize = 13; _SearchBox3.ZIndex = 2
    Instance.new("UICorner", _SearchBox3).CornerRadius = UDim.new(0, 12)
    local _SearchStroke3 = Instance.new("UIStroke", _SearchBox3); _SearchStroke3.Thickness = 1; _SearchStroke3.Color = Color3.fromRGB(68, 72, 105)
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
        f.BackgroundColor3 = Color3.fromRGB(16, 17, 28); f.BackgroundTransparency = 0.42; f.ZIndex = 2
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
        
        local stroke = Instance.new("UIStroke", f); stroke.Thickness = 1; stroke.Color = Color3.fromRGB(68, 72, 105)
        
        local pad = Instance.new("UIPadding", f)
        pad.PaddingTop = UDim.new(0, 11); pad.PaddingBottom = UDim.new(0, 11)
        pad.PaddingLeft = UDim.new(0, 14); pad.PaddingRight = UDim.new(0, 14)
        
        local layout = Instance.new("UIListLayout", f)
        layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 4)

        local t = Instance.new("TextLabel", f)
        t.LayoutOrder = 1; t.Size = UDim2.new(1, 0, 0, 22)
        t.BackgroundTransparency = 1; t.Text = "<font color='rgb(165,180,252)'>" .. version .. "</font> <font color='rgb(155,160,190)'>- " .. date .. "</font>"
        t.RichText = true; t.TextColor3 = Color3.fromRGB(255, 255, 255); t.Font = Enum.Font.GothamBold; t.TextSize = 13; t.TextXAlignment = Enum.TextXAlignment.Left; t.ZIndex = 2
        
        local d = Instance.new("TextLabel", f)
        d.LayoutOrder = 2; d.Size = UDim2.new(1, 0, 0, 0); d.AutomaticSize = Enum.AutomaticSize.Y
        d.BackgroundTransparency = 1; d.Text = desc; d.TextColor3 = Color3.fromRGB(210, 214, 240)
        d.Font = Enum.Font.GothamMedium; d.TextSize = 12; d.TextXAlignment = Enum.TextXAlignment.Left; d.TextWrapped = true; d.ZIndex = 2

        f.MouseEnter:Connect(function() Tween(stroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.25) end)
        f.MouseLeave:Connect(function() Tween(stroke, {Color = Color3.fromRGB(68, 72, 105)}, 0.25) end)
    end

    _CreateLogEntry("V4.2.30", "2026-11-20", "【重进直开主界面】修复创建账号重进仅弹提示不弹界面的问题，自动启动写入完整主界面源码。", 1)
    _CreateLogEntry("V4.2.29", "2026-11-20", "【纯白L强化 & 自启兜底】悬浮球 L 改为独立置顶纯白字+描边；修复直接粘贴执行时重进自启提示兜底。", 2)
    _CreateLogEntry("V4.2.28", "2026-11-20", "【重进自启强化 & 悬浮球徽标 & 大X】强化 autoexec 与传送自启写入；悬浮球改为紫蓝渐变圆角方形 L 徽标；关闭按钮改为大号 X。", 3)

    local _FpsInput = Instance.new("TextBox", _Page4)
    _FpsInput.LayoutOrder = 1; _FpsInput.Size = UDim2.new(0.98, 0, 0, 42); _FpsInput.BackgroundColor3 = Color3.fromRGB(16, 17, 28); _FpsInput.BackgroundTransparency = 0.42
    _FpsInput.Text = "   设置FPS解锁 15到240: 60"; _FpsInput.TextColor3 = Color3.fromRGB(242, 244, 255); _FpsInput.Font = Enum.Font.GothamMedium; _FpsInput.TextSize = 13; _FpsInput.TextXAlignment = Enum.TextXAlignment.Left; _FpsInput.ZIndex = 2
    Instance.new("UICorner", _FpsInput).CornerRadius = UDim.new(0, 12)
    local _FpsStroke = Instance.new("UIStroke", _FpsInput); _FpsStroke.Thickness = 1; _FpsStroke.Color = Color3.fromRGB(68, 72, 105)
    _DecorateInput(_FpsInput)

    _FpsInput.FocusLost:Connect(function()
        PlaySound("click")
        local val = tonumber(_FpsInput.Text:match("%d+")) or 60
        if val < 15 then val = 15 end if val > 240 then val = 240 end
        _FpsInput.Text = "   设置FPS解锁 15到240: " .. val
        pcall(function() setfpscap(val) end)
        ShowNotification("FPS 设置已更新", "当前上限已锁定为 " .. val)
    end)

    local function _CreateSettingToggleRow(order, titleText, onToggle)
        local row = Instance.new("Frame", _Page4)
        row.LayoutOrder = order
        row.Size = UDim2.new(0.98, 0, 0, 42)
        row.BackgroundColor3 = Color3.fromRGB(16, 17, 28)
        row.BackgroundTransparency = 0.42
        row.ZIndex = 2
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
        local stroke = Instance.new("UIStroke", row)
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(68, 72, 105)

        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(1, -78, 1, 0)
        label.Position = UDim2.new(0, 14, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = titleText
        label.TextColor3 = Color3.fromRGB(242, 244, 255)
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
        swStroke.Color = Color3.fromRGB(85, 90, 130)

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
                Tween(stroke, {Color = Color3.fromRGB(34, 197, 94)}, 0.2)
            else
                Tween(switchBtn, {BackgroundColor3 = Color3.fromRGB(36, 39, 64), BackgroundTransparency = 0.1}, 0.2)
                Tween(knob, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(225, 228, 250)}, 0.2)
                Tween(stroke, {Color = Color3.fromRGB(68, 72, 105)}, 0.2)
            end
        end

        row.MouseEnter:Connect(function()
            if not state then
                Tween(row, {BackgroundColor3 = Color3.fromRGB(25, 27, 45), BackgroundTransparency = 0.25}, 0.2)
                Tween(stroke, {Color = Color3.fromRGB(129, 140, 248)}, 0.2)
            end
        end)
        row.MouseLeave:Connect(function()
            if not state then
                Tween(row, {BackgroundColor3 = Color3.fromRGB(16, 17, 28), BackgroundTransparency = 0.42}, 0.2)
                Tween(stroke, {Color = Color3.fromRGB(68, 72, 105)}, 0.2)
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
            ShowNotification("挂机防踢保护已开启", "系统将自动模拟操作防止被服务器踢出")
        else
            pcall(function()
                if afkConnection then
                    afkConnection:Disconnect()
                    afkConnection = nil
                end
            end)
            ShowNotification("挂机防踢保护已关闭", "已恢复正常检测")
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
            ShowNotification("全局高亮已开启", "游戏视野已完全明亮化")
        else
            StopFullbright()
            ShowNotification("全局高亮已关闭", "已恢复默认光照环境")
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
            ShowNotification("天空变黑已开启", "仅将天空设为纯黑，不影响场景亮度")
        else
            StopFulldark()
            ShowNotification("天空变黑已关闭", "已恢复原有天空")
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
            ShowNotification("全屏黑已关闭", "已恢复正常屏幕显示")
        end)
    end

    fullscreenBlackCtrl = _CreateSettingToggleRow(5, "全屏黑", function(enabled)
        if enabled then
            ShowFullscreenBlack()
            ShowNotification("全屏黑已开启", "点击屏幕中央“取消黑屏”可关闭")
        else
            HideFullscreenBlack()
            ShowNotification("全屏黑已关闭", "已恢复正常屏幕显示")
        end
    end)

    local _DCB = Instance.new("TextButton", _Page4); _DCB.LayoutOrder = 6; _DCB.Size = UDim2.new(0.98, 0, 0, 44); _DCB.BackgroundColor3 = Color3.fromRGB(88, 101, 242); _DCB.BackgroundTransparency = 0.3; _DCB.Text = "JOIN DISCORD COMMUNITY"; _DCB.TextColor3 = Color3.fromRGB(255, 255, 255); _DCB.Font = Enum.Font.GothamBold; _DCB.TextSize = 13; _DCB.ZIndex = 2; _DCB.AutoButtonColor = false; Instance.new("UICorner", _DCB).CornerRadius = UDim.new(0, 12)
    local _DCBStroke = Instance.new("UIStroke", _DCB); _DCBStroke.Thickness = 1; _DCBStroke.Color = Color3.fromRGB(140, 155, 255)
    _DCB.MouseEnter:Connect(function() Tween(_DCB, {BackgroundColor3 = Color3.fromRGB(108, 121, 255), BackgroundTransparency = 0.15}, 0.2) end)
    _DCB.MouseLeave:Connect(function() Tween(_DCB, {BackgroundColor3 = Color3.fromRGB(88, 101, 242), BackgroundTransparency = 0.3}, 0.2) end)
    _DCB.MouseButton1Click:Connect(function() 
        PlaySound("click")
        setclipboard("https://discord.gg/ATbXDtNWE") 
        ShowNotification("Discord 链接已复制", "快去分享给好友加入社区吧")
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

    -- 右上角控制按钮
    local function _Ctrl(t, x, c, hoverC, f, fontObj, textPx, soundType)
        local sz = 34
        local b = Instance.new("TextButton", _TB)
        b.Size = UDim2.new(0, sz, 0, sz)
        b.Position = UDim2.new(1, x, 0.5, -math.floor(sz / 2))
        b.Text = t
        b.BackgroundColor3 = c
        b.BackgroundTransparency = 0.3
        b.TextColor3 = Color3.fromRGB(245, 247, 255)
        b.Font = fontObj or Enum.Font.Gotham
        b.TextSize = textPx or 15
        b.ZIndex = 3
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        
        local bStroke = Instance.new("UIStroke", b)
        bStroke.Thickness = 1
        bStroke.Color = Color3.fromRGB(255, 255, 255)
        bStroke.Transparency = 0.55
        
        b.MouseEnter:Connect(function() 
            Tween(b, {BackgroundColor3 = hoverC, BackgroundTransparency = 0.12}, 0.2) 
            Tween(bStroke, {Transparency = 0.2}, 0.2) 
        end)
        b.MouseLeave:Connect(function() 
            Tween(b, {BackgroundColor3 = c, BackgroundTransparency = 0.3}, 0.2) 
            Tween(bStroke, {Transparency = 0.55}, 0.2) 
        end)
        b.MouseButton1Click:Connect(function()
            PlaySound(soundType or "click")
            f()
        end)
    end

    -- 关闭按钮 大号 X
    _Ctrl("X", -46, Color3.fromRGB(239, 68, 68), Color3.fromRGB(255, 90, 90), function() 
        _OpenConfirmDialog("确定要退出此脚本吗？", "刘某某脚本 V4.2.30 (beta)", "确认退出", function()
            PlaySound("close")
            HideFullscreenBlack()
            pcall(function() _LP.Character.HumanoidRootPart.Anchored = false end)
            Tween(_M, {Size = UDim2.new(0, 535, 0, 350), BackgroundTransparency = 1}, 0.3)
            for _, v in pairs(_M:GetDescendants()) do if v:IsA("UIStroke") or v:IsA("ImageLabel") or v:IsA("TextLabel") or v:IsA("TextButton") then Tween(v, {Transparency = 1}, 0.3) end end
            task.wait(0.3); _S:Destroy()
        end)
    end, Enum.Font.GothamBold, 20, "click")

    local isMinimized = false

    -- 缩小按钮 —
    _Ctrl("—", -90, Color3.fromRGB(48, 52, 78), Color3.fromRGB(78, 84, 118), function() 
        isMinimized = not isMinimized
        _Sidebar.Visible = not isMinimized
        _ContentContainer.Visible = not isMinimized
        _HeaderLine.Visible = not isMinimized
        _SplitLine.Visible = not isMinimized
        _BgImage.Visible = not isMinimized
        Tween(_M, {Size = isMinimized and UDim2.new(0, 595, 0, 54) or UDim2.new(0, 595, 0, 390)}, 0.4, Enum.EasingStyle.Quart)
    end, Enum.Font.Gotham, 14, "click")

    -- 右下角 ◢ 拖动缩放手柄
    local _Resizer = Instance.new("TextButton", _M)
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
            _M.Size = UDim2.new(0, math.clamp(startSize.X + delta.X, 490, 820), 0, math.clamp(startSize.Y + delta.Y, 330, 620))
        end
    end)
    _UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    -- 悬浮球：紫蓝渐变圆角方形 + 独立置顶纯白 L（带暗色描边确保高对比）
    local _Ball = Instance.new("TextButton", _S)
    _Ball.Size = UDim2.new(0, 48, 0, 48)
    _Ball.Position = UDim2.new(0, 30, 0.4, 0)
    _Ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _Ball.BackgroundTransparency = 0
    _Ball.BorderSizePixel = 0
    _Ball.Text = ""
    _Ball.Visible = false
    _Ball.ZIndex = 10
    _Ball.AutoButtonColor = false
    Instance.new("UICorner", _Ball).CornerRadius = UDim.new(0, 12)
    ApplyAccentGradient(_Ball, Color3.fromRGB(79, 70, 229), Color3.fromRGB(147, 51, 234), 45)
    local _BallStroke = Instance.new("UIStroke", _Ball)
    _BallStroke.Thickness = 1.4
    _BallStroke.Color = Color3.fromRGB(235, 238, 255)
    _BallStroke.Transparency = 0.25

    local _BallLabel = Instance.new("TextLabel", _Ball)
    _BallLabel.Size = UDim2.new(1, 0, 1, 0)
    _BallLabel.Position = UDim2.new(0, 0, 0, 0)
    _BallLabel.BackgroundTransparency = 1
    _BallLabel.Text = "L"
    _BallLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    _BallLabel.TextSize = 24
    _BallLabel.Font = Enum.Font.GothamBold
    _BallLabel.TextStrokeColor3 = Color3.fromRGB(25, 18, 65)
    _BallLabel.TextStrokeTransparency = 0.2
    _BallLabel.ZIndex = 12

    local bDragging, bDragStart, bStartPos, bMoved = false, nil, nil, false
    _Ball.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            bDragging = true; bMoved = false
            bDragStart = i.Position
            bStartPos = _Ball.Position
        end
    end)
    _UIS.InputChanged:Connect(function(i)
        if bDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - bDragStart
            if delta.Magnitude > 5 then bMoved = true end
            _Ball.Position = UDim2.new(bStartPos.X.Scale, bStartPos.X.Offset + delta.X, bStartPos.Y.Scale, bStartPos.Y.Offset + delta.Y)
        end
    end)
    _UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            bDragging = false
        end
    end)

    -- 变悬浮球按钮 ＋
    _Ctrl("＋", -134, Color3.fromRGB(99, 102, 241), Color3.fromRGB(129, 140, 248), function()
        _Ball.Position = _M.Position
        _M.Visible = false
        _Ball.Visible = true
        _Ball.Size = UDim2.new(0, 0, 0, 0)
        Tween(_Ball, {Size = UDim2.new(0, 48, 0, 48)}, 0.4, Enum.EasingStyle.Back)
    end, Enum.Font.Gotham, 17, "click")

    _Ball.MouseButton1Click:Connect(function()
        if bMoved then return end
        PlaySound("click")
        isMinimized = false
        _M.Position = _Ball.Position
        _M.Visible = true
        _Ball.Visible = false
        _Sidebar.Visible = true
        _ContentContainer.Visible = true
        _HeaderLine.Visible = true
        _SplitLine.Visible = true
        _BgImage.Visible = true
        _Title.Visible = true
        _M.Size = UDim2.new(0, 0, 0, 0)
        Tween(_M, {Size = UDim2.new(0, 595, 0, 390)}, 0.4, Enum.EasingStyle.Back)
    end)

    local _drag, _dStart, _sPos
    _TB.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = true; _dStart = i.Position; _sPos = _M.Position end end)
    _UIS.InputChanged:Connect(function(i) if _drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - _dStart; _M.Position = UDim2.new(_sPos.X.Scale, _sPos.X.Offset + d.X, _sPos.Y.Scale, _sPos.Y.Offset + d.Y) end end)
    _UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then _drag = false end end)
end

_LMM_BOOT()
