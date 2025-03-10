local Collision = require("abstruct.Collision").Collision

--- @class CircleCollision:Collision
--- @field super Collision
local CircleCollision = Collision:extend()
CircleCollision.__index = CircleCollision


--- @param gameObject GameObject
--- @param fixture love.Fixture
function CircleCollision.new(gameObject, fixture)
    --- @class CircleCollision
    local instance = setmetatable({}, CircleCollision)
    instance:init(gameObject, fixture)
    return instance
end

--- @param gameObject GameObject
--- @param fixture love.Fixture
function CircleCollision:init(gameObject, fixture)
    -- スーパークラス初期化
    self.super:init(gameObject, fixture)

    self.gameObject = gameObject
    self.fixture = fixture

end