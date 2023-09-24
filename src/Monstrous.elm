module Monstrous exposing (MonstrousName(..), toString)


type MonstrousName
    = MonstrousName


toString : MonstrousName -> String
toString _ =
    "The Monstrous"


type alias Curse =
    { name : String
    , description : String
    }


type NaturalAttackBase
    = Teeth
    | Claws
    | Force
    | LifeDrain


type Extra
    = Harm
    | Armour
    | RangeTag


type NaturalAttack
    = Base (Maybe Extra) (Maybe Extra) (Maybe Extra)



-- type alias MonstrousMaker =
--     { name : MonstrousName
--     , description : String
--     , curses : List.Nonempty Curse
--     , naturalAttacks : Listn.Nonempty NaturalAttack
--     , moves : Listn.Nonempty Move
--     , gear : List.Nonempty Gear
--     }
