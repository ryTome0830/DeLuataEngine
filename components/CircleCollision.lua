--- @type Collision
local Collision = require("abstruct.Collision").Collision



--- @class CircleCollision:Collision
--- @field super Collision
local CircleCollision = Collision:extend()
CircleCollision.__index = CircleCollision
