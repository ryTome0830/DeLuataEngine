local Object = require("abstruct.Object").Object

--- このクラスは抽象クラスです。サブクラスでメソッドを実装する必要があります。
--- @class Component:Object Component抽象クラス
--- 継承
--- @field super Object
--- @field _enabled boolean
--- Componentメンバ
--- @field private object Object アタッチされるオブジェクト
local Component = Object:extend()
Component.__index = Component

--- Debugging function
-- --- Componentコンストラクタ
-- --- @private
-- --- @param object Object
-- function Component.new(object)
--     --- @class Component
--     local instance = setmetatable({}, Component)
--     instance:init(object)
--     return instance
-- end

--- 初期化処理
--- @protected
--- @param object Object
function Component:init(object)
    --print("Component:init called")
    -- スーパークラスの初期化
    self.super:init()
    --- @protected
    self.object = object
end


-- ========== metamethod ==========

--- 
--- @return string
function Component:__tostring()
    return "Component"
end


-- ========== DeLuataEngine ==========

--- 開始処理
function Component:load()
end

--- 更新処理
--- @param dt number フレーム時間love.update(dt)
function Component:upadte(dt)
end

--- 描画処理
function Component:draw()
end

--- 有効化時のコールバック関数
function Component:onEnable()
end

--- 無効化時のコールバック関数
function Component:onDisable()
end

-- --- 有効化/無効化切り替える
-- --- @param active boolean
-- function Component:setActive(active)
--     -- コンポーネントの状態がすでにactiveと同じ場合スルー
--     if self._enabled == active then return end

--     -- コールバック関数を呼び出す
--     self._enabled = active
--     if self._enabled then
--         self:onEnable()
--     else
--         self:onDisable()
--     end
-- end

return{
    Component=Component
}