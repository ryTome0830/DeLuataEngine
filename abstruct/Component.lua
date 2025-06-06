--[[
Componentクラスは、あらゆるコンポーネントの基底クラスです。

このクラスは、GameObjectにアタッチして、ゲームオブジェクトの動作を拡張するために使用されます。

Componentクラスを継承することで、独自のコンポーネントを作成することができます。
]]

local Object = require("abstruct.Object").Object

--- このクラスは抽象クラスです。サブクラスでメソッドを実装する必要があります。
--- @class Component:Object Component抽象クラス
--- 継承
--- @field super Object
--- @field private _enabled boolean
--- Componentメンバ
--- @field private gameObject Object アタッチされるオブジェクト
local Component = Object:extend()
Component.__index = Component

--- Debugging function
-- --- Componentコンストラクタ
-- --- @private
-- --- @param gameObject Object
-- function Component.new(gameObject)
--     --- @class Component
--     local instance = setmetatable({}, Component)
--     instance:init(gameobjects)
--     return instance
-- end

--- Componentコンストラクタ
--- @param gameObject GameObject
--- @vararg any コンポーネントの初期化に必要な引数
function Component.new(gameObject, ...)
end

--- 初期化処理
--- @protected
--- @param gameObject Object
function Component:init(gameObject, ...)
    -- スーパークラスの初期化
    self.super:init()
    --- @private
    self.gameObject = gameObject
end


-- ========== metamethod ==========

--- 
--- @return string
function Component:__tostring()
    return "Component"
end


-- ========== DeLuataEngine ==========

--- Componentクラスの継承
-- --- @return table
-- function Component:extend()
--     -- 新しいクラスclsを作成
--     --- @class Component
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

-- function Component:load()
-- end

-- function Component:update(dt)
-- end

-- function Component:draw()
-- end

-- --- オブジェクトの破棄
-- function Object:Destroy()
--     self:onDestroy()
-- end

-- ==========CallBacks==========

-- --- 有効化時のコールバック関数
-- function Component:onEnable()
-- end

-- --- 無効化時のコールバック関数
-- function Component:onDisable()
-- end

--- 破棄時のコールバック関数
--- @override
function Component:onDestroy()
    -- メモリリーク防止
    self.gameObject = nil
end

return{
    Component=Component
}