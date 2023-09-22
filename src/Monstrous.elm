module Monstrous exposing (..)

import Core exposing (Gear, Move)
import List.Nonempty as Listn


type MonstrousName
    = Monstrous


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


type alias MonstrousMaker =
    { name : MonstrousName
    , description : String
    , curses : List.Nonempty Curse
    , naturalAttacks : Listn.Nonempty NaturalAttack
    , moves : Listn.Nonempty Move
    , gear : List.Nonempty Gear
    }
