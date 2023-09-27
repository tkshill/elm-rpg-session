module Core exposing (..)

import Element.Region exposing (description)


type BaseKarma
    = Int


type Empathy
    = Empathy


empathyString : String
empathyString =
    "Empathy"


type Oddity
    = Oddity


oddityString : String
oddityString =
    "Oddity"


type Acuity
    = Acuity


acuityString : String
acuityString =
    "Acuity"


type Audacity
    = Audacity


audacityString : String
audacityString =
    "Audacity"


type Rating
    = E Empathy
    | O Oddity
    | Ac Acuity
    | Au Audacity


type alias Gear =
    String


type Alteration
    = PlusOne
    | MinusOne
    | Neutral


type alias PlaybookMove =
    { name : String
    , description : String
    , rollable : Maybe Rating
    }


type alias BasicMove =
    { name : BasicMoveName
    , description : String
    , stat : Rating
    }


type alias BasePlayBook =
    { name : String
    , description : String
    , ratings : Ratings
    , moves : List PlaybookMove
    , gear : List Gear
    , karma : BaseKarma
    }


type BasicMoveName
    = SupportAnother -- Karma
    | DoTheDamnThing -- Guts
    | SwaySomeone -- Charm
    | AssessReality -- Wits
    | GetYourFreakOn -- Weird


type alias Ratings =
    { empathy : Int
    , oddity : Int
    , acuity : Int
    , audacity : Int
    }


ratingToString : Rating -> String
ratingToString r =
    case r of
        O Oddity ->
            oddityString

        E Empathy ->
            empathyString

        Ac Acuity ->
            acuityString

        Au Audacity ->
            audacityString


type alias Moves =
    { description : String
    , moveList : List { id : Int, move : PlaybookMove, selected : Bool }
    }


type alias Gears =
    { description : String
    , gearList : List { id : Int, gear : Gear, selected : Bool }
    }


type alias History =
    List String
