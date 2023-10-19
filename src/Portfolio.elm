module Portfolio exposing (Msg(..))

import Components exposing (LabelValue(..), viewBlockInput, viewCheckBox, viewSimpleInput)
import Core
    exposing
        ( BasicMoveName(..)
        )
import Element exposing (..)
import Element.Region exposing (description)
import Html.Attributes exposing (type_)
import List.Extra as Liste
import Parse exposing (ArchetypeElement, PortfolioElement)
import Tuple exposing (first, mapSecond, second)
import Utility exposing (flip, thunk)


type alias Stats =
    { empathy : Rating
    , odd : Rating
    , wits : Rating
    , grit : Rating
    }


type alias Item =
    { name : String, description : String }


type alias Selectable =
    { id : Int, name : String, description : String }


type alias Checkable =
    { id : Int, name : String, description : String, selected : Bool }


type alias Portfolio =
    { name : String
    , pronouns : String
    , physicalDescription : String
    , portfolioName : String
    , portfolioDescription : String
    , archetypeName : String
    , archetypeDescription : String
    , agenda : String
    , ratings : Stats
    , karma : Int
    , notes : String
    , coreTraits : List Item
    , traits : List Checkable
    , metaTraits : List Checkable
    , gear : List Selectable
    , relationships : String
    , portfolios : List PortfolioElement
    }


type Wits
    = Wits


type Grit
    = Grit


type Odd
    = Odd


type Empathy
    = Empathy


type Stat
    = W Wits
    | G Grit
    | O Odd
    | E Empathy


orderedRatings : List Rating
orderedRatings =
    [ MinusOne, Zero, PlusOne, PlusTwo ]


updateRating : Rating -> UnitChange -> Rating
updateRating rating change =
    let
        finder changer =
            Liste.findIndex ((==) rating)
                >> Maybe.map ((+) changer)
                >> Maybe.andThen (flip Liste.getAt orderedRatings)
                >> Maybe.withDefault rating
    in
    case change of
        Raise ->
            finder 1 orderedRatings

        Lower ->
            finder -1 orderedRatings


type Rating
    = MinusOne
    | Zero
    | PlusOne
    | PlusTwo


type UnitChange
    = Raise
    | Lower


type RatingChange
    = WitsChanged Rating
    | GritChanged Rating
    | EmpathyChanged Rating
    | OddChanged Rating


type Msg
    = NameUpdated String
    | PhysicalDescriptionUpdated String
    | PronounsUpdated String
    | RatingChanged RatingChange
    | TraitSelected Int
    | MetaTraitSelected Int
    | KarmaChanged UnitChange
    | PortfolioChanged String PortfolioElement
    | ArchetypeChanged String
    | NotesUpdated String
    | AgendaUpdated String
    | RelationshipsUpdated String
    | GearChanged GearUpdate
    | RelationshipChanged String


type GearUpdate
    = NewGear
    | DeleteGear Int
    | EditGearName Int String
    | EditGearDescription Int String


dummyPortfolio : PortfolioElement
dummyPortfolio =
    { core = { name = "Dummy", description = "Dummy" }, traits = [], archetypes = [] }


dummyArchetype : ArchetypeElement
dummyArchetype =
    { name = "Dummy"
    , description = "Dummy"
    , crown = { name = "Dummy", description = "Dummy" }
    , crux = { name = "Dummy", description = "Dummy" }
    , karma = { name = "Dummy", description = "Dummy" }
    , examples = []
    }


update : Msg -> Portfolio -> Portfolio
update msg model =
    case msg of
        NameUpdated str ->
            { model | name = str }

        PhysicalDescriptionUpdated str ->
            { model | physicalDescription = str }

        PronounsUpdated str ->
            { model | pronouns = str }

        AgendaUpdated str ->
            { model | agenda = str }

        KarmaChanged change ->
            case change of
                Raise ->
                    { model | karma = model.karma + 1 }

                Lower ->
                    { model | karma = model.karma - 1 }

        GearChanged type_ ->
            case type_ of
                NewGear ->
                    let
                        newGear =
                            { id = List.length model.gear, name = "", description = "" }
                    in
                    { model | gear = model.gear ++ [ newGear ] }

                DeleteGear i ->
                    { model | gear = Liste.removeAt i model.gear }

                EditGearName i s ->
                    let
                        updater v =
                            { v | name = s }
                    in
                    { model | gear = Liste.updateAt i updater model.gear }

                EditGearDescription i s ->
                    let
                        updater v =
                            { v | description = s }
                    in
                    { model | gear = Liste.updateAt i updater model.gear }

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

                        EmpathyChanged v ->
                            { ratings | empathy = v }
            in
            { model | ratings = changer }

        TraitSelected i ->
            let
                traits =
                    model.traits

                newTraitsList =
                    traits
                        |> Liste.updateAt i (\t -> { t | selected = not t.selected })
            in
            { model | traits = newTraitsList }

        NotesUpdated s ->
            { model | notes = s }

        RelationshipsUpdated s ->
            { model | relationships = s }

        PortfolioChanged s ->
            if s == p.core.name then
                model

            else
                let
                    portfolio =
                        model.porfolios
                            |> Liste.find (\p -> p.core.name == s)
                            |> Maybe.withDefault dummyPortfolio

                    archetype =
                        portfolio.archetypes
                            |> List.head
                            |> Maybe.withDefault dummyArchetype
                in
                { model | portfolioName = portfolio.core.name, portfolioDescription = portfolio.core.description, archetype = archetype }

        ArchetypeChanged s ->
            if s == model.archetype.name then
                model

            else
                let
                    archetype =
                        model.portfolioBase.archetypes
                            |> Liste.find (\p -> p.name == s)
                            |> Maybe.withDefault dummyArchetype
                in
                { model | archetype = archetype }

        RelationshipChanged s ->
            { model | relationships = s }

        MetaTraitSelected i ->
            let
                traits =
                    model.metaTraits

                newTraitsList =
                    traits
                        |> Liste.updateAt i (\t -> { t | selected = not t.selected })
            in
            { model | metaTraits = newTraitsList }



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
