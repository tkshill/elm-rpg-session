module Portfolio exposing (Msg(..))

import Components exposing (LabelValue(..), viewBlockInput, viewCheckBox, viewSimpleInput)
import Core
    exposing
        ( BasicMoveName(..)
        , ratingToString
        )
import Element exposing (..)
import List.Extra as Liste
import Parse exposing (PortfolioElement)
import Tuple exposing (first, mapSecond, second)
import Utility exposing (thunk)


type alias Attack =
    { name : String
    , harm : AttackHarm
    , range : AttackRange
    , speed : AttackSpeed
    }


type alias Ratings =
    { charm : RatingValue
    , odd : RatingValue
    , wits : RatingValue
    , grit : RatingValue
    }


type alias Trait =
    { name : String, description : String }


type alias Portfolio =
    { name : String
    , pronouns : String
    , physicalDescription : String
    , portfolioDescription : String
    , archetypeDescription : String
    , why : String
    , ratings : Ratings
    , attacks : List { id : Int, attack : Attack }
    , karma : Int
    , harm : Int
    , notes : String
    , traits : List { id : Int, trait : Trait, selected : Bool }
    , gear : List String
    , relationships : String
    , porfolios : List PortfolioElement
    , portfolioName : String
    , archetypeName : String
    }


type Wits
    = Wits


type Grit
    = Grit


type Odd
    = Odd


type Charm
    = Charm


type Rating
    = W Wits
    | G Grit
    | O Odd
    | C Charm


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


type RatingChange
    = WitsChanged RatingValue
    | GritChanged RatingValue
    | CharmChanged RatingValue
    | OddChanged RatingValue


type Msg
    = NameUpdated String
    | PhysicalDescriptionUpdated String
    | PronounsUpdated String
    | RatingChanged RatingChange
    | TraitSelected Int
    | AttackUpdated Int AttackUpdate
    | KarmaChanged UnitChange
    | HarmChanged UnitChange
    | PortfolioChanged String
    | ArchetypeChanged String
    | NotesUpdated String
    | ReasonWhyUpdated String
    | RelationshipsUpdated String
    | GearChanged GearUpdate


type GearUpdate
    = NewGear String
    | DeleteGear Int
    | EditGear Int String


update : Msg -> Portfolio -> Portfolio
update msg model =
    case msg of
        NameUpdated str ->
            { model | name = str }

        PhysicalDescriptionUpdated str ->
            { model | physicalDescription = str }

        PronounsUpdated str ->
            { model | pronouns = str }

        ReasonWhyUpdated str ->
            { model | why = str }

        KarmaChanged change ->
            case change of
                Raise ->
                    { model | karma = model.karma + 1 }

                Lower ->
                    { model | karma = model.karma - 1 }

        HarmChanged change ->
            case change of
                Raise ->
                    { model | harm = model.harm + 1 }

                Lower ->
                    { model | harm = model.harm - 1 }

        RatingChanged change ->
            let
                ratings =
                    model.ratings

                changer =
                    case change of
                        WitsChanged v ->
                            { ratings | wits = v }

                        OddChanged v ->
                            { ratings | odd = v }

                        GritChanged v ->
                            { ratings | grit = v }

                        CharmChanged v ->
                            { ratings | charm = v }
            in
            { model | ratings = changer }

        GearChanged change ->
            case change of
                NewGear s ->
                    { model | gear = s :: model.gear }

                DeleteGear i ->
                    { model | gear = Liste.removeAt i model.gear }

                EditGear i s ->
                    { model | gear = Liste.updateAt i (thunk s) model.gear }

        TraitSelected i ->
            let
                traits =
                    model.traits

                newTraitsList =
                    traits
                        |> Liste.updateAt i (\t -> { t | selected = not t.selected })
            in
            { model | traits = newTraitsList }

        AttackUpdated i change ->
            let
                attacks =
                    model.attacks

                changer =
                    case change of
                        AttackName s ->
                            \a -> { a | name = s }

                        AttackHarm h ->
                            \a -> { a | harm = h }

                        AttackRange r ->
                            \a -> { a | range = r }

                        AttackSpeed s ->
                            \a -> { a | speed = s }

                newAttacks =
                    Liste.updateAt i (\v -> { v | attack = changer v.attack }) attacks
            in
            { model | attacks = newAttacks }

        NotesUpdated s ->
            { model | notes = s }

        RelationshipsUpdated s ->
            { model | relationships = s }

        PortfolioChanged s ->
            if s == model.portfolioName then model 
            else
                






-- let
--     attacks =
--         model.attacks
--     newAttackList =
--         attacks.attackList
--             |> Liste.updateIf (.id >> (==) i) (\v -> { v | selected = not bool })
--             |> Liste.updateIf (.id >> (/=) i) (\v -> { v | selected = False })
-- in
-- { model | attacks = { attacks | attackList = newAttackList } }
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
