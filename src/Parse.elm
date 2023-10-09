module Parse exposing (..)

import Mark


type PortfolioName
    = TheUnnatural -- Audacity/Oddity/Empathy/Acuity
    | TheMagical -- Oddity/Acuity/Audacity/Empathy
    | TheOutsider -- Acuity/Empathy/Oddity/Audacity
    | TheChampion -- Empathy/Audacity/Acuity/Oddity


type alias Trait =
    { id : Int, name : String, description : String }


type alias Archetype =
    { id : Int, name : String, description : String, examples : List String, karma : String, signatureMove : String }


type alias Stats =
    { oddity : Int, acuity : Int, audacity : Int, empathy : Int }


type PortfolioMarkupElement
    = Core { name : PortfolioName, flavour : String }
    | Archetypes (List Archetype)
    | StatGroup { oddity : Int, acuity : Int, audacity : Int, empathy : Int }
    | Traits (List Trait)


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


type alias PortfolioTemplate =
    { name : String
    , flavour : String
    , archetypes : List Archetype
    , stats : Stats
    , traits : List Trait
    }


type alias Portfolio =
    { name : PortfolioName
    , physicalDescription : String
    , agenda : String
    , flavour : String
    , archetypes : List Archetype
    , stats : Stats
    , traits : List Trait
    , attacks : List Attack
    , karma : Int
    , hurt : Int
    , harm : Harm
    , magicTraits : List Trait
    , weirdTrait : List Trait
    }



-- portfolioDocument : Mark.Document Portfolio
-- portfolioDocument = Mark.document
