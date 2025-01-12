local Component = require("abstruct.Component").Component
local Vector2 = require("Vector2").Vector2

--- @class Transform:Component Transformクラスオブジェクトの位置、回転、スケールを定義します
--- 継承
--- @field super Component
--- @field private gameObject Object
--- @field private _enabled boolean
--- Transformメンバ
--- @field pos Vector2 二次元平面座標
--- @field rotation number 回転
--- @field scale Vector2 スケール
--- @field parent Transform 親オブジェクト
--- @field children Transform[]
local Transform = Component:extend()
Transform.__index = Transform

--- Transformコンストラクタ
--- @param gameObject Object アタッチするオブジェクト
--- @param pos? Vector2|nil 親オブジェクトに対する相対位置
--- @param rotation? number|nil 物体の回転
--- @param scale? Vector2|nil オブジェクトのスケール
function Transform.new(gameObject, pos, rotation, scale)
    --- @class Transform
    local instance = setmetatable({}, Transform)
    instance:init(
        gameObject,
        pos or Vector2.new(),
        rotation or 0,
        scale or Vector2.new(1, 1)
    )
    return instance
end

--- 初期化処理
--- @private
--- @param gameObject Object
--- @param pos Vector2
--- @param rotation number
--- @param scale Vector2
function Transform:init(gameObject, pos, rotation, scale)
    -- スーパークラスの初期化
    self.super:init(gameObject)
    --- @private
    self.gameObject = gameObject
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

--- enableへのアクセスを制御する
function Transform:__newindex(key, value)
    if key == "_enabled" then
        error("Transform cannot be disabled.")
    else
        rawset(self, key, value)
    end
end


-- ========== DeLuataEngine ==========

--- Transformのposを設定
--- @param pos Vector2
function Transform:setPosition(pos)
    -- 引数が間違っている場合
    if type(pos) ~= "table" or type(pos.x) ~= "number" or type(pos.y) ~= "number" then
        -- エラー処理
        error("'Transform.setPosition' requires 'Vector2' for the argument type, but another type is specified.")
    end
    self.pos = pos
end

--- Transformのrotationを設定
--- @param rotation number
function Transform:setRotation(rotation)
    -- 引数が間違っている場合
    if type(rotation) ~= "number" then
        error("'Transform.setRotation' requires 'number' for the argument type, but another type is specified.")
        return
    end
    self.rotation = rotation
end

--- Transformのscaleを設定
--- @param scale Vector2
function Transform:setScale(scale)
    -- 引数が間違っている場合
    if type(scale) ~= "table" or type(scale.x) ~= "number" or type(scale.y) ~= "number" then
        -- エラー処理
        error("'Transform.setScale' requires 'Vector2' for the argument type, but another type is specified.")
    end
    self.scale = scale
end

--- 子を追加
--- @param childTransform Transform
function Transform:addChild(childTransform)
    -- 引数が間違っている場合
    if not childTransform:is(Transform) then  -- Transform型かどうかをチェック
        error("'Transform.addChild' requires 'Transform' for the argument type, but another type is specified.")
    end
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

--- 子を取得
--- @return GameObject[]
function Transform:getChild()
    local gameObjects = {}
    for _, child in ipairs(self.children) do
        table.insert(gameObjects, child.gameObject)
    end
    return gameObjects
end

--- ワールド座標を取得
--- @return Vector2
function Transform:getWorldPosition()
    local position = self.pos:clone()
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
    local scale = self.scale:clone()
    local parent = self.parent
    while parent do
        --scale = scale + parent.scale
        scale = scale * parent.scale
        parent = parent.parent
    end
    return scale
end

-- ==========CallBacks=========

function Transform:onEnable()
end

function Transform:onDisable()
end

function Transform:onDestroy()
    -- メモリリーク防止
    self.gameObject = nil
    self.pos = nil
    self.scale = nil
end


return{
    Transform=Transform
}