--[[
Componentクラスは、あらゆるコンポーネントの基底クラスです。
このクラスは、GameObjectにアタッチして、ゲームオブジェクトの動作を拡張するために使用されます。
Componentクラスを継承することで、独自のコンポーネントを作成することができます。
]]

--- @type Object
local Object = require("abstruct.Object").Object



--- このクラスは抽象クラスです。サブクラスでメソッドを実装する必要があります。
--- @class Component:Object Component抽象クラス
--- 継承
--- @field super Object
--- @field protected _enabled boolean
--- Componentメンバ
--- @field protected _gameObject GameObject アタッチされるオブジェクト
local Component = Object:extend()
Component.__index = Component

--- Debugging function
-- --- Componentコンストラクタ
-- --- @private
-- --- @param gameObject GameObject
-- function Component.new(gameObject)
--     --- @class Component
--     local instance = setmetatable({}, Component)
--     instance:init(gameobjects)
--     return instance
-- end

--- Componentコンストラクタ
--- @param gameObject GameObject
--- @vararg any コンポーネントの初期化に必要な引数
--- --@return Component
function Component.new(gameObject, ...)
end

--- 初期化処理
--- @protected
--- @param gameObject GameObject
function Component:init(gameObject)
    -- スーパークラスの初期化
    self.super:init()
    --- @private
    self._gameObject = gameObject
end


-- ========== metamethod ==========

--- 
--- @return string
function Component:__tostring()
    return "Component: "
end


-- ========== DeLuataEngine ==========

--- Componentクラスの継承
--- @return table
function Component:extend()
    -- 新しいクラスclsを作成
    --- @class Component
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

function Component:load()
end

function Component:update(dt)
end

function Component:draw()
end

--- オブジェクトの破棄
function Component:destroy()
    -- コールバック呼び出し
    self:onDestroy()

    -- メンバ初期化
    self._gameObject = nil

    -- スーパークラス初期化
    self.super:destroy()
end

-- ==========CallBacks==========

--- 有効化時のコールバック関数
function Component:onEnable()
end

--- 無効化時のコールバック関数
function Component:onDisable()
end

--- 破棄時のコールバック関数
function Component:onDestroy()
end

return{
    Component=Component
}