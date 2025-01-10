--[[ 
This Object implementation is based on the one from SNKRX, 
which is licensed under the MIT License. 
SNKRX is an open-source game available at (https://github.com/a327ex/SNKRX/blob/master/engine/game/object.lua).
This class has been slightly modified for use in this project.
This Object base class implementation was taken from SNKRX (MIT license)
]]

--- @class Object
local Object = {}
Object.__index = Object

-- --- コンストラクタ
-- --- @return Object
-- function Object.new()
--     --- @class Object
--     local instance = setmetatable({}, Object)
--     instance:init()
--     return instance
-- end

-- --- 初期化処理
-- --- @private
-- function Object:init()
-- end


-- ========== metamethod ==========

--- 
--- @return string
function Object:__tostring()
    return "Object"
end


-- ========== DeLuataEngine ==========

--- Objectクラスの継承
--- @return table
function Object:extend()
    -- 新しいクラスclsを作成
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
    while mt do
        if mt == T then
            return true
        end
        mt = getmetatable(mt)
    end
    return false
end

return {
    Object=Object
}