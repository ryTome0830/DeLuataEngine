local Vector2 = require("Vector2").Vector2

--- @class Transform Transformクラスオブジェクトの位置、回転、スケールを定義します
--- @field object Object
--- @field pos Vector2
--- @field rotation number
--- @field scale Vector2
--- @field parent Transform
--- @field children Transform[]
local Transform = {}
Transform.__index = Transform

--- Transformコンストラクタ
--- @param object Object アタッチするオブジェクト
--- @param pos? Vector2|nil 親オブジェクトに対する相対位置
--- @param rotation? number|nil 物体の回転
--- @param scale? Vector2|nil オブジェクトのスケール
function Transform.new(object, pos, rotation, scale)
    --- @class Transform
    local instance = setmetatable({}, Transform)
    instance:init(
        object,
        pos or Vector2.new(),
        rotation or 0,
        scale or Vector2.new(1, 1)
    )
    return instance
end

--- 初期化処理
--- @private
--- @param object Object
--- @param pos Vector2
--- @param rotation number
--- @param scale Vector2
function Transform:init(object, pos, rotation, scale)
    self.object = object
    self.pos = pos
    self.rotation = rotation
    self.scale = scale
    self.parent = nil
    self.children = {}
end

-- ========== metamethod ==========

function Transform:__tostring()
    return string.format("Transform(pos: %s, rotation: %f, scale: %s)",
        tostring(self.pos), self.rotation, tostring(self.scale))
end


-- ========== DeLuataEngine ==========

--- Transformのposを再設定
--- @param pos Vector2
function Transform:setPosition(pos)
    -- 引数が間違っている場合
    -- if love then
    --     print("'Transform.setPosition' requires 'Vector2' for the argument type, but another type is specified.")
    --     return
    -- end
    self.pos = pos
end

--- Transformのrotation
--- @param rotation number
function Transform:setRotation(rotation)
    -- 引数が間違っている場合
    -- if type(rotation) ~= "number" then
    --     print("'Transform.setRotation' requires 'number' for the argument type, but another type is specified.")
    --     return
    -- end
    self.rotation = rotation
end

--- 子を追加
--- @param childTransform Transform
function Transform:addChild(childTransform)
    -- 引数が間違っている場合
    -- if type(childTransform) ~= "table" then
    --     print("'Transform.addChild' requires 'Transform' for the argument type, but another type is specified.")
    -- end
    table.insert(self.children, childTransform)
    childTransform.parent = self
end

--- 子を削除
--- @param childTransform Transform
function Transform:removeChild(childTransform)
    for i, child in ipairs(self.children) do
        if child == childTransform then
            table.remove(self.children, i)
            childTransform.parent = nil
            break
        end
    end
end

--- ワールド座標を取得
--- @return Vector2
function Transform:getWorldPosition()
    local position = self.pos
    local parent = self.parent
    while parent do
        position = position + parent.pos
        parent = parent.parent
    end
    return position
end

--- ワールド回転を取得
--- @return number
function Transform:getWorldRotation()
    local rotation = self.rotation
    local parent = self.parent
    while parent do
        rotation = rotation + parent.rotation
        parent = parent.parent
    end
    return rotation
end

--- ワールドスケールを取得
--- @return Vector2
function Transform:getWorldScale()
    local scale = self.scale
    local parent = self.parent
    while parent do
        scale = scale + parent.scale
        --scale = scale * parent.scale
        parent = parent.parent
    end
    return scale
end
