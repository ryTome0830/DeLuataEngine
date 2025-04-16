--- @type Component
local Component = require("abstruct.Component").Component


--- @class RigidBody:Component
--- 継承
--- @field super Component
--- @field protected _enabled boolean
--- @field protected _gameObject GameObject
--- メンバ
--- @field bodyType love.BodyType
--- @field properties {linearDamping?: number, angularDamping?: number, fixedRotation?: boolean, gravityScale?: number, bullet?: boolean, sleepingAllowed?: boolean, awake?: boolean, linearVelocity?: {x: number, y: number}, angularVelocity?: number}
--- @field body love.Body
local RigidBody = Component:extend()
RigidBody.__index = RigidBody


--- RigidBodyコンストラクタ
--- @param gameObject GameObject
--- @param bodyType? love.BodyType
--- @param properties? {linearDamping?: number, angularDamping?: number, fixedRotation?: boolean, gravityScale?: number, bullet?: boolean, sleepingAllowed?: boolean, awake?: boolean, linearVelocity?: {x: number, y: number}, angularVelocity?: number}
--- @return RigidBody
function RigidBody.new(gameObject, bodyType, properties)
    --- @class RigidBody
    local instance = setmetatable({}, RigidBody)
    instance:init(
        gameObject,
        bodyType or "dynamic",
        properties or {}
    )

    return instance
end

--- @param gameObject GameObject
---@param bodyType love.BodyType
---@param properties table
function RigidBody:init(gameObject, bodyType, properties)
    self.super:init(gameObject)
    self._gameObject = gameObject
    self.bodyType = bodyType
    self.properties = properties
    self.body = love.physics.newBody(
        self._gameObject.scene.world,
        gameObject.transform.pos.x,
        gameObject.transform.pos.y,
        self.bodyType
    )
    self.body:setAngle(self._gameObject.transform.rotation)
    self.body:setUserData(self._gameObject)

    if properties.linearDamping then self.body:setLinearDamping(properties.linearDamping) end
    if properties.angularDamping then self.body:setAngularDamping(properties.angularDamping) end
    if properties.fixedRotation then self.body:setFixedRotation(properties.fixedRotation) end
    if properties.gravityScale then self.body:setGravityScale(properties.gravityScale) end
    if properties.bullet then self.body:setBullet(properties.bullet) end
    if properties.sleepingAllowed then self.body:setSleepingAllowed(properties.sleepingAllowed) end
    if properties.linearVelocity then self.body:setLinearVelocity(properties.linearVelocity.x, properties.linearVelocity.y) end
    if properties.angularVelocity then self.body:setAngularVelocity(math.rad(properties.angularVelocity)) end

    if properties.awake then self.body:setAwake(properties.awake) end
end

function RigidBody:load()
    
end

function RigidBody:update(dt)
    if not self:isEnable() or not self.body then return end
    if self.bodyType == "static" then return end

    if self.body:isActive() then
        self._gameObject.transform.pos:set(self.body:getPosition())
        self._gameObject.transform.rotation = self.body:getAngle()
    end
end

function RigidBody:destroy()
    self.body:destroy()
    self.body = nil
    self.super:destroy()
end

--- transform --> Body
--- @private
function RigidBody:syncBodyToTransform()
    self.body:setPosition(self._gameObject.transform.pos:get())
    self.body:setAngle(self._gameObject.transform.rotation)
end

--- Bodyの質量データリセット(called: Fixture)
function RigidBody:resetMassData()
    if self.bodyType == "dynamic" then
        self.body:resetMassData() 
    end
end

return{
    RigidBody=RigidBody
}
