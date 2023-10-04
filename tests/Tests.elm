module Tests exposing (..)

import Expect exposing (..)
import Mark exposing (Outcome(..))
import Mark.Error
import Test exposing (..)
import Element.Region exposing (description)


type PortfolioTestMarkupElement
    = PortfolioNameMarkup String
    | PortfolioArchetypeMarkup (List { id : Int, name : String })
    | PortfolioArchetypeMarkup2 (List { id : Int, name : String, description : String })


example : Test
example =
    test "example" <|
        \_ ->
            Expect.equal 1 1


testMarkup : Test
testMarkup =
    describe "We can correctly parse markup files" <|
        [ test "we can parse a simple markup file into a record with a field that expects a string" <| simpleMarkupParse
        , test "we can parse a markup file into a record with a field that expects a list of records" <| portfolioMarkupParse
        ]


sampleMarkup : String
sampleMarkup =
    """|>Text
    Sample
    Paragraph
    Paragraph
    """


simpleMarkupParse : () -> Expectation
simpleMarkupParse =
    \_ ->
        let
            document =
                Mark.document (\txt -> { text = txt }) (Mark.block "Text" identity Mark.string)

            expected =
                case Mark.compile document sampleMarkup of
                    Success doc ->
                        doc

                    _ ->
                        { text = "" }
        in
        Expect.equal { text = "Sample\nParagraph\nParagraph" } expected


samplePortfolioMarkup4 : String
samplePortfolioMarkup4 =
    """
|> Name
    The Unnatural

|> Archetypes
    1.  Unnatural Sustenance
        
        Choose a substance that you need to consume to stay alive, or sane. Talk with your steward to determine the parameters of your need.
        
        examples

            - blood

            - life force

            - corpses

            - brains

            - electricity
"""


samplePortfolioMarkup : String
samplePortfolioMarkup =
    """
|> Name
    The Unnatural

|> Archetypes
    1.  |> Archetype
            Unnatural Sustenance
"""


samplePortfolio : Result (List String) { name : String, archetypes : List { id : Int, name : String } }
samplePortfolio =
    { name = "The Unnatural"
    , archetypes =
        [ { id = 0
          , name = "Unnatural Sustenance"
          }
        ]
    }
        |> Result.Ok


parsePortfolioMarkupElements : List PortfolioTestMarkupElement -> Maybe { name : String, archetypes : List { id : Int, name : String } }
parsePortfolioMarkupElements elements =
    case elements of
        [ PortfolioNameMarkup name, PortfolioArchetypeMarkup archetypes ] ->
            Just { name = name, archetypes = archetypes }

        [ PortfolioArchetypeMarkup archetypes, PortfolioNameMarkup name ] ->
            Just { name = name, archetypes = archetypes }

        [ PortfolioArchetypeMarkup2 archetypes, PortfolioNameMarkup name ] ->
            Just { name = name, archetypes = archetypes }

        _ ->
            Nothing


portfolioMarkupParse : () -> Expectation
portfolioMarkupParse =
    \_ ->
        let
            name =
                Mark.block "Name" PortfolioNameMarkup Mark.string

            archetype : Mark.Block String
            archetype =
                Mark.block "Archetype" identity Mark.string

            archetypes =
                Mark.tree "Archetypes" (\(Mark.Enumerated list) -> List.concatMap (\(Mark.Item item) -> List.indexedMap (\i c -> { id = i, name = c }) item.content) list.items) archetype |> Mark.map PortfolioArchetypeMarkup

            -- |> Mark.map PortfolioArchetypesMarkup
            document =
                Mark.document identity (Mark.manyOf [ name, archetypes ] |> Mark.map parsePortfolioMarkupElements)

            expected =
                case Mark.compile document samplePortfolioMarkup of
                    Success doc ->
                        Result.fromMaybe [] doc

                    Almost partial ->
                        List.map Mark.Error.toString partial.errors |> Result.Err

                    Failure failure ->
                        List.map Mark.Error.toString failure |> Result.Err
        in
        Expect.equal samplePortfolio expected


samplePortfolioMarkup2 : String
samplePortfolioMarkup2 =
    """
|> Name
    The Unnatural

|> Archetypes
    1.  |> Archetype
            
            name = Unnatural Sustenance

            description = Choose a substance that you need to consume to stay alive, or sane. Talk with your steward to determine the parameters of your need.
"""

samplePortfolio2 : Result (List String) { name : String, archetypes : List { id : Int, name : String, description: String } }
samplePortfolio2 =
    { name = "The Unnatural"
    , archetypes =
        [ { id = 0
          , name = "Unnatural Sustenance"
          , description = "Choose a substance that you need to consume to stay alive, or sane. Talk with your steward to determine the parameters of your need."`
          }
        ]
    }
        |> Result.Ok

portfolioMarkupParse2 : () -> Expectation
portfolioMarkupParse2 =
    \_ ->
        let
            name =
                Mark.block "Name" PortfolioNameMarkup Mark.string

            archetype =
                Mark.record "Archetype"
                    (\n -> { name = n })
                    |> Mark.field "name" Mark.string
                    |> Mark.field "description" Mark.string
                    |> Mark.toBlock

            archetypes =
                Mark.tree "Archetypes"
                    (\(Mark.Enumerated list) -> List.concatMap (\(Mark.Item item) -> List.indexedMap (\i c -> { id = i, name = c.name, description = c.description }) item.content) list.items)
                    archetype
                    |> Mark.map PortfolioArchetypeMarkup2

            document =
                Mark.document identity (Mark.manyOf [ name, archetypes ] |> Mark.map parsePortfolioMarkupElements)

            expected =
                case Mark.compile document samplePortfolioMarkup2 of
                    Success doc ->
                        Result.fromMaybe [] doc

                    Almost partial ->
                        List.map Mark.Error.toString partial.errors |> Result.Err

                    Failure failure ->
                        List.map Mark.Error.toString failure |> Result.Err
        in
        Expect.equal samplePortfolio expected
