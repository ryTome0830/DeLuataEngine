--- @class Vector2 Vector2クラス
--- @field x number x座標
--- @field y number y座標
local Vector2 = {}
Vector2.__index = Vector2

--- Vector2コンストラクタ
--- @param x? number|nil x座標
--- @param y? number|nil y座標
--- @return Vector2
function Vector2.new(x, y)
    --- @class Vector2
    local instance = setmetatable({}, Vector2)
    instance:init(x or 0, y or 0)
    return instance
end


--- Vector2クラス初期化処理
--- @private
--- @package
--- @param x number x座標(default: 0)
--- @param y number y座標(default: 0)
function Vector2:init(x, y)
    self.x = x
    self.y = y
end

-- ========== metamethod ==========

--- ベクトルの加算
--- @private
--- @package
--- @param v2 Vector2 加算するベクトル
--- @return Vector2
function Vector2:__add(v2)
    if not v2 then
        error("Invalid arguments for Vector2 addition")
    end
    return Vector2.new(self.x + v2.x, self.y + v2.y)
end

--- ベクトルの減算
--- @private
--- @package
--- @param v2 Vector2 減算するベクトル
--- @return Vector2
function Vector2:__sub(v2)
    if not v2 then
        error("Invalid arguments for Vector2 subtraction")
    end
    return Vector2.new(self.x - v2.x, self.y - v2.y)
end

--- ベクトルの等価判定
--- @private
--- @package
--- @param v2 Vector2 比較するベクトル
--- @return boolean
function Vector2:__eq(v2)
    if not v2 then
        error("Invalid arguments for Vector2 comparison")
    end
    return self.x == v2.x and self.y == v2.y
end

--- ベクトルの文字列化
--- @private
--- @package
function Vector2:__tostring()
    if not self then
        error("Invalid argument for Vector2 tostring")
    end
    return string.format("Vector2(%f, %f)", self.x, self.y)
end

-- ========== DeLuataEngine ==========

--- ベクトルのスカラー倍
--- @param scalar number
--- @return Vector2
function Vector2:scale(scalar)
    return Vector2.new(self.x * scalar, self.y * scalar)
end

--- 内積
--- @param v Vector2
--- @return number
function Vector2:dot(v)
    return self.x * v.x + self.y * v.y
end

--- 外積
--- @param v Vector2
--- @return number
function Vector2:cross(v)
    return self.x * v.y - self.y * v.x
end

--- ベクトルの大きさ
--- @return number
function Vector2:length()
    if not self then
      error("Invalid argument for Vector2 length")
    end
    return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

--- 2つのベクトル間の距離
--- @param v Vector2
--- @return number
function Vector2:distance(v)
    local lv = Vector2.new(self.x - v.x, self.y - v.y)
    return lv:length()
end

--- ベクトルの回転
--- @param angle number ラジアン
--- @return Vector2
function Vector2:rotate(angle)
    local cos = math.cos(angle)
    local sin = math.sin(angle)
    return Vector2.new(self.x * cos - self.y * sin, self.x * sin + self.y * cos)
end

--- ベクトルを正規化
--- @return Vector2
function Vector2:normalized()
    local len = self:length()
    if len > 0 then
        return Vector2.new(self.x / len, self.y / len)
    else
        LogManager:logError("Cannot normalize zero-length vector.")
        return self
    end
end

--- Vector2のクローンを作成
--- @return Vector2
function Vector2:clone()
    return Vector2.new(self.x, self.y)
end

return {
    Vector2=Vector2,
}