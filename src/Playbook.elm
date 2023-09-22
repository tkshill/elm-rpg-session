module Playbook exposing (..)


type BaseKarma
    = Int


type Charm
    = Charm


type Weird
    = Weird


type Sharp
    = Sharp


type Guts
    = Guts


type Rating
    = C Charm
    | W Weird
    | S Sharp
    | G Guts


type alias BaseRatings =
    { charm : Int
    , weird : Int
    , sharp : Int
    , guts : Int
    }


type alias Gear =
    { name : String
    , tags : List String
    }


type Alteration
    = PlusOne
    | MinusOne
    | Neutral


type alias PlaybookMove =
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
    , moves : List PlaybookMove
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
