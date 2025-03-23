--[[
SpriteAnimation
]]
--- @type Animation
local Animation = require("animations.Animation").Animation



--- @class SpriteAnimation
local SpriteAnimation = Animation:extend()
SpriteAnimation.__index = SpriteAnimation


return {
    SpriteAnimation=SpriteAnimation
}