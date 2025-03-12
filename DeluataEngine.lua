require("SceneManager")
require("LogManager")
_G.DeLuataEngine={    -- エンジンの主要クラス
    Input = require("Input").Input,
    Scene = require("abstruct.Scene").Scene,
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

    },
    -- effectモジュール
    Effect={

    },
    -- functionモジュール
    Function={

    },
    -- mathモジュール
    Math={
        
    },
    -- obectモジュール
    Object={
        GameObject = require("objects.GameObject").GameObject
    },
    -- UIモジュール
    UI={
        
    }
}