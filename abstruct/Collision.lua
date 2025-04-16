--- @type Component
local Component = require("abstruct.Component").Component
--- @type RigidBody
local RigidBody = require("components.RigidBody").RigidBody



--- @class Collision:Component
--- 継承
--- @field super Component
--- @field protected _gameObject GameObject
--- @field protected _enabled boolean
--- Collisionメンバ
--- @field protected properties table
--- @field protected fixture love.Fixture
--- @field protected isSensor boolean
local Collision = Component:extend()
Collision.__index = Collision


--- Collisionコンストラクタ
--- @param gameObject GameObject
--- @param shape love.Shape
--- @param properties? {density?: number, friction?: number, resttution?: number, isSensor?: boolean, filterCategory?: integer, filterMask?: integer, filterGroup?: integer}
--- @return Collision
function Collision.new(gameObject, shape, properties)
    --- @class Collision
    local instance = setmetatable({}, Collision)
    instance:init(gameObject, shape, properties)
    return instance
end

--- 初期化処理
--- @protected
--- @param gameObject GameObject
--- @param shape love.Shape
--- @param properties table|nil
function Collision:init(gameObject, shape, properties)
    -- スーパークラスの初期化
    self.super:init(gameObject)
    self._gameObject = gameObject
    self.properties = properties or {}
    self.fixture = nil
    self.isSensor = self.properties.isSensor or false

    -- Shapeがあるかチェック
    if not shape then
        LogManager:logWarning(tostring(self._gameObject)..": Collision init requires a valid shape.")
        self:setActive(false)
        return
    end

    --- RigidBodyの存在をチェック
    --- @type RigidBody|nil
    local rigidBodyComp = self._gameObject:getComponent(RigidBody)
    if not rigidBodyComp or not rigidBodyComp:isEnable() or not rigidBodyComp.body then
        LogManager:logError(tostring(self._gameObject)..": Collision requires an enabled RigidBody component.")
        shape:release()
        return
    end

    --- Fixtureを作成
    --- @type love.Body
    local body = rigidBodyComp.body
    self.fixture = love.physics.newFixture(body, shape)

    --- Fixtureプロパティ
    self.fixture:setDensity(self.properties.density or (self.isSensor and 0 or 1.0))
    self.fixture:setFriction(self.properties.friction or 1)
    self.fixture:setRestitution(self.properties.restitution or 0)-- >>DEV 削除予定
    self.fixture:setFilterData(
        self.properties.filterCategory or 1,
        self.properties.filterMask or -1,
        self.properties.filterGroup or 0
    )
    self.fixture:setUserData(self)
end


-- ========== metamethod ==========

function Collision:__tostring()
    return "Collision: "
end


-- ========== DeLuataEngine ==========

-- --- Collisionクラスの継承
-- --- @return table
-- function Collision:extend()
--     -- 新しいクラスclsを作成
--     --- @class Collision
--     local cls = {}
--     -- Objectクラスの'__'で始まるプロパティをコピー
--     for k, v in pairs(self) do
--         if k:find("__") == 1 then
--         cls[k] = v
--         end
--     end
--     -- clsのメタテーブル__indexにclsを設定
--     cls.__index = cls
--     -- 親クラスの参照を保持
--     cls.super = self
--     -- cls
--     setmetatable(cls, self)
--     return cls
-- end

function Collision:load()
end

function Collision:update(dt)
end

function Collision:draw()
end

--- オブジェクトの破棄
function Collision:destroy()
    -- コールバック呼び出し
    self:onDestroy()

    -- メンバ初期化
    self._gameObject = nil
    self.fixture:setUserData(nil)
    self.fixture:destroy()
    self.fixture = nil

    -- スーパークラス初期化
    self.super:destroy()
end

--- @param isSensor boolean
function Collision:setSensor(isSensor)
    self.isSensor = isSensor
    self.fixture:setSensor(isSensor)
end

--- @param friction number[0, 1]
function Collision:setFriction(friction)
    if friction > 1 or friction < 0 then
        return
    end
    self.fixture:setFriction(friction)
end

--- @param density number
function Collision:setDensity(density)
    self.fixture:setDensity(density)
end

--- @param category integer
--- @param mask integer
--- @param group integer
function Collision:setFilterData(category, mask, group)
    self.fixture:setFilterData(category, mask, group)
end


-- ==========CallBacks==========


--- 衝突時のコールバック関数
--- @param other Collision
--- @param contact love.Contact
function Collision:onCollisionEnter(other, contact)
    LogManager:logDebug(tostring(self._gameObject).. " collided with " .. tostring(other._gameObject))
end

--- 衝突終了時のコールバック関数
--- @param other Collision
--- @param contact love.Contact
function Collision:onCollisionExit(other, contact)
    LogManager:logDebug(tostring(self._gameObject) .. " stopped colliding with " .. tostring(other._gameObject))
end


return {
    Collision=Collision
}