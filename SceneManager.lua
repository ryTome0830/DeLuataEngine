--[[
ScenenManagerクラス。ゲームのシーンを制御し、Sceneがあらゆるオブジェクトを管理します。
]]

--- @types Template
local Template = require("abstruct.Template").Template


--- @class SceneManager
--- @field scenes Scene<string, Scene> 登録されたシーンを保存
--- @field currentScene Scene 現在のロード中のシーン
local SceneManager = {}
SceneManager.__index = SceneManager

-- シングルトンインスタンス
local SceneManagerInstance = nil

--- SceneManagerコンストラクタ
--- @private
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

--- 指定したTemplateをSceneに追加します。
--- @param template Template
--- @param pos? Vector2
--- @param rotation? number
--- @param parent? GameObject
--- @return GameObject|nil
--- @overload fun(self: SceneManager, template: Template): GameObject|nil
--- @overload fun(self: SceneManager, template: Template, pos: Vector2): GameObject|nil
--- @overload fun(self: SceneManager, template: Template, pos: Vector2, rotation: number): GameObject|nil
--- @overload fun(self: SceneManager, template: Template, pos: Vector2, rotation: number, parent: GameObject): GameObject|nil
function SceneManager:instantiate(template, pos, rotation, parent)
    if not template then
        LogManager:logError("SceneManager:instantiate: template cannot be nil")
        return nil
    end
    if not template:is(Template) then
        LogManager:logError("'template' must be of type Template")
        return nil
    end

    --- @type GameObject
    local newGameObject = template:clone(pos, rotation, parent)
    if not newGameObject then
        LogManager:logError("Instantiation failed")
        return nil
    end

    return newGameObject
end


-- --- @return string
-- function SceneManager:generateUUID()
--     return string.format("%s", self.currentScene.gameObjectNum + 1)
-- end

--- @param sceneName string
--- @param sceneClass Scene
function SceneManager:registerScene(sceneName, sceneClass)
    if sceneName and sceneClass then
        self.scenes[sceneName] = sceneClass
    end
end

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
    --LogManager:logInfo("load: "..tostring(self.currentScene))
end

function SceneManager:updateScene(dt)
    self.currentScene:update(dt)
    --LogManager:logInfo("update: "..tostring(self.currentScene))
end

--- @param sceneName string
function SceneManager:changeScene(sceneName)
    if self.scenes[sceneName] then
        self:unloadScene()
        self:loadScene(sceneName)
    end
    --LogManager:logInfo("change: "..tostring(self.currentScene))
end

function SceneManager:unloadScene()
    self.currentScene:destroy()
    --LogManager:logInfo("unloaded: "..tostring(self.currentScene))
end

--- グローバルスコープ化
_G.SceneManager = SceneManager.new()
