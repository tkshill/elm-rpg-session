module Monstrous exposing (MonstrousName(..), toString)

import Core exposing (Gear, Move)
import Element.Region exposing (description)
import List.Nonempty as Listn


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


type alias LineageSuggestion =
    { name : String
    , description : String
    }


type alias MonstrousMaker =
    { name : MonstrousName
    , flavour : String
    , lineage : String
    , lineageSuggestions : List LineageSuggestion

    -- , lookExamples : String
    -- , curses : List.Nonempty Curse
    -- , naturalAttacks : Listn.Nonempty NaturalAttack
    -- , moves : Listn.Nonempty Move
    -- , gear : List.Nonempty Gear
    }


monstrousMaker : MonstrousMaker
monstrousMaker =
    { name = MonstrousName
    , flavour = """
        I feel the hunger, the lust to destroy.
        But I fight it: I never give in.
        I’m not human any more, not really, 
        but I have to protect those who still are.
        That way I can tell myself I’m different to the other monsters.
        Sometimes I can even believe it.
        """
    , lineage = """
        You’re  half-human,  half-monster:  decide  if  you  were  always  this  way or if you you were originally human and transformed somehow.
        Now decide if you were always fighting to be good, or if you were evil and changed sides.
        Define  your  monstrous  breed  by picking a curse,  moves, and natural attacks.
        Create the monster you want to be: whatever you choose defines your breed in the game.
        Some classic monsters with suggestions for picks are listed below. These are only suggestions: feel free to make a different version!
        """
    , lineageSuggestions =
        [ { name = "vampire"
          , description = """
            Curse: feed (blood or life-force). 
            Natural attacks:
                Base: life-drain  or  Base:  teeth;  
                add  +1  harm  to  base  attack.  
            Moves: 
                immortal or unquenchable vitality; 
                mental domination.
            """
          }
        ]
    }
