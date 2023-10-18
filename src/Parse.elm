module Parse exposing
    ( AllElements
    , ArchetypeElement
    , PortfolioElement
    , parseGetWeirdDocument
    , parsepPortfolioDocument
    )

import Mark
    exposing
        ( Block
        , Document
        , Enumerated(..)
        , Item(..)
        , document
        , field
        , manyOf
        , onError
        , record
        , string
        , toBlock
        , tree
        , verify
        )
import Mark.Error as Error


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


type alias MetaElements =
    { metaPhysical : List TraitElement
    , metaMagic : List TraitElement
    }


type alias CoreElement =
    { name : String
    , description : String
    }


type PortfolioElements
    = Core CoreElement
    | Archetypes (List ArchetypeElement)
    | Traits (List TraitElement)
    | MetaMagic (List TraitElement)
    | MetaPhysical (List TraitElement)


type alias AllElements =
    { metaElements : MetaElements
    , portflios : List PortfolioElement
    }


parseCore : Block CoreElement
parseCore =
    record "Core" CoreElement
        |> field "name" string
        |> field "description" string
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
        |> onError []


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
        content (Item item) =
            item.content

        transform (Enumerated list) =
            List.concatMap content list.items
    in
    tree name transform parseElement


topLevelError : Result Error.Custom value
topLevelError =
    Err { title = "Wrong Order", message = [ "Portfolio Elements in the wrong order." ] }


parsepPortfolioDocument : Document PortfolioElement
parsepPortfolioDocument =
    let
        validate elements =
            case elements of
                [ Core core, Archetypes archetypes, Traits traits ] ->
                    Ok <| PortfolioElement core archetypes traits

                _ ->
                    topLevelError

        topLevel =
            manyOf
                [ Mark.map Core parseCore
                , Mark.map Archetypes <| parseTree "Archetypes" parseArchetype
                , Mark.map Traits <| parseTree "Traits" parseTrait
                ]
    in
    topLevel
        |> verify validate
        |> document identity


parseGetWeirdDocument : Document MetaElements
parseGetWeirdDocument =
    let
        validate elements =
            case elements of
                [ MetaMagic metaMagic, MetaPhysical metaPhysical ] ->
                    Ok <| MetaElements metaMagic metaPhysical

                _ ->
                    topLevelError

        topLevel =
            manyOf
                [ Mark.map MetaMagic <| parseTree "MetaMagic" parseTrait
                , Mark.map MetaPhysical <| parseTree "MetaPhysical" parseTrait
                ]
    in
    topLevel
        |> verify validate
        |> document identity
