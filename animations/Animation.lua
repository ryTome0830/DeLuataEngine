--- @class Animation
local Animation = {}
Animation.__index = Animation

--- Animationクラスの継承
--- @return table
function Animation:extend()
    -- 新しいクラスclsを作成
    --- @class Scene
    local cls = {}
    -- Sceneクラスの'__'で始まるプロパティをコピー
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


return {
    Animation=Animation
}