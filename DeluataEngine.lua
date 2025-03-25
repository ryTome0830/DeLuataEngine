require("functions.Functions")
require("InputManager")
require("SceneManager")
require("LogManager")
_G.DeLuataEngine={
    Scene = require("abstruct.Scene").Scene,
    Template = require("abstruct.Template").Template,
    Transform = require("Transform").Transform,
    Vector2 = require("Vector2").Vector2,

    -- animationモジュール
    Animation={
        MoveAnimation=require("animations.MoveAnimation").MoveAnimation,
        SpriteAnimation=require("animations.SpriteAnimation").SpriteAnimation
    },
    -- audioモジュール
    Audio={

    },
    -- componentモジュール
    Component={
        Component=require("abstruct.Component").Component
    },
    -- effectモジュール
    Effect={

    },
    -- mathモジュール
    Maths={
        Math = require("math.Math").Math,
        Random = require("math.Random").Random
    },
    -- obectモジュール
    Object={
        GameObject = require("objects.GameObject").GameObject
    },
    -- UIモジュール
    UI={

    }
}

function LoadEngine()
    
end

function UpdateEngine(dt)

end

function LateUpdateEngine(dt)
    InputManager:update()
end