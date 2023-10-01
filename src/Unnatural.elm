module Unnatural exposing (Msg(..), UnnaturalName(..), makerModel, toString, viewMaker)

import Components exposing (LabelValue(..), viewBlockInput, viewCheckBox, viewSimpleInput)
import Core
    exposing
        ( Acuity(..)
        , Audacity(..)
        , BasicMoveName(..)
        , Empathy(..)
        , Gears
        , History
        , Moves
        , Oddity(..)
        , Rating(..)
        , Ratings
        , ratingToString
        )
import Element exposing (..)
import Element.Region exposing (description)
import List.Extra as Liste
import Utility exposing (fst, snd)


type UnnaturalName
    = UnnaturalName


toString : UnnaturalName -> String
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


type alias Curses =
    { description : String
    , curseList : List { id : Int, curse : Curse, selected : Bool }
    }


type alias Attacks =
    { description : String
    , attackList : List { id : Int, attack : Attack, selected : Bool }
    }


type alias MakerModel =
    { name : UnnaturalName
    , characterName : String
    , pronouns : String
    , physicalDescription : String
    , quirk : String
    , why : String
    , flavour : String
    , ratings : Ratings
    , looks : List (List String)
    , lineage : { description : String, suggestions : List LineageSuggestion }
    , instructions : String
    , curses : Curses
    , attacks : Attacks
    , moves : Moves
    , gear : Gears
    , history : History
    , relations : List { name : String, relation : String }
    }


type RatingShift
    = Up
    | Down


type Msg
    = NameUpdated String
    | PhysicalDescriptionUpdated String
    | PronounsUpdated String
    | QuirkUpdated String
    | ReasonWhyUpdated String
    | ShiftRating Rating RatingShift
    | SelectMove Int
    | SelectCurse Int
    | SelectAttack Int
    | SelectGear Int
    | CurseSelected Int Bool
    | AttackSelected Int Bool


makerModel : MakerModel
makerModel =
    { name = UnnaturalName
    , characterName = ""
    , physicalDescription = ""
    , quirk = ""
    , why = ""
    , pronouns = ""
    , instructions = """
        To make your Monstrous, first pick a name. Then follow the instructions  below  to  decide  your  look,  ratings,  breed,  moves,  and  gear.  
        Finally, introduce yourself and pick history.
        """
    , ratings =
        { empathy = -1
        , acuity = 0
        , audacity = 1
        , oddity = 2
        }
    , flavour = """
        I feel the hunger, the lust to destroy.
        But I fight it: I never give in.
        I’m not human any more, not really,
        but I have to protect those who still are.
        That way I can tell myself I’m different to the other monsters.
        Sometimes I can even believe it.
        """
    , lineage =
        { description = """
        You’re  half-human,  half-monster:  decide  if  you  were  always  this  way or if you you were originally human and transformed somehow.
        Now decide if you were always fighting to be good, or if you were evil and changed sides.
        Define  your  monstrous  breed  by picking a curse,  moves, and natural attacks.
        Create the monster you want to be: whatever you choose defines your breed in the game.
        Some classic monsters with suggestions for picks are listed below. These are only suggestions: feel free to make a different version!
        """
        , suggestions =
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
        }
    , looks =
        [ [ "Man", "Woman", "Mysterious", "Transgressive" ]
        , [ "Sinister aura", "powerful aura", "dark aura", "unnerving aura", "energetic aura", "evil aura", "bestial aura" ]
        , [ "Archaic  clothes", "casual  clothes", "ragged  clothes", "tailored  clothes", "stylish clothes", "street clothes", "outdoor clothes" ]
        ]
    , curses =
        { description = "Curses, pick one"
        , curseList =
            [ { id = 1
              , selected = False
              , curse =
                    { name = "Feed"
                    , description = """
            You must subsist on living humans.
            It might take the form of blood, brains, or spiritual essence but it must be from people.
            You need to act under pressure to resist feeding whenever a perfect opportunity presents itself.
            """
                    }
              }
            , { id = 2
              , selected = False
              , curse =
                    { name = "Vulnerability"
                    , description = """
            Pick a substance.
            You suffer +1 harm when you suffer harm from it.
            If you are bound or surrounded by it, you must act under pressure to use your powers.
            """
                    }
              }
            , { id = 3
              , selected = False
              , curse =
                    { name = "Pure  Drive"
                    , description = """
                One emotion rules you.
                Pick from: hunger, hate, anger, fear, jealousy, greed, joy, pride, envy, lust, or cruelty.
                Whenever you have a chance to indulge that emotion, you must do so immediately, or act under pressure to resist.
                """
                    }
              }
            , { id = 4
              , selected = False
              , curse =
                    { name = "Dark  Master"
                    , description = """
                You have an evil lord who doesn’t know you changed sides.
                They still give you orders, and they do not tolerate refusal. Or failure.
                """
                    }
              }
            ]
        }
    , attacks =
        { description = "Pick two Bases or one base and two extras"
        , attackList =
            [ { id = 1, selected = False, attack = "Base: Teeth (Heavy, Intimate, Messy)" }
            , { id = 2, selected = False, attack = "Base: Claws (Hard, hand)" }
            , { id = 3, selected = False, attack = "Base: Life-Drain (Light, Intimate, Life-drain)" }
            , { id = 4, selected = False, attack = "Base: Magical Force (Light, close, magical)" }
            , { id = 5, selected = False, attack = "Extra: Increase the harm by one level" }
            , { id = 6, selected = False, attack = "Extra: Add Ignore Armour to a base" }
            , { id = 7, selected = False, attack = "Extra: Improve Range by One Level" }
            ]
        }
    , moves =
        { description = "You get all the basic moves, plus pick three Monstrous moves:"
        , moveList =
            [ { id = 1
              , selected = False
              , move =
                    { name = "Immortal"
                    , description = "You do not age or sicken, and whenever you suffer harm you suffer 1-harm less."
                    , rollable = Nothing
                    }
              }
            , { id = 2
              , selected = False
              , move =
                    { name = "Unnatural Appeal"
                    , description = "Roll +Weird instead of +Charm when you Sway Someone."
                    , rollable = Nothing
                    }
              }
            , { id = 3
              , selected = False
              , move =
                    { name = "Unholy Strengh"
                    , description = "Roll +Weird instead of +Guts when you are trying to inflict harm."
                    , rollable = Nothing
                    }
              }
            , { id = 4
              , selected = False
              , move =
                    { name = "Incorporeal"
                    , description = "You can pass through solid objects (but not people)."
                    , rollable = Nothing
                    }
              }
            , { id = 5
              , selected = False
              , move =
                    { name = "Preternatural Speed"
                    , description = "You can move much faster than normal people. When you are trying to chase, flee, or run, take +1 to your roll."
                    , rollable = Nothing
                    }
              }
            , { id = 6
              , selected = False
              , move =
                    { name = "Claws of the beast"
                    , description = "All Natural attacks do +1 harm."
                    , rollable = Nothing
                    }
              }
            , { id = 7
              , selected = False
              , move =
                    { name = "Mental Dominion"
                    , description = "Get a Boost when you try to Sway a normal human. If you try to sway another hunter and you succeed, add Karma."
                    , rollable = Just (O Oddity)
                    }
              }
            , { id = 0
              , selected = False
              , move =
                    { name = "Unquenchable Vitality"
                    , description = "When you take harm, you can heal yourself. Roll +Tough. On a 10+, heal 2. On a 7-9, heal 1. On a 6 or lower your injuries worsen."
                    , rollable = Just (Au Audacity)
                    }
              }
            , { id = 8
              , selected = False
              , move =
                    { name = "Shapeshifter"
                    , description = "You can change your form, usually into an animal. Decide what your form(s) are. Take +1 to assess reality when you use your form's sense to investigate."
                    , rollable = Nothing
                    }
              }
            , { id = 9
              , selected = False
              , move =
                    { name = "Something Borrowed"
                    , description = "Take a move from another playbook."
                    , rollable = Nothing
                    }
              }
            ]
        }
    , gear =
        { description = "Choose One"
        , gearList =
            [ { id = 1, selected = False, gear = ".38 revolver (Hard close reload loud)" }
            , { id = 2, selected = False, gear = "9mm (Hard close loud)" }
            , { id = 3, selected = False, gear = "Magnum (Heavy close reload loud)" }
            , { id = 4, selected = False, gear = "Shotgun (Heavy close messy)" }
            , { id = 5, selected = False, gear = "Big knife (Light hand)" }
            , { id = 6, selected = False, gear = "Brass knuckles (Light hand quiet small)" }
            , { id = 7, selected = False, gear = "Sword (Hard hand messy)" }
            , { id = 8, selected = False, gear = "Huge sword (Heavy hand heavy)" }
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
    , relations = []
    }


update : Msg -> MakerModel -> MakerModel
update msg model =
    case msg of
        NameUpdated str ->
            { model | characterName = str }

        PhysicalDescriptionUpdated str ->
            { model | physicalDescription = str }

        PronounsUpdated str ->
            { model | pronouns = str }

        QuirkUpdated str ->
            { model | quirk = str }

        ReasonWhyUpdated str ->
            { model | why = str }

        ShiftRating rating shift ->
            let
                ratingsMap =
                    [ ( E Empathy, model.ratings.empathy )
                    , ( Ac Acuity, model.ratings.acuity )
                    , ( Au Audacity, model.ratings.audacity )
                    , ( O Oddity, model.ratings.oddity )
                    ]
                        |> List.sortBy snd
                        |> List.reverse

                idx =
                    Maybe.withDefault 0 (Liste.findIndex (fst >> (==) rating) ratingsMap)

                newMap =
                    if shift == Up then
                        Liste.swapAt (idx - 1) idx ratingsMap

                    else
                        Liste.swapAt idx (idx + 1) ratingsMap
            in
            { model
                | ratings =
                    { empathy = Maybe.withDefault 0 (Liste.findIndex (fst >> (==) (E Empathy)) newMap)
                    , acuity = Maybe.withDefault 0 (Liste.findIndex (fst >> (==) (Ac Acuity)) newMap)
                    , audacity = Maybe.withDefault 0 (Liste.findIndex (fst >> (==) (Au Audacity)) newMap)
                    , oddity = Maybe.withDefault 0 (Liste.findIndex (fst >> (==) (O Oddity)) newMap)
                    }
            }

        SelectMove i ->
            { model
                | moves =
                    { description = model.moves.description
                    , moveList = Liste.updateIf (\m -> m.id == i) (\m -> { m | selected = not m.selected }) model.moves.moveList
                    }
            }

        SelectCurse i ->
            { model
                | curses =
                    { description = model.curses.description
                    , curseList = Liste.updateIf (\m -> m.id == i) (\m -> { m | selected = not m.selected }) model.curses.curseList
                    }
            }

        SelectAttack i ->
            { model
                | attacks =
                    { description = model.attacks.description
                    , attackList = Liste.updateIf (\m -> m.id == i) (\m -> { m | selected = not m.selected }) model.attacks.attackList
                    }
            }

        SelectGear i ->
            { model
                | gear =
                    { description = model.gear.description
                    , gearList = Liste.updateIf (\m -> m.id == i) (\m -> { m | selected = not m.selected }) model.gear.gearList
                    }
            }

        CurseSelected i bool ->
            let
                curses =
                    model.curses

                newCurseList =
                    curses.curseList
                        |> Liste.updateIf (.id >> (==) i) (\v -> { v | selected = not bool })
                        |> Liste.updateIf (.id >> (/=) i) (\v -> { v | selected = False })
            in
            { model | curses = { curses | curseList = newCurseList } }

        AttackSelected i bool ->
            let
                attacks =
                    model.attacks

                newAttackList =
                    attacks.attackList
                        |> Liste.updateIf (.id >> (==) i) (\v -> { v | selected = not bool })
                        |> Liste.updateIf (.id >> (/=) i) (\v -> { v | selected = False })
            in
            { model | attacks = { attacks | attackList = newAttackList } }


viewRatings : Ratings -> Element msg
viewRatings ratings =
    let
        ratingsMap =
            [ ( E Empathy, ratings.empathy )
            , ( Ac Acuity, ratings.acuity )
            , ( Au Audacity, ratings.audacity )
            , ( O Oddity, ratings.oddity )
            ]
                |> List.sortBy snd
                |> List.reverse
    in
    column []
        (List.map
            (\r ->
                row []
                    [ text (ratingToString (fst r))
                    , text (String.fromInt (snd r))
                    ]
            )
            ratingsMap
        )


viewSuggestions : { description : String, suggestions : List LineageSuggestion } -> Element msg
viewSuggestions { description, suggestions } =
    let
        suggestionView ls =
            column [] [ text ls.name, text ls.description ]
    in
    column []
        [ text description
        , column [] <| List.map suggestionView suggestions
        ]


viewCurses : Curses -> Element Msg
viewCurses { description, curseList } =
    let
        viewCurseDetails : Curse -> Element Msg
        viewCurseDetails curse =
            column [] [ text curse.name, text curse.description ]
    in
    column []
        [ text description
        , column [] <| List.map (\{ id, curse, selected } -> viewCheckBox (CurseSelected id) (ElementLabelValue <| viewCurseDetails curse) selected) curseList
        ]


viewAttacks : Attacks -> Element Msg
viewAttacks { description, attackList } =
    column []
        [ text description
        , column [] <| List.map (\attack -> viewCheckBox (AttackSelected attack.id) (StringLabelValue attack.attack) attack.selected) attackList
        ]


viewMaker : (Msg -> msg) -> MakerModel -> Element msg
viewMaker transformer model =
    column
        [ width fill ]
        [ text "The Monstrous"
        , text model.flavour
        , viewSimpleInput NameUpdated "Pick a name for your character." "Enter Name here" model.characterName
        , viewSimpleInput PronounsUpdated "What's your character's pronouns?" "Enter your pronoun's here" model.pronouns
        , viewSuggestions model.lineage
        , viewBlockInput PhysicalDescriptionUpdated "What do people see when they look at your character?" "Enter your character description" model.physicalDescription
        , column [] <| List.map (\v -> column [] <| List.map text v) model.looks
        , viewSimpleInput ReasonWhyUpdated "Why does your character risk they life as a Monster Hunter?" "Enter your why here" model.why
        , viewSimpleInput QuirkUpdated "What's one character flaw you possess?" "Enter your flaw." model.quirk
        , viewCurses model.curses
        , viewAttacks model.attacks
        ]
        |> Element.map transformer
