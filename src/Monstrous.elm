module Monstrous exposing (MonstrousName(..), toString)

import Core exposing (Gear, Move)
import Element.Region exposing (description)
import List.Nonempty as Listn


type alias BaseRatings =
    { charm : Int
    , weird : Int
    , sharp : Int
    , tough : Int
    }


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
    , looks : List (List String)
    , lineageSuggestions : List LineageSuggestion
    , instructions : String
    , baseRatings : BaseRatings
    , curses : List Curse

    -- , lookExamples : String
    -- , curses : List.Nonempty Curse
    -- , naturalAttacks : Listn.Nonempty NaturalAttack
    -- , moves : Listn.Nonempty Move
    -- , gear : List.Nonempty Gear
    }


monstrousMaker : MonstrousMaker
monstrousMaker =
    { name = MonstrousName
    , instructions = """
        To make your Monstrous, first pick a name. Then follow the instructions  below  to  decide  your  look,  ratings,  breed,  moves,  and  gear.  
        Finally, introduce yourself and pick history.
        """
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
        [ { name = "Vampire"
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
        , { name = "Werewolf"
          , description = """
            Curse:  vulnerability  (silver).
            Natural  attacks:
                Base: claws;
                Base:  teeth.
            Moves:
                shapeshifter  (wolf  and/or  wolfman);  
                claws of the beast or unholy strength.
            """
          }
        , { name = "Ghost"
          , description = """
            Curse:  vulnerability  (rock  salt).
            Natural  attacks:
                Base: magical  force;
                add  hand  range  to  magical  force.  
            Moves:
                incorporeal;
                immortal.
            """
          }
        , { name = "Faerie"
          , description = """
            Curse:  pure  drive  (joy).
            Natural  attacks:
                Base:  magical force;
                add  ignore-armour  to  magical  force.
            Moves:
                flight;
                preternatural speed.
            """
          }
        , { name = "Demon"
          , description = """
            Curse: pure drive (cruelty).
            Natural attacks:
                Base: claws; 
                +1 harm to claws.
            Moves:
                dark negotiator;
                unquenchable vitality.
            """
          }
        , { name = "Orc"
          , description = """
            Curse: dark master (the orc overlord).
            Natural attacks:
                Base: teeth; 
                add ignore-armour to teeth.
            Moves:
                Unholy strength;
                dark negotiator.
            """
          }
        , { name = "Zombie"
          , description = """
            Curse: pure drive (hunger), feed (flesh or brains). 
            Natural attacks:
                Base: teeth;
                +1 harm to teeth.
            Moves:
                immortal; 
                unquenchable vitality.
            """
          }
        ]
    , looks =
        [ [ "Man", "Woman", "Mysterious", "Transgressive" ]
        , [ "Sinister aura", "powerful aura", "dark aura", "unnerving aura", "energetic aura", "evil aura", "bestial aura" ]
        , [ "Archaic  clothes", "casual  clothes", "ragged  clothes", "tailored  clothes", "stylish clothes", "street clothes", "outdoor clothes" ]
        ]
    , baseRatings =
        { charm = 0
        , sharp = -1
        , tough = 1
        , weird = 2
        }
    , curses =
        [ { name = "Feed"
          , description = """
            You must subsist on living humans.
            It might take the form of blood, brains, or spiritual essence but it must be from people. 
            You need to act under pressure to resist feeding whenever a perfect opportunity presents itself.
            """
          }
        , { name = "Vulnerability"
          , description = """
            Pick a substance.
            You suffer +1 harm when you suffer harm from it.
            If you are bound or surrounded by it, you must act under pressure to use your powers.
            """
          }
        , { name = "Pure  Drive"
          , description = """
                One emotion rules you.
                Pick from: hunger, hate, anger, fear, jealousy, greed, joy, pride, envy, lust, or cruelty.
                Whenever you have a chance to indulge that emotion, you must do so immediately, or act under pressure to resist.
                """
          }
        , { name = "Dark  Master"
          , description = """
                You have an evil lord who doesn’t know you changed sides.
                They still give you orders, and they do not tolerate refusal. Or failure.
                """
          }
        ]
    }
