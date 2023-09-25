module Core exposing (..)

import List.Nonempty as Listn


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
    { name : String
    , tags : Listn.Nonempty String
    }


type Alteration
    = PlusOne
    | MinusOne
    | Neutral


type alias Move =
    { name : String
    , description : String
    , moveType : MoveType
    }


type MoveType
    = FlavourMove
    | RollMove Rating
    | ModMove Modifier


type alias BasePlayBook =
    { name : String
    , description : String
    , ratings : BaseRatings
    , moves : List Move
    , gear : List Gear
    , karma : BaseKarma
    }


type BasicMoveName
    = Help
    | Engage
    | Sway
    | Assess
    | Act
    | Avoid
    | GetWeird


type alias GearStatModifier =
    { name : String
    , harm : Int
    , harmMods : Int
    , tags : String
    }


type Modifier
    = HarmMods Int
    | KarmaMods Int
    | RatingMods Rating Int
    | GearsMods (List Gear)
    | GearStatMods GearStatModifier
