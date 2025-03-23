--[[
MoveAnimation
]]
--- @type Animation
local Animation = require("animations.Animation").Animation



--- @class MoveAnimation
local MoveAnimation = Animation:extend()
MoveAnimation.__index = MoveAnimation



return {
    MoveAnimation=MoveAnimation
}