--[[ 
This Object implementation is based on the one from SNKRX, 
which is licensed under the MIT License. 
SNKRX is an open-source game available at (https://github.com/a327ex/SNKRX/blob/master/engine/game/object.lua).
This class has been slightly modified for use in this project.
This Object base class implementation was taken from SNKRX (MIT license)
]]

--- @class Object あらゆるオブジェクトの基底クラス
--- @field private _enabled boolean オブジェクトの有効化無向化
local Object = {}
Object.__index = Object

-- --- コンストラクタ
-- --- @private
-- --- @return Object
-- function Object.new()
--     --- @class Object
--     local instance = setmetatable({}, Object)
--     instance:init()
--     return instance
-- end

--- 初期化処理
--- @protected
function Object:init()
    --print("Object:init called")
    --- @private
    self._enabled = true
end


-- ========== metamethod ==========

--- @private
--- @package
--- @return string
function Object:__tostring()
    return "Object"
end

--- @private
--- @@package
function Object:__newindex(key, value)
    if key == "_enabled" then
        if value == true and not self._enabled then
            self:onEnable()
        elseif value == false and self._enabled then
            self:onDisable()
        elseif value ~= true and value ~= false then
            error("The argument is wrong! '_enabled' must be a boolean value!")
        end
        rawset(self, key, value)
    else
        rawset(self, key, value)
    end
end

-- ========== DeLuataEngine ==========

--- Objectクラスの継承
--- @return table
function Object:extend()
    -- 新しいクラスclsを作成
    --- @class Object
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

--- インスタンスがクラスTのインスタンスまたはそのサブクラスのインスタンスかどうかを判定
--- @param T table クラス
--- @return boolean
function Object:is(T)
    local mt = getmetatable(self)
    while mt ~= nil do
        if mt == T then
            return true
        end
        mt = getmetatable(mt)
    end
    return false
end


-- ========== DeLuataEngine ==========

--- オブジェクトの状態を返す
--- @return boolean
function Object:isEnable()
    return self._enabled
end

--- オブジェクトの状態を変更する
--- @param active boolean
function Object:setActive(active)
    -- 状態がすでに_enabledと同じときスルー
    if self._enabled == active then return end

    -- _enabledを切り替えてコールバック関数を呼び出す
    self._enabled = active
    if self._enabled then
        self:onEnable()
    else
        self:onDisable()
    end
end

--- 開始処理
function Object:load()
end

--- 更新処理
--- @param dt number フレーム時間love.update(dt)
function Object:update(dt)
end

--- 描画処理
function Object:draw()
end

--- オブジェクトの破棄
function Object:destroy()
    self:onDestroy()
end

-- ==========CallBacks==========

--- 有効化時のコールバック関数
--- @private
function Object:onEnable()
end

--- 無効化時のコールバック関数
--- @private
function Object:onDisable()
end

--- 破棄時のコールバック関数
--- @private
function Object:onDestroy()
end

return {
    Object=Object
}