module Portfolio exposing (Msg(..))

import Components exposing (LabelValue(..), viewBlockInput, viewCheckBox, viewSimpleInput)
import Core
    exposing
        ( Acuity(..)
        , Audacity(..)
        , BasicMoveName(..)
        , Empathy(..)
        , Oddity(..)
        , Rating(..)
        , Ratings
        , ratingToString
        )
import Element exposing (..)


type alias Attack =
    { name : String
    , harm : AttackHarm
    , range : AttackRange
    , speed : AttackSpeed
    }


type alias Trait =
    { name : String, description : String }


type alias Portfolio =
    { name : String
    , pronouns : String
    , physicalDescription : String
    , portfolioDescription : String
    , archetypeDescription : String
    , ratings : Ratings
    , attacks : List { id : Int, attack : Attack }
    , karma : Int
    , harm : Int
    , notes : String
    , traits : List { id : Int, trait : Trait, selected : Bool }
    }


type AttackHarm
    = Light
    | Heavy
    | Huge


type AttackRange
    = Touch
    | Close
    | Far


type AttackSpeed
    = Quick
    | Slow


type AttackUpdate
    = AttackName String
    | AttackHarm AttackHarm
    | AttackRange AttackRange
    | AttackSpeed AttackSpeed


type RatingValue
    = MinusOne
    | Zero
    | PlusOne
    | PlusTwo


type UnitChange
    = Raise
    | Lower


type Msg
    = NameUpdated String
    | PhysicalDescriptionUpdated String
    | PronounsUpdated String
    | RatingChanged Rating RatingValue
    | TraitSelected Int
    | TraitNotesUpdated Int String
    | AttackUpdated Int AttackUpdate
    | KarmaChanged UnitChange
    | HarmChanged UnitChange
    | PortfolioChanged String
    | ArchetypeChanged String
    | NotesUpdated String


update : Msg -> Portfolio -> Portfolio
update msg model =
    case msg of
        NameUpdated str ->
            { model | name = str }

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
                        |> sortByDescending Tuple.second

                idx =
                    Maybe.withDefault 0 (Liste.findIndex (Tuple.first >> (==) rating) ratingsMap)

                newMap =
                    if shift == Up then
                        Liste.swapAt (idx - 1) idx ratingsMap

                    else
                        Liste.swapAt idx (idx + 1) ratingsMap
            in
            { model
                | ratings =
                    { empathy = Maybe.withDefault 0 (Liste.findIndex (Tuple.first >> (==) (E Empathy)) newMap)
                    , acuity = Maybe.withDefault 0 (Liste.findIndex (Tuple.first >> (==) (Ac Acuity)) newMap)
                    , audacity = Maybe.withDefault 0 (Liste.findIndex (Tuple.first >> (==) (Au Audacity)) newMap)
                    , oddity = Maybe.withDefault 0 (Liste.findIndex (Tuple.first >> (==) (O Oddity)) newMap)
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



-- viewRatings : Ratings -> Element msg
-- viewRatings ratings =
--     let
--         ratingsMap =
--             [ ( E Empathy, ratings.empathy )
--             , ( Ac Acuity, ratings.acuity )
--             , ( Au Audacity, ratings.audacity )
--             , ( O Oddity, ratings.oddity )
--             ]
--                 |> sortByDescending Tuple.second
--     in
--     column []
--         (List.map
--             (\r ->
--                 row []
--                     [ text (ratingToString (Tuple.first r))
--                     , text (String.fromInt (Tuple.second r))
--                     ]
--             )
--             ratingsMap
--         )
-- viewSuggestions : { description : String, suggestions : List LineageSuggestion } -> Element msg
-- viewSuggestions { description, suggestions } =
--     let
--         suggestionView ls =
--             column [] [ text ls.name, text ls.description ]
--     in
--     column []
--         [ text description
--         , column [] <| List.map suggestionView suggestions
--         ]
-- viewCurses : Curses -> Element Msg
-- viewCurses { description, curseList } =
--     let
--         viewCurseDetails : Curse -> Element Msg
--         viewCurseDetails curse =
--             column [] [ text curse.name, text curse.description ]
--     in
--     column []
--         [ text description
--         , column [] <| List.map (\{ id, curse, selected } -> viewCheckBox (CurseSelected id) (ElementLabelValue <| viewCurseDetails curse) selected) curseList
--         ]
-- viewAttacks : Attacks -> Element Msg
-- viewAttacks { description, attackList } =
--     column []
--         [ text description
--         , column [] <| List.map (\attack -> viewCheckBox (AttackSelected attack.id) (StringLabelValue attack.attack) attack.selected) attackList
--         ]
-- viewMaker : (Msg -> msg) -> MakerModel -> Element msg
-- viewMaker transformer model =
--     column
--         [ width fill ]
--         [ text "The Monstrous"
--         , text model.flavour
--         , viewSimpleInput NameUpdated "Pick a name for your character." "Enter Name here" model.characterName
--         , viewSimpleInput PronounsUpdated "What's your character's pronouns?" "Enter your pronoun's here" model.pronouns
--         , viewSuggestions model.lineage
--         , viewBlockInput PhysicalDescriptionUpdated "What do people see when they look at your character?" "Enter your character description" model.physicalDescription
--         , column [] <| List.map (\v -> column [] <| List.map text v) model.looks
--         , viewSimpleInput ReasonWhyUpdated "Why does your character risk they life as a Monster Hunter?" "Enter your why here" model.why
--         , viewSimpleInput QuirkUpdated "What's one character flaw you possess?" "Enter your flaw." model.quirk
--         , viewCurses model.curses
--         , viewAttacks model.attacks
--         ]
--         |> Element.map transformer
-- type alias MarkupArchetype =
--     { id : Int
--     , name : String
--     }
-- type PortfolioMarkupElement
--     = PortfolioNameMarkup String
--     | PortfolioArchetypesMarkup (List MarkupArchetype)
