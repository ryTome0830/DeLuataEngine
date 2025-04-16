--- @type Vector2
local Vector2 = require("Vector2").Vector2

--- @class Random
local Random = {}
Random.__index = Random

--- シングルトンオブジェクト
--- @class Random
local singleton_object = nil

--- コンストラクタ
--- @return Random
function Random.new()
    if singleton_object == nil then
        --- @class Random
        singleton_object = setmetatable({}, Random)
        singleton_object:init(os.time())
    end
    return singleton_object
end

--- @param seed number
function Random:init(seed)
    self.randomSeed = seed
    math.randomseed(seed)
end


-- ========== metamethod ==========

--- @private
--- @return string
function Random:__tostring()
    return "Random"
end


-- ========== DeluataEngine ==========

--- 指定範囲の乱数を返す
--- @overload fun(self: Random)
--- @overload fun(self: Random, min: number, max: number)
--- @param min number 最小値
--- @param max number 最大値
--- @return number
function Random:range(min, max)
    if not min or not max then min, max = 0, 1 end
    return min + math.random() * (max - min)
end

--- 指定範囲の整数乱数を返す
--- @overload fun(self: Random)
--- @overload fun(self: Random, min: integer, max: integer)
--- @param min integer
--- @param max integer
--- @return integer
function Random:rangeInt(min, max)
    if not min or not max then min, max = 0, 100 end
    return math.random(min, max)
end

--- 正規分布に従う乱数の生成
--- @param mean number
--- @param stddev number
--- @return number
function Random:gaussian(mean, stddev)
    local u1 = math.random()
    local u2 = math.random()
    local z = math.sqrt(-2 * math.log(u1) * math.cos(2 * math.pi * u2))
    return mean + z * stddev
end

--- 配列からランダムに選択
--- @param t table
--- @return any
function Random:choice(t)
    return t[math.random(#t)]
end

--- 重み付き選択
--- @param weighedTable table<any, number>
--- @return any
function Random:weightedChoice(weighedTable)
    local totalWeight = 0
    for _, weight in pairs(weighedTable) do
        totalWeight = totalWeight + weight
    end

    local randomValue = math.random(0, totalWeight)
    local cumulativeWeight = 0
    for element, weight in pairs(weighedTable) do
        cumulativeWeight = cumulativeWeight + weight
        if randomValue <= cumulativeWeight then
            return element
        end
    end
end

--- 配列のシャッフル
--- @param t table
function Random:shuffleArray(t)
    local n = #t
    while n >= 2 do
        local k = math.random(n)
        t[n], t[k] = t[k], t[n]
        n = n - 1
    end
end

--- ランダムなVector2を生成
--- @param minX number
--- @param maxX number
--- @param minY number
--- @param maxY number
--- @return Vector2
--- @nodiscard
function Random:randomVector2(minX, maxX, minY, maxY)
    return Vector2.new(self:range(minX, maxX), self:range(minY, maxY))
end

return{
    Random=Random.new()
}
