-- [[ 2. GitHub 核心控制：Core.lua ]]
local cacheBuster = tostring(math.random(100000, 999999))
local MainUiRawUrl = "https://raw.githubusercontent.com/LMM-823/LMM-8232012/main/Main.lua?v=" .. cacheBuster

print("[ANIME LEAGUE] 核心引擎已启动...")

-- 瞬间执行主 UI 抓取
local success, err = pcall(function()
    loadstring(game:HttpGet(MainUiRawUrl))()
end)

if not success then
    warn("[ANIME LEAGUE] 云端 UI 加载失败: " .. tostring(err))
    if isfile and isfile("Main.lua") then
        loadstring(readfile("Main.lua"))()
    end
end
