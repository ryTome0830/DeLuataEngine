--[[
ScenenManagerクラス。ゲームのシーンを制御し、Sceneがあらゆるオブジェクトを管理します。
]]
--- @class SceneManager
local SceneManager = {}
SceneManager.__index = SceneManager

-- シングルトンインスタンス
local SceneManagerInstance = nil

--- SceneManagerコンストラクタ
--- @return SceneManager
function SceneManager.new()
    if SceneManagerInstance == nil then
        --- @class SceneManager
        local instance = setmetatable({}, SceneManager)
        instance:init()
        SceneManagerInstance = instance
    end
    return SceneManagerInstance
end

--- 初期化処理
function SceneManager:init()
    --- シーンキャッシュ
    --- @private
    --- @type table<string, Scene>
    self.scenes = {}

    --- 読み込み中のシーン
    --- @private
    --- @type Scene
    self.currentScene = nil
end


-- ========== metamethod ==========

--- @private
--- @return string
function SceneManager:__tostring()
    return "SceneManager: currentScene="..tostring(self.currentScene)
end


-- ==========DeLuataEngine=========

--- @param sceneName string
--- @param sceneClass Scene
function SceneManager:registerScene(sceneName, sceneClass)
    if sceneName and sceneClass then
        self.scenes[sceneName] = sceneClass
    end
end

-- --- called GameObject:init
-- --- @param gameObject GameObject
-- function SceneManager:registerGameObject(gameObject)
--     if self.currentScene then
--         self.currentScene:addGameObject(gameObject)
--         gameObject.scene = self.currentScene
--     end
-- end

--- @return Scene
function SceneManager:getCurrentScene()
    return self.currentScene
end

--- @param sceneName string
function SceneManager:loadScene(sceneName)
    if self.scenes then
        self.currentScene = self.scenes[sceneName].new()
        self.currentScene.name = sceneName
        self.currentScene:load()
    end
end

function SceneManager:updateScene(dt)
    self.currentScene:update(dt)
end

--- @param sceneName string
function SceneManager:changeScene(sceneName)
    if self.scenes[sceneName] then
        self:unloadScene()
        self:loadScene(sceneName)
    end
end

function SceneManager:unloadScene()
    self.currentScene:destroy()
end


return{
    SceneManager=SceneManager
}