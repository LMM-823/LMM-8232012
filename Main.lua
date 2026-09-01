-- [[ 🌚刘某某脚本🌝 V4.2 | Main ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- =========================
-- Core
-- =========================

local Core = loadstring([[
    -- Core.lua 内容放这里
]])()

-- =========================
-- 状态
-- =========================

local State = {
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

    c_esp = Color3.new(1, 0, 0),
    c_line = Color3.new(1, 0, 0),
    c_box = Color3.new(1, 0, 0)
}

Core.State = State