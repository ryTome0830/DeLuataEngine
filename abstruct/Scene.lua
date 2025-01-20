--[[
Sceneクラス。シーンの定義の基底クラスです。
すべてのゲームのオブジェクトやコンポーネントを保持します。
]]
--- @class Scene
local Scene = {}
Scene.__index = Scene

--- Sceneコンストラクタ
-- --- @param name string
-- --- @return Scene
-- function Scene.new(name)
--     --- @class Scene
--     local instance = setmetatable({}, Scene)
--     instance:init(name)
--     return instance
-- end

--- Scene初期化処理
--- @private
--- @package
--- @param name string
function Scene:init(name)
    -- シーンの初期化処理
    self.name = name or "Scene"
    --- @type table<string, GameObject>
    self.gameObjects = {}
end


-- ==========mmetamethod==========

--- @private
--- @return string
function Scene:__tostring()
    return "Scene: "..self.name
end

--- GameObjectの追加
--- @param gameObject GameObject
function Scene:addGameObject(gameObject)
    self.gameObjects[gameObject.name] = gameObject
end

--- GameObjectの削除
--- @param gameObjectName string
function Scene:removeGameObject(gameObjectName)
    self.gameObjects[gameObjectName] = nil
end

--- GameObjectの検索
--- @param gameObjectName string
--- @return GameObject
function Scene:findGameObject(gameObjectName)
    return self.gameObjects[gameObjectName]
end

--- オブジェクトの生成
function Scene:loadObject()
end

--- Sceneのロード
function Scene:load()
    for _, gameObject in pairs(self.gameObjects) do
        gameObject:load()
    end
end

--- Sceneの更新
--- @param dt number
function Scene:update(dt)
    for _, gameObject in pairs(self.gameObjects) do
        gameObject:update(dt)
    end
end

-- ==========callback==========

--- シーンの切り替わり
function Scene:onChange()
    for _, gameObject in pairs(self.gameObjects) do
        gameObject:destroy()
    end
end

return{
    Scene=Scene
}