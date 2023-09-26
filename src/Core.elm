module Core exposing (..)


type BaseKarma
    = Int


type Charm
    = Charm


type Weird
    = Weird


type Sharp
    = Sharp


type Tough
    = Tough


type Rating
    = C Charm
    | W Weird
    | S Sharp
    | T Tough


type alias BaseRatings =
    { charm : Int
    , weird : Int
    , sharp : Int
    , tough : Int
    }


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
    , ratings : BaseRatings
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


type alias BaseRatings =
    { charm : Int
    , weird : Int
    , sharp : Int
    , tough : Int
    }


type alias Moves =
    { description : String
    , initialLimit : Int
    , moveList : List PlaybookMove
    }


type alias Gear_ =
    { limit : Int
    , options : List Gear
    }


type History
    = List String
