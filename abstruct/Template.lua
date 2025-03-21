--- @class Object
local Object = require("abstruct.Object").Object

--- @class GameObject
local GameObject = require("objects.GameObject").GameObject

--- @class Vector2
local Vector2 = require("Vector2").Vector2

--- @class Transform
local Transform = require("Transform").Transform



--- @class Template:Object
--- @field name string
local Template = Object:extend()
Template.__index = Template


function Template.new()
    LogManager:logError("Template is an abstract class and cannot be instantiated directly.")
end

function Template:init()
    self.super:init()
    self.name = ""

    --- @type {class: Component, args: any[]}[]
    self.components = {}

    --- @type {template: Template, pos: Vector2, rotation: number}[]
    self.children = {}
end

--- @param pos? Vector2
--- @param rotation? number
--- @param parent? GameObject|nil
--- @return GameObject
function Template:clone(pos, rotation, parent)
    local gameObject = GameObject.new(self.name.."(clone)")
    gameObject.transform.pos = pos or Vector2.new()
    gameObject.transform.rotation = rotation or 0

    if parent then
        parent.transform:addChild(gameObject.transform)
    end

    for _, component in ipairs(self.components) do
        gameObject:addComponent(component.class, unpack(component.args))
    end

    for _, child in ipairs(self.children) do
        if not child.template:is(self) then
            child.template:clone(
                child.pos or Vector2.new(),
                child.rotation or 0,
                gameObject
            )
        end
    end

    return gameObject
end

return{
    Template = Template
}
