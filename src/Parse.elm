module Parse exposing (..)

import Mark


type PortfolioName
    = TheUnnatural -- Audacity/Oddity/Empathy/Acuity
    | TheMagical -- Oddity/Acuity/Audacity/Empathy
    | TheOutsider -- Acuity/Empathy/Oddity/Audacity
    | TheChampion -- Empathy/Audacity/Acuity/Oddity


type alias Move =
    { id : Int, name : String, description : String }


type alias Archetype =
    { id : Int, name : String, description : String, examples : List String, karma : String }


type alias Stats =
    { oddity : Int, acuity : Int, audacity : Int, empathy : Int }


type PortfolioMarkupElement
    = Core { name : PortfolioName, description : String, flavour : String }
    | Archetypes { name : String, description : String, options : List Archetype }
    | StatGroup { oddity : Int, acuity : Int, audacity : Int, empathy : Int }
    | Moves (List Move)


type HarmDealt
    = Light
    | Hard
    | Heavy
    | Humongous


type Range
    = Touch
    | Close
    | Far


type Speed
    = Fast
    | Slow


type alias Attack =
    { id : Int, name : String, givenName : String, harm : Harm, range : Range, speed : Speed }


type alias Harm =
    { value : Int, description : String }


type alias Portfolio =
    { name : PortfolioName
    , description : String
    , flavour : String
    , archetypes : List Archetype
    , stats : Stats
    , moves : List Move
    , attacks : List Attack
    , karma : Int
    , hurt : Int
    , harm : Harm
    }



-- portfolioDocument : Mark.Document Portfolio
-- portfolioDocument = Mark.document
