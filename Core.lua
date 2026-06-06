-- [[ 2. GitHub 上的 Core.lua 控制中心 ]]
local MainUiRawUrl = "https://raw.githubusercontent.com/LMM-823/LMM-8232012/main/Main.lua"

print("[ANIME LEAGUE] 核心引擎已启动...")
task.wait(0.2)

-- 1. 环境检查
local LocalPlayer = game:GetService("Players").LocalPlayer
print("[ANIME LEAGUE] 当前运行玩家: " .. LocalPlayer.Name)

-- 2. 核心桥接逻辑：从云端拉取并运行 UI 界面 (Main.lua)
print("[ANIME LEAGUE] 正在从云端安全加载 UI 框架...")
local success, err = pcall(function()
    loadstring(game:HttpGet(MainUiRawUrl))()
end)

-- 3. 错误处理备份机制
if not success then
    warn("[ANIME LEAGUE] 核心桥接 UI 失败，错误信息: " .. tostring(err))
    if isfile and isfile("Main.lua") then
        warn("[ANIME LEAGUE] 尝试启动本地备用 Main.lua...")
        loadstring(readfile("Main.lua"))()
    end
else
    print("[ANIME LEAGUE] 核心与 UI 桥接成功，准备渲染！")
end
