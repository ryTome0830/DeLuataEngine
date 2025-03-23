--- @type Component
local Component = require("abstruct.Component").Component



--- @class Collision:Component
--- 継承
--- @field super Component
--- @field private gameObject Object
--- @field private _enabled boolean
--- Collisionメンバ
--- @field offsetX number
--- @field offsetY number
--- @field worldPosition Vector2
local Collision = Component:extend()
Collision.__index = Collision


--- Collisionコンストラクタ
--- @param gameObject GameObject
--- @param fixture love.Fixture
function Collision.new(gameObject, fixture)
end

--- 初期化処理
--- @protected
--- @param gameObject GameObject
--- @param fixture love.Fixture
function Collision:init(gameObject, fixture)
    -- スーパークラスの初期化
    self.super:init(gameObject)
    --- @private
    self.fixture = fixture
end

-- ========== DeLuataEngine ==========

--- Collisionクラスの継承
--- @return table
function Collision:extend()
    -- 新しいクラスclsを作成
    --- @class Collision
    local cls = {}
    -- Objectクラスの'__'で始まるプロパティをコピー
    for k, v in pairs(self) do
        if k:find("__") == 1 then
        cls[k] = v
        end
    end
    -- clsのメタテーブル__indexにclsを設定
    cls.__index = cls
    -- 親クラスの参照を保持
    cls.super = self
    -- cls
    setmetatable(cls, self)
    return cls
end

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
    self.gameObject = nil
    self.fixture:destroy()
    self.fixture = nil

    -- スーパークラス初期化
    self.super:destroy()
    self.super = nil
end

function Collision:setSensor(isSensor)
    self.isSensor = isSensor
    if self.fixture then
        self.fixture:setSensor(isSensor)
    end
end

-- ==========CallBacks==========

--- 有効化時のコールバック関数
function Collision:onEnable()
end

--- 無効化時のコールバック関数
function Collision:onDisable()
end

--- 破棄時のコールバック関数
function Collision:onDestroy()
end











return {
    Collision=Collision
}