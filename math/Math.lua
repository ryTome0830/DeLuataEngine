--- @class Math
local Math = {}
Math.__index = Math

--- シングルトンオブジェクト
--- @class Math
local singleton_object = nil

--- コンストラクタ
--- @return Math
function Math.new()
    if singleton_object == nil then
        --- @class Math
        singleton_object = setmetatable({}, Math)
        singleton_object:init()
    end
    return singleton_object
end

function Math:init()
end


-- ========== metamethod ==========

--- @private
--- @return string
function Math:__tostring()
    return "Math"
end


-- ========== DeluataEngine ==========

--- 値を最小・最大範囲に制限
--- @param value number
--- @param min number
--- @param max number
--- @return number
function Math:clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

--- 線形補間
--- @param a number 開始値
--- @param b number 終了値
--- @param t number 時間(0-1)
--- @return number
function Math:lerp(a, b, t)
    return a + (b - a) * self:clamp(t, 0, 1)
end

--- 度数法 => 弧度法
--- @param degrees number 角度(度数表)
--- @return number
function Math:degToRad(degrees)
    return degrees * math.pi / 180
end

--- 弧度法 => 度数法
--- @param radians number ラジアン
--- @return number
function Math:radToDeg(radians)
    return radians * 180 / math.pi
end

--- 数値を丸める
--- @param value number 値
--- @return number
function Math:round(value)
    return math.floor(value + 0.5)
end


return{
    Math=Math.new()
}
