module Tests exposing (..)

import Expect exposing (..)
import Mark exposing (Outcome(..))
import Mark.Error
import Test exposing (..)


type PortfolioTestMarkupElement
    = PortfolioNameMarkup String
    | PortfolioArchetypeMarkup (List { id : Int, name : String })
    | PortfolioArchetypeMarkup2 (List { id : Int, name : String, description : String })
    | PortfolioArchetypeMarkup3 (List { id : Int, name : String, description : String, examples : List String })


type ParsedElement
    = S1 { name : String, archetypes : List { id : Int, name : String } }
    | S2 { name : String, archetypes : List { id : Int, name : String, description : String } }
    | S3 { name : String, archetypes : List { id : Int, name : String, description : String, examples : List String } }



-- SAMPLE TEXT --


sampleMarkup : String
sampleMarkup =
    """
|>Text
    Sample
    Paragraph
    Paragraph
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


samplePortfolioMarkup3 : String
samplePortfolioMarkup3 =
    """
|> Name
    The Unnatural

|> Archetypes
    1.  |> Archetype
    
            name = Unnatural Sustenance
        
            description = Choose a substance that you need to consume to stay alive, or sane. Talk with your steward to determine the parameters of your need.
        
            examples =

                |> Examples

                    -   blood

                    -   life force

                    -   corpses

                    -   brains

                    -   electricity
"""



-- SAMPLE PORTFOLIOS


samplePortfolio : Result (List String) ParsedElement
samplePortfolio =
    { name = "The Unnatural"
    , archetypes =
        [ { id = 0
          , name = "Unnatural Sustenance"
          }
        ]
    }
        |> S1
        |> Result.Ok


samplePortfolio2 : Result (List String) ParsedElement
samplePortfolio2 =
    { name = "The Unnatural"
    , archetypes =
        [ { id = 0
          , name = "Unnatural Sustenance"
          , description = "Choose a substance that you need to consume to stay alive, or sane. Talk with your steward to determine the parameters of your need."
          }
        ]
    }
        |> S2
        |> Result.Ok


samplePortfolio3 : Result (List String) ParsedElement
samplePortfolio3 =
    { name = "The Unnatural"
    , archetypes =
        [ { id = 0
          , name = "Unnatural Sustenance"
          , description = "Choose a substance that you need to consume to stay alive, or sane. Talk with your steward to determine the parameters of your need."
          , examples = [ "blood", "life force", "corpses", "brains", "electricity" ]
          }
        ]
    }
        |> S3
        |> Result.Ok


exampleTest : Test
exampleTest =
    test "example" <|
        \_ ->
            Expect.equal 1 1


testMarkup : Test
testMarkup =
    describe "We can correctly parse markup files" <|
        [ test "we can parse a simple markup file into a record with a field that expects a string" <| simpleMarkupParse
        , test "we can parse a markup file into a record with a field that expects a list of records" <| portfolioMarkupParse
        , test "We can parse a markup file with a list containing a record with two items" <| portfolioMarkupParse2
        , test "The full archetypes work" <| portfolioMarkupParse3
        ]


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


parsePortfolioMarkupElements : List PortfolioTestMarkupElement -> Maybe ParsedElement
parsePortfolioMarkupElements elements =
    case elements of
        [ PortfolioNameMarkup name, PortfolioArchetypeMarkup archetypes ] ->
            Just (S1 { name = name, archetypes = archetypes })

        [ PortfolioNameMarkup name, PortfolioArchetypeMarkup2 archetypes ] ->
            Just (S2 { name = name, archetypes = archetypes })

        [ PortfolioNameMarkup name, PortfolioArchetypeMarkup3 archetypes ] ->
            Just (S3 { name = name, archetypes = archetypes })

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


portfolioMarkupParse2 : () -> Expectation
portfolioMarkupParse2 =
    \_ ->
        let
            name =
                Mark.block "Name" PortfolioNameMarkup Mark.string

            archetype =
                Mark.record "Archetype"
                    (\n d -> { name = n, description = d })
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
        Expect.equal samplePortfolio2 expected


portfolioMarkupParse3 : () -> Expectation
portfolioMarkupParse3 =
    \_ ->
        let
            name =
                Mark.block "Name" PortfolioNameMarkup Mark.string

            example : Mark.Item String -> List String
            example (Mark.Item item) =
                item.content

            exampleList : Mark.Block (List String)
            exampleList =
                Mark.tree "Examples" (\(Mark.Enumerated list) -> List.concatMap example list.items) Mark.string

            archetype : Mark.Block { name : String, description : String, examples : List String }
            archetype =
                Mark.record "Archetype"
                    (\n d e -> { name = n, description = d, examples = e })
                    |> Mark.field "name" Mark.string
                    |> Mark.field "description" Mark.string
                    |> Mark.field "examples" exampleList
                    |> Mark.toBlock

            archetypes =
                Mark.tree "Archetypes"
                    (\(Mark.Enumerated list) -> List.concatMap (\(Mark.Item item) -> List.indexedMap (\i c -> { id = i, name = c.name, description = c.description, examples = c.examples }) item.content) list.items)
                    archetype
                    |> Mark.map PortfolioArchetypeMarkup3

            document =
                Mark.document identity (Mark.manyOf [ name, archetypes ] |> Mark.map parsePortfolioMarkupElements)

            expected =
                case Mark.compile document samplePortfolioMarkup3 of
                    Success doc ->
                        Result.fromMaybe [] doc

                    Almost partial ->
                        List.map Mark.Error.toString partial.errors |> Result.Err

                    Failure failure ->
                        List.map Mark.Error.toString failure |> Result.Err
        in
        Expect.equal samplePortfolio3 expected
