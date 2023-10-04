module Tests exposing (..)

import Expect exposing (..)
import Mark exposing (Outcome(..))
import Mark.Error
import Test exposing (..)
import Unnatural exposing (MarkupArchetype, PortfolioMarkupElement(..))


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


samplePortfolioMarkup2 : String
samplePortfolioMarkup2 =
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


samplePortfolio : Result (List String) { name : String, archetypes : List MarkupArchetype }
samplePortfolio =
    { name = "The Unnatural"
    , archetypes =
        [ { id = 0
          , name = "Unnatural Sustenance"
          }
        ]
    }
        |> Result.Ok


parsePortfolioMarkupElements : List PortfolioMarkupElement -> Maybe { name : String, archetypes : List MarkupArchetype }
parsePortfolioMarkupElements elements =
    case elements of
        [ PortfolioNameMarkup name, PortfolioArchetypesMarkup archetypes ] ->
            Just { name = name, archetypes = archetypes }

        [ PortfolioArchetypesMarkup archetypes, PortfolioNameMarkup name ] ->
            Just { name = name, archetypes = archetypes }

        _ ->
            Nothing


portfolioMarkupParse : () -> Expectation
portfolioMarkupParse =
    \_ ->
        let
            name =
                Mark.block "Name" PortfolioNameMarkup Mark.string

            -- exampleList =
            --     Mark.tree "List" (\(Mark.Enumerated list) -> List.map (\(Mark.Item item) -> Maybe.withDefault "" (List.head item.content)) list.items) Mark.string
            -- archetype =
            --     Mark.record "Archetype"
            --         (\n d e -> { name = n, description = d, examples = e })
            --         |> Mark.field "name" Mark.string
            --         |> Mark.field "description" Mark.string
            --         |> Mark.field "examples" exampleList
            --         |> Mark.toBlock
            archetype : Mark.Block String
            archetype =
                Mark.block "Archetype" identity Mark.string

            archetypes =
                Mark.tree "Archetypes" (\(Mark.Enumerated list) -> List.concatMap (\(Mark.Item item) -> List.indexedMap (\i c -> { id = i, name = c }) item.content) list.items) archetype |> Mark.map PortfolioArchetypesMarkup

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
