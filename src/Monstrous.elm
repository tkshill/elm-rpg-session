module Monstrous exposing (MonstrousName(..), monstrousMaker, toString)

import Core
    exposing
        ( BaseRatings
        , BasicMoveName(..)
        , Charm(..)
        , Gear_
        , History
        , Moves
        , Rating(..)
        , Tough(..)
        )


type MonstrousName
    = MonstrousName


toString : MonstrousName -> String
toString _ =
    "The Monstrous"


type alias Curse =
    { name : String
    , description : String
    }


type alias Attack =
    String


type alias LineageSuggestion =
    { name : String
    , description : String
    }


type alias AttackExtra =
    String


type alias MonstrousMaker =
    { name : MonstrousName
    , flavour : String
    , lineage : String
    , looks : List (List String)
    , lineageSuggestions : List LineageSuggestion
    , instructions : String
    , baseRatings : BaseRatings
    , curses : List Curse
    , attacks : List Attack
    , extras : List AttackExtra
    , moves : Moves
    , gear : Gear_
    , history : History
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
    , attacks =
        [ "Base: Teeth (3 harm, intimate)"
        , "Base: Claws (2 harm, hand)"
        , "Base: Life-Drain (1 harm, intimate, life-drain)"
        , "Base: Magical Force (1 harm, close, magical)"
        ]
    , extras =
        [ "Extra: Add one harm to a base"
        , "Extra: Add ignore armour to a base"
        , "Extra: Add extra range to a base"
        ]
    , moves =
        { description = "You get all the basic moves, plus pick three Monstrous moves:"
        , limit = 3
        , moveList =
            [ { name = "Immortal"
              , description = "You do not age or sicken, and whenever you suffer harm you suffer 1-harm less."
              , rollable = Nothing
              }
            , { name = "Unnatural Appeal"
              , description = "Roll +Weird instead of +Charm when you Sway Someone."
              , rollable = Nothing
              }
            , { name = "Unholy Strengh"
              , description = "Roll +Weird instead of +Guts when you are trying to inflict harm."
              , rollable = Nothing
              }
            , { name = "Incorporeal"
              , description = "You can pass through solid objects (but not people)."
              , rollable = Nothing
              }
            , { name = "Preternatural Speed"
              , description = "You can move much faster than normal people. When you are trying to chase, flee, or run, take +1 to your roll."
              , rollable = Nothing
              }
            , { name = "Claws of the beast"
              , description = "All Natural attacks do +1 harm."
              , rollable = Nothing
              }
            , { name = "Mental Dominion"
              , description = "Get +1 when you try to Sway a normal human. If you try to sway another hunter and you succeed, add Karma."
              , rollable = Just (C Charm)
              }
            , { name = "Unquenchable Vitality"
              , description = "When you take harm, you can heal yourself. Roll +Tough. On a 10+, heal 2. On a 7-9, heal 1. On a 6 or lower your injuries worsen."
              , rollable = Just (T Tough)
              }
            , { name = "Shapeshifter"
              , description = "You can change your form, usually into an animal. Decide what your form(s) are. Take +1 to assess reality when you use your form's sense to investigate."
              , rollable = Nothing
              }
            , { name = "Something Borrowed"
              , description = "Take a move from another playbook."
              , rollable = Nothing
              }
            ]
        }
    , gear =
        { limit = 1
        , options =
            [ ".38 revolver (2-harm close reload loud)"
            , "9mm (2-harm close loud)"
            , "Magnum (3-harm close reload loud)"
            , "Shotgun (3-harm close messy)"
            , "Big knife (1-harm hand)"
            , "Brass knuckles (1-harm hand quiet small)"
            , "Sword (2-harm hand messy)"
            , "Huge sword (3-harm hand heavy)"
            ]
        }
    , history =
        [ "You lost control one time, and almost killed them. Ask them how they stopped you."
        , "They tried to slay you, but you proved you’re on the side of good. Ask them what convinced them."
        , "Close relations, or a distant descendant. Tell them which."
        , "You saved them from another of your kind, and prevented reprisals against that individual creature (maybe it’s another good one, or maybe it has a hold over you)."
        , "They are tied to your curse or origin. Tell them how."
        , "You fought together against the odds, and prevailed."
        , "They saved you from another hunter who was prepared to kill you. Ask them what happened."
        ]
    }
