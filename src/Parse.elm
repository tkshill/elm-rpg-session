module Parse exposing (PortfolioElement, parsepPortfolioDocument)

import Mark
    exposing
        ( Block
        , Document
        , Enumerated(..)
        , Item(..)
        , document
        , field
        , record
        , string
        , toBlock
        , tree
        , verify
        )



-- type PortfolioName
--     = TheUnnatural -- Audacity/Oddity/Empathy/Acuity
--     | TheMagical -- Oddity/Acuity/Audacity/Empathy
--     | TheOutsider -- Acuity/Empathy/Oddity/Audacity
--     | TheChampion -- Empathy/Audacity/Acuity/Oddity
-- type alias Trait =
--     { id : Int, name : String, description : String }
-- type alias Archetype =
--     { id : Int, name : String, description : String, examples : List String, karma : String, signatureMove : String }
-- type PortfolioMarkupElement
--     = Core { name : PortfolioName, flavour : String }
--     | Archetypes (List Archetype)
--     | StatGroup { oddity : Int, acuity : Int, audacity : Int, empathy : Int }
--     | Traits (List Trait)
-- type HarmDealt
--     = Light
--     | Hard
--     | Heavy
--     | Humongous
-- type Range
--     = Touch
--     | Close
--     | Far
-- type Speed
--     = Fast
--     | Slow
-- type alias Attack =
--     { id : Int, name : String, givenName : String, harm : Harm, range : Range, speed : Speed }
-- type alias Harm =
--     { value : Int, description : String }
-- type alias PortfolioTemplate =
--     { name : String
--     , flavour : String
--     , archetypes : List Archetype
--     , stats : Stats
--     , traits : List Trait
--     }
-- type alias Portfolio =
--     { name : PortfolioName
--     , physicalDescription : String
--     , agenda : String
--     , flavour : String
--     , archetypes : List Archetype
--     , stats : Stats
--     , traits : List Trait
--     , attacks : List Attack
--     , karma : Int
--     , hurt : Int
--     , harm : Harm
--     , magicTraits : List Trait
--     , weirdTrait : List Trait
--     }


type alias TraitElement =
    { name : String, description : String }


type alias ArchetypeElement =
    { name : String
    , description : String
    , crown : TraitElement
    , crux : TraitElement
    , karma : TraitElement
    , examples : List String
    }


type alias PortfolioElement =
    { core : CoreElement
    , archetypes : List ArchetypeElement
    , traits : List TraitElement
    }


type alias CoreElement =
    { name : String
    , flavour : String
    }


type PortfolioElements
    = Core CoreElement
    | Archetypes (List ArchetypeElement)
    | Traits (List TraitElement)


parseCore : Block CoreElement
parseCore =
    record "Core" CoreElement
        |> field "name" string
        |> field "flavour" string
        |> toBlock


parseTrait : Block TraitElement
parseTrait =
    record "Trait" TraitElement
        |> field "name" string
        |> field "description" string
        |> toBlock


parseExamples : Block (List String)
parseExamples =
    let
        example (Mark.Item item) =
            item.content

        transform (Mark.Enumerated list) =
            List.concatMap example list.items
    in
    tree "Examples" transform string


parseArchetype : Block ArchetypeElement
parseArchetype =
    record "Archetype" ArchetypeElement
        |> field "name" string
        |> field "description" string
        |> field "crown" parseTrait
        |> field "crux" parseTrait
        |> field "karma" parseTrait
        |> field "examples" parseExamples
        |> toBlock


parseTree : String -> Block item -> Block (List item)
parseTree name parseElement =
    let
        transform_ (Item item) =
            item.content

        transform (Enumerated list) =
            List.concatMap transform_ list.items
    in
    tree name transform parseElement


parsepPortfolioDocument : Document PortfolioElement
parsepPortfolioDocument =
    let
        validate elements =
            case elements of
                [ Core core, Archetypes archetypes, Traits traits ] ->
                    Ok (PortfolioElement core archetypes traits)

                _ ->
                    Err { title = "Wrong Order", message = [ "Portfolio Elements in the wrong order." ] }

        topLevel =
            Mark.manyOf
                [ Mark.map Core parseCore
                , Mark.map Archetypes <| parseTree "Archetypes" parseArchetype
                , Mark.map Traits <| parseTree "Traits" parseTrait
                ]
    in
    topLevel
        |> verify validate
        |> document identity
