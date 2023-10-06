module Parse exposing (..)


type PortfolioName
    = TheUnnatural -- Audacity/Oddity/Empathy/Acuity
    | TheMagical -- Oddity/Acuity/Audacity/Empathy
    | TheOutsider -- Acuity/Empathy/Oddity/Audacity
    | TheChampion -- Empathy/Audacity/Acuity/Oddity


type alias Move =
    { id : Int, name : String, description : String }


type alias Archetype =
    { id : Int, name : String, description : String, examples : List String, karma : String }


type PortfolioMarkupElement
    = Core { name : PortfolioName, description : String, flavour : String }
    | Archetypes { name : String, description : String, options : List Archetype }
    | Stats { oddity : Int, acuity : Int, audacity : Int, empathy : Int }
    | Moves (List Move)
