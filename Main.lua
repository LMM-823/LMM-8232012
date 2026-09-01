-- [[ 🌚刘某某脚本🌝 V4.3 - Main 主入口 ]]

local CoreModule = nil -- 此处可根据您的加载方式引入 Core，例如 loadstring 或模块化 require
-- 假设 Core 返回的内容存在一个变量中，或者您将上面 Core 的逻辑与下方代码拼装。
-- 为了方便您直接使用，这里假定直接调用上面的 Core 变量：

local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _UIS = game:GetService("UserInputService")
local _TS = game:GetService("TweenService")
local _LP = _P.LocalPlayer
local _Cam = workspace.CurrentCamera

-- 调用 Core 中的工具函数
-- local _G_LMM_88 = CoreModule.Data
-- local Tween = CoreModule.Tween
-- local _DecorateInput = CoreModule.DecorateInput
-- CoreModule.InitCoreLoops()

-- (由于篇幅和独立运行考虑，UI 构建部分完整保留，并在其中调用相应的配置项)

-- ==================== 删除旧 UI ====================
pcall(function()
    local old = _CG:FindFirstChild("LMM_Final_V40")
    if old then old:Destroy() end
end)

local _S = Instance.new("ScreenGui")
_S.Name = "LMM_Final_V40"
_S.ResetOnSpawn = false
_S.IgnoreGuiInset = false
_S.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_S.Parent = _CG

-- 后续的 UI 界面初始化、页面布局、组件挂载等代码保持原样...
print("✨ 主入口加载完毕，请结合 Core 模块一同运行。")
