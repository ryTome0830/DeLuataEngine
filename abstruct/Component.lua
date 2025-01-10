local Object = require("abstruct.Object").Object

--- このクラスは抽象クラスです。サブクラスでメソッドを実装する必要があります。
--- @class Component:Object Component抽象クラス
--- @field object Object アタッチされるオブジェクト
--- @field enabled boolean コンポーネントの有効化/無効化
local Component = Object:extend()
Component.__index = Component

-- --- Componentコンストラクタ
-- --- @param object Object
-- function Component.new(object)
--     --- @class Component
--     local instance = setmetatable({}, Component)
--     instance:init(object)
--     return instance
-- end

-- --- 初期化処理
-- --- @private
-- --- @param object Object
-- function Component:init(object)
--     self.object = object
--     self.enabled = true
-- end


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

--- 有効化/無効化切り替える
--- @param active boolean
function Component:setActive(active)
    -- コンポーネントの状態がすでにactiveと同じ場合スルー
    if self.enabled == active then return end

    -- コールバック関数を呼び出す
    self.enabled = active
    if self.enabled then
        self:onEnable()
    else
        self:onDisable()
    end
end

return{
    Component=Component
}