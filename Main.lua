-- [[ Anime League - Main.lua ]]

-- 确保 Core 已经加载完成
if not _G.AnimeLeagueCore then
    warn("[Anime League] 错误：请先运行 Core.lua！")
    return
end

local Core = _G.AnimeLeagueCore

-- 1. 创建 Cactus Hub 风格的 4 个横向大分类
Core.CreateTab("👤 Main", 1)
Core.CreateTab("🌱 Farming", 2)
Core.CreateTab("👁️ Visuals", 3)
Core.CreateTab("⚙️ Settings", 4)

-- 2. 分别往各个页面里塞满名字叫 "1" 的无功能按钮
for i = 1, 5 do Core.CreateButton("👤 Main", i) end
for i = 1, 4 do Core.CreateButton("🌱 Farming", i) end
for i = 1, 4 do Core.CreateButton("👁️ Visuals", i) end
for i = 1, 3 do Core.CreateButton("⚙️ Settings", i) end

print("[Anime League] Main 内容加载成功，空按钮全部设置为 '1'！")
