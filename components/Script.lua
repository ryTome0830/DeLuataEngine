--- @type Component
local Component = require("abstruct.Component").Component

--- @class Script:Component
--- 継承
--- @field super Component
--- @field protected _gameObject GameObject
--- @field protected _enabled boolean
--- Collisionメンバー
--- 
local Script = Component:extend()
Script.__index = Script


--- Scriptコンストラクタ
--- @param gameObject GameObject
function Script.new(gameObject)
    --- @class Script
    local instance = setmetatable({}, Script)
    instance:init(gameObject)
    return instance
end

--- 初期化処理
--- @param gameObject GameObject
function Script:init(gameObject)
    self.super:init(gameObject)
    self._gameObject = gameObject
end


-- ========= metamethod ==========

function Script:__tostring()
    return "Script: "
end


-- ========= DeLuataEngine ==========

-- --- Scriptクラスの継承
-- --- @return table
-- function Script:extend()
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

function Script:load()
end

function Script:update(dt)
end

function Script:draw()
end

function Script:destroy()
    -- コールバック呼び出し
    self:onDestroy()

    -- メンバ初期化
    self._gameObject = nil
    self.super:destroy()
end


return {
    Script=Script,
}
